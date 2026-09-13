#!/usr/bin/env bash
#
# install.sh — set up a project with Loadout: Layer 1 (commodity engineering
# frameworks) + Layer 2 (the personal layer from this repo).
#
# By default the install is LAYERED: it provisions the Layer 1 plugins
# (superpowers, GSD, context-mode, claude-mem, skill-creator, frontend-design)
# via the `claude` CLI, then copies the Layer 2 skills and the operator
# profile (with its Layer Contract). Pass --standalone to skip Layer 1
# entirely — pure bash, zero external dependencies.
#
# Usage:
#   ./install.sh <target-dir>                                 # default: wizard
#   ./install.sh <target-dir> --wizard
#   ./install.sh <target-dir> --preset <name> [--standalone]
#   ./install.sh <target-dir> --custom \
#       [--domains <list>] [--business <list>] [--meta <list>] \
#       [--standalone] [--no-claude-overwrite]
#
# Presets:
#   academic-research   scientific-python, academic-writing, data-analysis, report-generation
#   job-pipeline        scientific-python, infra-containers, outreach-applications,
#                       automation-workflows
#   engineering         engineering-simulation, scientific-python, data-analysis,
#                       report-generation, infra-containers
#
# Every domain/business/meta skill not listed above a preset is still reachable via
# --custom, or via the wizard's dynamic domain toggle and outcome-driven business
# selection (wizard.sh Q3/Q7) — presets are a maintenance-cost curation of the common
# cases, not the only way to reach a skill.
#
# Custom flags accept comma-separated lists (no spaces). Examples:
#   --domains backend-saas,frontend,infra-containers
#   --business outcome-framing,client-services
#   --meta monetize-or-opensource
#
# --standalone (optional) skips Layer 1 plugin provisioning; copy-only, no deps.
# --no-claude-overwrite (optional) skips copying CLAUDE.md (used by wizard.sh).

set -euo pipefail

# ---- Paths ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="$SCRIPT_DIR"

# ---- Helpers ----
die() { echo "ERROR: $*" >&2; exit 1; }
info() { echo "  $*"; }
# trim leading/trailing whitespace (comma-separated lists may be entered as "a, b, c")
trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; printf '%s' "${s%"${s##*[![:space:]]}"}"; }

usage() {
    cat <<'EOF'
Usage:
  ./install.sh <target-dir>                                 # default: wizard
  ./install.sh <target-dir> --wizard
  ./install.sh <target-dir> --preset <name> [--standalone]
  ./install.sh <target-dir> --custom [--domains <list>] [--business <list>] [--meta <list>] [--standalone]

Default install is layered: Layer 1 plugins (superpowers, GSD, context-mode,
claude-mem, skill-creator, frontend-design) via the claude CLI, then the
Loadout personal layer on top. --standalone skips Layer 1 (pure bash, zero deps).

Presets:
  academic-research, job-pipeline, engineering

Run with no arguments for this help.
EOF
}

# ---- Args ----
[[ $# -lt 1 ]] && { usage; exit 0; }

TARGET="$1"; shift
[[ -z "${TARGET:-}" ]] && die "missing target directory"
[[ ! -d "$TARGET" ]] && die "target directory does not exist: $TARGET"

MODE=""        # preset | custom | wizard
PRESET=""
DOMAINS=""
BUSINESS=""
META=""
STANDALONE="false"
NO_CLAUDE_OVERWRITE="false"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --preset)               MODE="preset";  PRESET="$2";   shift 2 ;;
        --custom)               MODE="custom";                  shift   ;;
        --wizard)               MODE="wizard";                  shift   ;;
        --domains)              DOMAINS="$2";                   shift 2 ;;
        --business)             BUSINESS="$2";                  shift 2 ;;
        --meta)                 META="$2";                      shift 2 ;;
        --standalone)           STANDALONE="true";              shift   ;;
        --no-claude-overwrite)  NO_CLAUDE_OVERWRITE="true";     shift   ;;
        --help|-h)              usage; exit 0 ;;
        *)                      die "unknown flag: $1" ;;
    esac
