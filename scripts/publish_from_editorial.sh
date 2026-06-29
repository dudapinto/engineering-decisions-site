#!/bin/sh

set -eu

usage() {
    cat <<'EOF'
Usage:
  scripts/publish_from_editorial.sh <article-folder> [language...]

Examples:
  scripts/publish_from_editorial.sh 001-ai-made-code-cheap
  scripts/publish_from_editorial.sh 001-ai-made-code-cheap en pt-br

Behavior:
  - Reads canonical article(s) from ../engineering-decisions/03-articles/
  - Copies article(s) into this site's content/posts/
  - Strips numeric prefix from destination filename
  - If no language is passed, auto-detects all `article.<lang>.md` files

Modes:
  - PUBLISH_MODE=draft forces local site copies to `draft: true`
  - PUBLISH_MODE=final forces local site copies to `draft: false`

Notes:
  - Source repo is editorial truth.
  - This repo is publication target only.
  - Script adds `translationKey` if missing.
EOF
}

if [ "${1:-}" = "" ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
fi

article_folder=$1
shift || true
publish_mode=${PUBLISH_MODE:-final}

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
editorial_dir=${EDITORIAL_DIR:-"$repo_dir/../engineering-decisions"}
source_dir="$editorial_dir/03-articles/$article_folder"

if [ ! -d "$source_dir" ]; then
    echo "Source article folder not found: $source_dir" >&2
    exit 1
fi

dest_name=$article_folder
case "$dest_name" in
    [0-9][0-9][0-9]-*)
        dest_name=${dest_name#*-}
        ;;
esac

detect_languages() {
    find "$source_dir" -maxdepth 1 -type f -name 'article.*.md' | sort | while read -r path; do
        basename "$path" | sed -E 's/^article[.]([^.]+([.-][^.]+)*)[.]md$/\1/'
    done
}

normalize_languages() {
    if [ "$#" -gt 0 ]; then
        printf '%s\n' "$@"
        return
    fi
    detect_languages
}

set_frontmatter_field() {
    file=$1
    field=$2
    value=$3
    tmp_file="$file.tmp"

    awk -v field="$field" -v value="$value" '
        BEGIN {
            in_frontmatter = 0
            field_seen = 0
        }
        NR == 1 && $0 == "---" {
            in_frontmatter = 1
            print
            next
        }
        in_frontmatter && $0 ~ ("^" field ":[[:space:]]*") {
            print field ": " value
            field_seen = 1
            next
        }
        in_frontmatter && $0 == "---" {
            if (!field_seen) {
                print field ": " value
            }
            in_frontmatter = 0
            print
            next
        }
        {
            print
        }
    ' "$file" > "$tmp_file"

    mv "$tmp_file" "$file"
}

publish_one() {
    language=$1
    source_file="$source_dir/article.$language.md"

    if [ ! -f "$source_file" ]; then
        echo "Source file not found: $source_file" >&2
        exit 1
    fi

    if [ ! -s "$source_file" ]; then
        echo "Source file is empty: $source_file" >&2
        exit 1
    fi

    dest_dir="$repo_dir/content/posts"
    dest_file="$dest_dir/$dest_name.$language.md"

    mkdir -p "$dest_dir"
    cp "$source_file" "$dest_file"

    first_line=$(sed -n '1p' "$dest_file")
    if [ "$first_line" != "---" ]; then
        echo "Warning: $dest_file has no YAML front matter. Hugo metadata may be missing." >&2
    else
        case "$publish_mode" in
            draft)
                set_frontmatter_field "$dest_file" "draft" "true"
                ;;
            final)
                set_frontmatter_field "$dest_file" "draft" "false"
                ;;
            *)
                echo "Invalid PUBLISH_MODE: $publish_mode" >&2
                exit 1
                ;;
        esac
        set_frontmatter_field "$dest_file" "translationKey" "$dest_name"
    fi

    if [ "$language" = "en" ]; then
        public_path="/posts/$dest_name/"
    else
        public_path="/$language/posts/$dest_name/"
    fi

    echo "Published copy updated:"
    echo "  source: $source_file"
    echo "  dest:   $dest_file"
    echo "  mode:   $publish_mode"
    echo "  url:    $public_path"
}

languages=$(normalize_languages "$@")

if [ -z "$languages" ]; then
    echo "No source article.<lang>.md files found in: $source_dir" >&2
    exit 1
fi

printf '%s\n' "$languages" | while read -r language; do
    [ -n "$language" ] || continue
    publish_one "$language"
done
