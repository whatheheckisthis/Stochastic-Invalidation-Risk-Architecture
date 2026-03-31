import * as fs from "fs";
import * as path from "path";
import { execSync } from "child_process";
import { auditEmit } from "./audit";

const SCHEMA_PATH = path.join(__dirname, "..", "config", "schema", "iato_policy.xsd");

export async function validateConfig(configPath: string): Promise<boolean> {
  if (!configPath) {
    auditEmit("VALIDATE_SKIP", "no_config_path_provided");
    return true;
  }

  if (!fs.existsSync(configPath)) {
    auditEmit("VALIDATE_HALT", `config_not_found path=${configPath}`);
    return false;
  }

  if (!fs.existsSync(SCHEMA_PATH)) {
    auditEmit("VALIDATE_HALT", `schema_not_found path=${SCHEMA_PATH}`);
    return false;
  }

  try {
    const { validateXML } = await import("xmllint-wasm");
    const xml = fs.readFileSync(configPath, "utf8");
    const xsd = fs.readFileSync(SCHEMA_PATH, "utf8");

    const result = await validateXML({
      xml: [{ fileName: configPath, contents: xml }],
      schema: [{ fileName: SCHEMA_PATH, contents: xsd }],
    });

    if (!result.valid) {
      const errors = result.errors.join("; ");
      auditEmit("VALIDATE_HALT", `xsd_invalid config=${configPath} errors=${errors}`);
      return false;
    }

    auditEmit("VALIDATE_PASS", `config=${configPath}`);
    return true;
  } catch {
    try {
      execSync(`xmllint --noout --schema "${SCHEMA_PATH}" "${configPath}"`, { stdio: "pipe" });
      auditEmit("VALIDATE_PASS", `config=${configPath} method=subprocess`);
      return true;
    } catch {
      auditEmit("VALIDATE_HALT", `xsd_invalid config=${configPath} method=subprocess`);
      return false;
    }
  }
}
