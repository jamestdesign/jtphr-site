#!/bin/bash
# Sync Obsidian KnowledgeBase → Astro content/kb/
# Flattens directory structure, preserves frontmatter, adds category from path

KB_SRC="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/KnowledgeBase"
KB_DEST="$(dirname "$0")/../src/content/kb"

rm -rf "$KB_DEST"
mkdir -p "$KB_DEST"

# Copy relevant notes (skip _meta, sessions, TODO, INDEX, _README, .obsidian, .claude*)
find "$KB_SRC" -name "*.md" \
  -not -path "*/.obsidian/*" \
  -not -path "*/.claude*/*" \
  -not -path "*/.claudian/*" \
  -not -path "*/_meta/*" \
  -not -path "*/sessions/*" \
  -not -path "*/_attachments/*" \
  -not -name "TODO.md" \
  -not -name "INDEX.md" \
  -not -name "_README.md" | while read -r file; do

  # Derive category from path
  relpath="${file#$KB_SRC/}"
  dir="$(dirname "$relpath")"

  case "$dir" in
    ideas/ai-tools/AI影音創作/教學) category="AI影音-教學" ;;
    ideas/ai-tools/AI影音創作/提示詞) category="AI影音-提示詞" ;;
    ideas/ai-tools/AI影音創作/工具評比) category="AI影音-工具評比" ;;
    ideas/ai-tools) category="AI工具" ;;
    ideas/strategies) category="策略" ;;
    stocks) category="股票" ;;
    stocks/companies) category="股票-個股分析" ;;
    stocks/daily) category="股票-盤後日報" ;;
    stocks/tool) category="股票-工具" ;;
    stocks/趨勢觀察) category="股票-趨勢觀察" ;;
    *) category="其他" ;;
  esac

  # Flatten filename: replace / with _
  flat_name="$(echo "$relpath" | sed 's|/|__|g')"

  # Read file and inject category into frontmatter if missing
  python3 -c "
import sys, re

with open('$file', 'r') as f:
    content = f.read()

# Parse frontmatter
fm_match = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
if fm_match:
    fm = fm_match.group(1)
    body = content[fm_match.end():]
    # Add category if not present
    if 'category:' not in fm:
        fm += '\ncategory: \"$category\"'
    # Ensure title exists
    if 'title:' not in fm:
        # Use filename as title
        fname = '$(basename "$file" .md)'
        fm = 'title: \"' + fname.replace('_', ' ') + '\"\n' + fm
    content = '---\n' + fm + '\n---\n' + body
else:
    # No frontmatter - create one
    fname = '$(basename "$file" .md)'
    content = '---\ntitle: \"' + fname.replace('_', ' ') + '\"\ncategory: \"$category\"\n---\n' + content

# Remove Obsidian wikilinks [[...]] → plain text
content = re.sub(r'\[\[([^\]|]+)\|([^\]]+)\]\]', r'\2', content)
content = re.sub(r'\[\[([^\]]+)\]\]', r'\1', content)

# Remove Obsidian image embeds ![[...]]
content = re.sub(r'!\[\[([^\]]+)\]\]', '', content)

with open('$KB_DEST/$flat_name', 'w') as f:
    f.write(content)
"

done

echo "Synced $(ls "$KB_DEST"/*.md 2>/dev/null | wc -l | tr -d ' ') notes to $KB_DEST"
