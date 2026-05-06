---
title: notebooklm-py
date: '2026-04-05'
tags: []
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
category: "AI工具"
---

# notebooklm-py

> 來源：@aiwithanushka（Instagram）
> 日期：2026-04-05
> 類別：AI工具 / 知識管理

## 一句話摘要
用 Python 讓 Claude Code 操控 Google NotebookLM，免費生成心智圖、投影片、音訊摘要等內容。

## 核心功能
- Audio Overview（Podcast 風格摘要）
- Video Overview
- Mind Map（心智圖）
- Reports（報告）
- Flashcards（抽認卡）
- Quiz（測驗題）
- Infographic（資訊圖）
- Slide Deck（投影片）
- Data Table（資料表）

## 安裝方式
```bash
pip install "notebooklm-py[browser]"
playwright install chromium
notebooklm login
notebooklm skill install
```

## 使用範例
```
notebooklm create "我的研究"
notebooklm source add "https://..."
notebooklm generate mind-map
notebooklm generate audio
notebooklm generate slide-deck
```

## 適用場景
- YouTube 影片 → 心智圖
- 長文章 → 結構化報告
- 多篇文章 → 整合摘要
- 語音筆記 → 知識卡片

## 注意事項
- 非官方 API，用 Playwright 自動化瀏覽器
- NotebookLM 改版可能導致失效
- 需要 Google 帳號登入

## 實作難度
⭐⭐☆ 中等

---

## 原始截圖
![](/images/kb/notebooklm-01-cover.jpg)
![](/images/kb/notebooklm-02-github.jpg)
![](/images/kb/notebooklm-03-features.jpg)
![](/images/kb/notebooklm-04-install.jpg)
![](/images/kb/notebooklm-05-skill-usage.jpg)
![](/images/kb/notebooklm-06-use-cases.jpg)
