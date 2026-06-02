# Cross-Tool Payload Registry

Every payload that crosses a tool boundary must appear in this table.

- **Backed**: has a septa schema in this directory — validated by `validate-all.sh`
- **Draft**: schema designed but deferred under the F1 freeze — lives in `draft/`, not validated by `validate-all.sh`
- **Exempted**: registered in `exemptions.json` with rationale — reviewed but deferred
- **UNSEAMED**: not registered — indicates a gap that needs resolution

## Schema-Backed Payloads

| Payload | Producer | Consumers | Schema File | Status |
|---------|----------|-----------|-------------|--------|
| annulus-status | annulus | cap | annulus-status-v1.schema.json | Backed |
| annulus-statusline | annulus | cap, scripts, tools | annulus-statusline-v1.schema.json | Backed |
| capability-registry | stipe | spore, downstream tools | capability-registry-v1.schema.json | Backed |
| capability-runtime-lease | running tools, service wrappers | spore | capability-runtime-lease-v1.schema.json | Backed |
| canopy-notification | canopy | cap, annulus | canopy-notification-v1.schema.json | Backed |
| canopy-snapshot | canopy | cap | canopy-snapshot-v1.schema.json | Backed |
| canopy-task-detail | canopy | cap | canopy-task-detail-v1.schema.json | Backed |
| code-graph | rhizome | hyphae | code-graph-v1.schema.json | Backed |
| cap-code-graph | rhizome (export) | cap (graph view) | cap-code-graph-v1.schema.json | Backed |
| command-output | mycelium | hyphae | command-output-v1.schema.json | Backed |
| cortina-audit-handoff | cortina | canopy | cortina-audit-handoff-v1.schema.json | Backed |
| cortina-lifecycle-event | cortina | orchestrators, dashboards | cortina-lifecycle-event-v1.schema.json | Backed |
| dispatch-request | operator, .handoffs/ | hymenium | dispatch-request-v1.schema.json | Backed |
| evidence-ref | canopy | operator surfaces, dashboards | evidence-ref-v1.schema.json | Backed |
| claude-code-hook-envelope | claude-code-runtime (external) | cortina | claude-code-hook-envelope-v1.schema.json | Backed |
| hook-execution | hook-runners (cortina, volva, stipe) | stipe, cortina, lamella | hook-execution-v1.schema.json | Backed |
| host-identifier | baseline | all-tools | host-identifier-v1.schema.json | Backed |
| hyphae-activity | hyphae | cap | hyphae-activity-v1.schema.json | Backed |
| hyphae-analytics | hyphae | cap | hyphae-analytics-v1.schema.json | Backed |
| hyphae-archive | hyphae export/import | hyphae, migration-tools | hyphae-archive-v1.schema.json | Backed |
| hyphae-context | hyphae | cap | hyphae-context-v1.schema.json | Backed |
| hyphae-health | hyphae | cap | hyphae-health-v1.schema.json | Backed |
| hyphae-lessons | hyphae | cap | hyphae-lessons-v1.schema.json | Backed |
| hyphae-memoir-inspect | hyphae | cap | hyphae-memoir-inspect-v1.schema.json | Backed |
| hyphae-memoir-list | hyphae | cap | hyphae-memoir-list-v1.schema.json | Backed |
| hyphae-memoir-search-all | hyphae | cap | hyphae-memoir-search-all-v1.schema.json | Backed |
| hyphae-memoir-search | hyphae | cap | hyphae-memoir-search-v1.schema.json | Backed |
| hyphae-memoir-show | hyphae | cap | hyphae-memoir-show-v1.schema.json | Backed |
| hyphae-memory-lookup | hyphae | cap | hyphae-memory-lookup-v1.schema.json | Backed |
| hyphae-protocol | hyphae | volva | hyphae-protocol-v1.schema.json | Backed |
| hyphae-search | hyphae | cap | hyphae-search-v1.schema.json | Backed |
| hyphae-session-list | hyphae | cap | hyphae-session-list-v1.schema.json | Backed |
| hyphae-session-timeline | hyphae | cap | hyphae-session-timeline-v1.schema.json | Backed |
| hyphae-sources | hyphae | cap | hyphae-sources-v1.schema.json | Backed |
| hyphae-stats | hyphae | cap | hyphae-stats-v1.schema.json | Backed |
| hyphae-topic-memories | hyphae | cap | hyphae-topic-memories-v1.schema.json | Backed |
| hyphae-topics | hyphae | cap | hyphae-topics-v1.schema.json | Backed |
| mycelium-gain | mycelium | cap | mycelium-gain-v1.schema.json | Backed |
| resolved-status-customization | annulus (config export) | cap, lamella, stipe | resolved-status-customization-v1.schema.json | Backed |
| session-event | cortina | hyphae | session-event-v1.schema.json | Backed |
| session-message-class | hyphae, canopy (message classifiers) | cap, session readers | session-message-class-v1.schema.json | Backed |
| stipe-doctor | stipe | cap | stipe-doctor-v1.schema.json | Backed |
| stipe-init-plan | stipe | cap | stipe-init-plan-v1.schema.json | Backed |
| task-packet | hymenium | worker-agents | task-packet-v1.schema.json | Backed |
| tool-usage-event | cortina | canopy, cap | tool-usage-event-v1.schema.json | Backed |
| usage-event | all-tools | baseline | usage-event-v1.schema.json | Backed |
| cap-observer-status | cap-server | annulus, operator dashboards | cap-observer-status-v1.schema.json | Backed |
| cap-stats-memories | cap-server | operator dashboard | cap-stats-memories-v1.schema.json | Backed |
| cap-stats-savings | cap-server | operator dashboard | cap-stats-savings-v1.schema.json | Backed |
| cap-stats-sessions | cap-server | operator dashboard | cap-stats-sessions-v1.schema.json | Backed |
| volva-hook-event | volva | cortina | volva-hook-event-v1.schema.json | Backed |
| workflow-outcome | hymenium | canopy, cap | workflow-outcome-v1.schema.json | Backed |
| workflow-participant-runtime-identity | baseline | all-tools | workflow-participant-runtime-identity-v1.schema.json | Backed |
| workflow-status | hymenium | canopy, cap | workflow-status-v1.schema.json | Backed |
| workflow-template | workflow-designers | canopy, dispatch | workflow-template-v1.schema.json | Backed |
| workspace-session | volva-runtime | cap, hyphae, canopy | workspace-session-v1.schema.json | Backed |
| agent-heartbeat | canopy | annulus, cap | agent-heartbeat-v1.schema.json | Backed |
| canopy-handoff-assignee | canopy | cap | canopy-handoff-assignee-v1.schema.json | Backed |
| canopy-handoff-disposition | canopy | cap | canopy-handoff-disposition-v1.schema.json | Backed |
| canopy-task-branch | canopy | cap | canopy-task-branch-v1.schema.json | Backed |
| coding-agent-threat | septa (vocabulary) | canopy, hymenium | coding-agent-threat-v1.schema.json | Backed |
| compliance-framework-id | septa (vocabulary) | security tooling, cap | compliance-framework-id-v1.schema.json | Backed |
| cortina-fact-extracted | cortina | hyphae | cortina-fact-extracted-v1.schema.json | Backed |
| cortina-hook-signal | cortina | claude-code, annulus, cap | cortina-hook-signal-v1.schema.json | Backed |
| handoff-graph | operator, orchestration tools | canopy | handoff-graph-v1.schema.json | Backed |
| handoff-session | canopy | canopy, cap | handoff-session-v1.schema.json | Backed |
| handoff-to-user | hymenium | operator, cap | handoff-to-user-v1.schema.json | Backed |
| hymenium-workflow | workflow authors (lamella) | hymenium, cap | hymenium-workflow-v1.schema.json | Backed |
| hyphae-memoir-block-type | hyphae | hyphae, cap | hyphae-memoir-block-type-v1.schema.json | Backed |
| hyphae-memoir-link | hyphae | cap | hyphae-memoir-link-v1.schema.json | Backed |
| hyphae-memory-category | septa (vocabulary) | hyphae, cortina, cap | hyphae-memory-category-v1.schema.json | Backed |
| hyphae-reflexion-record | cortina, agents | hyphae | hyphae-reflexion-record-v1.schema.json | Backed |
| provider-model-cost | operator, ecosystem maintainer | annulus, cap | provider-model-cost-v1.schema.json | Backed |
| review-annotation | cap-server | canopy, hyphae, cap | review-annotation-v1.schema.json | Backed |
| review-annotation-event | cap-server | canopy, hyphae | review-annotation-event-v1.schema.json | Backed |
| review-finding | lamella-skills, canopy | canopy, cap | review-finding-v1.schema.json | Backed |
| doc-review-finding | canopy, lamella-skills | canopy, cap | doc-review-finding-v1.schema.json | Backed |
| session-envelope | any tool (threading envelope) | all-tools | session-envelope-v1.schema.json | Backed |
| threat-severity | septa (vocabulary) | security tooling, orchestrators, cap | threat-severity-v1.schema.json | Backed |
| working-memory | hyphae (session end), cortina (SessionEnd) | hyphae, cap | working-memory-v1.schema.json | Backed |
| content-bundle | lamella (bundle publish) | stipe, canopy, cap | content-bundle-v1.schema.json | Backed |
| schema-registry-entry | operator, tool author | canopy, rhizome, cap | schema-registry-entry-v1.schema.json | Backed |
| skill-frontmatter | lamella (emits SKILL.md) | lamella validator, stipe | skill-frontmatter-v1.schema.json | Backed |
| workflow-invoke-result | hymenium (invoke/run) | cap, canopy | workflow-invoke-result-v1.schema.json | Backed |

