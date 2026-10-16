#!/bin/bash
# Install only the files named in the manifest. Existing files stay untouched.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DRY_RUN=0
PRIVATE_DIR=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=1; shift ;;
        --private-dir)
            [[ $# -ge 2 && -d "$2/private-overlay" ]] || { echo 'Missing private-overlay directory' >&2; exit 2; }
            PRIVATE_DIR="$(cd "$2" && pwd -P)"; shift 2 ;;
        --help) echo 'Usage: symlink-setup.sh [--dry-run] [--private-dir PATH]'; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 2 ;;
    esac
done
: "${HOME:?HOME must be set}"
HOME_ROOT="$(cd "$HOME" && pwd -P)"
SOURCES=()
TARGETS=()
MODES=()
while IFS=$'\t' read -r mode source target; do
    [[ -n "$mode" ]] || continue
    SOURCES+=("$ROOT/$source"); TARGETS+=("$target"); MODES+=("$mode")
done < "$ROOT/install-manifest.tsv"
if [[ -n "$PRIVATE_DIR" ]]; then
    for name in .gitconfig.local .zshrc.local .bash_profile.local .aliases.local .ssh/config.local; do
        [[ -f "$PRIVATE_DIR/private-overlay/$name" ]] || continue
        SOURCES+=("$PRIVATE_DIR/private-overlay/$name"); TARGETS+=("$name"); MODES+=(link)
    done
fi
# Validate every path before creating any files. An ancestor symlink could send
# application writes straight into a Git checkout or another unexpected place.
for ((i=0; i<${#SOURCES[@]}; i++)); do
    [[ -f "${SOURCES[i]}" && ! -L "${SOURCES[i]}" ]] || { echo "Invalid source: ${SOURCES[i]}" >&2; exit 1; }
    relative="${TARGETS[i]}"
    [[ "$relative" != /* && "/$relative/" != *'/../'* && "/$relative/" != *'/./'* ]] || { echo 'Invalid target path' >&2; exit 1; }
    parent="$HOME_ROOT"
    remaining="$relative"
    while [[ "$remaining" == */* ]]; do
        part="${remaining%%/*}"; remaining="${remaining#*/}"
        parent="$parent/$part"
        [[ ! -L "$parent" ]] || { echo "Refusing symlinked parent: $parent" >&2; exit 1; }
        [[ ! -e "$parent" || -d "$parent" ]] || { echo "Parent is not a directory: $parent" >&2; exit 1; }
    done
done
conflicts=0
for ((i=0; i<${#SOURCES[@]}; i++)); do
    source="${SOURCES[i]}"; target="$HOME_ROOT/${TARGETS[i]}"; mode="${MODES[i]}"
    if [[ -L "$target" && "$mode" == link && "$(readlink "$target")" == "$source" ]]; then
        continue
    fi
    if [[ -f "$target" && ! -L "$target" && "$mode" == copy ]] && cmp -s "$source" "$target"; then
        continue
    fi
    if [[ -e "$target" || -L "$target" ]]; then
        echo "Conflict (preserved): $target" >&2; conflicts=1; continue
    fi
    printf '%s %s -> %s\n' "$mode" "$source" "$target"
    if [[ "$DRY_RUN" == 0 ]]; then
        mkdir -p "$(dirname "$target")"
        if [[ "$mode" == copy ]]; then cp "$source" "$target"; else ln -s "$source" "$target"; fi
    fi
done
exit "$conflicts"
