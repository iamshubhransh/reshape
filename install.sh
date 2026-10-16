#!/usr/bin/env bash
#
# reshape installer
#
# Installs the reshape skill into ~/.claude/skills so Claude Code picks it up
# automatically.
#
# Works two ways:
#
#   Remote (one-liner):
#     curl -fsSL https://raw.githubusercontent.com/iamshubhransh/reshape/main/install.sh | bash
#
#   Local (from a clone):
#     ./install.sh
#
set -euo pipefail

REPO_URL="https://github.com/iamshubhransh/reshape.git"
REPO_TARBALL="https://github.com/iamshubhransh/reshape/archive/refs/heads/main.tar.gz"
SKILL_NAME="reshape"
SKILLS_ROOT="plugins/reshape/skills"
DEST_BASE="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

# ---- pretty output ---------------------------------------------------------
if [ -t 1 ]; then
  BOLD=$(printf '\033[1m'); GREEN=$(printf '\033[32m'); YELLOW=$(printf '\033[33m')
  RED=$(printf '\033[31m'); DIM=$(printf '\033[2m'); RESET=$(printf '\033[0m')
else
  BOLD=""; GREEN=""; YELLOW=""; RED=""; DIM=""; RESET=""
fi
info()  { printf '%s\n' "${BOLD}==>${RESET} $*"; }
ok()    { printf '%s\n' "${GREEN}✓${RESET} $*"; }
warn()  { printf '%s\n' "${YELLOW}!${RESET} $*"; }
die()   { printf '%s\n' "${RED}✗${RESET} $*" >&2; exit 1; }

# ---- locate the skill source -----------------------------------------------
# If this script is being run from inside a checkout, copy from there.
# Otherwise download a fresh copy into a temp dir.
SOURCE_ROOT=""
CLEANUP_TMP=""

SCRIPT_DIR=""
if [ -n "${BASH_SOURCE:-}" ] && [ -f "${BASH_SOURCE[0]:-}" ]; then
  SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
fi

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$SKILLS_ROOT/$SKILL_NAME/SKILL.md" ]; then
  SOURCE_ROOT="$SCRIPT_DIR/$SKILLS_ROOT"
  info "Installing from local checkout."
else
  TMP=$(mktemp -d 2>/dev/null || mktemp -d -t reshape)
  CLEANUP_TMP="$TMP"
  trap '[ -n "$CLEANUP_TMP" ] && rm -rf "$CLEANUP_TMP"' EXIT
  if command -v git >/dev/null 2>&1; then
    info "Fetching reshape…"
    git clone --depth 1 "$REPO_URL" "$TMP/repo" >/dev/null 2>&1 \
      || die "git clone failed. Check your network or clone manually from $REPO_URL"
    SOURCE_ROOT="$TMP/repo/$SKILLS_ROOT"
  elif command -v curl >/dev/null 2>&1; then
    info "Fetching reshape (tarball)…"
    curl -fsSL "$REPO_TARBALL" | tar -xz -C "$TMP" \
      || die "Download failed. Check your network or install git and retry."
    SOURCE_ROOT="$TMP/reshape-main/$SKILLS_ROOT"
  else
    die "Need either git or curl to download. Please install one and retry."
  fi
fi

SOURCE="$SOURCE_ROOT/$SKILL_NAME"
[ -f "$SOURCE/SKILL.md" ] || die "Could not find the skill in the download. Please report this issue."

# ---- install ---------------------------------------------------------------
mkdir -p "$DEST_BASE"
DEST_DIR="$DEST_BASE/$SKILL_NAME"
if [ -d "$DEST_DIR" ]; then
  warn "Existing install at $DEST_DIR — replacing it."
  rm -rf "$DEST_DIR"
fi
cp -R "$SOURCE" "$DEST_DIR"
ok "Installed ${BOLD}$SKILL_NAME${RESET} to ${DIM}$DEST_DIR${RESET}"

echo
info "Next steps"
printf '  %s\n' "1. Restart Claude Code (or start a new session) so it loads the skill."
printf '  %s\n' "2. Run /reshape path/to/prd.md — or just ask Claude to grill you on a PRD."
echo
printf '%s\n' "${DIM}Prefer the marketplace? /plugin marketplace add iamshubhransh/reshape${RESET}"