## Draft / Deferred Payloads

Schemas designed but deferred under the F1 freeze roadmap. They live in `draft/` and are **not** validated by `validate-all.sh` (the validator globs `*.schema.json` non-recursively at the root). They are intentional designs preserved for post-freeze implementation, not gaps. To promote one, move the file from `draft/` to the repo root, add a fixture, and move its row up to the Schema-Backed table. See the "Drafts (Deferred)" section in `integration-patterns.md`.

| Payload | Producer | Consumers | Schema File | Status |
|---------|----------|-----------|-------------|--------|
| context-envelope | hyphae, rhizome, cortina, canopy | model context assembly, cap | draft/context-envelope-v1.schema.json | Draft |
| credential | stipe, cortina, operator actions | credential managers, auth bootstrap, deployment tools | draft/credential-v1.schema.json | Draft |
| degradation-tier | tool-health-monitors | cortina, volva, canopy, agents, dashboards | draft/degradation-tier-v1.schema.json | Draft |
| dependency-types | canopy, hymenium, hyphae | canopy, cap, agent-handoff | draft/dependency-types-v1.schema.json | Draft |
| handoff-context | agent-handoff, ecosystem | agent-receiving, canopy, cap | draft/handoff-context-v1.schema.json | Draft |
| tool-relevance-rules | lamella | cortina | draft/tool-relevance-rules-v1.schema.json | Draft |

