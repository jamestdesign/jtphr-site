#!/bin/bash
# deploy-mjapp — 把 jtphr-site build 好推上 jtphr.mj-app.com.tw（James 的 Vultr 主機）
#
# 走 Tailscale（100.91.38.104 = james-tang），不經公網。
# 只碰 /var/www/jtphr —— 那台還有 rubykingland/jtai/jtkb 三個站，別動（James 2026-08-26 授權範圍）。
# Vercel 照舊保留（publish-photonb.sh 推 GitHub 後 Vercel 自動更新），這支是第二條腿。
set -e
cd "$(dirname "$0")/.."
SRV=root@100.91.38.104
echo "🔨 build…"
bun run build >/dev/null
echo "📤 rsync → $SRV:/var/www/jtphr"
rsync -az --delete \
  -e "ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR" \
  dist/ "$SRV":/var/www/jtphr/
ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR "$SRV" 'chown -R caddy:caddy /var/www/jtphr'
echo "✅ 已部署 → https://jtphr.mj-app.com.tw"
