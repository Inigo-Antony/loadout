#!/usr/bin/env bash
#
# install.sh — populate a project's .claude/ directory from Loadout.
#
# Usage:
#   ./install.sh <target-dir>                                 # default: wizard
#   ./install.sh <target-dir> --wizard
#   ./install.sh <target-dir> --preset <name> [--plugins]
#   ./install.sh <target-dir> --custom \
#       [--domains <list>] [--business <list>] [--meta <list>] \
#       [--plugins] [--no-claude-overwrite]
#
# Presets:
#   academic-research   scientific-python, academic-writing, data-analysis, report-generation
#   saas-launch         backend-saas, frontend, infra-containers, outcome-framing,
#                       product-launch, report-generation, monetize-or-opensource
#   freelance-services  client-services, outcome-framing, automation-workflows
#   content-creator     content-creation, seo-and-marketing, digital-products, product-launch
#   job-pipeline        scientific-python, infra-containers, outreach-applications,
#                       automation-workflows
#   consultant          ai-consulting, outcome-framing, client-services, report-generation
#   engineering         engineering-simulation, scientific-python, data-analysis,
#                       report-generation, infra-containers
#
# Custom flags accept comma-separated lists (no spaces). Examples:
#   --domains backend-saas,frontend,infra-containers
#   --business outcome-framing,client-services
#   --meta monetize-or-opensource
#
# --plugins (optional) runs `claude plugin install` for the recommended plugin set.
# --no-claude-overwrite (optional) skips copying CLAUDE.md (used by wizard.sh).

set -euo pipefail

# ---- Paths ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="$SCRIPT_DIR"

# ---- Helpers ----
die() { echo "ERROR: $*" >&2; exit 1; }
info() { echo "  $*"; }

usage() {
    cat <<'EOF'
Usage:
  ./install.sh <target-dir>                                 # default: wizard
  ./install.sh <target-dir> --wizard
  ./install.sh <target-dir> --preset <name> [--plugins]
  ./install.sh <target-dir> --custom [--domains <list>] [--business <list>] [--meta <list>] [--plugins]

Presets:
  academic-research, saas-launch, freelance-services,
  content-creator, job-pipeline, consultant, engineering

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
INSTALL_PLUGINS="false"
NO_CLAUDE_OVERWRITE="false"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --preset)               MODE="preset";  PRESET="$2";   shift 2 ;;
        --custom)               MODE="custom";                  shift   ;;
        --wizard)               MODE="wizard";                  shift   ;;
        --domains)              DOMAINS="$2";                   shift 2 ;;
        --business)             BUSINESS="$2";                  shift 2 ;;
        --meta)                 META="$2";                      shift 2 ;;
        --plugins)              INSTALL_PLUGINS="true";         shift   ;;
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
    export LIB
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
    saas-launch)
        DOMAINS="backend-saas,frontend,infra-containers,report-generation"
        BUSINESS="outcome-framing,product-launch"
        META="monetize-or-opensource"
        ;;
    freelance-services)
        DOMAINS=""
        BUSINESS="client-services,outcome-framing,automation-workflows"
        META=""
        ;;
    content-creator)
        DOMAINS=""
        BUSINESS="content-creation,seo-and-marketing,digital-products,product-launch"
        META=""
        ;;
    job-pipeline)
        DOMAINS="scientific-python,infra-containers"
        BUSINESS="outreach-applications,automation-workflows"
        META=""
        ;;
    consultant)
        DOMAINS="report-generation"
        BUSINESS="ai-consulting,outcome-framing,client-services"
        META=""
        ;;
    engineering)
        DOMAINS="engineering-simulation,scientific-python,data-analysis,report-generation,infra-containers"
        BUSINESS=""
        META=""
        ;;
    *)
        [[ "$MODE" == "preset" ]] && die "unknown preset: $PRESET"
        ;;
esac

# ---- Build target structure ----
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
cp "$LIB/core/pitfalls.md"                       "$TARGET/.claude/pitfalls.md"
mkdir -p "$TARGET/.claude/skills/thinking" "$TARGET/.claude/skills/operating"
cp "$LIB"/core/skills/thinking/*.md              "$TARGET/.claude/skills/thinking/"
cp "$LIB"/core/skills/operating/*.md             "$TARGET/.claude/skills/operating/"
info "pitfalls.md, $(ls "$LIB"/core/skills/thinking/*.md | wc -l) thinking skills, $(ls "$LIB"/core/skills/operating/*.md | wc -l) operating skills"

# ---- Copy domain skills ----
if [[ -n "$DOMAINS" ]]; then
    echo "==> Copying domain skills: $DOMAINS"
    IFS=',' read -ra DOM_ARR <<< "$DOMAINS"
    for d in "${DOM_ARR[@]}"; do
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

# ---- Plugins ----
if [[ "$INSTALL_PLUGINS" == "true" ]]; then
    echo "==> Installing recommended plugins"
    if ! command -v claude >/dev/null 2>&1; then
        echo "  WARNING: 'claude' command not found in PATH; skipping plugin install."
        echo "  Install Claude Code first, then run: $0 $TARGET --plugins"
    else
        # The recommended baseline. Edit this block to change the set.
        PLUGINS=(
            "skill-creator@anthropics"
            "frontend-design@anthropics"
            "superpowers@obra"
            "claude-mem@thedotmack"
            "context-mode"
            "gsd"
        )
        for p in "${PLUGINS[@]}"; do
            echo "  installing: $p"
            claude plugin install "$p" || echo "    (failed; continue)"
        done
    fi
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
echo "  - Reference $TARGET/.claude/pitfalls.md when designing new skills"
