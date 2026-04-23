#!/usr/bin/env python3
"""Check that all exemptions.json producer paths exist."""
import json
import os
import sys

if len(sys.argv) < 3:
    print("Usage: check-cross-tool-payloads.py <exemptions.json> <septa_dir>")
    sys.exit(1)

exemptions_file = sys.argv[1]
septa_dir = sys.argv[2]

try:
    with open(exemptions_file) as f:
        data = json.load(f)
except Exception as e:
    print(f"  ERROR: Could not parse {exemptions_file}: {e}")
    sys.exit(1)

workspace_root = os.path.dirname(septa_dir)
checked = 0
missing = 0

for entry in data.get('exemptions', []):
    producer = entry.get('producer', '')
    if producer.startswith('external:'):
        print(f"  SKIP  {producer} (external)")
        continue

    checked += 1
    full_path = os.path.join(workspace_root, producer)

    if os.path.exists(full_path):
        print(f"  OK    {producer}")
    else:
        print(f"  MISS  {producer} (does not exist)")
        missing += 1

if missing > 0:
    print(f"ERROR: {missing} producer path(s) do not exist")
    sys.exit(1)
else:
    print(f"All {checked} non-external producers exist")
    sys.exit(0)
