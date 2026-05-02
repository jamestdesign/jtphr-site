---
title: Claude Routines 全新功能 — 一句話打造全自動工作流（取代 n8n？）
date: 2026-04-17
來源: YouTube — 李哈利 Harry Lee
連結: https://youtu.be/DRgkh8IRk9k?si=vX59KNwMHRscN6zm
tags:
  - AI工具
  - Claude
  - 自動化
  - Routines
  - n8n替代
  - 工作流
aliases:
  - Claude Routines
  - Routines 取代 n8n
category: "AI工具"
---

# Claude Routines — 一句話打造全自動 AI 工作流

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 核心</p>
<div class="text-sm text-gray-300">

Claude 發布全新 **Routines** 功能：可在 Claude Code 內直接設定**排程自動化工作流**（每天/每週/每月），用自然語言描述即可建立。作者（李哈利）認為這可以**徹底取代 n8n**。

</div>
</div>


---

## 🆕 什麼是 Routines

- 在 Claude Code 內建的**排程自動化功能**
- 可設定每日/每週/每月的特定時間自動執行
- 用**自然語言**描述工作流（不用拖拉節點）
- 搭配 **Connectors**（Gmail / Slack / Calendar 等）自動操作外部服務
- 存在 Claude Code 的 routine 資料夾中

## 🎬 影片範例演示

作者示範了一個「每天早上自動處理 Email」的 Routine：

```
指令：「每天早上幫我去 Gmail 抓取所有新郵件，
      如果有過往對話的郵件就幫我寫 draft 回覆，
      完成後透過 Slack 通知我」
```

Claude Code 執行結果：
1. ✅ 抓取 30 封郵件
2. ✅ 篩選歷史對話（0 封符合）
3. ✅ 跳過無需回覆的
4. ✅ 透過 Slack 發通知

→ **整個流程用兩句話就設定完畢**

## 🆚 Routines vs n8n 對比

| | Claude Routines | n8n |
|---|---|---|
| 設定方式 | **自然語言** | 拖拉節點 + 參數 |
| 學習曲線 | **極低** | 中高 |
| 需要自架 | ❌ Claude 內建 | ✅ 要自架 |
| 複雜工作流 | 用文字描述 | 視覺化節點圖 |
| 等待機制 | Claude 自己處理 | 內建 wait 節點 |
| Connector | Gmail/Slack/Calendar 等 | **400+ 整合** |
| 排程 | 每日/每週/每月 | cron 表達式（更靈活）|
| 除錯 | 對話式 | 節點日誌 |
| 價格 | Claude 訂閱即可 | 免費（自架）or $20/月 |

### 作者觀點
> 「之前很多人質疑 Claude 能不能取代 n8n，現在有了 Routines，我越來越覺得可以完全取代了」

### 我的補充觀點

**Routines 能取代 n8n 的場景**：
- 簡單線性工作流（A → B → C）
- 個人自動化（Email / Slack / Calendar）
- 不需要複雜條件分支

**n8n 仍有優勢的場景**：
- 複雜分支邏輯（if/else 多層巢狀）
- 需要 400+ 個 Connector（Claude 目前支援較少）
- 需要精確的 cron 排程
- 批次處理大量資料（Kling 等待 3-5 分鐘 → n8n 的 wait 更穩）
- 團隊協作（多人共用工作流）

---

## 🎯 跟你現有工具的關係

### 你目前已有的排程方案

| 方案 | 技術 | 用途 |
|------|------|------|
| **macOS launchd** | daily-session-insight.sh | 每天 4:03 AM session insight |
| **GAS 觸發器** | stock_tracker_v8.gs | 每天 3:30 PM 股票更新 |
| **CronCreate** | Claude Code 內建 | 會話內排程（7 天過期）|

### Routines 可以取代/補強的

| 現有方案 | Routines 能做嗎？ |
|---------|-----------------|
| daily session insight | ⚠️ 可以但 launchd 更穩（不依賴 Claude 在線）|
| 股票更新 | ❌ 這是 GAS server-side，不用改 |
| 每日財經新聞推送 | ✅ **非常適合！** |
| 每日攝影素材整理 | ✅ 可以嘗試 |
| 每週 /review-kb | ✅ 可以嘗試 |

---

## 💡 Routines 最適合你的 3 個應用

### 1. 每日財經新聞自動推送（ideas/TODO 裡的那個）
```
Routine: 每天早上 8 點
→ 搜尋台股相關新聞
→ 篩選 watchlist 相關個股
→ 整理成摘要
→ 推送到 Telegram 股票群
```
→ 之前在 TODO 的「設計每日早晨自動財經新聞 Subagent」可以用 Routines 實現！

### 2. 每週知識庫體檢（/review-kb）
```
Routine: 每週日 10 點
→ 掃描 KnowledgeBase 所有筆記
→ 找出矛盾/過時/孤立筆記
→ 整理成報告
→ 推送到 Telegram 私訊
```

### 3. 每日攝影素材整理（未來 NAS 後）
```
Routine: 每天晚上 11 點
→ 掃描 NAS 的新素材
→ 按日期/地點分組
→ 生成當日素材清單
→ 推送到自動剪輯群
```

---

## ⚠️ 待確認的關鍵問題

1. **Routines 是否在 Claude Code CLI 也可用？**
   影片裡是在 Claude 桌面 App / Cowork 介面操作的。如果只有桌面 App 才有 → 你需要用 Claude 桌面 App 來設定。

2. **Routines 需要電腦保持開機嗎？**
   如果跟之前的 CronCreate 一樣是 session-only → 那還是 launchd 更穩。
   如果是 server-side（像 scheduled agents）→ 那就很強。

3. **Routines 能搭配你的 Telegram MCP 嗎？**
   如果可以 → 就能直接替代很多手動推送邏輯。

---

## 📝 後續行動

<div class="not-prose my-6 bg-purple-500/10 border-l-4 border-purple-500 rounded-r-lg p-4">
<p class="font-bold text-purple-400 mb-2">☑️ Todo</p>
<div class="text-sm text-gray-300">

- [ ] 確認 Routines 是否在 Claude Code CLI 可用（檢查 `claude routine` 指令）
- [ ] 如果可用 → 試建一個「每日財經新聞」Routine
- [ ] 如果不可用 → 用 Claude 桌面 App 設定
- [ ] 評估是否可以取代 ideas/TODO 裡的 n8n 計畫

</div>
</div>


---

## 🔗 相關筆記

- 影像工廠_Claude_Kling_ElevenLabs_n8n自動化工作流 — 之前的 n8n 影像工廠方案（Routines 可能替代 n8n 部分）
- Claude_Cowork_整合工作流_對應現況 — Claude.ai 功能對照
- 個人攝影自動化流水線_4種場景設計 — 排程自動化可用 Routines
