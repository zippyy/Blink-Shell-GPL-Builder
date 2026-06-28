#!/bin/bash
# Compatibility launcher for the GPL Blink builder.
# Repairs the TEAM_ID substitution so project.pbxproj remains a valid Xcode plist,
# then runs the normal builder with all arguments unchanged.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILDER="${SCRIPT_DIR}/build-blink-shell-gpl.sh"

if [[ ! -f "$BUILDER" ]]; then
    echo "Error: build-blink-shell-gpl.sh was not found next to this launcher."
    exit 1
fi

python3 - "$BUILDER" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
data = path.read_text(encoding="utf-8")
old = 'sed -i \'\' "s/${HARDCODED_TEAM}/\\${TEAM_ID}/g" "$PROJECT_FILE"'
new = 'sed -i \'\' "s/${HARDCODED_TEAM}/\\\"\\$(TEAM_ID)\\\"/g" "$PROJECT_FILE"'

if old in data:
    path.write_text(data.replace(old, new), encoding="utf-8")
    print("Patched TEAM_ID substitution: project files will use \"$(TEAM_ID)\".")
elif new in data:
    print("TEAM_ID substitution is already patched.")
else:
    print("Warning: Could not find the expected TEAM_ID substitution rule.")
PY

exec "$BUILDER" "$@"
