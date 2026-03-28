#!/bin/bash
# Setup script for Claude Code skills
# Run this on a new machine or to sync skills after a fresh install

set -e

echo "=== Claude Code Skills Setup ==="
echo ""

# Check dependencies
command -v npx >/dev/null 2>&1 || { echo "Error: npx not found. Install Node.js first."; exit 1; }

# Skills manifest — add/remove skills here
SKILLS=(
  # Context7 — up-to-date docs fetching
  "ctx7@latest setup --claude --cli -y"

  # Anthropic official
  "skills add anthropics/skills@webapp-testing -g -y"

  # TypeScript
  "skills add wshobson/agents@typescript-advanced-types -g -y"

  # Security
  "skills add affaan-m/everything-claude-code@security-review -g -y"
  "skills add trailofbits/skills -g -y"

  # Performance
  "skills add sickn33/antigravity-awesome-skills@web-performance-optimization -g -y"

  # Writing
  "skills add blader/humanizer -g -y"

  # Planning
  "skills add OthmanAdi/planning-with-files -g -y"
)

installed=0
failed=0

for skill in "${SKILLS[@]}"; do
  echo ""
  echo "--- Installing: $skill ---"
  if npx $skill 2>&1; then
    ((installed++))
  else
    echo "  [FAILED] $skill"
    ((failed++))
  fi
done

echo ""
echo "=== Done ==="
echo "Installed: $installed | Failed: $failed"
echo ""
echo "Skills are available globally in ~/.claude/skills/ and ~/.agents/skills/"
