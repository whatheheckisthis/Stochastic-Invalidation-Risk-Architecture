# SIRA Notebook Quickstart

## Requirements

### MCP server runtime

These dependencies must be present before `npm install`
is run. The server will not start without them.

| Dependency | Minimum version | Purpose |
|---|---|---|
| Node.js | 20.0.0 | MCP server runtime |
| npm | 9.0.0 | Package management |
| Bash | 5.0 | Dispatch and orchestration scripts |

### Host-layer dependencies

These dependencies are invoked by the Bash orchestration
layer at action execution time, not by the Node.js server
at startup. The server starts without them. Actions that
invoke them will halt with a logged error if they are
absent.

> **Scope:** Host-layer dependencies are outside the npm
> package boundary. They must be installed and verified
> on the WSL2 host independently of `npm install`. See
> the pre-flight checklist below for verification
> commands.
>
> Host-layer dependency governance:
> [`docs/IATO_MCP_ARCHITECTURE.md §3`](../docs/IATO_MCP_ARCHITECTURE.md#3--container-runtime-and-schema-validation)
> — Rootless Podman and XSD schema validation.

| Dependency | Minimum version | Purpose | Verification |
|---|---|---|---|
| Podman | 4.0.0 | Rootless container operations | `podman --version` |
| xmllint | any | XSD validation fallback (subprocess) | `xmllint --version` |

**Install xmllint on WSL2/Ubuntu if not present:**

```bash
apt-get install -y libxml2-utils
```

**Install Podman on WSL2/Ubuntu if not present:**

```bash
apt-get install -y podman
```
