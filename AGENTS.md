# Septa Agent Notes

## Purpose

Septa work produces versioned schemas, example fixtures, and boundary notes. Keep the contract layer explicit and keep producer or consumer implementation in the owning repos.

---

## Source of Truth

- `*.schema.json` files are authoritative for payload shapes.
- `fixtures/*.example.json` files are authoritative for valid examples.
- `README.md`, `integration-patterns.md`, and `mcp-conventions.md` explain the boundary rules.
- Downstream repos own serialization, parsing, and transport behavior.

When a schema and fixture disagree, fix the schema first, then the fixture, then the affected producer and consumer repos.

---

## Before You Start

Before writing code, verify:

1. **Owning contract**: Identify which schema and fixture pair you are changing.
2. **Consumers**: Identify the repos that produce or consume that payload.
3. **Versioning**: Decide whether this is a shape edit or a version bump before you change files.
4. **Cross-repo impact**: If the payload crosses a repo boundary, update the dependent repos in the same change.

---

## Preferred Commands

Use these for most work:

```bash
jq '.project, .nodes, .edges' fixtures/code-graph-v1.example.json
check-jsonschema --schemafile code-graph-v1.schema.json fixtures/code-graph-v1.example.json
```

For targeted work:

```bash
rg -n '"volva-hook-event-v1"|schema_version' .
```

---

## Repo Architecture

Septa is a contract repository. Its job is to keep payload definitions small, explicit, and versioned so other repos can move independently.

Key boundaries:

- `*.schema.json` owns the contract shape.
- `fixtures/*.example.json` owns the example payloads that prove the schema is usable.
- `README.md` owns the contract inventory and workflow notes.
- `integration-patterns.md` and `mcp-conventions.md` own the cross-boundary guidance.
- `target/`, build outputs, and downstream copies are not source of truth.

Current direction:

- Keep boundary changes explicit through versioned schemas.
- Keep fixture updates paired with schema changes.
- Keep downstream implementation changes in the owning repos, not here.

---

## Working Rules

- Update the schema and fixture together.
- Bump the contract version when the shape changes in a breaking way.
- Do not hand-edit downstream generated copies of a contract.
- Keep the contract inventory in `README.md` current.
- Run schema validation before closing a change.

---

## Multi-Agent Patterns

For substantial contract work, use at least two agents:

**1. Primary implementation worker**
- Owns the schema, fixture, and documentation edits
- Specific files in scope: the touched `*.schema.json`, matching fixture, and related docs
- Does not edit consumer implementation repos

**2. Independent validator**
- Does not duplicate implementation. Reviews the broader shape.
- Specifically looks for:
  - schema and fixture mismatch
  - missing version bump
  - inventory or boundary doc drift
  - uncoordinated consumer or producer changes

If the validator finds real structural issues, fix those before polishing output.

---

## Skills to Load

Default:

- `claude-mycelium-workspace-router` - keep the boundary call explicit
- `writing-voice` - keep schema and boundary prose concise

Situational:

- `test-writing` - when adding fixture coverage or validation checks
- `claude-mycelium-rust-repos` - when coordinating with Rust consumers or producers
