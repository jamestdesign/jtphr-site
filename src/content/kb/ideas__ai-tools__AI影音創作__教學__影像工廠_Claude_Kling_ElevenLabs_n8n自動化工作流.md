---
title: 影像工廠 — Claude + Kling + ElevenLabs + n8n 全自動工作流
date: 2026-04-14
來源: Threads — @youngster_workflow_ai（19 小時前）
連結: https://www.threads.com/@youngster_workflow_ai/post/DXEm2Bik2gV
作者: youngster_workflow_ai
互動: 111 讚 / 27 留言 / 9 分享 / 128 收藏
tags:
- AI工具
- AI影音
- 教學
- 工作流自動化
- n8n
- Claude
- Kling
- ElevenLabs
- 影像工廠
aliases:
- 影像工廠
- n8n 影片自動化
creator: claude_robin
co_creators:
- james
managed_by: claude_robin
managed_at: '2026-05-06'
transformed: false
private: false
published: false
version: 1
last_revised: null
revision_history: []
category: "AI影音-教學"
---

# 影像工廠 — Claude + Kling + ElevenLabs + n8n 全自動工作流

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 核心</p>
<div class="text-sm text-gray-300">

@youngster_workflow_ai 用 **n8n**（開源工作流自動化平台）把 Claude（大腦/分鏡）+ Kling AI（攝影師/影片生成）+ ElevenLabs（音樂/音效/配音）**串成一條全自動產線**。
「跟 Claude 確定好分鏡，5 分鐘就可以做好簡單的室內設計影片」。
這是真正的「**影像工廠**」— 輸入指令，自動產出完成影片。

</div>
</div>


---

## 📑 原圖

![](/images/kb/youngster-workflow-ai/01-workflow-diagram.jpg)
![](/images/kb/youngster-workflow-ai/02-threads-post.jpg)

---

## 📝 原文翻譯

> 跟 Claude 確定好分鏡，5 分鐘就可以做好簡單的室內設計影片⋯⋯會不會太扯⋯⋯
>
> 做了一個工作流，把大家會用到的都串在一條線上，成了名副其實的**影像工廠**。
> - **Claude** 作為大腦
> - **Kling AI** 作為攝影師
> - **ElevenLabs** 作為音樂、音效
>
> 可以用在各種類型的影音創作。

---

## 🔧 工作流拆解（從截圖中的 n8n 節點圖分析）

截圖中可見一個完整的 **n8n 自動化流程**，節點包括：

```
Schedule Trigger（定時觸發）
        ↓
Get Data（取得資料 — 可能是 Airtable / Notion 資料庫）
        ↓
Claude AI（寫分鏡腳本 + 規劃畫面描述）
        ↓
Convert text to speech（ElevenLabs TTS — 文字轉語音）
        ↓
Upload an object/3（上傳素材到 Kling）
        ↓
Kling / AI avatar（影片生成 + AI 虛擬人物）
        ↓
Wait/1（等待 Kling 生成完成）
        ↓
HTTP Request/12（取回影片結果）
        ↓
Update record（更新資料庫紀錄）
        ↓
Shares an object（分享/發布成品）
```

### 這個工作流的 10 個節點各在做什麼

| # | 節點 | 功能 | 對應工具 |
|---|------|------|---------|
| 1 | Schedule Trigger | 定時觸發（例如每天早上 9 點跑一次）| n8n 內建 |
| 2 | Get Data | 從資料庫讀取今天要做的影片主題 | Airtable / Notion API |
| 3 | Claude AI | **寫分鏡 + 腳本 + 畫面描述**（大腦）| Claude API |
| 4 | Convert to speech | **文字轉語音**（旁白/配音）| ElevenLabs TTS API |
| 5 | Upload object | 上傳圖片/參考素材到 Kling | Kling API |
| 6 | Kling AI avatar | **生成影片**（含 AI 虛擬人物）| Kling API |
| 7 | Wait | 等待生成（Kling 需要幾分鐘）| n8n 內建 |
| 8 | HTTP Request | 取回生成完的影片檔 | Kling API |
| 9 | Update record | 更新資料庫「已完成」| Airtable / Notion |
| 10 | Share | 發布/分享（可能是上傳到 YouTube / IG）| 各平台 API |

---

## 🆕 這個工作流的關鍵新概念：n8n

### 什麼是 n8n？

**n8n**（讀作 n-eight-n）是一個**開源的工作流自動化平台**，類似 Zapier / Make，但：
- ✅ **開源**（可以自己架，完全免費）
- ✅ **視覺化**（拖拉節點連線）
- ✅ 支援 400+ 個整合（包括 Claude API、Kling、ElevenLabs）
- ✅ 可自架在你的 Mac / NAS / VPS
- 網址：https://n8n.io

### n8n vs 你目前的 Claude Code 自動化

| 面向 | n8n | Claude Code（你現在用的）|
|------|-----|----------------------|
| 介面 | **視覺化**拖拉 | 命令列 + 文字 |
| 排程 | **內建 cron**，超簡單 | macOS launchd（你已設定）|
| API 串接 | **400+ 整合**，拖拉即用 | MCP + Bash script |
| 靈活度 | 中（要走節點邏輯）| **極高**（任何 code 都行）|
| AI 能力 | 呼叫 API（外部）| **Claude 本體**（內部）|
| 學習曲線 | 低（視覺化）| 中高（要懂命令列）|
| 部署 | 自架 or 雲端 $20/月 | 已有 ✅ |
| 長時間任務 | ✅ 擅長等待 + 重試 | ⚠️ 需要自己寫 wait/retry |

### 核心差異

**n8n 的強項 = 「等待」**

你的 Kling 影片生成需要 3-5 分鐘，n8n 可以：
```
發送請求 → 等 5 分鐘 → 自動取回結果 → 下一步
```