done

# Default to wizard mode when no mode flag is given.
[[ -z "$MODE" ]] && MODE="wizard"

# ---- Wizard dispatch (before preset/custom logic) ----
if [[ "$MODE" == "wizard" ]]; then
    WIZARD="$LIB/wizard.sh"
    [[ -f "$WIZARD" ]] || die "wizard.sh not found at $WIZARD"
    export LIB STANDALONE
    exec bash "$WIZARD" "$TARGET"
fi

# ---- Preset definitions ----
case "$PRESET" in
    "")
        ;;  # custom mode, fall through
    academic-research)
        DOMAINS="scientific-python,academic-writing,data-analysis,report-generation"
        BUSINESS=""
        META=""
        ;;
    job-pipeline)
        DOMAINS="scientific-python,infra-containers"
        BUSINESS="outreach-applications,automation-workflows"
        META=""
        ;;
    engineering)
        DOMAINS="engineering-simulation,scientific-python,data-analysis,report-generation,infra-containers"
        BUSINESS=""
        META=""
        ;;
    *)
        [[ "$MODE" == "preset" ]] && die "unknown preset: $PRESET (available: academic-research, job-pipeline, engineering — or use --custom)"
        ;;
esac

# ---- Layer 1: commodity engineering frameworks (default; skip with --standalone) ----
# Plugins install globally — once per machine, not per project. Loadout (Layer 2)
# assumes these exist and delegates engineering execution to them.
if [[ "$STANDALONE" != "true" ]]; then
    echo "==> Provisioning Layer 1 (superpowers, GSD, context-mode, claude-mem, skill-creator, frontend-design)"
    if ! command -v claude >/dev/null 2>&1; then
        echo "  WARNING: 'claude' CLI not found in PATH; skipping Layer 1 provisioning."
        echo "  Layer 2 still installs. To finish later: install Claude Code, then rerun,"
        echo "  or use --standalone to silence this warning."
    else
        # superpowers, skill-creator, frontend-design live in the default
        # claude-plugins-official marketplace — no marketplace suffix needed.
        # gsd, context-mode, claude-mem live in their own marketplace repos,
        # which must be registered before `claude plugin install` can find them.
        MARKETPLACES=(
            "jnuyens/gsd-plugin"
            "mksglu/context-mode"
            "thedotmack/claude-mem"
        )
        for m in "${MARKETPLACES[@]}"; do
            echo "  marketplace: $m"
            claude plugin marketplace add "$m" || echo "    (failed; continue)"
        done
        PLUGINS=(
            "superpowers"
            "gsd@gsd-plugin"
            "context-mode@context-mode"
            "claude-mem@thedotmack"
            "skill-creator"
            "frontend-design"
        )
        for p in "${PLUGINS[@]}"; do
            echo "  installing: $p"
            claude plugin install "$p" || echo "    (failed; continue)"
        done
    fi
fi

# ---- Layer 2: build target structure ----
echo "==> Installing into: $TARGET/.claude/"
mkdir -p "$TARGET/.claude/skills"

# ---- Always copy core ----
echo "==> Copying core (always)"
if [[ "$NO_CLAUDE_OVERWRITE" != "true" ]]; then
    if [[ -f "$LIB/core/CLAUDE.md.template" ]]; then
        cp "$LIB/core/CLAUDE.md.template" "$TARGET/CLAUDE.md"
        info "CLAUDE.md (from template — placeholders unfilled; rerun with --wizard to personalize)"
    else
        die "core/CLAUDE.md.template not found at $LIB/core/"
    fi
