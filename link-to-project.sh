#!/bin/bash
# Symlink global skills into a specific project's .claude/skills/
# Usage: ./link-to-project.sh /path/to/project
#
# This makes global skills explicitly available in the project.
# Useful if you want project-level visibility or override global config.

set -e

PROJECT_DIR="${1:-.}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: Directory $PROJECT_DIR does not exist"
  exit 1
fi

GLOBAL_SKILLS="$HOME/.claude/skills"
PROJECT_SKILLS="$PROJECT_DIR/.claude/skills"

if [ ! -d "$GLOBAL_SKILLS" ]; then
  echo "Error: No global skills found at $GLOBAL_SKILLS"
  echo "Run ./setup.sh first."
  exit 1
fi

mkdir -p "$PROJECT_SKILLS"

linked=0
skipped=0

for skill in "$GLOBAL_SKILLS"/*/; do
  name=$(basename "$skill")
  target="$PROJECT_SKILLS/$name"

  if [ -e "$target" ]; then
    ((skipped++))
    continue
  fi

  # Resolve to the actual skill directory (follow symlinks)
  real_path=$(realpath "$skill")
  ln -s "$real_path" "$target"
  ((linked++))
done

echo "Linked $linked skills to $PROJECT_SKILLS ($skipped already existed)"