你的 Claude Code 要做同樣的事需要：
```
發送請求 → sleep 300 → curl 取結果 → parse → 下一步
```

不是做不到，但 n8n 做起來更優雅。

---

## 🎯 跟你現有工具的對應

| 影像工廠節點 | 你已有的對應 | 缺什麼 |
|------------|-----------|--------|
| Claude AI（分鏡） | ✅ universal-video-prompt v2 skill | 無缺 |
| Kling AI（影片）| ✅ Kling prompt 已有多組 | 缺 **Kling API** 自動化呼叫 |
| ElevenLabs（配音）| ❌ **沒有** | 需要加 ElevenLabs |
| n8n（編排）| ⚠️ Claude Code + launchd 可替代 | 或可直接裝 n8n |
| 排程觸發 | ✅ launchd 已有 | 無缺 |
| 資料庫 | ⚠️ Obsidian TODO.md | 如果要排程大量影片需要 Airtable |
| 發布 | ⚠️ 手動 | 可加 Buffer / 直接 API |

### 你缺的 2 塊拼圖

1. **ElevenLabs**（語音 / 配音 / 音效）
   - 這是你目前完全沒有的
   - 有免費額度（每月 10,000 字元 TTS）
   - Pro $5/月起
   - 對你的「攝影生活影片」有用嗎？→ **有用**（可以加旁白、配樂）

2. **Kling API 自動化**（不是手動貼 prompt）
   - 你目前是手動到 Kling 網站貼 prompt
   - 影像工廠的做法是透過 API 自動送 + 自動取回
   - Kling 有 API（需要申請）

---

## 💡 你可以怎麼複製這個「影像工廠」

### 方案 A：用 n8n（跟原作者一樣）

```
安裝 n8n（自架在 Mac / NAS）
        ↓
設定節點：Claude API → ElevenLabs → Kling API
        ↓
視覺化拖拉連線
        ↓
排程觸發 or 手動觸發
```

優點：視覺化、等待機制、400+ 整合
缺點：要學 n8n、要自架

### 方案 B：用你現有的 Claude Code + Skills（推薦）

```
你在 Telegram 說「幫我做一支室內設計影片」
        ↓
Claude Code（universal-video-prompt v2）寫分鏡 + prompt
        ↓
Claude Code 呼叫 ElevenLabs API 生配音（需新增 MCP 或 Bash script）
        ↓
Claude Code 呼叫 Kling API 生影片（需新增）
        ↓
等待 + 取回結果
        ↓
CapCut/FCPX MCP 組合剪輯
        ↓
匯出 + 通知你
```

優點：不用學新工具、跟你現有工作流一致
缺點：等待機制要自己寫（sleep + retry）

### 方案 C：混合（最佳 — 長期推薦）

- **n8n 負責「等待密集」的任務**（Kling 生成 3-5 分鐘、批次處理）
- **Claude Code 負責「智慧決策」**（分鏡、prompt、品質判斷）
- 兩者透過 **webhook** 互相呼叫

```
Claude Code → 寫好分鏡 → 傳給 n8n webhook
        ↓
n8n → 呼叫 ElevenLabs → 等待 → 呼叫 Kling → 等待 → 取回
        ↓
n8n → webhook 通知 Claude Code → 品質審查
        ↓
Claude Code → CapCut MCP 剪輯 → 匯出 → Telegram 通知你
```

---

## 🎬 展示範例：室內設計影片

截圖裡展示的成品是一支**室內設計影片**：
- 一位穿黑色洋裝的女性（AI avatar）
- 被合成到一個豪華的室內設計場景中
- 場景含：水晶吊燈、沙發、畫作、大理石牆面
- 5 分鐘內完成

這個工作流不限於室內設計，**可以用在**：
- 你的股票分析影片（AI 主播 + 資料視覺化背景）
- 旅行回憶影片（AI 旁白 + 照片動態化）
- IG Reels 商品介紹（AI avatar 拿產品）
- 房地產展示（室內設計 + AI 導覽員）

---

## 📝 關於你問的「你能解析影片嗎？」

如果這篇 Threads 有附影片：
- ❌ 我無法直接播放/分析 Threads 上的影片（需要下載 MP4）
- ✅ 如果你把影片下載後傳給我，我可以分析（用 Read 工具看截圖，或用 markitdown 萃取 metadata）
- ✅ 如果是 YouTube 連結，我可以抓字幕分析

**建議**：如果你覺得那支影片值得深入分析，把它下載後傳到 Telegram 給我。

---

## 📝 後續行動

<div class="not-prose my-6 bg-purple-500/10 border-l-4 border-purple-500 rounded-r-lg p-4">
<p class="font-bold text-purple-400 mb-2">☑️ Todo</p>
<div class="text-sm text-gray-300">

- [ ] 評估是否安裝 **n8n**（自架在 robin Mac 或未來的 NAS）
- [ ] 評估是否申請 **Kling AI API**（從手動貼 prompt 升級為 API 自動化）
- [ ] 評估是否加入 **ElevenLabs**（TTS 配音/音效，免費額度 10K 字元/月）
- [ ] 如果以上都 yes → 在新的「自動剪輯群」實作完整的影像工廠流水線

</div>
</div>


---

## 🔗 相關筆記

- 個人攝影自動化流水線_4種場景設計 — 你的 4 種場景設計（影像工廠可以驅動所有場景）
- Claude_自動剪輯_Premiere_MCP_完整整理 — 剪輯環節的 MCP 方案
- Google_Veo3_完整使用指南 — Kling 的替代影片生成工具
- 威森_Claude_Skill_3個實用技能_安裝教學 — prompt skill
- AI影音創作 INDEX
