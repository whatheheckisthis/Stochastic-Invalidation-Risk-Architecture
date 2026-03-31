import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import { execFile } from "child_process";
import { promisify } from "util";
import * as path from "path";
import * as fs from "fs";

import { ENUMERATED_ACTIONS, isEnumeratedAction, ActionResult } from "./dispatch";
import { auditEmit, getSessionFile } from "./audit";
import { validateConfig } from "./validate";

const execFileAsync = promisify(execFile);

const DISPATCH_SCRIPT = path.join(__dirname, "..", "orchestrator", "dispatch.sh");
const GOVERNANCE_DOCS_BASE = path.join(__dirname, "..", "..", "docs");

const TOOL_DEFINITIONS = [
  {
    name: "apply",
    description:
      "Apply a versioned provisioning script against an XSD-validated config. Runs preflight → apply → verify in sequence. Halts on any stage failure.",
    inputSchema: {
      type: "object" as const,
      properties: {
        scriptPath: { type: "string", description: "Absolute path to the versioned Bash script to apply." },
        configPath: { type: "string", description: "Absolute path to the XSD-validated XML config." },
      },
      required: ["scriptPath", "configPath"],
    },
  },
  {
    name: "state_check",
    description:
      "Compare live filesystem state against SHA-256 checksums declared in the XSD-validated XML config. Exit 0 = known-good. Exit 2 = deviation detected — caller must invoke decommission.",
    inputSchema: {
      type: "object" as const,
      properties: {
        configPath: { type: "string", description: "Absolute path to the XSD-validated XML config." },
      },
      required: ["configPath"],
    },
  },
  {
    name: "decommission",
    description:
      "Eliminate workspace and rebuild from verified root script. Stops and removes all declared containers, removes workspace paths, then executes the rebuild script declared in the XML config.",
    inputSchema: {
      type: "object" as const,
      properties: {
        configPath: { type: "string", description: "Absolute path to the XSD-validated XML config." },
      },
      required: ["configPath"],
    },
  },
  {
    name: "spawn_container",
    description:
      "Spawn a rootless Podman container from XSD-validated config. UID/GID mapping, memory limits, network mode, and security flags are sourced exclusively from the config — no runtime override.",
    inputSchema: {
      type: "object" as const,
      properties: {
        configPath: { type: "string", description: "Absolute path to the XSD-validated XML config." },
      },
      required: ["configPath"],
    },
  },
  {
    name: "teardown_container",
    description:
      "Stop and remove a container declared in the XSD-validated config. No in-place repair. Rebuild is triggered by decommission if required.",
    inputSchema: {
      type: "object" as const,
      properties: {
        configPath: { type: "string", description: "Absolute path to the XSD-validated XML config." },
      },
      required: ["configPath"],
    },
  },
  {
    name: "vsphere_preflight",
    description:
      "Validate an IaC config for vSphere pre-flight before cloud promotion. Asserts network isolation mode and CIDR scope.",
    inputSchema: {
      type: "object" as const,
      properties: {
        configPath: { type: "string", description: "Absolute path to the XSD-validated XML config." },
      },
      required: ["configPath"],
    },
  },
  {
    name: "read_risk_committee",
    description: "Return RISK_COMMITTEE.md. Read-only. No dispatch invoked. No state change.",
    inputSchema: { type: "object" as const, properties: {}, required: [] },
  },
  {
    name: "read_defense_appendix",
    description: "Return DEFENSE_APPENDIX.md. Read-only. No dispatch invoked. No state change.",
    inputSchema: { type: "object" as const, properties: {}, required: [] },
  },
  {
    name: "read_compliance_crosswalk",
    description: "Return COMPLIANCE_CROSSWALK.csv. Read-only. No dispatch invoked. No state change.",
    inputSchema: { type: "object" as const, properties: {}, required: [] },
  },
] as const;

