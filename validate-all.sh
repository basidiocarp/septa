#!/usr/bin/env bash
# Validate all septa schema-fixture pairs.
# Uses a Python wrapper to build a local $ref registry so cross-file
# references resolve without network access.
# Requires: pip install jsonschema referencing
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

python3 - "$SCRIPT_DIR" <<'PYEOF'
import json, sys, os
from pathlib import Path

try:
    from jsonschema import Draft202012Validator
    from referencing import Registry, Resource
    from referencing.jsonschema import DRAFT202012
except ImportError:
    print("ERROR: requires jsonschema and referencing packages")
    print("  pip install jsonschema referencing")
    sys.exit(2)

schema_dir = Path(sys.argv[1])
fixture_dir = schema_dir / "fixtures"

# Build a registry of all schemas keyed by both $id and bare filename
pairs = []
for path in sorted(schema_dir.glob("*.schema.json")):
    with open(path) as f:
        schema = json.load(f)
    resource = Resource.from_contents(schema, default_specification=DRAFT202012)
    # Key by $id if present
    if "$id" in schema:
        pairs.append((schema["$id"], resource))
    # Also key by bare filename so $ref: "foo.schema.json" resolves
    pairs.append((path.name, resource))

registry = Registry().with_resources(pairs)

passed = 0
failed = 0
skipped = 0
errors = []

def validate_fixture(schema, schema_path_name, fixture_path):
    """Validate a single fixture against a schema. Returns True on pass."""
    global passed, failed, errors
    with open(fixture_path) as f:
        fixture = json.load(f)
    label = f"{schema_path_name} / {fixture_path.name}"
    try:
        validator = Draft202012Validator(schema, registry=registry)
        validator.validate(fixture)
        print(f"PASS  {label}")
        passed += 1
        return True
    except Exception:
        print(f"FAIL  {label}")
        for err in sorted(Draft202012Validator(schema, registry=registry).iter_errors(fixture), key=str):
            print(f"      {err.json_path}: {err.message[:120]}")
            break
        errors.append(label)
        failed += 1
        return False

for path in sorted(schema_dir.glob("*.schema.json")):
    name = path.stem.replace(".schema", "")
    fixture_path = fixture_dir / f"{name}.example.json"

    if not fixture_path.exists():
        print(f"SKIP  {path.name} (no fixture)")
        skipped += 1
        continue

    with open(path) as f:
        schema = json.load(f)

    validate_fixture(schema, path.name, fixture_path)

    # Also validate variant fixtures (.full, .degraded, .flagged) if present
    for variant in ("full", "degraded", "flagged"):
        variant_path = fixture_dir / f"{name}.{variant}.json"
        if variant_path.exists():
            validate_fixture(schema, path.name, variant_path)

print()
print(f"Results: {passed} passed, {failed} failed, {skipped} skipped")

if errors:
    print()
    print("Failed schemas:")
    for e in errors:
        print(f"  - {e}")
    sys.exit(1)
PYEOF
