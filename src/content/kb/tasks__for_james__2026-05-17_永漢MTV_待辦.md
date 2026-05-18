---
title: 永漢 MTV 待辦清單(2026-05-17 EOD)
date: 2026-05-17
creator: robert
tags:
  - 攝影
  - 影片
  - 永漢
  - todo
  - handoff
category: "其他"
---

# 永漢 MTV 待辦清單(2026-05-17 EOD)

> James 收尾休息,明天繼續從這裡接。Robert 整理當天進度 + 明天要拍板的決策。

---

## ✅ 今天完成(2026-05-17)

| Step | 內容 | 產出 |
|---|---|---|
| **9-V-a** | LR 評影片 rating / Pick / NG/HL/KP caption | 7 MOV 全評完(IMG_6221 KP / IMG_6230 HL / IMG_6232 HL / IMG_6222 4★)|
| **9-V-b** | 切 HL + 4★ → `_export/<scene>/<clip>.mp4` 平層 + INSERT catalog + caption「已出片」 | 3 MP4(H.264 60fps 8-bit · 14-23MB)|
| **9-V-c** | KP 段抽 1 幀代表 | `_KP_preview/IMG_6221_kp01_t02.50.jpg` |
| **manual STILL 流程實證** | James 截圖 → 命名 → LR import → 9-P 精修 → 9-P-c 整理 + KF keyword | IMG_6221-1_t05.20.jpg 完整跑完 |
| **Step 11 行前劇本討論** | 4 版互動式 storyboard HTML 迭代 → 拍板 63s MTV(18 鏡) | `永漢_MTV_storyboard.html` v4 + 拍板 JSON |
| **Step 12 FCPXML 初剪 v1** | Python gen → FCPXML → FCP 匯入 → timeline 自動建好 | `永漢_MTV.fcpxml` |

**KB 更新**(轉化進 vault):
- `robert/raw/2026-05-17_9-V-a_HL_NG_KP_重新拍板.md`(rating 0-5★ / Pick=-1 物理刪 / HL⊆KP / caption C 精簡格式)
- `robert/raw/2026-05-17_永漢_storyboard_拍板版.md`(18 鏡 timeline + JSON schema)
- `robert/raw/2026-05-17_Step12_FCPXML_初剪_實證.md`(FCPXML 1.10 schema 坑 + Python generator)
- `_attachments/影片pipeline_n8n視覺圖_2026-05-16.html`(多處更新)

---

## ⏳ 明天 3 個拍板決策(我等齊就開動)

### Q1:**Frame Rate**(影響 project 重生)

| 選項 | 影響 |
|---|---|
| **30p**(我推薦)| 60fps source 慢動作神友好 / 輸出檔小 / 兼容性佳 |
| 60p(目前 FCPXML v1)| 流暢但慢動作差一點 / 檔案大 |
| 24p | 電影感 / 但慢動作不順 |

### Q2:**全片色調主調**(8 選 1)

🌿 Natural / ☀️ Warm Sunset / 🌊 Cool Calm / 🎬 Film Cinematic / 📽️ Vintage 35mm / 🌙 Moody Dark / ⚪️ B&W / 🍃 Forest Green

我推薦:**🍃 Forest Green** 或 **☀️ Warm Sunset**(高爾夫戶外場景)

### Q3:**Storyboard HTML v5 加 per-clip 設定?**

加的話我 v5 加這些欄位 per shot:
- 入場 / 出場轉場(Cross Dissolve / Fade / Slide / Push)
- 慢動作(50% / 25% / Freeze)
- Ken Burns(Pan / Zoom)
- 音量 override(0% mute / 50% / 100%)
- 字幕 / 標題 overlay 文字
- 色調 override(覆蓋全片主調)

選 A 加 / 選 B 不加(進 FCP 手動)

---

## 🌟 8 個 enhancement(看你要哪些)

| # | 元素 | 推薦度 |
|---|---|---|
| 1 | **音樂 beat 同步 cut**(BPM 對齊節拍)| ⭐⭐⭐ MTV 神效 |
| 2 | **Audio ducking**(BGM 在重要環音降音)| ⭐⭐ |
| 3 | **顏色 LUT**(電影級 .cube)| ⭐ 跟主色調搭|
| 4 | **暗角 vignette**(視覺聚焦)| ⭐⭐ |
| 5 | **微 Film Grain**(1-3% 復古)| ⭐ 跟風格搭 |
| 6 | **Letterbox 2.35:1**(電影寬螢幕)| ⭐ 看你喜好 |
| 7 | **Lower thirds**(場景 / 時間 小字幕)| ⭐⭐ 紀錄片風 |
| 8 | **Sound design 音效**(揮桿 whoosh / 風聲)| ⭐⭐ |

---

## 🎯 後續 step(等 Q1+Q2+Q3 後接)

1. Robert 重生 FCPXML v2(含 fps / 色調 / per-clip 設定)
2. James FCP 重新匯入 → 看 v2
3. 微調 / 加效果 / 加標題
4. **Step 13** FCP 內精修
5. **Step 14** Export(H.264 1080p)
6. **Step 15** 上雲(GPhotos / Drive / Synology)

---

## 📂 重要檔案位置(明天接續用)

- Storyboard HTML(互動):`~/Desktop/Claude-Workspace/photo-grade/2026-05-17_永漢_storyboard/永漢_MTV_storyboard.html`
- FCPXML v1:同資料夾下 `永漢_MTV.fcpxml`
- Python generators:同資料夾下 `gen_storyboard.py` / `gen_fcpxml.py`
- FCP library:`/Volumes/X10 Pro2/FCPX_libraries/2026-05-15 永漢.fcpbundle`
- BGM:`/Volumes/X10 Pro2/FCPX素材/MUSIC/la-vie-élégante--jakob-welik.mp3`

---

休息一晚 🌙 明天接續 ☀️

---

## 📝 2026-05-18 進度補記

**完成**:
- ✅ FCPXML v2 重生(30p)→ `永漢_MTV_V2_30P.fcpxml`,project 名 `2026-05-15 永漢高球日V2_30P`
- ✅ 主色調確認 ☀️ Warm Sunset
- ✅ Per-clip 可行性 feasibility check 完成(Tier 1/2/3 分類)
- ✅ 色調 FCPXML 方式釐清(`<adjust-color>` 數值 vs Adjustment Layer 手動)

**明天起點**:
- ❓ Warm Sunset 套法決策:**A. FCPXML 寫 `<adjust-color>` 數值** OR **B. FCP 內 Adjustment Layer 手動套**(我推薦 B)
- ⏳ Storyboard HTML v5 per-clip 設定加入 7 項(Tier 1 + 部分 Tier 2):
  1. 入場 / 出場 Fade
  2. Cross Dissolve 轉場
  3. 慢動作 50% / 25% / Freeze(video only)
  4. 音量(預設 mute)
  5. Ken Burns(photo only)
  6. 單 clip 色調 override(沿用 / Natural / B&W)
  7. 字幕 overlay(自由文字)
- ⏳ Project-level:BGM fade in/out 秒數
- ⏳ 生 FCPXML v3 含所有設定
- ⏳ Step 13 FCP 微調 → Step 14 Export → Step 15 上雲

**未動**:
- Tier 3 enhancements(beat sync / audio ducking / LUT / vignette / grain / letterbox / lower thirds / sound design)— 都留 FCP 手動 / 後續討論

