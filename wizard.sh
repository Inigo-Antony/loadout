#!/usr/bin/env bash
#
# wizard.sh — interactive personalization wizard for Loadout
#
# Usage:
#   ./wizard.sh <target-dir>
#
# Walks the user through 5–8 questions, then writes a personalized CLAUDE.md
# and a curated skill set into <target-dir>/CLAUDE.md and <target-dir>/.claude/.
#
# Intended to be called from install.sh:
#   ./install.sh ~/projects/myproject --wizard
# which dispatches here when --wizard is passed.
#
# This script is intentionally written in pure bash + standard POSIX tools
# (grep, awk, sed) so it runs on every machine install.sh already runs on.
# No python, no jq, no network calls. Reference-markdown "parsing" is
# regex-based signal extraction — the user reviews the draft before commit.

set -euo pipefail

# ---- Paths ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Locate LIB (repo root). Priority: explicit LIB env (set by install.sh), then
# SCRIPT_DIR if it contains install.sh (wizard sits at repo root), else walk up.
if [[ -z "${LIB:-}" ]]; then
    if [[ -f "$SCRIPT_DIR/install.sh" ]]; then
        LIB="$SCRIPT_DIR"
    elif [[ -f "$SCRIPT_DIR/../install.sh" ]]; then
        LIB="$(cd "$SCRIPT_DIR/.." && pwd)"
    else
        echo "ERROR: cannot locate Loadout repo root from $SCRIPT_DIR" >&2
        exit 1
    fi
fi

