#!/bin/bash
# deploy-mjapp — 把 jtphr-site build 好推上 jtphr.mj-app.com.tw（James 的 Vultr 主機）
#
# 走 Tailscale（100.91.38.104 = james-tang），不經公網。
# 2026-08-27 起用專屬帳號 robert（金鑰 ~/.ssh/robert_mjapp_ed25519）：無 sudo、只能寫 /var/www/jtphr。
# 群組 setgid 已設好，rsync 後不需 chown（root 已退場）。
# 只碰 /var/www/jtphr —— 那台還有 rubykingland/jtai/jtkb 三個站，別動（James 2026-08-26 授權範圍）。
# Vercel 照舊保留（publish-photonb.sh 推 GitHub 後 Vercel 自動更新），這支是第二條腿。
set -e
cd "$(dirname "$0")/.."
SRV=robert@100.91.38.104
KEY=~/.ssh/robert_mjapp_ed25519
echo "🔨 build…"
bun run build >/dev/null
echo "📤 rsync → $SRV:/var/www/jtphr"
rsync -az --delete \
  -e "ssh -i $KEY -o StrictHostKeyChecking=no -o LogLevel=ERROR -o ServerAliveInterval=10" \
  --timeout=90 --partial \
  dist/ "$SRV":/var/www/jtphr/
echo "✅ 已部署 → https://jtphr.mj-app.com.tw"