async function runDispatch(action: string, scriptPath?: string, configPath?: string): Promise<ActionResult> {
  const auditRef = getSessionFile();

  if (!isEnumeratedAction(action)) {
    auditEmit("DISPATCH_HALT", `reason=unknown_action action=${action}`);
    return {
      success: false,
      exitCode: 1,
      stdout: "",
      stderr: `Unknown action: ${action}. Only enumerated actions are permitted.`,
      auditRef,
    };
  }

  if (configPath) {
    const valid = await validateConfig(configPath);
    if (!valid) {
      return {
        success: false,
        exitCode: 1,
        stdout: "",
        stderr: `XSD validation failed for config: ${configPath}. Action halted.`,
        auditRef,
      };
    }
  }

  auditEmit("DISPATCH_START", `action=${action} script=${scriptPath ?? ""} config=${configPath ?? ""}`);

  const args = [action, scriptPath ?? "", configPath ?? ""].filter((a) => a !== "");

  try {
    const { stdout, stderr } = await execFileAsync("bash", [DISPATCH_SCRIPT, ...args], {
      env: { ...process.env, AUDIT_LOG: auditRef },
    });

    auditEmit("DISPATCH_COMPLETE", `action=${action} exit=0`);
    return { success: true, exitCode: 0, stdout, stderr, auditRef };
  } catch (err: any) {
    const exitCode: number = err.code ?? 1;
    auditEmit("DISPATCH_HALT", `action=${action} exit=${exitCode} stderr=${(err.stderr ?? "").slice(0, 200)}`);

    const isDeviation = exitCode === 2;
    return {
      success: false,
      exitCode,
      stdout: err.stdout ?? "",
      stderr: isDeviation ? `STATE_DEVIATION_DETECTED: ${err.stderr ?? ""}. Invoke decommission.` : err.stderr ?? "",
      auditRef,
    };
  }
}

function readGovernanceDoc(fileName: string): string {
  const docPath = path.join(GOVERNANCE_DOCS_BASE, fileName);
  return fs.readFileSync(docPath, "utf8");
}

const server = new Server({ name: "iato-mcp", version: "1.0.0" }, { capabilities: { tools: {} } });

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: TOOL_DEFINITIONS,
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  const input = (args ?? {}) as Record<string, string>;

  auditEmit("TOOL_CALL", `tool=${name} configPath=${input.configPath ?? ""} scriptPath=${input.scriptPath ?? ""}`);

  switch (name) {
    case "read_risk_committee": {
      auditEmit("GOV_READ", "doc=RISK_COMMITTEE.md");
      return { content: [{ type: "text", text: readGovernanceDoc("RISK_COMMITTEE.md") }] };
    }
    case "read_defense_appendix": {
      auditEmit("GOV_READ", "doc=DEFENSE_APPENDIX.md");
      return { content: [{ type: "text", text: readGovernanceDoc("DEFENSE_APPENDIX.md") }] };
    }
    case "read_compliance_crosswalk": {
      auditEmit("GOV_READ", "doc=COMPLIANCE_CROSSWALK.csv");
      return { content: [{ type: "text", text: readGovernanceDoc("COMPLIANCE_CROSSWALK.csv") }] };
    }
    default: {
      const result = await runDispatch(name, input.scriptPath, input.configPath);
      const summary = [
        `Action: ${name}`,
        `Status: ${result.success ? "SUCCESS" : "HALT"}`,
        `Exit: ${result.exitCode}`,
        `Audit: ${result.auditRef}`,
        result.exitCode === 2 ? "DEVIATION DETECTED — invoke decommission" : "",
        result.stdout ? `\nOutput:\n${result.stdout}` : "",
        result.stderr ? `\nErrors:\n${result.stderr}` : "",
      ]
        .filter(Boolean)
        .join("\n");

      return {
        content: [{ type: "text", text: summary }],
        isError: !result.success,
      };
    }
  }
});

async function main(): Promise<void> {
  auditEmit("SERVER_START", `pid=${process.pid} actions=${ENUMERATED_ACTIONS.join(",")}`);
  const transport = new StdioServerTransport();
  await server.connect(transport);
  auditEmit("SERVER_READY", "transport=stdio");
}

main().catch((err) => {
  auditEmit("SERVER_FATAL", `error=${String(err)}`);
  process.exit(1);
});
