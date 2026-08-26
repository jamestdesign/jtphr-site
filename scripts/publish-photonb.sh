#!/bin/bash
# Publish the photography notebook (public/photonb/) to the live site.
#
# For Robert: add or edit .html notes inside public/photonb/, then run this.
# It rebuilds the index and pushes ONLY the photonb folder to main, so the rest
# of the JTpHR site is never touched. Vercel auto-deploys within ~1 minute.
#
#   ./scripts/publish-photonb.sh
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# --- Path guard: this flow may ONLY touch public/photonb/ ---------------------
# If the working tree has any change OUTSIDE public/photonb/, abort. This keeps
# Robert's edits scoped to the notebook and prevents accidentally publishing
# changes to the rest of the JTpHR site (mirrors the vault folder rule).
OUTSIDE="$(git status --porcelain | awk '{print $2}' | grep -v '^public/photonb/' || true)"
if [ -n "$OUTSIDE" ]; then
  echo "⛔ 偵測到 public/photonb/ 以外的變更，已中止發佈：" >&2
  echo "$OUTSIDE" | sed 's/^/   - /' >&2
  echo "" >&2
  echo "這條流程只發佈攝影筆記本。請先還原上面的檔案（git checkout -- <file>），" >&2
  echo "或交給 Robin 處理網站其他部分後再跑一次。" >&2
  exit 1
fi

# --- Pick a JS runtime: bun (robin) or node (work machine) --------------------
if command -v bun >/dev/null 2>&1; then
  RUNTIME="bun"
elif command -v node >/dev/null 2>&1; then
  RUNTIME="node"
else
  echo "⛔ 找不到 bun 或 node，無法重建列表頁。請先安裝其一。" >&2
  exit 1
fi

# 1) Rebuild the index from whatever notes currently exist.
"$RUNTIME" scripts/build-photonb-index.mjs

# 2) Stage ONLY the photonb folder — nothing else in the repo gets committed.
git add public/photonb

if git diff --cached --quiet; then
  echo "public/photonb/ 沒有變更 — 不需要發佈。"
  exit 0
fi

# 3) Commit + push to main. Vercel deploys automatically on push.
COUNT=$(find public/photonb -name '*.html' ! -name 'index.html' ! -name '_*' | wc -l | tr -d ' ')
git commit -m "photonb: update notebook (${COUNT} notes)"

# Pull-rebase first so a stale local main doesn't reject the push.
git pull --rebase origin main
git push origin main

echo ""
echo "✅ 已發佈！約 1 分鐘後可在 https://jtphr-site.vercel.app/photonb/ 看到更新。"

# 2026-08-26：同步到 jtphr.mj-app.com.tw（James 的主機；Tailscale 不通時跳過，不擋 Vercel 發佈）
if /Applications/Tailscale.app/Contents/MacOS/Tailscale status >/dev/null 2>&1 || ping -c1 -t3 100.91.38.104 >/dev/null 2>&1; then
  "$(dirname "$0")/deploy-mjapp.sh" || echo "⚠️ mj-app 部署失敗（Vercel 不受影響），稍後可手動跑 scripts/deploy-mjapp.sh"
else
  echo "⚠️ Tailscale 不在線，略過 mj-app 同步（下次發佈會補上）"
fi
