# Septa

Versioned cross-tool schemas for the Basidiocarp ecosystem. It owns the payload boundaries that let repos change without silent breakage.

Named after fungal septa, the partitions that separate compartments while still allowing controlled exchange.

Part of the [Basidiocarp ecosystem](https://github.com/basidiocarp).

---

## The Problem

Each ecosystem project ships on its own schedule. Without a shared schema layer, one repo can change a payload name, field, or enum value and another repo only discovers the break later.

## The Solution

Septa is the shared contract layer for the workspace.

- It stores versioned JSON Schemas for cross-tool payloads.
- It keeps valid example fixtures next to those schemas.
- It documents which producer and consumer own each boundary.
- It gives the workspace one place to check before changing a cross-repo payload.

---

## The Ecosystem

| Tool | Purpose |
|------|---------|
| **[septa](https://github.com/basidiocarp/septa)** | Cross-tool schemas and fixtures |
| **[mycelium](https://github.com/basidiocarp/mycelium)** | Token-optimized command output |
| **[hyphae](https://github.com/basidiocarp/hyphae)** | Persistent agent memory |
| **[rhizome](https://github.com/basidiocarp/rhizome)** | Code intelligence via tree-sitter and LSP |
| **[spore](https://github.com/basidiocarp/spore)** | Shared transport, discovery, config, and infrastructure primitives |
| **[annulus](https://github.com/basidiocarp/annulus)** | Cross-ecosystem operator utilities |
| **[canopy](https://github.com/basidiocarp/canopy)** | Multi-agent coordination runtime |
| **[cortina](https://github.com/basidiocarp/cortina)** | Lifecycle signal capture and session attribution |
| **[hymenium](https://github.com/basidiocarp/hymenium)** | Workflow orchestration engine |
| **[volva](https://github.com/basidiocarp/volva)** | Execution-host runtime layer |
| **[cap](https://github.com/basidiocarp/cap)** | Dashboard and UI for ecosystem read models and operator workflows |
| **[lamella](https://github.com/basidiocarp/lamella)** | Skills, hooks, and plugins for Claude Code |
| **[stipe](https://github.com/basidiocarp/stipe)** | Ecosystem installer and manager |

> **Boundary:** `septa` owns wire formats and fixtures. Producer and consumer repos own the code that serializes, deserializes, and validates those payloads in practice.

---

## Quick Start

```bash
# Inspect a fixture
jq '.project, .nodes, .edges' fixtures/code-graph-v1.example.json

# Validate all schemas against their fixtures (primary workflow)
bash validate-all.sh
```

> **Note:** `check-jsonschema --schemafile <schema> <fixture>` is **not supported** for schemas
> that use local `$ref` references (most schemas here). Those schemas resolve `$ref` using their
> `$id` URI via `https://basidiocarp.dev`, which `check-jsonschema` cannot satisfy without the
> full registry. Use `bash validate-all.sh` instead — it builds the registry locally.
>
> For single-schema debugging only, you can supply `--base-uri file:///absolute/path/to/septa/`
> to tell `check-jsonschema` where to resolve relative references, but this is path-sensitive and
> not guaranteed to work for all schema layouts. Treat it as a debug aid, not a validation path.

---

## How It Works

```text
Producer repo        septa/                Consumer repo
─────────────        ──────                ─────────────
emit payload   ─►    schema + fixture  ─►  parse + validate
change shape   ─►    update version     ─►  update dependents
```

1. Define the boundary in a versioned `*.schema.json`.
2. Pin a valid example in `fixtures/*.example.json`.
3. Coordinate the schema, fixture, producer, and consumer together.
4. Validate the boundary before shipping.

---

## Contract Inventory

| Family | Contracts |
|--------|-----------|
| Resilience & Degradation | `degradation-tier-v1` |
| Workflow / Orchestration | `dispatch-request-v1`, `workflow-status-v1`, `workflow-template-v1`, `workflow-participant-runtime-identity-v1`, `task-packet-v1`, `task-output-v1`, `workflow-outcome-v1` |
| Cross-tool payloads | `code-graph-v1`, `command-output-v1`, `context-envelope-v1`, `cortina-audit-handoff-v1`, `cortina-lifecycle-event-v1`, `credential-v1`, `dependency-types-v1`, `evidence-ref-v1`, `handoff-context-v1`, `hook-execution-v1`, `host-identifier-v1`, `resolved-status-customization-v1`, `session-event-v1`, `tool-relevance-rules-v1`, `tool-usage-event-v1`, `usage-event-v1`, `volva-hook-event-v1` |
| Canopy → Cap, Annulus | `canopy-notification-v1`, `canopy-snapshot-v1`, `canopy-task-detail-v1` |
| Canopy → Annulus | `agent-heartbeat-v1` |
| Hyphae → Cap | `hyphae-activity-v1`, `hyphae-analytics-v1`, `hyphae-context-v1`, `hyphae-health-v1`, `hyphae-lessons-v1`, `hyphae-memory-lookup-v1`, `hyphae-memoir-inspect-v1`, `hyphae-memoir-list-v1`, `hyphae-memoir-search-v1`, `hyphae-memoir-search-all-v1`, `hyphae-memoir-show-v1`, `hyphae-search-v1`, `hyphae-session-list-v1`, `hyphae-session-timeline-v1`, `hyphae-sources-v1`, `hyphae-stats-v1`, `hyphae-topic-memories-v1`, `hyphae-topics-v1` |
| Hyphae export/import | `hyphae-archive-v1` |
| Mycelium → Cap | `mycelium-gain-v1`, `mycelium-summary-v1` |
| Stipe → Cap | `stipe-doctor-v1`, `stipe-init-plan-v1` |
| Annulus → Cap, scripts | `annulus-statusline-v1` |
| Capability Registry | `capability-registry-v1`, `capability-runtime-lease-v1` |

### Draft Schemas

Two schemas are currently in draft status at `septa/draft/` and have not yet been promoted to the main contract inventory:

- `local-service-endpoint-v1` — defines transport and identity semantics for local service endpoints
- `hook-execution-v1` — codifies the fail-open invariant for hook execution (see section below)

These schemas appear in prose documentation below but are not included in the contract inventory table above.

---

## What Septa Owns

- Versioned JSON Schema definitions for cross-repo payloads
- Canonical example fixtures for those payloads
- Cross-boundary documentation such as inventory and integration notes
- The rule that boundary changes are explicit and coordinated
- Normalized usage and cost event boundaries before summary and UI layers
- Portable resolved status and customization boundaries before host-specific rendering
- Orchestration contracts: workflow intake (`dispatch-request-v1`), runtime status (`workflow-status-v1`), template definitions (`workflow-template-v1`), task packets (`task-packet-v1`), and workflow outcomes (`workflow-outcome-v1`)

The orchestration authority split is: Hymenium owns workflow lifecycle decisions and emits status and outcome payloads; Canopy owns the coordination ledger and reads those payloads; Septa owns the wire shapes that connect them.

## What Septa Does Not Own

- Runtime transport rules, handled by [`spore`](https://github.com/basidiocarp/spore)
- Producer implementation details, handled by the repo emitting the payload
- Consumer parsing and storage logic, handled by the repo receiving the payload
- Release orchestration across repos, handled by the owning repos and workspace process

---

## Key Features

- Versioned schemas keep payload changes explicit instead of drifting silently.
- Concrete fixtures let producers and consumers share the same example payloads.
- Boundary documentation stays next to the schemas.
- Cross-repo discipline keeps contract changes in one visible place.

---

## Architecture

```text
septa/
├── *.schema.json     versioned JSON Schema files
├── fixtures/         example payloads that validate
├── README.md         ownership, workflow, and inventory
├── integration-patterns.md
└── mcp-conventions.md
```

---

## Documentation

- [README.md](README.md) — purpose, workflow, and contract inventory
- [integration-patterns.md](integration-patterns.md) — producer and consumer boundary notes
- [mcp-conventions.md](mcp-conventions.md) — transport conventions and MCP protocol guidance

---

## Producer Contract Testing

Septa ships a reusable validator that producer repos can call from their own test
suites to prove real output validates against the shared schema registry.

```bash
# Validate captured producer stdout against a named schema
python3 septa/scripts/validate-producer-output.py \
    --septa-dir /path/to/septa \
    --schema hyphae-activity-v1 \
    captured-output.json
```

The script builds the same local `$ref` registry that `validate-all.sh` uses,
so all cross-file schema references resolve without network access.

**Harness pattern (three-step)**

1. **Produce**: run or stub the real producer and capture JSON stdout.
2. **Validate**: call `validate-producer-output.py` against the schema. Exit non-zero stops the test.
3. **Parse**: feed the same JSON through the real consumer parser to confirm the consumer round-trips correctly.

```bash
# Step 1 — capture (swap with real CLI call in producer test suites)
hyphae activity --project my-project --limit 5 > /tmp/activity.json

# Step 2 — validate against Septa
python3 septa/scripts/validate-producer-output.py \
    --septa-dir "$SEPTA_DIR" --schema hyphae-activity-v1 /tmp/activity.json

# Step 3 — parse (in TypeScript consumer tests, do the equivalent)
# const payload = JSON.parse(fs.readFileSync('/tmp/activity.json', 'utf8'))
# expect(parseActivityPayload(payload)).not.toThrow()
```

**Never use `check-jsonschema --schemafile` for schemas with local `$ref`
references.** Those schemas resolve `$ref` through the `$id` URI base
(`https://basidiocarp.dev`) which `check-jsonschema` cannot satisfy without the
full registry. `validate-producer-output.py` and `validate-all.sh` are the
correct validation paths.

To run all five priority producer surfaces through the harness in one command:

```bash
bash septa/scripts/contract-harness-demo.sh
```

---

## Development

```bash
# Run before every schema or fixture change
bash validate-all.sh

# Inspect a fixture
jq '.project, .nodes, .edges' fixtures/code-graph-v1.example.json
```

Direct `check-jsonschema --schemafile` invocations are **not supported** for schemas with local
`$ref` references — they fail because cross-file references resolve through the `$id` URI base
(`https://basidiocarp.dev`) that only `validate-all.sh` builds locally. If you need to debug a
single schema, use:

```bash
# Debug only — path-sensitive, not a reliable validation path
check-jsonschema --base-uri file:///absolute/path/to/septa/ \
  --schemafile code-graph-v1.schema.json \
  fixtures/code-graph-v1.example.json
```

## Fail-Open Hook Execution Contract

The `hook-execution-v1` contract codifies the fail-open invariant for all hook runners in the ecosystem. Hooks must never block host commands regardless of how they fail.

| Field | Value | Meaning |
|-------|-------|---------|
| `timeout_ms` | 1–30000 (default 10000) | Wall-clock limit before the hook process is killed |
| `on_timeout` | `"proceed"` (required) | Kill hook, log warning, allow host command to continue |
| `on_error` | `"proceed"` (required) | Log warning on non-zero exit, allow host command to continue |
| `exit_code_semantics.non_zero` | `"advisory_failure"` | Non-zero exit is informational only, never blocking |
| `stderr_disposition` | `"log"` or `"suppress"` | stderr is never forwarded to the user as an error |

**Producers:** cortina hook runner, volva hook adapters, lamella hook templates.
**Consumers:** stipe doctor (validates timeout bounds at install time), cortina (enforces fail-open at runtime).

Schema: [`septa/draft/hook-execution-v1.schema.json`](draft/hook-execution-v1.schema.json) (draft, pending promotion)
Fixture: [`fixtures/hook-execution-v1.example.json`](fixtures/hook-execution-v1.example.json)


---

## License

See repository license.
