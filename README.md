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
| **[canopy](https://github.com/basidiocarp/canopy)** | Multi-agent coordination runtime |
| **[cortina](https://github.com/basidiocarp/cortina)** | Lifecycle signal capture and session attribution |
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

# Validate a fixture against its schema
check-jsonschema --schemafile code-graph-v1.schema.json fixtures/code-graph-v1.example.json
check-jsonschema --schemafile resolved-status-customization-v1.schema.json fixtures/resolved-status-customization-v1.example.json
check-jsonschema --schemafile volva-hook-event-v1.schema.json fixtures/volva-hook-event-v1.example.json
check-jsonschema --schemafile usage-event-v1.schema.json fixtures/usage-event-v1.example.json
```

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
| Cross-tool payloads | `code-graph-v1`, `command-output-v1`, `cortina-lifecycle-event-v1`, `evidence-ref-v1`, `handoff-context-v1`, `resolved-status-customization-v1`, `session-event-v1`, `usage-event-v1`, `volva-hook-event-v1`, `workflow-participant-runtime-identity-v1` |
| Canopy → Cap | `canopy-snapshot-v1`, `canopy-task-detail-v1` |
| Hyphae → Cap | `hyphae-activity-v1`, `hyphae-analytics-v1`, `hyphae-context-v1`, `hyphae-health-v1`, `hyphae-lessons-v1`, `hyphae-memory-lookup-v1`, `hyphae-memoir-inspect-v1`, `hyphae-memoir-list-v1`, `hyphae-memoir-search-v1`, `hyphae-memoir-search-all-v1`, `hyphae-memoir-show-v1`, `hyphae-search-v1`, `hyphae-session-list-v1`, `hyphae-session-timeline-v1`, `hyphae-sources-v1`, `hyphae-stats-v1`, `hyphae-topic-memories-v1`, `hyphae-topics-v1` |
| Mycelium → Cap | `mycelium-gain-v1` |
| Stipe → Cap | `stipe-doctor-v1`, `stipe-init-plan-v1` |

---

## What Septa Owns

- Versioned JSON Schema definitions for cross-repo payloads
- Canonical example fixtures for those payloads
- Cross-boundary documentation such as inventory and integration notes
- The rule that boundary changes are explicit and coordinated
- Normalized usage and cost event boundaries before summary and UI layers
- Portable resolved status and customization boundaries before host-specific rendering
- Workflow, participant, and runtime-session identity boundaries shared across tools

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

## Development

```bash
jq '.project, .nodes, .edges' fixtures/code-graph-v1.example.json
check-jsonschema --schemafile code-graph-v1.schema.json fixtures/code-graph-v1.example.json
check-jsonschema --schemafile resolved-status-customization-v1.schema.json fixtures/resolved-status-customization-v1.example.json
check-jsonschema --schemafile volva-hook-event-v1.schema.json fixtures/volva-hook-event-v1.example.json
check-jsonschema --schemafile usage-event-v1.schema.json fixtures/usage-event-v1.example.json
check-jsonschema --schemafile workflow-participant-runtime-identity-v1.schema.json fixtures/workflow-participant-runtime-identity-v1.example.json
```

## License

See repository license.