# ---- Helpers ----
die()  { echo "ERROR: $*" >&2; exit 1; }
info() { echo "  $*"; }
hr()   { echo "------------------------------------------------------------"; }
say()  { echo ""; echo "$*"; }
# trim leading/trailing whitespace (comma-separated lists may be entered as "a, b, c")
trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; printf '%s' "${s%"${s##*[![:space:]]}"}"; }
# list available domain skills (basenames), discovered from the repo so the
# prompt and validation stay in sync with the actual files.
list_domains() {
    local f
    for f in "$LIB"/domains/*.md; do
        [[ -e "$f" ]] || continue
        basename "$f" .md
    done
}

# ask <prompt> <default> <varname>
# Reads one line. If empty, uses default. Stores into the named variable.
ask() {
    local prompt="$1" default="$2" varname="$3" reply=""
    if [[ -n "$default" ]]; then
        printf "  %s [%s]: " "$prompt" "$default"
    else
        printf "  %s: " "$prompt"
    fi
    IFS= read -r reply || true
    [[ -z "$reply" ]] && reply="$default"
    printf -v "$varname" '%s' "$reply"
}

# ask_multiline <prompt> <varname>
# Reads until a single "." on a line. Stores joined content.
ask_multiline() {
    local prompt="$1" varname="$2" line="" buf=""
    echo "  $prompt"
    echo "  (end with a single '.' on its own line, or just press enter to skip)"
    while IFS= read -r line; do
        [[ "$line" == "." ]] && break
        [[ -z "$line" && -z "$buf" ]] && break
        buf+="${line}"$'\n'
    done
    printf -v "$varname" '%s' "$buf"
}

# pick_one <prompt> <varname> <option1> <option2> ...
# Numbered menu; user types the number.
pick_one() {
    local prompt="$1" varname="$2"; shift 2
    local opts=("$@") i=1 choice="" reply=""
    echo "  $prompt"
    for o in "${opts[@]}"; do
        printf "    %d) %s\n" "$i" "$o"
        i=$((i+1))
    done
    while true; do
        printf "  pick [1-%d]: " "${#opts[@]}"
        IFS= read -r reply || true
        [[ "$reply" =~ ^[0-9]+$ ]] || { echo "  enter a number."; continue; }
        (( reply >= 1 && reply <= ${#opts[@]} )) || { echo "  out of range."; continue; }
        choice="${opts[$((reply-1))]}"
        break
    done
    printf -v "$varname" '%s' "$choice"
}

# toggle_menu <prompt> <varname> <option1> <option2> ...
# Numbered checklist. User types one number per line to flip that item's
# checkbox; the menu redraws after each input. Blank line + Enter confirms
# the selection. Stores the checked option strings, one per line, into
# <varname> (read them back with `while IFS= read -r line; do ...; done <<< "$varname"`).
toggle_menu() {
    local prompt="$1" varname="$2"; shift 2
    local opts=("$@")
    local n=${#opts[@]}
    local -a checked
    local i reply idx result=""
    for ((i = 0; i < n; i++)); do checked[i]=0; done
    while true; do
        echo "  $prompt"
        for ((i = 0; i < n; i++)); do
            if [[ "${checked[i]}" == "1" ]]; then
                printf "    %d) [x] %s\n" "$((i + 1))" "${opts[i]}"
            else
                printf "    %d) [ ] %s\n" "$((i + 1))" "${opts[i]}"
            fi
        done
        printf "  toggle a number, or press Enter to confirm: "
        reply=""
        IFS= read -r reply || true
        [[ -z "$reply" ]] && break
        if [[ "$reply" =~ ^[0-9]+$ ]] && (( reply >= 1 && reply <= n )); then
            idx=$((reply - 1))
            if [[ "${checked[idx]}" == "1" ]]; then checked[idx]=0; else checked[idx]=1; fi
        else
            echo "  enter a number between 1 and $n, or press Enter to finish."
        fi
        echo ""
    done
    for ((i = 0; i < n; i++)); do
        [[ "${checked[i]}" == "1" ]] && result+="${opts[i]}"$'\n'
    done
    printf -v "$varname" '%s' "$result"
}

# dedup_csv <comma-separated-list>
# Removes duplicate entries (order-preserving) from a comma-separated list.
dedup_csv() {
    echo "$1" | tr ',' '\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | awk 'NF && !seen[$0]++' | paste -sd, -
}

# ensure_skill_drafts_readme
# Writes the skill-drafts/README.md header once, on first use.
ensure_skill_drafts_readme() {
    local f="$TARGET/.claude/skill-drafts/README.md"
    if [[ ! -f "$f" ]]; then
        mkdir -p "$TARGET/.claude/skill-drafts"
        cat > "$f" <<'EOF'
# Skill drafts

Reference files staged here during a wizard run, one subfolder per category.
None of these are skills yet -- bash can't author a skill body. In a live
Claude Code session, run the `walkthrough-then-codify` skill against a
subfolder to turn its contents into a real skill under `.claude/skills/`.

Staged:
EOF
    fi
}

# stage_skill_draft <category> <comma-separated-reference-paths>
# Copies the given files into .claude/skill-drafts/<category>/ and records
# the count in skill-drafts/README.md. Skips paths that don't exist (warns).
stage_skill_draft() {
    local category="$1" paths="$2"
    local dest="$TARGET/.claude/skill-drafts/$category"
    mkdir -p "$dest"
    local -a ref_arr
    IFS=',' read -ra ref_arr <<< "$paths"
    local p copied=0 base destfile n
    for p in "${ref_arr[@]}"; do
        p="$(trim "$p")"
        [[ -z "$p" ]] && continue
        if [[ -f "$p" ]]; then
            base="$(basename "$p")"
            destfile="$dest/$base"
            n=2
            while [[ -e "$destfile" ]]; do
                destfile="$dest/${n}-${base}"
                n=$((n + 1))
            done
            cp "$p" "$destfile"
            copied=$((copied + 1))
        else
            echo "    WARNING: not found, skipping: $p"
        fi
    done
    if (( copied > 0 )); then
        ensure_skill_drafts_readme
        echo "- $category: $copied file(s) staged in skill-drafts/$category/" >> "$TARGET/.claude/skill-drafts/README.md"
        info "staged $copied file(s) into .claude/skill-drafts/$category/"
    fi
}

# ---- Reference-markdown signal extraction ----
#
# We do NOT call out to an LLM here. We pull simple, conservative signals:
#   - candidate name (first H1 of the file)
#   - role/title lines (matches "I am a ...", "Role:", "Title:")
#   - voice signals (short-vs-long sentences ratio, presence of bullet lists)
#   - topical keywords (top 8 word stems above frequency threshold,
#     after stripping common stopwords)
# These get surfaced as "we saw X — accept y/n?" so the user is always in the loop.
extract_signals() {
    local f="$1"
    [[ ! -f "$f" ]] && { echo "  (not found, skipping): $f"; return; }
    echo ""
    echo "  reading $f ..."

    # Candidate name from first H1
    local name_guess
    name_guess="$(grep -m1 -E '^# [^#]' "$f" 2>/dev/null | sed -E 's/^# //; s/[[:space:]]+$//' || true)"
    [[ -n "$name_guess" ]] && echo "    H1 / candidate identity line: \"$name_guess\""

    # Role / self-description lines
    local role_lines
    role_lines="$(grep -inE '(^|[[:space:]])(i am|i am a|i am an|role:|title:|currently|i work|i build|i ship)[^.]*' "$f" 2>/dev/null | head -3 | sed 's/^/      /' || true)"
    [[ -n "$role_lines" ]] && { echo "    role / self-description signals:"; echo "$role_lines"; }

    # Voice signal: very-short sentences (<=8 words ending with period) suggest concise voice
    local short_count long_count
    short_count="$(awk 'BEGIN{c=0} {n=split($0,a,/[.!?]/); for(i=1;i<=n;i++){w=split(a[i],b," "); if(w>=2 && w<=8) c++}} END{print c}' "$f")"
    long_count="$(awk 'BEGIN{c=0}  {n=split($0,a,/[.!?]/); for(i=1;i<=n;i++){w=split(a[i],b," "); if(w>=18) c++}} END{print c}' "$f")"
    echo "    voice estimate: short-sentence count=$short_count, long-sentence count=$long_count"
    if (( short_count > long_count )); then
        echo "    -> voice tilts concise"
    else
        echo "    -> voice tilts verbose / expository"
    fi

    # Topical keywords (very rough — strip punctuation, lowercase, drop stopwords, count)
    local kws
    kws="$(tr '[:upper:]' '[:lower:]' < "$f" \
        | tr -c '[:alpha:]' '\n' \
        | awk 'length($0) >= 5' \
        | grep -Ev '^(claude|about|after|again|because|before|being|could|every|first|might|other|their|there|these|thing|those|through|under|where|which|while|would|years|using|should|really)$' \
        | sort | uniq -c | sort -rn | head -8 | awk '{print "      "$2" ("$1")"}')"
    [[ -n "$kws" ]] && { echo "    top topical keywords:"; echo "$kws"; }
}

# ---- Header ----
clear || true
cat <<'EOF'
============================================================
  Loadout :: personalization wizard
  ~5 minutes. ~7 questions. Editable output at the end.
============================================================

I'll ask a handful of questions, then write a personalized
CLAUDE.md plus a curated skill set into your target project.
You can re-run this safely — existing edits are preserved.

EOF

# ---- Arg ----
TARGET="${1:-}"
[[ -z "$TARGET" ]] && die "missing target directory.  usage: ./wizard.sh <target-dir>"
[[ ! -d "$TARGET" ]] && die "target directory does not exist: $TARGET"
TARGET="$(cd "$TARGET" && pwd)"

# ---- Re-run detection ----
EXISTING_CLAUDE="$TARGET/CLAUDE.md"
REUSE_EXISTING="false"
if [[ -f "$EXISTING_CLAUDE" ]]; then
    say "I found an existing CLAUDE.md at:"
    echo "  $EXISTING_CLAUDE"
    pick_one "what should I do with it?" CHOICE \
        "back it up to CLAUDE.md.bak and write a fresh one" \
        "treat it as a reference file (extract signals, then write a fresh one)" \
        "abort — I want to edit it by hand"
    case "$CHOICE" in
        back*)      cp "$EXISTING_CLAUDE" "$EXISTING_CLAUDE.bak"; info "backed up to CLAUDE.md.bak" ;;
        treat*)
            REUSE_EXISTING="true"
            cp "$EXISTING_CLAUDE" "$EXISTING_CLAUDE.bak"
            info "backed up to CLAUDE.md.bak"
            hr
            say "Scanning your existing CLAUDE.md for signals (regex extraction -- no LLM call)."
            extract_signals "$EXISTING_CLAUDE.bak"
            echo ""
            echo "  Signals above are advisory. Override anything you disagree with"
            echo "  on the next prompts, or accept the defaults."
            ;;
        abort*)     die "aborted by user" ;;
    esac
fi

# =========================================================
# QUESTIONS
# =========================================================

hr
say "Q1. What's your name? (used to address you in your CLAUDE.md)"
ask "name" "" NAME
[[ -z "$NAME" ]] && die "name required"

hr
say "Q2. What's your role / title / one-line self-description?"
echo "    examples:"
echo "      - full-stack indie hacker shipping niche SaaS"
echo "      - PhD candidate, computational neuroscience"
echo "      - independent consultant, B2B AI workflows"
ask "role" "" ROLE
[[ -z "$ROLE" ]] && die "role required"

hr
say "Q3. What domain(s) do you work in?"
DOMAIN_OPTS=()
while IFS= read -r d; do
    [[ -n "$d" ]] && DOMAIN_OPTS+=("$d")
done < <(list_domains)
NEW_SKILL_LABEL="+ create a new skill from reference files"
toggle_menu "Toggle the domain skills to include:" DOMAIN_TOGGLE_RESULT \
    "${DOMAIN_OPTS[@]}" "$NEW_SKILL_LABEL"

DOMAIN_INPUT=""
CREATE_DOMAIN_SKILL="false"
while IFS= read -r sel; do
    [[ -z "$sel" ]] && continue
    if [[ "$sel" == "$NEW_SKILL_LABEL" ]]; then
        CREATE_DOMAIN_SKILL="true"
        continue
    fi
    DOMAIN_INPUT="${DOMAIN_INPUT:+$DOMAIN_INPUT,}$sel"
done <<< "$DOMAIN_TOGGLE_RESULT"

if [[ "$CREATE_DOMAIN_SKILL" == "true" ]]; then
    echo "    Comma-separated absolute paths to notes/docs to draw a new domain skill from."
    ask "reference files" "" DOMAIN_REF_FILES
    [[ -n "$DOMAIN_REF_FILES" ]] && stage_skill_draft "domains" "$DOMAIN_REF_FILES"
fi

hr
say "Q4. Voice preferences."
pick_one "verbosity?" VOICE_VERBOSITY \
    "concise — lead with the answer, justify after, no filler" \
    "balanced — short paragraphs, some context" \
    "verbose — full reasoning shown, examples and asides welcome"
pick_one "register?" VOICE_REGISTER \
    "direct / informal — peer voice, no apologies" \
    "professional — courteous but not flowery" \
    "academic — measured, hedged where warranted"

hr
say "Q5. Tooling preferences."
pick_one "primary OS?" PRIMARY_OS \
    "Linux (Fedora / Arch / Debian-family)" \
    "macOS" \
    "Windows + WSL" \
    "Windows native"
pick_one "default language for code-heavy work?" DEFAULT_LANG \
    "Python" \
    "TypeScript / JavaScript" \
    "Go" \
    "Rust" \
    "polyglot — pick per task"

hr
say "Q6. Anything else Claude should know about how you work?"
echo "    Standing rules, pet peeves, file-naming conventions, MCP servers in use."
echo "    End with '.' on its own line, or press enter to skip."
ask_multiline "extra notes" EXTRA_NOTES

hr
say "Q7. Last, and most important: what OUTCOME are you driving toward?"
echo "    Not the domain — the result. What ships in the next 90 days, and what"
echo "    does success look like: revenue, users, a publication, a signed client,"
echo "    a job offer? One sentence. This selects the business + meta skills and"
echo "    becomes the 'current focus' line of your profile."
ask "outcome" "" SHIP_GOAL

hr
if [[ "${STANDALONE:-false}" != "true" ]]; then
    say "Layer 1 — engineering frameworks."
    echo "    Loadout is a thin personal layer; engineering execution is delegated to"
    echo "    superpowers, GSD, context-mode, and claude-mem (plus skill-creator and"
    echo "    frontend-design). Installing them requires the 'claude' CLI in PATH."
    pick_one "provision Layer 1 plugins?" LAYER1_CHOICE \
        "yes — layered install (recommended)" \
        "no — standalone, copy skills only (zero dependencies)"
    case "$LAYER1_CHOICE" in
        no*) STANDALONE="true" ;;
        *)   STANDALONE="false" ;;
    esac
fi

# =========================================================
# DERIVE SKILL SELECTION FROM ANSWERS
# =========================================================

# Domain skills come from explicit answer
DOMAINS="$DOMAIN_INPUT"

# Business + meta inferred from the ship goal + role (cheap heuristics).
BUSINESS=""
META=""
goal_lower="$(echo "$SHIP_GOAL $ROLE" | tr '[:upper:]' '[:lower:]')"

case "$goal_lower" in
    *saas*|*product*|*launch*|*indie*)
        BUSINESS="outcome-framing,digital-products"
        META="monetize-or-opensource"
        ;;
    *consult*|*client*|*freelance*)
        BUSINESS="client-services,outcome-framing,ai-consulting"
        ;;
    *content*|*blog*|*newsletter*|*audience*|*creator*)
        BUSINESS="content-creation,seo-and-marketing,digital-products"
        ;;
    *job*|*application*|*hire*|*phd*|*academic*|*research*)
        BUSINESS="outreach-applications"
        ;;
    *)
        BUSINESS="outcome-framing"
        ;;
esac

# =========================================================
# WRITE PERSONALIZED CLAUDE.md
# =========================================================

# Map verbosity + register into a single voice paragraph.
case "$VOICE_VERBOSITY" in
    concise*)  VOICE_STYLE_LINE="Concise, signal-dense. Lead with the answer, justify after. No filler. Specific verbs over weak ones." ;;
    balanced*) VOICE_STYLE_LINE="Balanced. Short paragraphs. Lead with the conclusion, then a paragraph of supporting context." ;;
    verbose*)  VOICE_STYLE_LINE="Verbose where it earns its place. Full reasoning is welcome; show working." ;;
esac
case "$VOICE_REGISTER" in
    direct*)       VOICE_REGISTER_LINE="Direct, peer voice. No apologies or hedging filler (\"great question\", \"I hope this helps\")." ;;
    professional*) VOICE_REGISTER_LINE="Professional and courteous, without flowery language or unnecessary disclaimers." ;;
    academic*)     VOICE_REGISTER_LINE="Measured and academic. Hedge claims where evidence is partial; cite sources for technical claims." ;;
esac

# OS line
case "$PRIMARY_OS" in
    Linux*)         OS_LINE="Linux (rootless containers preferred where applicable)" ;;
    macOS*)         OS_LINE="macOS" ;;
    *WSL*)          OS_LINE="Windows + WSL2" ;;
    *Windows*)      OS_LINE="Windows (native, PowerShell)" ;;
esac

# Compose CLAUDE.md from the template — the single source of truth for the
# profile structure (including the Layer Contract). No inline fallback: a
# checkout without the template is broken and should fail loudly.
TEMPLATE="$LIB/core/CLAUDE.md.template"
[[ -f "$TEMPLATE" ]] || die "core/CLAUDE.md.template not found at $LIB/core/ — incomplete checkout?"

# Tooling notes: collapse the OS/lang answers into a single line, plus
# any extras the user typed in Q7 (kept as-is below in its own section).
TOOLING_NOTES_INLINE="Default language $DEFAULT_LANG on $OS_LINE."
DOMAIN_DISPLAY="$(echo "$DOMAINS" | tr ',' ' ' | sed 's/[[:space:]]\+/, /g')"

# mustache-style {{#FIELD}}…{{/FIELD}} blocks: keep the inner content only
# if the corresponding variable is non-empty.
keep_or_strip() {
    # $1 = field name, $2 = current value, $3 = file
    if [[ -n "$2" ]]; then
        sed -E -i.tmp "s|\\{\\{#${1}\\}\\}(.*)\\{\\{/${1}\\}\\}|\\1|g" "$3"
    else
        sed -E -i.tmp "s|\\{\\{#${1}\\}\\}.*\\{\\{/${1}\\}\\}||g" "$3"
    fi
    rm -f "${3}.tmp"
}

cp "$TEMPLATE" "$TARGET/CLAUDE.md"
# Optional blocks first (must run before plain substitution).
keep_or_strip "DOMAIN" "$DOMAIN_DISPLAY" "$TARGET/CLAUDE.md"
keep_or_strip "GOALS"  "$SHIP_GOAL"      "$TARGET/CLAUDE.md"

# Escape sed-replacement special chars (|, \, &) in user input so values
# like "Alice|Bob" or "C:\Users\..." don't break the substitution or
# introduce accidental backreferences. Newlines are also stripped — they
# would terminate the sed expression.
sed_escape() {
    printf '%s' "$1" | tr -d '\n' | sed -e 's/[\\&|]/\\&/g'
}

NAME_S="$(sed_escape "$NAME")"
ROLE_S="$(sed_escape "$ROLE")"
DOMAIN_DISPLAY_S="$(sed_escape "$DOMAIN_DISPLAY")"
SHIP_GOAL_S="$(sed_escape "$SHIP_GOAL")"
VOICE_LINE_S="$(sed_escape "$VOICE_STYLE_LINE $VOICE_REGISTER_LINE")"
OS_LINE_S="$(sed_escape "$OS_LINE")"
DEFAULT_LANG_S="$(sed_escape "$DEFAULT_LANG")"
TOOLING_NOTES_S="$(sed_escape "$TOOLING_NOTES_INLINE")"

# Plain placeholders.
sed -i.tmp \
    -e "s|{{NAME}}|$NAME_S|g" \
    -e "s|{{ROLE}}|$ROLE_S|g" \
    -e "s|{{DOMAIN}}|$DOMAIN_DISPLAY_S|g" \
    -e "s|{{BACKGROUND}}||g" \
    -e "s|{{GOALS}}|$SHIP_GOAL_S|g" \
    -e "s|{{VOICE_STYLE}}|$VOICE_LINE_S|g" \
    -e "s|{{PRIMARY_OS}}|$OS_LINE_S|g" \
    -e "s|{{DEFAULT_LANGUAGE}}|$DEFAULT_LANG_S|g" \
    -e "s|{{TOOLING_NOTES}}|$TOOLING_NOTES_S|g" \
    "$TARGET/CLAUDE.md"
rm -f "$TARGET/CLAUDE.md.tmp"

if [[ -n "$EXTRA_NOTES" ]]; then
    {
        echo ""
        echo "## Operator-specific notes"
        echo ""
        printf '%s' "$EXTRA_NOTES"
    } >> "$TARGET/CLAUDE.md"
fi
info "wrote $TARGET/CLAUDE.md (from template)"

# =========================================================
# WRITE SKILLS (delegate to install.sh's copy logic)
# =========================================================

# We re-use install.sh in --custom mode to do the actual file copy. This keeps
# the wizard responsible only for *deciding* what to install, not how.

INSTALL_SH="$LIB/install.sh"
[[ ! -f "$INSTALL_SH" ]] && die "install.sh not found at $INSTALL_SH"

echo ""
hr
say "Installing skills: domains=[$DOMAINS]  business=[$BUSINESS]  meta=[$META]"

# --no-claude-overwrite keeps install.sh from clobbering the personalized
# CLAUDE.md this wizard just wrote.
ARGS=("$TARGET" --custom --no-claude-overwrite)
[[ -n "$DOMAINS" ]]  && ARGS+=(--domains "$DOMAINS")
[[ -n "$BUSINESS" ]] && ARGS+=(--business "$BUSINESS")
[[ -n "$META" ]]     && ARGS+=(--meta "$META")
[[ "${STANDALONE:-false}" == "true" ]] && ARGS+=(--standalone)

bash "$INSTALL_SH" "${ARGS[@]}"

# =========================================================
# DONE
# =========================================================
hr
echo ""
echo "==> Done."
echo ""
echo "Personalized files:"
echo "  $TARGET/CLAUDE.md"
echo "  $TARGET/.claude/skills/  (core + selected domains/business/meta)"
echo ""
echo "Next steps:"
echo "  1. Open $TARGET in Claude Code."
echo "  2. Review CLAUDE.md and tweak voice / tooling lines as needed."
echo "  3. Run the in-Claude 'profile-me' skill to deepen the profile and"
echo "     generate domain-specific skills from your real workflows."
echo ""
echo "Re-run safely: this wizard always backs up CLAUDE.md before writing."
