#!/bin/bash
# Auto-generate share pages for all KB notes + daily reports
# Each note gets a stable hash-based ID (same note = same share link)

SHARE_DIR="$(dirname "$0")/../src/content/share"
KB_DIR="$(dirname "$0")/../src/content/kb"
DAILY_DIR="$(dirname "$0")/../src/content/daily"
MAP_FILE="$(dirname "$0")/../src/data/share-map.json"

mkdir -p "$SHARE_DIR" "$(dirname "$MAP_FILE")"

python3 << 'PYEOF'
import hashlib, json, os, re, glob

SHARE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__) if '__file__' in dir() else '.', 'src/content/share'))
KB_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__) if '__file__' in dir() else '.', 'src/content/kb'))
DAILY_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__) if '__file__' in dir() else '.', 'src/content/daily'))
MAP_FILE = os.path.abspath(os.path.join(os.path.dirname(__file__) if '__file__' in dir() else '.', 'src/data/share-map.json'))

# Use project root
for d in ['src/content/share', 'src/content/kb', 'src/content/daily', 'src/data']:
    p = os.path.join(os.getcwd(), d)
    if os.path.isdir(p):
        if 'share' in d: SHARE_DIR = p
        elif 'kb' in d: KB_DIR = p
        elif 'daily' in d: DAILY_DIR = p
        elif 'data' in d: MAP_FILE = os.path.join(p, 'share-map.json')

def stable_id(note_id):
    """Generate stable 8-char ID from note ID"""
    return hashlib.md5(note_id.encode()).hexdigest()[:8]

def clean_for_share(content):
    """Remove internal links, TODOs, category"""
    content = re.sub(r'\ncategory:.*\n', '\n', content)
    content = re.sub(r'## 🔗 相關筆記[\s\S]*?(?=\n---|\n## |\Z)', '', content)
    content = re.sub(r'> \[!todo\][\s\S]*?(?=\n---|\n## |\Z)', '', content)
    return content

share_map = {}

# Clear old share files
for f in glob.glob(os.path.join(SHARE_DIR, '*.md')):
    os.remove(f)

# Process KB notes
for md in sorted(glob.glob(os.path.join(KB_DIR, '*.md'))):
    note_id = os.path.basename(md).replace('.md', '')
    share_id = stable_id(note_id)

    with open(md) as f:
        content = f.read()

    content = clean_for_share(content)

    # Add sourceNote
    if 'sourceNote:' not in content:
        content = content.replace('---\n\n', f'---\nsourceNote: "{note_id}"\n\n', 1)

    with open(os.path.join(SHARE_DIR, f'{share_id}.md'), 'w') as f:
        f.write(content)

    share_map[f'kb/{note_id.lower()}'] = share_id

# Process daily notes
for md in sorted(glob.glob(os.path.join(DAILY_DIR, '*.md'))):
    note_id = os.path.basename(md).replace('.md', '')
    share_id = stable_id('daily_' + note_id)

    with open(md) as f:
        content = f.read()

    content = clean_for_share(content)

    with open(os.path.join(SHARE_DIR, f'{share_id}.md'), 'w') as f:
        f.write(content)

    share_map[f'daily/{note_id}'] = share_id

# Write map
with open(MAP_FILE, 'w') as f:
    json.dump(share_map, f, ensure_ascii=False, indent=2)

print(f"Generated {len(share_map)} share pages")
PYEOF
