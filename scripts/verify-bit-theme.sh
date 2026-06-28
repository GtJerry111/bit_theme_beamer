#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail=0
check_absent() {
  local pattern="$1"; shift
  local desc="$1"; shift
  if rg -n "$pattern" "$@"; then
    echo "FAIL: $desc" >&2
    fail=1
  else
    echo "OK: $desc"
  fi
}

check_present() {
  local pattern="$1"; shift
  local desc="$1"; shift
  if rg -n "$pattern" "$@" >/dev/null; then
    echo "OK: $desc"
  else
    echo "FAIL: $desc" >&2
    fail=1
  fi
}

check_absent "JXred|BSblue|SCU-Full|SCU-Lite" "no obsolete option names in top-level guidance" \
  "$repo_root/AGENTS.md" "$repo_root/CLAUDE.md"
check_absent "SCU Beamer Theme|SCU-Version|SCU_Beamer|SCU-Beamer|四川大学|Sichuan" \
  "no stale SCU branding in top-level guidance" \
  "$repo_root/AGENTS.md" "$repo_root/CLAUDE.md"
check_present '[^%]*\\pgfuseimage\{verify\}' \
  "verify image is used on the cover page" \
  "$repo_root/beamerinnerthemebit.sty"
check_absent '[^%]*\\pgfuseimage\{verify\}' \
  "verify image is not used outside the cover page" \
  "$repo_root/beamerthemebit.sty"

exit "$fail"
