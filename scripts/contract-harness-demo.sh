#!/usr/bin/env bash
# Contract harness demo: validate representative captured outputs for the
# five priority producer surfaces against their Septa schemas.
#
# These fixtures stand in for real captured producer stdout in the absence
# of a live environment.  Producers should wire validate-producer-output.py
# into their own test suites using the same pattern:
#
#   python3 "$SEPTA_DIR/scripts/validate-producer-output.py" \
#       --septa-dir "$SEPTA_DIR" \
#       --schema <schema-name> \
#       <captured-output.json>
#
# Usage: bash septa/scripts/contract-harness-demo.sh
set -euo pipefail

SEPTA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURES="$SEPTA_DIR/fixtures"
VALIDATOR="$SEPTA_DIR/scripts/validate-producer-output.py"

PASS=0
FAIL=0

validate() {
  local schema="$1"
  local fixture="$2"
  echo "==> $schema"
  if python3 "$VALIDATOR" --septa-dir "$SEPTA_DIR" --schema "$schema" "$fixture"; then
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
  fi
}

# Priority surface 1: Canopy task / snapshot / status
validate canopy-task-detail-v1        "$FIXTURES/canopy-task-detail-v1.example.json"
validate canopy-snapshot-v1           "$FIXTURES/canopy-snapshot-v1.example.json"
validate canopy-notification-v1       "$FIXTURES/canopy-notification-v1.example.json"

# Priority surface 2: Hyphae read / archive
validate hyphae-activity-v1           "$FIXTURES/hyphae-activity-v1.example.json"
validate hyphae-archive-v1            "$FIXTURES/hyphae-archive-v1.example.json"

# Priority surface 3: Mycelium gain / summary
validate mycelium-gain-v1             "$FIXTURES/mycelium-gain-v1.example.json"
validate mycelium-summary-v1          "$FIXTURES/mycelium-summary-v1.example.json"

# Priority surface 4: Cortina session / usage
validate cortina-lifecycle-event-v1   "$FIXTURES/cortina-lifecycle-event-v1.example.json"

# Priority surface 5: Volva hook event
validate volva-hook-event-v1          "$FIXTURES/volva-hook-event-v1.example.json"

echo ""
echo "Results: $PASS passed, $FAIL failed"
test "$FAIL" -eq 0
