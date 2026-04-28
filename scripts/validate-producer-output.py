#!/usr/bin/env python3
"""
Validate a captured producer output file against a Septa schema.

Usage:
    python3 septa/scripts/validate-producer-output.py \\
        --septa-dir /path/to/septa \\
        --schema hyphae-activity-v1 \\
        <captured-output.json>

The validator builds a local $ref registry from all schemas in septa_dir so
cross-file references resolve without network access.  Do NOT use
check-jsonschema with --schemafile for schemas that contain local $ref entries
— those schemas resolve $ref via the $id URI (https://basidiocarp.dev) which
check-jsonschema cannot satisfy.  This script is the correct validation path.

Exit codes:
    0 — validation passed
    1 — validation failed (schema errors printed to stderr)
    2 — usage/dependency error
"""

import argparse
import json
import sys
from pathlib import Path


def build_registry(schema_dir: Path):
    """Return a jsonschema Registry containing every *.schema.json in schema_dir."""
    try:
        from referencing import Registry, Resource
        from referencing.jsonschema import DRAFT202012
        from jsonschema import Draft202012Validator  # noqa: F401 – ensure it's importable
    except ImportError:
        print(
            "ERROR: requires jsonschema and referencing packages\n"
            "  pip install jsonschema referencing",
            file=sys.stderr,
        )
        sys.exit(2)

    from referencing import Registry, Resource
    from referencing.jsonschema import DRAFT202012

    pairs = []
    for path in sorted(schema_dir.glob("*.schema.json")):
        with open(path) as f:
            schema = json.load(f)
        resource = Resource.from_contents(schema, default_specification=DRAFT202012)
        if "$id" in schema:
            pairs.append((schema["$id"], resource))
        # Also key by bare filename so $ref: "foo.schema.json" resolves
        pairs.append((path.name, resource))

    return Registry().with_resources(pairs)


def validate(json_file: Path, schema_name: str, septa_dir: Path) -> bool:
    """
    Validate json_file against the named schema.

    schema_name may be:
      - "hyphae-activity-v1"          (without .schema.json suffix)
      - "hyphae-activity-v1.schema.json"  (with suffix)

    Returns True on success, False on failure (errors printed to stderr).
    """
    try:
        from jsonschema import Draft202012Validator
    except ImportError:
        print("ERROR: requires jsonschema package\n  pip install jsonschema referencing", file=sys.stderr)
        sys.exit(2)

    if not schema_name.endswith(".schema.json"):
        schema_name = schema_name + ".schema.json"

    schema_path = septa_dir / schema_name
    if not schema_path.exists():
        print(f"ERROR: schema not found: {schema_path}", file=sys.stderr)
        sys.exit(2)

    with open(schema_path) as f:
        schema = json.load(f)

    with open(json_file) as f:
        instance = json.load(f)

    registry = build_registry(septa_dir)
    validator = Draft202012Validator(schema, registry=registry)
    errors = list(validator.iter_errors(instance))

    if not errors:
        print(f"PASS  {json_file.name} validates against {schema_name}")
        return True

    print(f"FAIL  {json_file.name} does not validate against {schema_name}", file=sys.stderr)
    for err in sorted(errors, key=lambda e: str(e.json_path)):
        print(f"      {err.json_path}: {err.message[:200]}", file=sys.stderr)
    return False


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate a captured producer JSON output against a Septa schema.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument(
        "--septa-dir",
        default=None,
        help="Path to the septa repo directory.  Defaults to the directory "
             "containing this script's parent.",
    )
    parser.add_argument(
        "--schema",
        required=True,
        help="Schema name, e.g. hyphae-activity-v1 (without .schema.json suffix).",
    )
    parser.add_argument("json_file", help="Path to the JSON file to validate.")
    args = parser.parse_args()

    json_path = Path(args.json_file)
    if not json_path.exists():
        print(f"ERROR: file not found: {json_path}", file=sys.stderr)
        return 2

    if args.septa_dir:
        septa_dir = Path(args.septa_dir)
    else:
        # Default: two levels up from scripts/
        septa_dir = Path(__file__).resolve().parent.parent

    if not septa_dir.exists():
        print(f"ERROR: septa dir not found: {septa_dir}", file=sys.stderr)
        return 2

    return 0 if validate(json_path, args.schema, septa_dir) else 1


if __name__ == "__main__":
    sys.exit(main())
