export const ENUMERATED_ACTIONS = [
  "apply",
  "state_check",
  "decommission",
  "spawn_container",
  "teardown_container",
  "vsphere_preflight",
  "wsdl_preflight",
] as const;

export type EnumeratedAction = (typeof ENUMERATED_ACTIONS)[number];

export function isEnumeratedAction(action: string): action is EnumeratedAction {
  return (ENUMERATED_ACTIONS as readonly string[]).includes(action);
}

export interface ActionResult {
  success: boolean;
  exitCode: number;
  stdout: string;
  stderr: string;
  auditRef: string;
}

export interface DispatchRequest {
  action: EnumeratedAction;
  scriptPath?: string;
  configPath?: string;
}
