#!/usr/bin/env python
# PreToolUse guard: protect repo-root files.
# For Write/Edit/MultiEdit/NotebookEdit whose target lives directly in the
# repository (or worktree) root, it returns permissionDecision "ask" so the
# user must approve before Claude creates or modifies a root file. Edits inside
# any subfolder are allowed silently. The repo root is passed as argv[1] by the
# hook command (falls back to CLAUDE_PROJECT_DIR / cwd). Stays silent on any
# error (fail-open) so it never wrongly interrupts edits.
import sys, json, os

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

ti = data.get("tool_input") or {}
fp = ti.get("file_path") or ti.get("notebook_path") or ""
if not fp:
    sys.exit(0)

root = sys.argv[1] if len(sys.argv) > 1 and sys.argv[1] else (
    os.environ.get("CLAUDE_PROJECT_DIR") or os.getcwd()
)
parent = os.path.dirname(os.path.abspath(fp))

def norm(p):
    return os.path.normcase(os.path.normpath(p))

if root and norm(parent) == norm(root):
    reason = (
        "This file is in the repository ROOT, protected by a project rule. "
        "Default approach: create a NEW subfolder and adapt a COPY there instead. "
        "Approve only if you intentionally want to create/modify this root file."
    )
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "ask",
            "permissionDecisionReason": reason,
        }
    }))

sys.exit(0)
