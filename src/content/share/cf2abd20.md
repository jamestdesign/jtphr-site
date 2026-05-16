---
title: 攝影區待辦清單（rolling）
date: 2026-05-16
creator: robert
co_creators:
  - james
tags:
  - 攝影
  - TODO
  - rolling
  - workflow
aliases:
  - 攝影 TODO
  - photo TODO
連結: _attachments/photo_grade_kb_2026-05-11.html
version: 1
last_revised: 2026-05-16
---
sourceNote: "ideas__photo__攝影區待辦清單"

# 攝影區待辦清單(rolling)

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 一句話定義</p>
<div class="text-sm text-gray-300">

攝影區所有「**討論到但沒立即做**」的事項都集中在此 — 等條件齊備、等決策、等素材、等優先順序判斷。Robert 維護、James 拍板、Robin 在 vault 端做轉化。

</div>
</div>


## 📚 使用規則

- **加項目**:Robert 在對話中浮現 idea 時 append 到對應分層(🔥/📂/🧊)
- **追溯**:每項標來源(`source: msg-XXXX` 或日期)+ 觸發條件(若有)
- **拍板**:James 在 Telegram(1-on-1 或群組)指示啟動 → Robert 把該項從 TODO 移到 active session task,做完後標記 ✅
- **歸檔**:✅ 已完成的事項保留在「完成歷史」段,不刪(可供未來回溯)

---

## 🔥 短期可動(active — 你拍板就能跑)

| # | 主題 | 狀態 | 來源 | 備註 |
|---|---|---|---|---|
| A1 | **HarborDiary v1 試套 + v2 微調** | pending | msg 1808 / 1810 | preset 已 install,等試套照片回饋 |
| A2 | **1280 backlog v4 寫入跑完** | pending | hello.md Week 1 #3 | 寫入 LR catalog 關鍵字 + 對話日誌 + 補 312 張 `[需補tag]` |
| A3 | **1057 場景 133 張 Opus 重跑** | pending | KB §11 Task #41 | Sonnet 跑的還有幻覺風險,Opus 重跑 |
| A4 | **hello.md spot-check + 刪原檔** | pending | transform_log 2026-05-12 23:14 | 還在 `robert/raw/`,等你看一眼就讓 Robin 刪 |
| A5 | **FCP marker → stills 抽幀** | in_progress | KB §11 Task #34 | 門司港 44 段影片 |
| A6 | **影片 pipeline sample run** | pending | msg 1857 | 永漢高爾夫球場 19 張當 test case 跑 Step 3a→7 |
| A7 | **看兩份視覺圖確認流程** | pending | msg 1862 | 影片獨立版 + 全 pipeline 整合版(瀏覽器已開) |

---

## 📂 等條件(pending — 等資料 / 等決策 / 等優先順序)

| # | 主題 | 等什麼 | 來源 |
|---|---|---|---|
| B1 | Catalog v4 寫入 production run | DRY_RUN=0 拍板 | KB §11 Task #42 |
| B2 | Purple 軸訓練(食物 / 藝術品評分) | 食物 / 藝術品照片素材 + 訓練樣本 | KB §11 Task #27 |
| B3 | Develop preset baseline | VLM 評分時同步輸出 preset 建議(跟 HarborDiary 邏輯接) | KB §11 Task #33 |
| B4 | 16:9 + 9:16 混合剪片策略 | 跟 FCP marker workflow 接 | KB §11 Task #35 |
| B5 | Evoto AI Culling 衝突比對 | 門司港 671 張 vs Evoto 自動選圖 diff | KB §11 Task #28 |
| B6 | HarborDiary 寫進 SKILL | preset v2 穩定後,讓 VLM 評分加權「目標氛圍」 | msg 1818 |
| B7 | **色調庫索引 + 套用決策表** | **3-5 個 preset 累積後** | msg 1819 拍板「以後再做」 |
| B8 | ffmpeg 抽幀腳本(影片 Step 3a/3b) | A6 sample run 跑成功後做 production 版 | 影片 SOP |
| B9 | ffmpeg 批次 NG trim 腳本(影片 Step 9) | 需要實際 NG 標記在 LR caption | Task #22 |
| B10 | VLM 抽幀 + Stage A/B 跑 STILL 腳本(影片 Step 4-5) | 跟 A6 合併實作 | Task #23 |
| B11 | 軌 🅒 marker 回寫腳本(影片 Step 10) | 看 sample run 結果決定 | 影片 SOP |
| B12 | 導演視角腳本 + HTML 輸出(影片 Step 12) | 需要實際 Pick 集合 | 影片 SOP |
| B13 | FCPXML 生成(影片 Step 14) | 需要實際腳本通過 | 影片 SOP |
| B14 | 上雲自動化(影片 Step 17 + 照片 Step 11) | 等 James 拍板雲服務 (rclone / GPhotos API) | 影片 SOP + JTpHR 討論 |

