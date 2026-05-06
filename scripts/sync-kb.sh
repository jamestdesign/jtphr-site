#!/bin/bash
# Sync Obsidian KnowledgeBase → Astro content/kb/
# Handles: images, callouts, wikilinks, frontmatter

KB_SRC="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/KnowledgeBase"
KB_DEST="$(dirname "$0")/../src/content/kb"
IMG_DEST="$(dirname "$0")/../public/images/kb"

rm -rf "$KB_DEST"
mkdir -p "$KB_DEST" "$IMG_DEST"

# 1. Copy all attachments to public/images/kb/
if [ -d "$KB_SRC/_attachments" ]; then
  cp -R "$KB_SRC/_attachments/"* "$IMG_DEST/" 2>/dev/null
  echo "Copied attachments to $IMG_DEST"
fi

# 2. Process markdown files
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

  flat_name="$(echo "$relpath" | sed 's|/|__|g')"

  python3 << PYEOF
import re
import sys

with open('$file', 'r') as f:
    content = f.read()

category = "$category"

# --- Parse frontmatter ---
fm_match = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
if fm_match:
    fm = fm_match.group(1)
    body = content[fm_match.end():]

    # Skip private notes (multi-agent v1 schema)
    if re.search(r'^\s*private:\s*true\s*$', fm, re.MULTILINE):
        sys.exit(0)

    if 'category:' not in fm:
        fm += '\ncategory: "' + category + '"'
    if 'title:' not in fm:
        import os
        fname = os.path.basename('$file').replace('.md', '').replace('_', ' ')
        fm = 'title: "' + fname + '"\n' + fm
    content = '---\n' + fm + '\n---\n' + body
else:
    import os
    fname = os.path.basename('$file').replace('.md', '').replace('_', ' ')
    content = '---\ntitle: "' + fname + '"\ncategory: "' + category + '"\n---\n' + content

# --- Fix Obsidian image embeds → standard markdown ---
# ![[_attachments/dir/file.jpg]] → ![](/images/kb/dir/file.jpg)
def fix_image(m):
    path = m.group(1)
    # Remove _attachments/ prefix if present
    clean = re.sub(r'^_attachments/', '', path)
    return f'![](/images/kb/{clean})'

content = re.sub(r'!\[\[([^\]]+\.(?:jpg|jpeg|png|gif|webp|svg))\]\]', fix_image, content, flags=re.IGNORECASE)

# --- Fix Obsidian callouts → HTML ---
# > [!type] title\n> content → styled div
def fix_callouts(text):
    lines = text.split('\n')
    result = []
    i = 0
    while i < len(lines):
        # Match callout start: > [!type] optional title
        m = re.match(r'^>\s*\[!([\w]+)\]\s*(.*)', lines[i])
        if m:
            ctype = m.group(1).lower()
            title = m.group(2).strip() or ctype.capitalize()
            # Collect callout body
            body_lines = []
            i += 1
            while i < len(lines) and lines[i].startswith('>'):
                line = re.sub(r'^>\s?', '', lines[i])
                body_lines.append(line)
                i += 1
            body = '\n'.join(body_lines)

            # Map callout types to colors
            colors = {
                'important': ('border-red-500', 'bg-red-500/10', 'text-red-400'),
                'warning': ('border-yellow-500', 'bg-yellow-500/10', 'text-yellow-400'),
                'tip': ('border-green-500', 'bg-green-500/10', 'text-green-400'),
                'note': ('border-blue-500', 'bg-blue-500/10', 'text-blue-400'),
                'info': ('border-blue-500', 'bg-blue-500/10', 'text-blue-400'),
                'todo': ('border-purple-500', 'bg-purple-500/10', 'text-purple-400'),
            }
            border, bg, text_color = colors.get(ctype, ('border-gray-500', 'bg-gray-500/10', 'text-gray-400'))

            icons = {
                'important': '🔴',
                'warning': '⚠️',
                'tip': '💡',
                'note': '📝',
                'info': 'ℹ️',
                'todo': '☑️',
            }
            icon = icons.get(ctype, '📌')

            result.append(f'<div class="not-prose my-6 {bg} border-l-4 {border} rounded-r-lg p-4">')
            result.append(f'<p class="font-bold {text_color} mb-2">{icon} {title}</p>')
            result.append(f'<div class="text-sm text-gray-300">\n\n{body}\n\n</div>')
            result.append('</div>')
            result.append('')
        else:
            result.append(lines[i])
            i += 1
    return '\n'.join(result)

content = fix_callouts(content)

# --- Fix Obsidian wikilinks ---
# [[page|display]] → display
# [[page]] → page
content = re.sub(r'\[\[([^\]|]+)\|([^\]]+)\]\]', r'\2', content)
content = re.sub(r'\[\[([^\]]+)\]\]', r'\1', content)

# --- Fix source links in frontmatter (連結:) ---
# Keep YouTube/web links clickable - they're already in frontmatter

with open('$KB_DEST/$flat_name', 'w') as f:
    f.write(content)
PYEOF

done

echo "Synced $(ls "$KB_DEST"/*.md 2>/dev/null | wc -l | tr -d ' ') notes to $KB_DEST"
echo "Images in $(du -sh "$IMG_DEST" 2>/dev/null | cut -f1)"
