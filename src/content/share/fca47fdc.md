---
title: "2026-07-11-1044"
date: 2026-07-11
time: 10:44
source: dm
tags: [session-insight]
related: [影片工具鏈, claudetube, crv, yt-dlp, 影片分析分流, Telegram]
---
sourceNote: "insight__2026-07-11-1044"

# Session Insight — 2026-07-11 10:44

（工作主要在 2026-07-10 晚間的 Telegram DM 進行，重啟後接續完成並於今日補寫 insight）

## 這次做了什麼
驗收 2026-07-10 裝的影片工具鏈（路線 B / uv）：確認 uv+Python3.12+static-ffmpeg+crv+claudetube+19 個 skill 已全裝好，對兩支 YouTube 影片做 claudetube 與 crv 的實際煙霧測試，產出雙影片完整內文 HTML 報告，修掉 crv 找不到 yt-dlp 的雷，並把「影片分析視覺 vs 內容分流」定為常規規則。

## 產出成果
1. 雙影片內文報告（繁中全逐字稿＋章節＋摘要，深色自適應單檔）：`/Users/james.t/Desktop/影片內文報告_無人機x康寧玻璃_20260710.html`
   - ① 天下雜誌《台灣無人機出口量年增35倍》Ep.92（v=3IoCMZPg-iQ）
   - ② 財訊《玻璃改變顯示器也改變半導體》聽了財知道 EP346 CPO（v=PJTKjoko4gI）
2. 修復 crv 的 yt-dlp 依賴：`uv tool install yt-dlp` → `~/.local/bin/yt-dlp` v2026.7.4，crv 乾淨環境自己找得到；清掉測試殘留的 327MB source.mp4
3. Memory 更新：
   - `project_video_skills_toolchain.md` 增補「煙霧測試結論＋已知雷」段
   - 新增 `feedback_video_analysis_routing.md`（視覺 vs 內容分流）＋登錄 MEMORY.md 索引

## 這次的模式（meta-thinking）
1. 驗收既有安裝時，先用 `command -v` / `--version` / 列出實際檔案「查證現狀」，再決定要不要重跑。用戶以為要重裝，查證後確認早已裝好，省下整套重跑。
2. 非英文影片取逐字稿：優先抓 YouTube 原生字幕（`yt-dlp --sub-langs zh-TW`），無字幕才 fallback whisper 且至少 medium；whisper tiny 對中文會整段亂碼＋重複迴圈。
3. 影片任務先分一刀「要視覺 or 要內容」：教學/畫面→視覺工具（ask_video/抽幀）；口播/訪談/財經→逐字稿。對口播片硬跑視覺問答會 confidence 0 答不出。
4. 當隔離 venv 的 CLI（crv）找不到共用依賴（yt-dlp）→ 把該依賴獨立 `uv tool install`，讓它落在 `~/.local/bin`（在 PATH），一次供所有工具共用，比逐一注入各 venv 乾淨。

## 下一步
- [ ] 恢復 Telegram 上線：桌面雙擊「啟動TG助理.command」（真終端最穩）— 下次要用 TG 前
- [ ] crv 長片再用時注意：慢又吃 CPU、-o 夾會留原檔大檔要清（有長片需求時再處理）

## 來源連結
- https://www.youtube.com/watch?v=3IoCMZPg-iQ
- https://www.youtube.com/watch?v=PJTKjoko4gI
