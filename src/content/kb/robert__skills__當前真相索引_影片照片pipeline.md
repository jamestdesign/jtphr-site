---
title: 當前真相索引 — 影片/照片 pipeline
date: 2026-06-03
creator: robert
co_creators: []
tags:
  - 索引
  - pipeline
  - 影片
  - 照片
  - current-truth
aliases:
  - 當前真相索引
  - current truth index
category: "其他"
---

# 當前真相索引 — 影片/照片 pipeline

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 用途（給 Robert 自己）</p>
<div class="text-sm text-gray-300">

動工前先看這頁，避免「新重點忽略舊的」。每個主題只認**一份現行文件**，其餘標 superseded。見 memory feedback_reconcile_new_with_old。

</div>
</div>


## 🔢 統一步驟編號（2026-06-03 James 拍板，全文件一致）

- **共用段 S1–S8**：S1 匯入 → S2 場景命名 → S3 影片智慧抽幀 → S4 VLM 標籤 → S5 VLM 評分+Pick → S6 catalog 寫入 → S7 AutoTone → S8 James LR review
- **照片 9P**：9P-a Evoto 精修 → 9P-b LR 套色 preset → 9P-c 出片
- **影片 9V**：9V-a FCPX 撿片(KP/HL/NG) → 9V-b Export XML → 9V-c Robert 批次出圖 → 9V-d James 剪輯 → 9V-e 出片

James 報位置一律用這套代號（例「我在 9V-a」）。

## 📍 各主題的現行文件

| 主題 | 現行（看這個） | 已被取代 / 歷史 |
|---|---|---|
| 影片端完整工序 | **影片剪輯攻略書 V2.1** → PhotoNB `/photonb/video-editing-kb.html`；vault `_attachments/2026-06-03_video_editing_kb_v2.1.html` | 2026-05-16_影片NG_KP_HP_schema、2026-05-17_9-V-a_HL_NG_KP_重新拍板（v1/v2 schema raw）；PhotoNB `_video-schema.html`、`_fcpx-cheatsheet.html`（已併入，退成歷史） |
| 全系統分工總覽 | **全 Pipeline 總覽地圖** → PhotoNB `/photonb/pipeline-overview.html`；vault `_attachments/全pipeline_整合視覺圖_v2.1_2026-06-03.html` | `_attachments/全pipeline_n8n整合視覺圖_2026-05-16.html`（5/16 原版，影片半邊已過時） |
| 影片工序決策紀錄 | 2026-06-03_影片KB_V2.1_FCPX撿片工序_智慧抽幀減量 | — |
| 更新歷史 | PhotoNB `/photonb/_video-editing-kb-changelog.html` | — |

## ✅ V2.1 影片 schema 定稿重點（避免再來回）

- **抽幀**：scene-detect 為主、減量（時間保底 10s / scene 門檻 0.4）；目的=評場景用途，非找 keeper。
- **KP**：i/o 同一禎 + keyword `KP_R/Y/G/P`；畫質無損，Robert 抽 4K + 分類寫 XMP。**不要再建議改 marker。**
- **HL**：keyword + i/o 範圍為準，Favorite(F) 只是視覺；clip 給 4★/5★ → 短片段動態照片。
- **NG**：短素材只標不切；**1★「長篇發表（去 NG）」**才切掉拼接（i/o 框整段 + Delete/Reject 標壞鏡頭 → concat 成一支）。
- **編碼**：H.264 yuv420p 1080p（LR 預覽相容；別用 HEVC）。

## 給 Robin

> @jamestang_bot 這頁是 Robert 的「當前真相索引」，幫我避免新舊脫節。影片 V2.1 已收斂、發 PhotoNB。若要轉化進正式區，以此索引的「現行」欄為準，歷史欄那些標 superseded。
</content>
