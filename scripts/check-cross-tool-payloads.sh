#!/usr/bin/env bash
# Validates the cross-tool payload registry:
# 1. Every entry in exemptions.json still references a file that exists (or is external)
# 2. All *.schema.json files are listed in CROSS-TOOL-PAYLOADS.md
# 3. No schema file has been added without a CROSS-TOOL-PAYLOADS.md entry

set -euo pipefail

SEPTA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXEMPTIONS="$SEPTA_DIR/exemptions.json"
PAYLOADS_MD="$SEPTA_DIR/CROSS-TOOL-PAYLOADS.md"

PASS=0
FAIL=0

pass() { echo "  PASS  $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL  $1: $2"; FAIL=$((FAIL+1)); }

echo "=== Septa Cross-Tool Payload Check ==="
echo ""

# Check 1: exemptions.json is valid JSON
if python3 -c "import json; json.load(open('$EXEMPTIONS'))" 2>/dev/null; then
  pass "exemptions.json is valid JSON"
else
  fail "exemptions.json" "invalid JSON"
fi

# Check 2: each exempted producer path exists (skip external: producers)
echo ""
echo "Checking exemptions.json producer paths:"
EXEMPTION_ERRORS=0
python3 "$SEPTA_DIR/scripts/check-cross-tool-payloads.py" "$EXEMPTIONS" "$SEPTA_DIR" || EXEMPTION_ERRORS=$?

if [ $EXEMPTION_ERRORS -eq 0 ]; then
  pass "exemptions.json producer paths exist"
else
  fail "exemptions.json" "one or more producer paths do not exist"
fi

# Check 3: all schema files are mentioned in CROSS-TOOL-PAYLOADS.md
echo ""
echo "Checking schema-file coverage in CROSS-TOOL-PAYLOADS.md:"
SCHEMA_COUNT=0
MISSING_COUNT=0
for schema in "$SEPTA_DIR"/*.schema.json; do
  name=$(basename "$schema")
  SCHEMA_COUNT=$((SCHEMA_COUNT+1))
  if grep -q "$name" "$PAYLOADS_MD" 2>/dev/null; then
    echo "  OK    $name"
  else
    echo "  MISS  $name (not in registry)"
    MISSING_COUNT=$((MISSING_COUNT+1))
  fi
done

if [ "$MISSING_COUNT" -eq 0 ]; then
  pass "all $SCHEMA_COUNT schemas listed in CROSS-TOOL-PAYLOADS.md"
else
  fail "CROSS-TOOL-PAYLOADS.md" "$MISSING_COUNT schema(s) not in registry"
fi

echo ""
echo "Results: ${PASS} pass / ${FAIL} fail"

if [ "$FAIL" -eq 0 ]; then
  exit 0
else
  exit 1
fi