## Exempted Payloads

| Payload | Producer | Consumers | Status | Rationale |
|---------|----------|-----------|--------|-----------|
| (none) | — | — | — | All previously exempted payloads have been promoted to full schemas (2026-04-30). |

## Unseamed Payloads

(None currently known. If you discover a cross-tool payload not in either table above, create an issue and add an exemption entry with medium severity pending schema design.)

---

## Updating This Registry

### To add a new schema-backed payload:

1. Create the schema file in this directory: `{payload-name}-v1.schema.json`
2. Create the fixture file: `fixtures/{payload-name}-v1.example.json`
3. Add a row to the "Schema-Backed Payloads" table above
4. Run `bash validate-all.sh` to confirm the schema and fixture validate
5. Commit both the schema, fixture, and this registry update

### To add a new exempted payload:

1. Add an entry to `exemptions.json` with payload name, producer, consumers, severity, and rationale
2. Add a row to the "Exempted Payloads" table above with a reference to `exemptions.json`
3. Ensure the producer and consumer paths exist (run `bash scripts/check-cross-tool-payloads.sh`)
4. Plan when to promote this exemption to a full schema (tracked in `tracked_in` field)
5. Commit both `exemptions.json` and this registry update

### To discover unseamed payloads:

Use the check script: `bash scripts/check-cross-tool-payloads.sh`. It validates:
- All exemptions.json producer paths exist (or are marked external)
- All schemas are listed in this registry
- No schemas have been added without a registry entry
