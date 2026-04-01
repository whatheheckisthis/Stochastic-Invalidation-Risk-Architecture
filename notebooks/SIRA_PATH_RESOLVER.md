# SIRA Notebook — Path Resolver Technical Record

> **License:** Apache License 2.0 — derived material use
> permitted under license terms. See `LICENSE` and `NOTICE`
> at repository root.
>
> **Academic use:** This material must not be used to underpin
> coursework content or submitted as original work in any
> assessed academic context. It is a practitioner artefact,
> not peer-reviewed literature. Trace all analytical claims
> to their cited primary sources. See `notebooks/DISCLAIMER.md`
> for full terms.


> Governance record for the portable TOML path resolution strategy
> implemented in Cell 01 of `sira_scenarios.ipynb`.
> This is an operational control document, not a developer note.

---

## Why path resolution requires governance

The notebook consumes `config/sira.toml` — the declared-intent
register that governs every scenario parameter, signal threshold,
and runtime constraint. If the notebook resolves the wrong file
(or fails silently and falls back to a default), every analytical
output downstream is ungoverned.

Path resolution is therefore a control boundary, not a convenience
feature. The resolver must:

1. Find the correct `sira.toml` across all valid launch contexts
2. Fail loudly with actionable error output when it cannot
3. Never silently fall back to a different file
4. Be auditable — the resolved path is logged to session metadata

---

## Four resolution strategies

Strategies are attempted in priority order. The first success wins.
No subsequent strategies are attempted after a successful resolution.

### Strategy 1 — Subdirectory relative path

```
../config/sira.toml
```

**When it works:** Notebook launched from the `notebooks/`
subdirectory. This is the standard layout and the most common
execution context.

**When it fails:** Notebook launched from repo root, a CI runner,
or any directory other than `notebooks/`.

**Priority rationale:** Standard layout is the expected case.
Checking it first avoids unnecessary filesystem traversal in
the common case.

---

### Strategy 2 — Repo root relative path

```
config/sira.toml
```

**When it works:** Notebook launched from the repository root.
Common when a reviewer opens JupyterLab from the repo root
rather than the `notebooks/` subdirectory.

**When it fails:** Any launch context where the working directory
is neither the repo root nor `notebooks/`.

**Priority rationale:** Repo root is the second most common
launch context. Checked before environment variable to preserve
conventional usage without requiring operator configuration.

---

### Strategy 3 — Environment variable override

```
Sys.getenv("SIRA_TOML_PATH")
```

**When it works:** Operator has set `SIRA_TOML_PATH` to an
absolute path before launching the notebook.

**When it fails:** Environment variable is unset or empty.
The resolver skips this strategy silently — no error is emitted
for an unset variable.

**Use cases:**
- CI/CD pipelines where the working directory is not predictable
- Air-gapped deployments where the config file is not co-located
  with the notebook
- Multiple environment testing (dev/staging/prod configs)

**How to set:**
```r
# In R before running Cell 01:
Sys.setenv(SIRA_TOML_PATH = "/absolute/path/to/config/sira.toml")

# Or in shell before launching Jupyter:
export SIRA_TOML_PATH=/absolute/path/to/config/sira.toml
```

**Priority rationale:** Environment variable is the explicit
operator override mechanism. It is checked after conventional
paths to avoid requiring configuration for standard use, but
before the upward walk to provide a clean override path for
non-standard deployments.

---

### Strategy 4 — Upward directory walk

Walks upward from the current working directory, checking
`config/sira.toml` at each level, for up to five levels.

**When it works:** Notebook launched from any subdirectory
of the repository — `notebooks/sub/`, `notebooks/analysis/`,
or any other nested location.

**When it fails:** Repository is more than five directory
levels deep from the working directory, or `config/sira.toml`
does not exist anywhere in the upward path.

**Priority rationale:** Fallback for non-standard layouts.
Five-level limit prevents infinite traversal and bounds the
search to a reasonable repository depth.

---

## Failure behaviour

When all four strategies fail, the resolver halts with a
structured error message that names every strategy attempted
and the exact override mechanism:

```
HALT: sira.toml not found.
Mitigation strategies tried:
  1. ../config/sira.toml (from notebooks/ subdirectory)
  2. config/sira.toml (from repo root)
  3. SIRA_TOML_PATH environment variable
  4. Upward directory walk (5 levels)
Set SIRA_TOML_PATH=/absolute/path/to/sira.toml to resolve.
```

This is a governance-quality error. The operator knows:
- Every path that was checked
- That no silent fallback occurred
- The exact command to resolve the failure

Silent fallback to a default configuration is not permitted.
A notebook run on an unresolved configuration would produce
ungoverned outputs — the resolver treats this as a fatal error.

---

## Audit trail

The resolved path and working directory are logged to session
metadata (Cell 12) alongside seed, timestamp, and package versions:

```
Config source:   /absolute/path/to/config/sira.toml
Working directory: /home/dhruv/iato/notebooks
```

This record is the evidence that the correct configuration was
loaded. A compliance auditor can verify the resolved path against
the controlled release manifest.

---

## Operator mitigations by deployment context

| Context | Recommended strategy | Action required |
|---|---|---|
| Standard (from `notebooks/`) | Strategy 1 (auto) | None |
| Launched from repo root | Strategy 2 (auto) | None |
| CI/CD pipeline | Strategy 3 | Set `SIRA_TOML_PATH` in pipeline env |
| Air-gapped deployment | Strategy 3 | Set `SIRA_TOML_PATH` in launch script |
| Nested subdirectory | Strategy 4 (auto) | None if within 5 levels |
| Containerised execution | Strategy 3 | Mount config and set env var |
| Multiple environments | Strategy 3 | Set per-environment `SIRA_TOML_PATH` |

For containerised execution the recommended pattern is:

```bash
docker run \
  -e SIRA_TOML_PATH=/config/sira.toml \
  -v /host/config:/config:ro \
  sira-notebook
```

The config volume is mounted read-only — the notebook cannot
modify the governed configuration at runtime.
