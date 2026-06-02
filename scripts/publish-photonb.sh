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

# 1) Rebuild the index from whatever notes currently exist.
bun scripts/build-photonb-index.mjs

# 2) Stage ONLY the photonb folder — nothing else in the repo gets committed.
git add public/photonb

if git diff --cached --quiet; then
  echo "No changes in public/photonb/ — nothing to publish."
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
