# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Septa is the shared contract layer for cross-tool payloads in the Basidiocarp ecosystem. It is a schema-and-fixture repository, not a runtime; changing a payload here defines the wire format that other repos implement. Septa owns versioned JSON Schema files, example fixtures, and boundary notes; it defers producer and consumer behavior to the repos that emit or read the payloads.

---

## What Septa Does NOT Do

- Does not implement runtime transport rules; that belongs to the transport repo and the consuming tools.
- Does not own producer serialization logic or consumer parsing logic.
- Does not store application state or secrets.
- Does not resolve downstream drift on its own; consumers still need matching updates.
- Does not treat fixtures as optional examples; they are part of the contract.

---

## Failure Modes

- **Schema and fixture mismatch**: validation fails before the change is treated as complete.
- **Contract version drift**: a producer or consumer still targets an older shape and needs a coordinated update.
- **Downstream consumer lag**: Septa is correct, but one of the repos that depends on it has not been updated yet.
- **Validation tool unavailable**: schema checks cannot run locally, so the change should not be merged without another validation path.

---

## Build & Test Commands

```bash
jq '.project, .nodes, .edges' fixtures/code-graph-v1.example.json
check-jsonschema --schemafile code-graph-v1.schema.json fixtures/code-graph-v1.example.json
check-jsonschema --schemafile volva-hook-event-v1.schema.json fixtures/volva-hook-event-v1.example.json
```

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

- **schema files**: canonical payload shapes. Update these first when a boundary changes.
- **fixtures/**: valid examples for each contract. Keep them aligned with the matching schema.
- **README.md**: contract inventory, ownership, and workflow notes.
- **integration-patterns.md** and **mcp-conventions.md**: boundary guidance for consumers and transport-related conventions.

