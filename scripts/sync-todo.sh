#!/bin/bash
# Sync Obsidian TODO files → Astro data with note references
KB_SRC="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/KnowledgeBase"
TODO_DEST="$(dirname "$0")/../src/data"
mkdir -p "$TODO_DEST"

python3 << PYEOF
import re, json, os, glob

KB = os.path.expanduser("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/KnowledgeBase")
DEST = "$TODO_DEST"

# Build a lookup: note filename → KB page id (flat name used in Astro)
note_lookup = {}
for md in glob.glob(os.path.join(KB, '**/*.md'), recursive=True):
    rel = os.path.relpath(md, KB)
    if any(x in rel for x in ['.obsidian', '.claude', '.claudian', '_meta', 'sessions', '_attachments']):
        continue
    if os.path.basename(rel) in ('TODO.md', 'INDEX.md', '_README.md'):
        continue
    flat = rel.replace('/', '__')
    # Index by various name patterns
    basename = os.path.basename(rel).replace('.md', '')
    note_lookup[basename] = flat.replace('.md', '')
    note_lookup[rel] = flat.replace('.md', '')
    # Also without extension
    note_lookup[rel.replace('.md', '')] = flat.replace('.md', '')

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
        lines = f.readlines()

    current_section = ''
    current_todo = None

    for line in lines:
        line = line.rstrip('\n')

        # Section headers
        m = re.match(r'^##\s+(.+)', line)
        if m:
            current_section = re.sub(r'[^\w\s/（）\u4e00-\u9fff]', '', m.group(1)).strip()
            continue

        # TODO items (top-level)
        m = re.match(r'^- \[([ x])\]\s+\*\*(.+?)\*\*', line)
        if m:
            if current_todo:
                all_todos.append(current_todo)
            done = m.group(1) == 'x'
            title = m.group(2)
            # Extract date
            date_m = re.search(r'\x60(\d{4}-\d{2}-\d{2})\x60', line)
            date = date_m.group(1) if date_m else ''
            # Extract completion date if present
            done_date_m = re.search(r'[✅]\s*\x60(\d{4}-\d{2}-\d{2})\x60', line)
            done_date = done_date_m.group(1) if done_date_m else ''

            current_todo = {
                'category': category,
                'section': current_section,
                'title': title,
                'date': date,
                'doneDate': done_date,
                'done': done,
                'details': [],
                'refs': [],  # Referenced notes
                'source': '',  # Source/origin
            }
            continue

        # Sub-items for current todo
        if current_todo and line.startswith('  '):
            detail = line.strip().lstrip('- ').strip()

            # Extract note references
            # Pattern: 參考筆記：path/to/note.md
            ref_m = re.search(r'參考筆記[：:]\s*(.+)', detail)
            if ref_m:
                ref_path = ref_m.group(1).strip()
                # Try to find in lookup
                note_id = note_lookup.get(ref_path, note_lookup.get(ref_path.replace('.md', ''), ''))
                if note_id:
                    current_todo['refs'].append({'path': ref_path, 'id': note_id})
                else:
                    current_todo['refs'].append({'path': ref_path, 'id': ''})
                continue

            # Pattern: 來源：description
            src_m = re.search(r'來源[：:]\s*(.+)', detail)
            if src_m:
                current_todo['source'] = src_m.group(1).strip()
                # Check if source contains a note path
                for key, nid in note_lookup.items():
                    if key in current_todo['source']:
                        current_todo['refs'].append({'path': key, 'id': nid})
                        break
                continue

            # Pattern: 依 [[NoteName]]
            wiki_m = re.search(r'依\s*\[\[(.+?)\]\]', detail)
            if wiki_m:
                ref_name = wiki_m.group(1).split('|')[0]
                note_id = note_lookup.get(ref_name, '')
                if note_id:
                    current_todo['refs'].append({'path': ref_name, 'id': note_id})

            # Skip sub-checkboxes
            if re.match(r'\[[ x]\]', detail):
                continue

            current_todo['details'].append(detail)

    if current_todo:
        all_todos.append(current_todo)

os.makedirs(DEST, exist_ok=True)
with open(os.path.join(DEST, 'todos.json'), 'w') as f:
    json.dump(all_todos, f, ensure_ascii=False, indent=2)

done_count = sum(1 for t in all_todos if t['done'])
ref_count = sum(len(t['refs']) for t in all_todos)
print(f"Extracted {len(all_todos)} todos ({done_count} done), {ref_count} note references")
PYEOF
