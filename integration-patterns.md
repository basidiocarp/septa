# Integration Patterns

This document describes cross-tool communication patterns in the ecosystem.

## Overview

Components communicate through stable interfaces rather than private database access or ad hoc parsing. Each pattern below names the producer, consumer, wire format, and schema reference.

---

## cortina → hyphae (Session Lifecycle)

**Producer:** cortina (hook runner)  
**Consumer:** hyphae (memory MCP server)  
**Purpose:** Capture session start, outcome signals, and session end events.

**Wire Format:** CLI invocation (cortina spawns hyphae binary):
- `hyphae session start` — opens a session, returns session_id
- `hyphae store` — stores episodic memories with topic/content
- `hyphae session end` — closes session with summary, files modified, errors

Note: Cortina uses CLI invocation, not MCP JSON-RPC, to avoid circular dependencies at hook time.

**Schema References:**
- `session-event-v1.schema.json` — session lifecycle events

---

## cortina → hyphae (Outcome Evidence)

**Producer:** cortina (captures test results, errors, corrections)  
**Consumer:** hyphae (stores as memories with evidence references)  
**Purpose:** Link memories to verifiable artifacts (test runs, error logs).

**Wire Format:** JSON-RPC calls with evidence references:
- `hyphae_memory_store` with `evidence` field containing URIs

**Schema References:**
- `evidence-ref-v1.schema.json` — evidence reference format

---

## canopy → hyphae (Task Handoffs)

**Producer:** canopy (multi-agent coordinator)  
**Consumer:** hyphae (retrieves context for new agent tasks)  
**Purpose:** Pass context and evidence references when handing off between agents.

**Wire Format:** JSON-RPC calls:
- `hyphae_memory_recall` — retrieve relevant memories for task context
- `hyphae_session_context` — get session state for handoff

**Schema References:**
- `handoff-context-v1.schema.json` — handoff context structure

---

## mycelium → hyphae (Chunked Output Storage)

**Producer:** mycelium (CLI proxy)  
**Consumer:** hyphae (stores large command outputs as retrievable chunks)  
**Purpose:** Store command outputs exceeding token limits for later retrieval.

**Wire Format:** JSON-RPC calls:
- `hyphae_store_command_output` — stores chunked command output
- `hyphae_get_command_chunks` — retrieves stored chunks by reference

**Schema References:**
- `command-output-v1.schema.json` — command output storage format

---

## volva → cortina (Hook Events)

**Producer:** volva (execution host hook adapter)
**Consumer:** cortina (volva adapter intake)
**Purpose:** Capture normalized volva lifecycle events so cortina can record host-level hook activity.

**Wire Format:** CLI invocation with JSON payload on stdin:
- `cortina adapter volva hook-event` — reads a single hook-event payload from stdin

**Schema References:**
- `volva-hook-event-v1.schema.json` — volva hook event payload
- `cortina-lifecycle-event-v1.schema.json` — transferable normalized lifecycle vocabulary derived from captured host events

---

## volva → canopy (Workflow Participant Runtime Identity)

**Producer:** volva (execution-host runtime and persisted session surface)  
**Consumer:** canopy (workflow linkage, queue/worktree/review read models)  
**Purpose:** Keep workflow identity, participant identity, and runtime-session identity consistent when a host session is linked to task orchestration.

**Wire Format:** Shared structured JSON identity object reused at tool boundaries:
- `volva` emits execution-session state with workflow, participant, and runtime-session identity
- `canopy` links the same identity fields into task workflow context and operator-facing read models

This contract is intentionally small in v1. It standardizes the identity core without forcing every repo to adopt the same transport envelope at once.

**Schema References:**
- `workflow-participant-runtime-identity-v1.schema.json` — shared workflow, participant, and runtime-session identity contract

---

## cortina → ecosystem (Normalized Lifecycle Vocabulary)

**Producer:** cortina (adapter-first lifecycle capture)
**Consumer:** downstream orchestrators and dashboards that need host-agnostic lifecycle semantics
**Purpose:** Share a narrower lifecycle vocabulary for host, tool, compaction, and council capture without forcing consumers to parse host-specific envelopes.

**Wire Format:** Structured JSON emitted by Cortina normalization helpers and hook capture payloads.

**Schema References:**
- `cortina-lifecycle-event-v1.schema.json` — normalized lifecycle event contract

---

## cortina → mycelium → cap (Usage Events and Summaries)

**Producer:** cortina (normalized edge capture for transcript and lifecycle-derived usage)
**Deterministic summary consumer:** mycelium (economics and summary surfaces)
**Operator-facing consumer:** cap (usage and cost views)
**Purpose:** Keep usage and cost reporting on a shared portable event shape instead of forcing each tool to reverse-engineer host-specific transcripts or adapters.

**Wire Format:** Shared structured JSON usage event plus deterministic summary surfaces:
- `cortina` normalizes host usage edges into `usage-event-v1`
- `mycelium` summarizes those normalized counters instead of inventing a UI-local usage contract
- `cap` reads summary and history surfaces from downstream tools rather than acting as the source of truth

This boundary is intentionally narrow in v1. It standardizes timestamps, tool and runtime identity, scoped workflow metadata, and resource counters before aggregation and display layers diverge.

