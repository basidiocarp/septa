# Cross-Tool Payload Registry

Every payload that crosses a tool boundary must appear in this table.

- **Backed**: has a septa schema in this directory — validated by `validate-all.sh`
- **Exempted**: registered in `exemptions.json` with rationale — reviewed but deferred
- **UNSEAMED**: not registered — indicates a gap that needs resolution

## Schema-Backed Payloads

| Payload | Producer | Consumers | Schema File | Status |
|---------|----------|-----------|-------------|--------|
| annulus-statusline | annulus | cap, scripts, tools | annulus-statusline-v1.schema.json | Backed |
| capability-registry | stipe | spore, downstream tools | capability-registry-v1.schema.json | Backed |
| capability-runtime-lease | running tools, service wrappers | spore | capability-runtime-lease-v1.schema.json | Backed |
| canopy-notification | canopy | cap, annulus | canopy-notification-v1.schema.json | Backed |
| canopy-snapshot | canopy | cap | canopy-snapshot-v1.schema.json | Backed |
| canopy-task-detail | canopy | cap | canopy-task-detail-v1.schema.json | Backed |
| code-graph | rhizome | hyphae | code-graph-v1.schema.json | Backed |
| command-output | mycelium | hyphae | command-output-v1.schema.json | Backed |
| context-envelope | hyphae, rhizome, cortina, canopy | model context assembly, cap | context-envelope-v1.schema.json | Backed |
| cortina-audit-handoff | cortina | canopy | cortina-audit-handoff-v1.schema.json | Backed |
| credential | stipe, cortina, operator actions | credential managers, auth bootstrap, deployment tools | credential-v1.schema.json | Backed |
| cortina-lifecycle-event | cortina | orchestrators, dashboards | cortina-lifecycle-event-v1.schema.json | Backed |
| degradation-tier | tool-health-monitors | cortina, volva, canopy, agents, dashboards | degradation-tier-v1.schema.json | Backed |
| dependency-types | canopy, hymenium, hyphae | canopy, cap, agent-handoff | dependency-types-v1.schema.json | Backed |
| dispatch-request | operator, .handoffs/ | hymenium | dispatch-request-v1.schema.json | Backed |
| evidence-ref | canopy | operator surfaces, dashboards | evidence-ref-v1.schema.json | Backed |
| handoff-context | agent-handoff, ecosystem | agent-receiving, canopy, cap | handoff-context-v1.schema.json | Backed |
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
| hyphae-search | hyphae | cap | hyphae-search-v1.schema.json | Backed |
| hyphae-session-list | hyphae | cap | hyphae-session-list-v1.schema.json | Backed |
| hyphae-session-timeline | hyphae | cap | hyphae-session-timeline-v1.schema.json | Backed |
| hyphae-sources | hyphae | cap | hyphae-sources-v1.schema.json | Backed |
| hyphae-stats | hyphae | cap | hyphae-stats-v1.schema.json | Backed |
| hyphae-topic-memories | hyphae | cap | hyphae-topic-memories-v1.schema.json | Backed |
| hyphae-topics | hyphae | cap | hyphae-topics-v1.schema.json | Backed |
| mycelium-gain | mycelium | cap | mycelium-gain-v1.schema.json | Backed |
| mycelium-summary | mycelium | hyphae, cap | mycelium-summary-v1.schema.json | Backed |
| resolved-status-customization | all-tools | status-aggregators | resolved-status-customization-v1.schema.json | Backed |
| session-event | cortina | hyphae | session-event-v1.schema.json | Backed |
| stipe-doctor | stipe | cap | stipe-doctor-v1.schema.json | Backed |
| stipe-init-plan | stipe | cap | stipe-init-plan-v1.schema.json | Backed |
| task-output | canopy | canopy, cap | task-output-v1.schema.json | Backed |
| task-packet | hymenium | worker-agents | task-packet-v1.schema.json | Backed |
| tool-relevance-rules | lamella | cortina | tool-relevance-rules-v1.schema.json | Backed |
| tool-usage-event | cortina | canopy, cap | tool-usage-event-v1.schema.json | Backed |
| usage-event | all-tools | baseline | usage-event-v1.schema.json | Backed |
| volva-hook-event | volva | cortina | volva-hook-event-v1.schema.json | Backed |
| workflow-outcome | hymenium | canopy, cap | workflow-outcome-v1.schema.json | Backed |
| workflow-participant-runtime-identity | baseline | all-tools | workflow-participant-runtime-identity-v1.schema.json | Backed |
| workflow-status | hymenium | canopy, cap | workflow-status-v1.schema.json | Backed |
| workflow-template | workflow-designers | canopy, dispatch | workflow-template-v1.schema.json | Backed |

## Exempted Payloads

| Payload | Producer | Consumers | Status | Rationale |
|---------|----------|-----------|--------|-----------|
| MemoryProtocolSurface | hyphae | volva | Exempted | Co-versioned in same workspace; low drift risk. Shape is stable but not formally documented. See `exemptions.json`. |
| HyphaeSessionContext | hyphae | volva | Exempted | Session context JSON. Co-versioned; drift detectable by integration test. Schema backlog item. See `exemptions.json`. |
| ClaudeCodeHookEnvelope | claude-code-runtime (external) | cortina | Exempted (external) | Claude Code's hook envelope format owned by Claude Code runtime, not this codebase. Cannot be schema-backed without owning the spec. See `exemptions.json`. |

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
