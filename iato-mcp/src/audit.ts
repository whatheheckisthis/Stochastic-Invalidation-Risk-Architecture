import * as fs from "fs";
import * as path from "path";
import * as os from "os";

const SESSION_DIR = path.join(__dirname, "..", "audit", "session");

const SESSION_FILE = path.join(
  SESSION_DIR,
  `${new Date().toISOString().replace(/[:.]/g, "").slice(0, 15)}_${process.pid}.log`
);

export function auditEmit(event: string, detail: string): string {
  const timestamp = new Date().toISOString().slice(0, 23) + "Z";
  const host = os.hostname().split(".")[0];
  const user = os.userInfo().username;
  const pid = process.pid;

  const record = `${timestamp} | IATO-MCP | host=${host} user=${user} pid=${pid} | ${event} | ${detail}`;

  fs.mkdirSync(SESSION_DIR, { recursive: true });
  fs.appendFileSync(SESSION_FILE, record + "\n", { encoding: "utf8" });
  process.stderr.write(record + "\n");

  return SESSION_FILE;
}

export function getSessionFile(): string {
  return SESSION_FILE;
}
