#!/usr/bin/env bash
# generated-by: groundrules v1.12.0
#
# check-adr-index.sh — every ADR file has a row in the index, and every row points at a file.
#
# Why this exists: on 2026-09-21 an ADR was added without its index row and survived, because the
# only thing checking that invariant was a line in the release checklist — read at release, days
# after the omission. A set comparison has one correct answer, so it is a check, not a reminder.
#
# Deterministic, offline, zero tokens. Exit 0 when the two sets match, 1 when they do not.
#
# Usage (from the project root):
#   bash test/check-adr-index.sh

set -euo pipefail

DIR="${1:-docs/decisions}"
INDEX="$DIR/README.md"

[[ -d "$DIR"   ]] || { echo "check-adr-index: no such directory: $DIR" >&2; exit 2; }
[[ -f "$INDEX" ]] || { echo "check-adr-index: no index at $INDEX" >&2; exit 2; }

fail=0

# Files: NNNN-*.md, excluding the template (0000) and the index itself.
files="$(find "$DIR" -maxdepth 1 -name '[0-9][0-9][0-9][0-9]-*.md' -exec basename {} \; \
         | grep -v '^0000-' | sort)"

# Rows: whatever the index links to that looks like an ADR filename.
rows="$(grep -o '([0-9][0-9][0-9][0-9]-[^)]*\.md)' "$INDEX" | tr -d '()' | sort -u)"

while read -r f; do
  [[ -z "$f" ]] && continue
  grep -qxF "$f" <<<"$rows" || { echo "❌ not in the index: $f"; fail=1; }
done <<<"$files"

while read -r r; do
  [[ -z "$r" ]] && continue
  [[ -f "$DIR/$r" ]] || { echo "❌ index row points at a missing file: $r"; fail=1; }
done <<<"$rows"

# A duplicated row is not a missing one, and reads as agreement until someone diffs them.
dupes="$(grep -o '([0-9][0-9][0-9][0-9]-[^)]*\.md)' "$INDEX" | tr -d '()' | sort | uniq -d)"
[[ -n "$dupes" ]] && { echo "❌ listed more than once: $(tr '\n' ' ' <<<"$dupes")"; fail=1; }

n_files="$(grep -c . <<<"$files" || true)"
if [[ "$fail" == "0" ]]; then
  echo "✅ check-adr-index: $n_files ADRs, all indexed, no dangling or duplicate rows"
else
  echo "check-adr-index: FAILED — add the missing row(s) to $INDEX" >&2
fi
exit "$fail"