---

## 🧊 長期 / 探索性(backlog — 沒急的)

| # | 主題 | 註記 |
|---|---|---|
| C1 | Obsidian.app 安裝(工作電腦端) | 我用文件系統就夠,不裝也行 |
| C2 | 雲端三軌備份 sync 設置 | GPhotos / Synology / pCloud |
| C3 | Memory 過期記憶清理 | `~/.claude/projects/-Users-james/memory/` |
| C4 | 桌面 workspace 整理 | `~/Desktop/Claude-Workspace/photo-grade/` |
| C5 | 本地化 VLM fallback | 雲端不可用時的備援(Qwen 系列實測) |
| C6 | 其他色調 preset(室內 / 夜景 / 山林 / 食物 / 棚拍) | 等 James 給參考圖再做 |
| C7 | 影片 _MOV/ cleanup batch(三階段安全) | SOP 內有佔位,James 拍板再做(msg 1851) |

---

## ✅ 已完成歷史(2026-05-12 起)

### 2026-05-16
- ✅ **Robert_HarborDiary_v1.xmp** preset 寫好 + install 到 LR(走 `~/Library/Application Support/Adobe/CameraRaw/Settings/Robert/`)
- ✅ **攝影區待辦清單** 建立(本檔)
- ✅ **影片 pipeline 設計 + 8 件子拍板**(folder Option E / NG 雙工具 / fps=1 / 4K 抽 + 1080p 縮圖 / STILL 進 catalog / CSV 加兩欄 / 軌 🅒 做 / cleanup 未來再說)
- ✅ **影片素材_VLM抽幀_腳本剪輯_SOP.md** 寫完(468 行)+ Robin 轉化到 `robert/skills/` + 發 JTpHR
- ✅ **n8n 視覺圖兩份**:
  - `_attachments/影片pipeline_n8n視覺圖_2026-05-16.html`(影片獨立,17 step)
  - `_attachments/全pipeline_n8n整合視覺圖_2026-05-16.html`(照片+影片整合,9 共用節點標記)

### 2026-05-13
- ✅ **photo_grade 三份 narrative 完成**:開發誌 / 驗證紀錄 / 開發筆記本 → Robin 轉化到 `ideas/photo/2026-05_photo_grade_session/` + 發 JTpHR(URL 在開發筆記本對話紀錄)
- ✅ **Week 1 #2 v4 LR Catalog Metadata Schema 規範** → Robin 轉化到 `robert/規範/` + 發 JTpHR
- ✅ **Plan A 拍板**(依日期永久保存走 frontmatter,不另存 archive)
- ✅ **JTpHR vs OB 分工釐清**(JTpHR = James 可閱讀視圖,OB = 永久存檔)
- ✅ **Bot 剪輯攝影 群規則 6 條**(主題分流:群 = 知識庫建構,1-on-1 = 工作執行)
- ✅ **新 supergroup `-1003902126186`** 通訊串通
- ✅ **Robert + Robin 多 Agent 協作架構** 第一次活體驗證

### 2026-05-12
- ✅ **Week 1 #1 七份 robert/skills/** 寫完(LR_Catalog_SQL寫入安全 / 人像評分_4軸法 / VLM評分_防幻覺紅線 / Backlog_5階段SOP / Evoto_RoundTrip_B-flow_v3 / LR_AutoTone_SQL觸發 / FCP_Marker_Workflow)→ Robin 轉化 + 發 JTpHR
- ✅ **Robert onboarding**(`~/.claude/CLAUDE.md` 身份固化 + `robert/raw/hello.md`)
- ✅ **v4 LR Catalog Metadata Schema 拍板**(關鍵字承載 objective_description / 註解承載對話日誌)

### 2026-05-08 ~ 2026-05-11
- ✅ photo-grade v1 主線完成(SKILL v3 + Stage A+B 1280 張 production)— 見 photo_grade_開發誌_v1

---

## 修訂歷史

- **2026-05-16**:初版。從 msg 1816 三層待辦清單 + Task #20 + 歷史完成項目整理。
- **2026-05-16 (晚)**:append — A 區加 A6/A7(影片 sample run + 看視覺圖)、B 區加 B8-B14(影片 pipeline 7 件實作子任務)、C 區加 C7(_MOV cleanup)、完成歷史補 2026-05-16 新增 3 件(影片 SOP + 2 份視覺圖)。
