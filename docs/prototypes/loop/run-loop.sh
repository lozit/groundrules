#!/usr/bin/env bash
# generated-by: groundrules v1.7.0
#
# run-loop.sh — the capped runner for the minimal maker/verifier loop (M1 prototype).
#
# It replays LOOP.md against a FRESH agent each iteration until one of:
#   - the agent reports "DONE: backlog empty" (natural stop), or
#   - the hard MAX iteration ceiling is hit (anti-runaway — MANDATORY, not optional).
#
# The model forgets between iterations; the repo remembers. All loop logic lives in the Markdown
# prompts (LOOP.md / maker.md / verifier.md) — this script is the ONLY executable piece (ADR 0002/0025).
#
# Usage:
#   bash run-loop.sh [--max N] [--prompt path/to/LOOP.md] [--workdir DIR]
#
# Defaults: --max 5, --prompt <this script's dir>/LOOP.md, --workdir current directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MAX=5                          # hard ceiling — the anti-runaway safety. There is no "unlimited".
PROMPT="$SCRIPT_DIR/LOOP.md"
WORKDIR="$(pwd)"
DONE_MARKER="DONE: backlog empty"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --max)     MAX="$2"; shift 2 ;;
    --prompt)  PROMPT="$2"; shift 2 ;;
    --workdir) WORKDIR="$2"; shift 2 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

# Guard the cap: must be a positive integer, and refuse an absurd ceiling that defeats the purpose.
if ! [[ "$MAX" =~ ^[0-9]+$ ]] || [[ "$MAX" -lt 1 ]]; then
  echo "error: --max must be a positive integer (got '$MAX')" >&2; exit 2
fi
if [[ "$MAX" -gt 50 ]]; then
  echo "error: --max $MAX exceeds the prototype's sanity ceiling of 50 (this is anti-runaway, on purpose)" >&2
  exit 2
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "error: 'claude' CLI not found on PATH — this runner drives 'claude -p' headless." >&2
  echo "       (The contract is validated by subagent simulation; see this folder's README.)" >&2
  exit 127
fi

cd "$WORKDIR"
echo "loop: workdir=$WORKDIR  prompt=$PROMPT  max=$MAX"

for (( i=1; i<=MAX; i++ )); do
  echo "──────── iteration $i / $MAX ────────"

  # Each iteration is a FRESH headless agent invocation: no carried context, state read from disk.
  # `|| true` so a non-zero exit on one iteration doesn't kill the loop before we inspect the output.
  out="$(claude -p "$(cat "$PROMPT")" 2>&1 || true)"
  printf '%s\n' "$out"

  if printf '%s' "$out" | grep -qF "$DONE_MARKER"; then
    echo "loop: natural stop — '$DONE_MARKER' at iteration $i."
    exit 0
  fi
done

echo "loop: hit MAX=$MAX without an empty backlog. Stopping (anti-runaway)."
echo "loop: inspect TODO.md (unchecked tasks) and blocked.md (parked decisions) for human triage."
exit 0
