---
title: DaVinci Resolve 21 AI 新功能 + MCP 自動化分析
date: 2026-04-17
來源: ziro.film IG/Threads（由 Claude 整理）+ 用戶於 Ideas 群分享
連結: 用戶於 Telegram Ideas 群分享 4 張截圖
tags:
- AI工具
- AI影音
- 教學
- DaVinci Resolve
- MCP
- 自動剪輯
- 調色
aliases:
- DaVinci Resolve 21
- 達芬奇 MCP
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

# DaVinci Resolve 21 AI 新功能 + MCP 自動化分析

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 核心結論</p>
<div class="text-sm text-gray-300">

DaVinci Resolve Studio（$295 一次買斷）是**性價比最高的自動化剪輯方案**：MCP 工具數最多（342）、Python 原生支援、調色業界第一、新版內建 AI 語音生成（可取代 ElevenLabs）。適合取代 FCPX 成為你的主力剪輯工具。

</div>
</div>


---

## 📑 原圖

- ![](/images/kb/davinci-resolve-21/01-features.jpg)
- ![](/images/kb/davinci-resolve-21/02-features.jpg)
- ![](/images/kb/davinci-resolve-21/03-features.jpg)
- ![](/images/kb/davinci-resolve-21/04-features.jpg)

---

## 🆕 DaVinci Resolve 21 新 AI 功能（9 項）

### 1. IntelliSearch（智慧搜尋）⭐⭐⭐
分析媒體內容後，用關鍵字搜尋整個專案素材（物件/人物/對白文字）。大型專案找素材不用翻 bin。
→ **自動化價值高**：Claude 可以用此功能找到特定鏡頭

### 2. CineFocus（電影感對焦）⭐⭐
後期重新指定畫面合焦點、調整景深、加 bokeh 光圈形狀效果。支援關鍵幀，可做後製 rack focus。

### 3. Face Age Transformer（臉部年齡轉換）⭐
分析人臉後用 offset 滑桿加減年齡特徵（皺紋、豐潤度）。適合閃回/閃前場景。

### 4. Face Reshaper（臉部重塑）⭐
AI 局部重塑臉部五官比例與大小。

### 5. Blemish Removal（瑕疵移除）⭐⭐
一鍵 AI 消除臉部瑕疵，連不明顯的痘疤都能處理。

### 6. UltraSharpen（超級銳化）⭐⭐
據稱最強銳化工具，能提升影片畫質。也能修復 deblur。

### 7. Motion Deblur（動態去模糊）⭐⭐
分析素材，移除常見動態模糊（拍攝/軟片）。對動作場景特別有感。

### 8. Speech Generator（語音生成）⭐⭐⭐
文字轉語音，可用 Blackmagic 內建聲音模型，或用自己的聲音模板（最少 10 秒）複製個人語音。
→ **可取代 ElevenLabs！**

### 9. Slate Reading（場記板辨識）⭐⭐⭐
AI 自動識取場記板上的資訊（鏡頭、碟次、備註），匯入 logging 時間。
→ **自動化價值極高**：專業拍攝的 metadata 自動化

---

## 🔧 DaVinci Resolve MCP 現況

### GitHub Repos

