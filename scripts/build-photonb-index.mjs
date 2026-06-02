#!/usr/bin/env node
// Build public/photonb/index.html by scanning the HTML notes in that folder.
// Robert never edits the index by hand — he just drops/updates .html notes and
// runs scripts/publish-photonb.sh, which calls this generator first.
//
// Conventions:
//   - Each note is a standalone .html file in public/photonb/
//   - <title> becomes the card title (falls back to the filename)
//   - <meta name="description"> becomes the card subtitle (optional)
//   - <meta name="date" content="YYYY-MM-DD"> sets the date (falls back to file mtime)
//   - Files named index.html or starting with "_" (e.g. _template.html) are ignored

import { readdirSync, readFileSync, writeFileSync, statSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const DIR = join(dirname(fileURLToPath(import.meta.url)), '..', 'public', 'photonb');

const pick = (html, re, fallback = '') => {
  const m = html.match(re);
  return m ? m[1].trim() : fallback;
};

const esc = (s) =>
  s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');

const notes = readdirSync(DIR)
  .filter((f) => f.endsWith('.html') && f !== 'index.html' && !f.startsWith('_'))
  .map((file) => {
    const html = readFileSync(join(DIR, file), 'utf8');
    const title = pick(html, /<title>([\s\S]*?)<\/title>/i, file.replace(/\.html$/, ''));
    const desc = pick(html, /<meta\s+name=["']description["']\s+content=["']([\s\S]*?)["']/i);
    const metaDate = pick(html, /<meta\s+name=["']date["']\s+content=["']([\s\S]*?)["']/i);
    const date = metaDate || statSync(join(DIR, file)).mtime.toISOString().slice(0, 10);
    return { file, title, desc, date };
  })
  .sort((a, b) => (a.date < b.date ? 1 : a.date > b.date ? -1 : 0));

const cards = notes
  .map(
    (n) => `      <a class="card" href="./${esc(n.file)}">
        <span class="date">${esc(n.date)}</span>
        <h2>${esc(n.title)}</h2>
        ${n.desc ? `<p>${esc(n.desc)}</p>` : ''}
      </a>`
  )
  .join('\n');

const empty = `      <p class="empty">還沒有筆記。把 .html 檔放進 public/photonb/ 再執行發佈即可。</p>`;

const page = `<!doctype html>
<html lang="zh-TW">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>攝影筆記本 · PhotoNB</title>
  <meta name="description" content="James 的攝影筆記本，隨時隨地用瀏覽器閱讀。" />
  <style>
    :root {
      --surface: #0f0f23; --brand: #1a1a2e; --accent: #e94560;
      --text: #eaeaea; --muted: #a0a0a0;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0; background: var(--surface); color: var(--text);
      font-family: 'Noto Sans TC', 'Helvetica Neue', system-ui, sans-serif;
      line-height: 1.6; -webkit-font-smoothing: antialiased;
    }
    .wrap { max-width: 760px; margin: 0 auto; padding: 4rem 1.25rem 6rem; }
    header { margin-bottom: 2.5rem; }
    .eyebrow { color: var(--accent); font-size: .8rem; letter-spacing: .18em; text-transform: uppercase; margin: 0 0 .5rem; }
    h1 { margin: 0; font-size: 2rem; }
    .sub { color: var(--muted); margin: .5rem 0 0; }
    .list { display: flex; flex-direction: column; gap: 1rem; }
    .card {
      display: block; text-decoration: none; color: inherit;
      background: var(--brand); border: 1px solid #2a2a44; border-radius: 14px;
      padding: 1.25rem 1.4rem; transition: border-color .15s, transform .15s;
    }
    .card:hover { border-color: var(--accent); transform: translateY(-2px); }
    .card .date { color: var(--muted); font-size: .78rem; letter-spacing: .04em; }
    .card h2 { margin: .35rem 0 .25rem; font-size: 1.15rem; }
    .card p { margin: 0; color: var(--muted); font-size: .92rem; }
    .empty { color: var(--muted); }
    footer { margin-top: 3rem; color: var(--muted); font-size: .8rem; }
    footer a { color: var(--accent); }
  </style>
</head>
<body>
  <div class="wrap">
    <header>
      <p class="eyebrow">PhotoNB</p>
      <h1>攝影筆記本</h1>
      <p class="sub">隨時隨地用瀏覽器閱讀的攝影筆記。共 ${notes.length} 篇。</p>
    </header>
    <main class="list">
${notes.length ? cards : empty}
    </main>
    <footer>
      <a href="/">← 回 JTpHR 首頁</a>
    </footer>
  </div>
</body>
</html>
`;

writeFileSync(join(DIR, 'index.html'), page, 'utf8');
console.log(`photonb index rebuilt: ${notes.length} note(s)`);