fi
mkdir -p "$TARGET/.claude/skills/thinking" "$TARGET/.claude/skills/operating"
cp "$LIB"/core/skills/thinking/*.md              "$TARGET/.claude/skills/thinking/"
cp "$LIB"/core/skills/operating/*.md             "$TARGET/.claude/skills/operating/"
info "$(ls "$LIB"/core/skills/thinking/*.md | wc -l) thinking skills, $(ls "$LIB"/core/skills/operating/*.md | wc -l) operating skills"

# ---- Privacy boundary: filing-protocol's reference/ and log/ stay local by
# default (the scaffold is public, the fill is not). Written unconditionally
# since the filing-protocol skill and CLAUDE.md.template block ship in every
# install regardless of mode or wizard answer; idempotent on re-run.
GITIGNORE="$TARGET/.gitignore"
GITIGNORE_MARKER="# Loadout filing structure (reference/, log/) — local by default"
if [[ ! -f "$GITIGNORE" ]] || ! grep -qF "$GITIGNORE_MARKER" "$GITIGNORE" 2>/dev/null; then
    { [[ -s "$GITIGNORE" ]] && echo ""; echo "$GITIGNORE_MARKER"; echo "reference/**"; echo "log/**"; } >> "$GITIGNORE"
    info ".gitignore: reference/**, log/** (supplied material and working logs stay local)"
fi

# ---- Copy domain skills ----
if [[ -n "$DOMAINS" ]]; then
    echo "==> Copying domain skills: $DOMAINS"
    IFS=',' read -ra DOM_ARR <<< "$DOMAINS"
    for d in "${DOM_ARR[@]}"; do
        d="$(trim "$d")"
        src="$LIB/domains/${d}.md"
        [[ ! -f "$src" ]] && die "domain skill not found: $d"
        cp "$src" "$TARGET/.claude/skills/${d}.md"
        info "$d.md"
    done
fi

# ---- Copy business skills ----
if [[ -n "$BUSINESS" ]]; then
    echo "==> Copying business skills: $BUSINESS"
    IFS=',' read -ra BIZ_ARR <<< "$BUSINESS"
    for b in "${BIZ_ARR[@]}"; do
        b="$(trim "$b")"
        src="$LIB/business/${b}.md"
        [[ ! -f "$src" ]] && die "business skill not found: $b"
        cp "$src" "$TARGET/.claude/skills/${b}.md"
        info "$b.md"
    done
fi

# ---- Copy meta skills ----
if [[ -n "$META" ]]; then
    echo "==> Copying meta skills: $META"
    IFS=',' read -ra META_ARR <<< "$META"
    for m in "${META_ARR[@]}"; do
        m="$(trim "$m")"
        src="$LIB/meta/${m}.md"
        [[ ! -f "$src" ]] && die "meta skill not found: $m"
        cp "$src" "$TARGET/.claude/skills/${m}.md"
        info "$m.md"

        # If parent meta-skill, also bring in subs
        if [[ "$m" == "monetize-or-opensource" ]]; then
            mkdir -p "$TARGET/.claude/skills/sub"
            cp "$LIB"/meta/sub/*.md "$TARGET/.claude/skills/sub/"
            info "sub/open-sourcing.md, sub/monetization.md"
        fi
    done
fi

echo ""
echo "==> Done."
echo ""
echo "Files installed:"
find "$TARGET/.claude" -type f | sort | sed 's|^|  |'
[[ "$NO_CLAUDE_OVERWRITE" != "true" ]] && echo "  $TARGET/CLAUDE.md"
echo ""
echo "Next steps:"
echo "  - Open $TARGET in Claude Code"
echo "  - Skills auto-discover from .claude/skills/"
if [[ "$NO_CLAUDE_OVERWRITE" != "true" ]]; then
    echo "  - CLAUDE.md was copied with placeholders unfilled. Either edit by hand"
    echo "    or rerun with --wizard for an interactive personalization."
fi
echo "  - Reference pitfalls.md in the loadout repo (core/pitfalls.md) when designing new skills"