**Schema References:**
- `usage-event-v1.schema.json` — normalized usage and cost event contract
- `workflow-participant-runtime-identity-v1.schema.json` — optional shared workflow identity nested under usage-event scope

---

## rhizome → hyphae (Code Graph Export)

**Producer:** rhizome (code intelligence MCP)  
**Consumer:** hyphae (imports as memoirs for code-aware recall)  
**Purpose:** Export code structure graphs as permanent knowledge.

**Wire Format:** JSON-RPC calls:
- `rhizome export_to_hyphae` — triggers export
- `hyphae_import_code_graph` — imports the graph as a memoir

**Schema References:**
- `code-graph-v1.schema.json` — code graph structure

---

## hyphae → cap (Dashboard Data)

**Producer:** hyphae (memory MCP server)
**Consumer:** cap (dashboard)
**Purpose:** Serve memory, session, memoir, analytics, and health data to the operator dashboard.

**Wire Format:** CLI invocation (cap backend spawns hyphae binary):
- `hyphae stats --json` — memory stats
- `hyphae health --json` — health summary
- `hyphae search --json` — memory search results
- `hyphae session list --json` — session index
- `hyphae session timeline --session-id <id> --json` — per-session event timeline
- `hyphae analytics --json` — analytics aggregates
- `hyphae memoir list --json` and related memoir commands — memoir browser

Note: `hyphae-session-timeline-v1` is a Cap-facing read model. It intentionally preserves the current stored shapes for `files_modified` and `errors` rather than reusing the write-time `session-event-v1` field semantics verbatim.

**Schema References:**
- `hyphae-stats-v1.schema.json`, `hyphae-health-v1.schema.json`, `hyphae-search-v1.schema.json`
- `hyphae-session-list-v1.schema.json`, `hyphae-session-timeline-v1.schema.json`
- `hyphae-analytics-v1.schema.json`, `hyphae-activity-v1.schema.json`
- `hyphae-memoir-list-v1.schema.json`, `hyphae-memoir-show-v1.schema.json`, etc.

---

## canopy → cap (Task Board)

**Producer:** canopy (multi-agent coordinator)
**Consumer:** cap (operator task board)
**Purpose:** Expose task status, evidence, and attention model to the dashboard.

**Wire Format:** CLI invocation (cap backend spawns canopy binary):
- `canopy snapshot --format json` — dashboard-level attention snapshot
- `canopy task get <id> --format json` — single task detail with evidence

**Schema References:**
- `canopy-snapshot-v1.schema.json` — attention snapshot
- `canopy-task-detail-v1.schema.json` — task detail

---

## stipe → cap (Health and Setup)

**Producer:** stipe (installer and manager)
**Consumer:** cap (health panel and setup wizard)
**Purpose:** Expose install health and repair actions to the dashboard.

**Wire Format:** CLI invocation (cap backend spawns stipe binary):
- `stipe doctor --json` — health report with repair actions
- `stipe init --dry-run --json` — init plan with detected hosts and steps

**Schema References:**
- `stipe-doctor-v1.schema.json` — doctor report
- `stipe-init-plan-v1.schema.json` — init plan

---

## stipe → lamella → cap (Resolved Status and Customization)

**Producer:** stipe (host-aware resolution and repair flows)
**Customization bundle consumer:** lamella (preset and bundle packaging)
**Preview consumer:** cap (status preview and edit surfaces)
**Purpose:** Keep statusline state, host render capabilities, and customization metadata portable instead of binding UI or packaging work to raw host config blobs.

**Wire Format:** Shared structured JSON resolved-state object:
- `stipe` resolves host-specific status and repair context into `resolved-status-customization-v1`
- `lamella` packages preset or bundle metadata against the same portable shape
- `cap` previews and edits the portable state instead of owning host-local config formats

This contract is intentionally small in v1. It carries resolved status, render capabilities, customization metadata, and origin information without replacing host-specific repair logic.

**Schema References:**
- `resolved-status-customization-v1.schema.json` — portable resolved status and customization contract

---

## mycelium → cap (Token Analytics)

**Producer:** mycelium (CLI proxy)
**Consumer:** cap (analytics panel)
**Purpose:** Expose token savings statistics and command history to the dashboard.

**Wire Format:** CLI invocation (cap backend spawns mycelium binary):
- `mycelium gain --format json` — summary and per-command analytics
- `mycelium gain --history --format json` — command history

**Schema References:**
- `mycelium-gain-v1.schema.json` — token savings analytics

---

## Timestamp Convention

New schemas prefer **ISO 8601 datetime strings** (`"format": "date-time"`) for all timestamp fields. Epoch-based fields like `captured_at_unix` in existing schemas (e.g., `usage-event-v1`) are stable and will not be migrated.

When adding a timestamp to a new or updated schema, use `"type": "string", "format": "date-time"` and document the field as ISO 8601. Do not introduce new epoch-based timestamp fields.

---

## Adding New Patterns

When adding a new cross-tool integration:

1. Define the wire format (JSON-RPC tool names and parameters)
2. Create or reference a schema in `septa/`
3. Document producer and consumer responsibilities
4. Add to this file with schema reference
5. Update both producer and consumer CLAUDE.md files
