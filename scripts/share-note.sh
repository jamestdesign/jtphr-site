#!/bin/bash
# Share a KB note with a random URL
# Usage: share-note.sh <kb-note-id>
# Example: share-note.sh ideas__ai-tools__claude_adobe_整合教學_aiposthub

NOTE_ID="$1"
SHARE_DIR="$(dirname "$0")/../src/content/share"
KB_DIR="$(dirname "$0")/../src/content/kb"

if [ -z "$NOTE_ID" ]; then
  echo "Usage: $0 <kb-note-id>"
  echo "Available notes:"
  ls "$KB_DIR"/*.md | sed 's|.*/||;s|\.md$||' | sort
  exit 1
fi

# Find the KB note
KB_FILE="$KB_DIR/${NOTE_ID}.md"
if [ ! -f "$KB_FILE" ]; then
  echo "Note not found: $NOTE_ID"
  echo "Try: ls src/content/kb/"
  exit 1
fi

# Generate random 6-char ID
SHARE_ID=$(python3 -c "import secrets; print(secrets.token_urlsafe(6)[:8].lower())")

mkdir -p "$SHARE_DIR"

# Copy note, strip internal links and category
python3 << PYEOF
import re

with open('$KB_FILE') as f:
    content = f.read()

# Remove category from frontmatter
content = re.sub(r'\ncategory:.*\n', '\n', content)

# Add sourceNote to frontmatter
content = content.replace('---\n\n', '---\nsourceNote: "$NOTE_ID"\n\n', 1)

# Remove "相關筆記" section (internal links)
content = re.sub(r'## 🔗 相關筆記[\s\S]*?(?=\n---|\n## |\Z)', '', content)

# Remove TODO sections
content = re.sub(r'> \[!todo\][\s\S]*?(?=\n---|\n## |\Z)', '', content)

with open('$SHARE_DIR/${SHARE_ID}.md', 'w') as f:
    f.write(content)

print("$SHARE_ID")
PYEOF

echo ""
echo "Share link: https://jtphr-site.vercel.app/s/$SHARE_ID"
echo "File: $SHARE_DIR/$SHARE_ID.md"
