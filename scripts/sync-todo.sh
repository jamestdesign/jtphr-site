#!/bin/bash
# Sync Obsidian TODO files → Astro content for dashboard
KB_SRC="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/KnowledgeBase"
TODO_DEST="$(dirname "$0")/../src/data"
mkdir -p "$TODO_DEST"

python3 << 'PYEOF'
import re, json, os

KB = os.path.expanduser("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/KnowledgeBase")
DEST = os.path.join(os.path.dirname(os.path.abspath("$0")), "src/data")
DEST = os.path.abspath(os.path.join(os.path.dirname(__file__) if '__file__' in dir() else '.', '../src/data'))

todo_files = {
    '基建': os.path.join(KB, 'TODO.md'),
    'Ideas': os.path.join(KB, 'ideas/TODO.md'),
    '股票': os.path.join(KB, 'stocks/TODO.md'),
}

all_todos = []

for category, filepath in todo_files.items():
    if not os.path.exists(filepath):
        continue
    with open(filepath) as f:
        content = f.read()

    current_section = ''
    for line in content.split('\n'):
        # Section headers
        m = re.match(r'^##\s+(.+)', line)
        if m:
            current_section = re.sub(r'[^\w\s/（）]', '', m.group(1)).strip()
            continue

        # TODO items
        m = re.match(r'^- \[([ x])\]\s+\*\*(.+?)\*\*\s*`?(\d{4}-\d{2}-\d{2})?`?', line)
        if m:
            done = m.group(1) == 'x'
            title = m.group(2)
            date = m.group(3) or ''
            all_todos.append({
                'category': category,
                'section': current_section,
                'title': title,
                'date': date,
                'done': done,
            })
            continue

        # Sub-items (details for the last todo)
        if line.strip().startswith('- ') and all_todos and not line.strip().startswith('- ['):
            detail = line.strip().lstrip('- ').strip()
            if 'details' not in all_todos[-1]:
                all_todos[-1]['details'] = []
            all_todos[-1]['details'].append(detail)

PYEOF

# Simpler approach - use python directly with correct paths
python3 << PYEOF2
import re, json, os

KB = os.path.expanduser("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/KnowledgeBase")
DEST = "$TODO_DEST"

todo_files = {
    '基建': os.path.join(KB, 'TODO.md'),
    'Ideas': os.path.join(KB, 'ideas/TODO.md'),
    '股票': os.path.join(KB, 'stocks/TODO.md'),
}

all_todos = []

for category, filepath in todo_files.items():
    if not os.path.exists(filepath):
        continue
    with open(filepath) as f:
        content = f.read()

    current_section = ''
    for line in content.split('\n'):
        m = re.match(r'^##\s+(.+)', line)
        if m:
            current_section = re.sub(r'[^\w\s/（）\u4e00-\u9fff]', '', m.group(1)).strip()
            continue

        m = re.match(r'^- \[([ x])\]\s+\*\*(.+?)\*\*', line)
        if m:
            done = m.group(1) == 'x'
            title = m.group(2)
            # Extract date if present
            date_m = re.search(r'\x60(\d{4}-\d{2}-\d{2})\x60', line)
            date = date_m.group(1) if date_m else ''
            all_todos.append({
                'category': category,
                'section': current_section,
                'title': title,
                'date': date,
                'done': done,
            })

os.makedirs(DEST, exist_ok=True)
with open(os.path.join(DEST, 'todos.json'), 'w') as f:
    json.dump(all_todos, f, ensure_ascii=False, indent=2)

print(f"Extracted {len(all_todos)} todos to {DEST}/todos.json")
PYEOF2