| Repo | 工具數 | 特色 |
|------|--------|------|
| ⭐ [samuelgursky/davinci-resolve-mcp](https://github.com/samuelgursky/davinci-resolve-mcp) | **342** | 最完整，涵蓋整個 Scripting API |
| [Tooflex/davinci-resolve-mcp](https://lobehub.com/mcp/tooflex-davinci-resolve-mcp) | — | 進階控制（剪輯/調色/音訊）|
| [barckley75/resolve-mcp](https://lobehub.com/mcp/barckley75-resolve-mcp) | — | 直接原生 API，不需 addon |
| [apvlv/davinci-resolve-mcp](https://github.com/apvlv/davinci-resolve-mcp) | — | 含 Fusion 支援 |

### 重要限制

<div class="not-prose my-6 bg-yellow-500/10 border-l-4 border-yellow-500 rounded-r-lg p-4">
<p class="font-bold text-yellow-400 mb-2">⚠️ Warning</p>
<div class="text-sm text-gray-300">

**免費版 DaVinci Resolve 的 Scripting API 非常有限** → MCP 需要 **Studio 版**
- 價格：USD $295（約 NT$9,500）**一次買斷**
- 不是訂閱制

</div>
</div>


---

## 🆚 四大剪輯軟體 MCP 完整比較

| | **DaVinci Resolve** | Premiere Pro | FCPX | CapCut |
|---|---|---|---|---|
| MCP 工具數 | **342** ⭐ | 269 | 53-100 | 11+ |
| 定價 | **$295 買斷** | NT$700/月 | NT$9,000 買斷 | 免費/Pro |
| 調色 | **業界第一** | 中 | 中 | 基礎 |
| 內建 AI 語音 | **✅** | ❌ | ❌ | ❌ |
| 智慧搜尋 | **✅** | ❌ | ❌ | ❌ |
| Python 原生 | **✅** | ❌ | ❌ | ❌ |
| 特效引擎 | **Fusion 內建** | 要 AE | 要 Motion | 基礎 |
| 你有嗎 | ❌ 待裝 | ❌ | ✅ 有 | ✅ 有 |

---

## 💡 對影像工廠流水線的影響

### 簡化前（原方案）
```
Claude → ElevenLabs（配音）→ Kling（影片）→ FCPX/CapCut（剪輯）→ 匯出
```
= 4 個獨立工具

### 簡化後（DaVinci 方案）
```
Claude → Kling（影片）→ DaVinci Resolve（剪輯+調色+語音+銳化+去瑕疵）→ 匯出
```
= 3 個工具（**少一個 ElevenLabs**）

### 被整合掉的：
- ✅ ElevenLabs → DaVinci Speech Generator 取代
- ✅ After Effects → DaVinci Fusion 取代
- ✅ 獨立調色軟體 → DaVinci 本體就是調色王

---

## 🎯 4 種攝影場景更新

| 場景 | 原方案 | DaVinci 方案 |
|------|--------|-------------|
| 實境秀生活紀錄 | CapCut | CapCut（快速）or DaVinci（品質）|
| MTV 濃縮分享 | FCPX | **DaVinci**（調色+節拍） |
| 月度回憶 | FCPX | **DaVinci**（長片+調色+語音旁白）|
| 旅行精選 | FCPX + CapCut | **DaVinci**（主力）+ CapCut（IG 快版）|

→ **DaVinci 取代 FCPX 為主力**，CapCut 保留做快速短片

---

## 📝 後續行動

<div class="not-prose my-6 bg-purple-500/10 border-l-4 border-purple-500 rounded-r-lg p-4">
<p class="font-bold text-purple-400 mb-2">☑️ Todo</p>
<div class="text-sm text-gray-300">

- [ ] 下載免費版 DaVinci Resolve 試玩介面
- [ ] 評估是否買 Studio 版 $295（一次買斷）
- [ ] 安裝 samuelgursky/davinci-resolve-mcp（342 工具）
- [ ] 更新 個人攝影自動化流水線_4種場景設計 筆記
- [ ] 更新 影像工廠_Claude_Kling_ElevenLabs_n8n自動化工作流 — 去掉 ElevenLabs 改用 DaVinci Speech Generator

</div>
</div>


---

## 🔗 相關筆記

- Claude_自動剪輯_Premiere_MCP_完整整理 — 三大平台（+DaVinci 成為第四個）
- 個人攝影自動化流水線_4種場景設計 — 4 種場景（需更新為 DaVinci 主力）
- 影像工廠_Claude_Kling_ElevenLabs_n8n自動化工作流 — n8n 流水線（需更新）
- Google_Veo3_完整使用指南 — 影片生成搭配 DaVinci 後製
- AI影音創作 INDEX
