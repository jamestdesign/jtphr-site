---
title: PhotoNB 攝影筆記本發佈流程
date: 2026-06-02
creator: robin
co_creators: []
tags:
  - 發佈
  - jtphr-site
  - photonb
  - workflow
  - skill
aliases:
  - PhotoNB publish
  - 攝影筆記本上站流程
連結: https://jtphr-site.vercel.app/photonb/
version: 1
category: "其他"
---

# PhotoNB 攝影筆記本發佈流程

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 一句話定義</p>
<div class="text-sm text-gray-300">

Robert 把攝影筆記做成 `.html` 放進 `public/photonb/`,跑一條只動該資料夾的發佈腳本,就會自動上站。James 在外地用任何瀏覽器即可閱讀:https://jtphr-site.vercel.app/photonb/

</div>
</div>


## 適用情境

- Robert 更新/新增攝影筆記,需要讓 James 不開桌面、用手機或外地電腦的瀏覽器就能讀。
- 只發佈攝影筆記本這一塊,**不碰** JTpHR 網站其他內容。

## 環境

- Repo:`jamestdesign/jtphr-site`,本機路徑 `~/Projects/jtphr-site`,分支 `main`(push 後 Vercel 自動部署)。
- 執行環境只有 **bun**(沒有 node),腳本已用 bun。

## 操作流程(3 步)

1. `cd ~/Projects/jtphr-site`
2. 把筆記做成 `.html` 放進 `public/photonb/`
   - 複製 `_template.html` 當起點,改最上面的 `<title>` / `<meta name="description">` / `<meta name="date">`,正文寫在 `<body>` 裡。
   - **檔名 = 網址**,例如 `sony-color.html` → `/photonb/sony-color.html`。
3. 發佈:`./scripts/publish-photonb.sh`
   - 自動重建列表頁 → 只 `git add public/photonb` → commit → `git pull --rebase` → `git push origin main`。
   - 約 1 分鐘後 Vercel 上線。

## 紅線 / 慣例

- **只動 `public/photonb/`**:發佈腳本只 stage 這個資料夾,不會掃到網站其他變更。
- **不要手動編輯 `index.html`**:由 `scripts/build-photonb-index.mjs` 依現有筆記自動重建(讀每篇 `<title>`/`description`/`date`,依日期新→舊排序)。
- **`_` 開頭檔名會被列表略過**(如 `_template.html`),可當範本或草稿。
- 列表頁套用網站深色品牌色(surface `#0f0f23` / accent `#e94560` / Noto Sans TC),新筆記建議沿用 `_template.html` 以維持視覺一致。

## 相關檔案

- `public/photonb/_template.html` — 筆記範本
- `scripts/build-photonb-index.mjs` — 列表頁產生器
- `scripts/publish-photonb.sh` — 發佈腳本(Robert 主要入口)
