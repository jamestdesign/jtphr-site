---
title: 威森 Claude Skill 3 個實用技能 安裝教學
date: 2026-04-11
來源: 部落格 — 理工威森
連結: https://wilson-men.tw/3-skill/
作者: 理工威森
原文發布: 2026-04-08
tags:
- AI工具
- Claude
- Skills
- ClaudeAI
- 行銷
- 提示詞工程
aliases:
- 威森Skill教學
- Claude Skill 安裝
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

# 威森 Claude Skill 3 個實用技能 安裝教學

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 核心觀點</p>
<div class="text-sm text-gray-300">

Skill 就像為 Claude 裝上專家模組。未安裝時 Claude 是通用助理，裝上 Skill 後能自動套用專業架構與格式輸出成品。本文示範安裝 3 個實用 Skill，可串聯成完整廣告產線。

</div>
</div>


---

## 適用環境

- **Claude.ai 網頁版／桌面 App**（不是 Claude Code）
- 需要 **Claude Pro 或 Team 方案**（免費版無法使用）
- 手機和電腦皆可

<div class="not-prose my-6 bg-yellow-500/10 border-l-4 border-yellow-500 rounded-r-lg p-4">
<p class="font-bold text-yellow-400 mb-2">⚠️ 與我現有環境的差異</p>
<div class="text-sm text-gray-300">

這篇講的是 Claude.ai 的 Skill 系統，跟我們前一篇 Obsidian_Claude_Code_第二大腦_Claudian 講的 Claude Code skill 是不同產品線。

| | Claude Code Skills | Claude.ai Skills |
|---|---|---|
| 安裝位置 | `vault/.claude/skills/` 或 `~/.claude/skills/` | Claude.ai 設定 → Skills 上傳 |
| 檔案格式 | SKILL.md + references/ | 單一 .md 檔 |
| 觸發方式 | Claude Code 自動讀取 | Claude.ai 對話自動套用 |

</div>
</div>


---

## 安裝四步驟（Claude.ai 路線）

1. **進入設定** — 點擊頭像進入 Settings
2. **找到 Skills 區塊** — 在設定頁面定位 Skills 選項
3. **上傳三個 .md 檔案**：
   - `universal-image-prompt.md`（圖片提示詞）
   - `universal-video-prompt.md`（影片提示詞）
   - `ad-story-designer.md`（廣告故事設計）
4. **確認啟用** — 三個 Skill 都打開

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 檔案已取得</p>
<div class="text-sm text-gray-300">

用戶 2026-04-11 直接在 Telegram 提供 3 個 .md 檔，已存到 vault：
- _attachments/wilson-skills/universal-image-prompt.md
- _attachments/wilson-skills/universal-video-prompt.md
- _attachments/wilson-skills/ad-story-designer.md

</div>
</div>


---

## 三個 Skill 詳細解析（已讀取實際內容）

### 1. universal-image-prompt（AI 圖片提示詞產生器）

**核心架構：五層鏡頭思維**

每張圖的 prompt 用 5 層結構組裝：
1. **Subject（主體）** — 主角是什麼，永遠放最前面
2. **Scene（場景）** — 環境細節，前景/中景/背景三層
3. **Lighting（光線）** — 8 種常用光線（自然光／黃金時段／戲劇側光／逆光剪影...）
4. **Style（風格）** — 攝影類／藝術類／風格類／情緒類
5. **Technical（技術）** — 鏡頭、景深、畫質、構圖、後製

**支援平台**：Midjourney、DALL-E、Flux、Stable Diffusion、Ideogram、GPT-4o、Recraft

**產出格式**：
- 完整 Prompt（英文，可直接複製）
- 五層解讀（中文，每層說明）
- 平台建議（推薦平台 + 比例 + 模型版本）
- 變體建議（2 個延伸方向）

**特色**：支援平台特性差異化（Midjourney 簡短、DALL-E 自然語言、Flux 重技術、SD 加權重）

### 2. universal-video-prompt（AI 影片提示詞產生器）

**核心架構：八層漢堡公式**

每個影片鏡頭用 8 層結構組裝：
1. **Medium（景別）** — 8 種：ECU/CU/MCU/MS/MFS/FS/WS/EWS
2. **Shot Type（鏡頭類型）** — 過肩 / POV / 雙人 / 插入 / 環境 / 反應
3. **Angle（角度）** — 平視 / 仰角 / 俯角 / 鳥瞰 / Dutch / 蟲視
4. **Movement（運鏡）** — 10+ 種：Static / Pan / Tilt / Dolly / Tracking / Crane / Handheld / Zoom / Orbit / Whip pan
5. **Focus（焦點）** — 淺景深 / 全域對焦 / Rack focus / Split diopter / Soft focus
6. **Subject（主體）** — 動作要有起始結束、表情要具體
7. **Lighting（光線）** — 8 種影片光線
8. **Color（色調）** — 暖琥珀 / 冷藍去飽和 / 高對比電影感 / 青橙對比...

**支援平台**：Kling、Veo、即夢 Seedance、Runway、Pika、Hailuo、Sora

**產出格式**：
- 分鏡規劃（多鏡頭時）
- 每鏡頭八層解讀
- 多平台適配版本（Kling / 即夢 / Runway 各一版）
- 變體建議

**特色**：可拆分鏡頭、提供平台差異化建議

### 3. ad-story-designer（廣告故事設計師）

**核心方法論**：痛點 → 故事 → 分鏡

**6 步驟產出流程**：
1. **品牌快問快答** — 7 個問題確認資訊（產品 / 客群 / 痛點 / 解法 / 秒數 / 平台 / 目的）
2. **受眾心理分析** — 表層痛點 / 深層恐懼 / 理想狀態 / 行動障礙 / 觸發情境
3. **故事線設計** — 提供 15 / 30 / 60 秒的固定結構模板 + 情緒曲線
4. **逐秒分鏡腳本** — 每個鏡頭含畫面 / 景別 / 運鏡 / 台詞 / 音效 / 情緒目標
5. **拍攝 / AI 生成建議** — 真人拍攝 + AI 生成兩條路線
6. **替代方案** — 額外提供 2 個不同切入角度

**廣告故事六大原則**：
1. 3 秒定生死（開場不能用 logo）
2. 痛點要具體
3. 產品是配角
4. 一支廣告一個訊息
5. 結尾要有行動
6. 情緒比資訊重要

**平台差異化**：IG Reels / TikTok（9:16 直式）、YouTube（16:9）、Facebook（1:1 或 4:5）

**強項**：可串聯 universal-video-prompt 把分鏡轉成 AI 影片 prompt

---

## 進階用法：串聯工作流

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 廣告產線</p>
<div class="text-sm text-gray-300">

三個 Skill 可順序連動：

```
廣告故事設計 (ad-story-designer)
        ↓ 產出企劃 + 分鏡
影片提示詞 (universal-video-prompt)
        ↓ 轉成分鏡語言
圖片提示詞 (universal-image-prompt)
        ↓ 產出 keyframe 圖片提示
完成 production-ready 素材
```

Claude 會根據指令自動切換適用的 Skill，不用手動指定。

</div>
</div>


---

## 常見問答

- ❌ **免費版無法使用** — 需付費方案（Pro / Team）
- ✅ **手機和電腦均可** — 安裝後全局生效
- ✅ **Skill 是增強而非取代** Claude 的能力
- ✅ **檔案可手動編輯** 自定義內容（.md 格式）

---

## 對你的價值評估

<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">📝 是否值得安裝？</p>
<div class="text-sm text-gray-300">

取決於你要不要做：
- **行銷廣告／影音內容** → ⭐⭐⭐ 強烈建議
- **自媒體 / IG / 短影片** → ⭐⭐⭐ 強烈建議
- **純文字工作 / 知識整理** → ⭐ 用不太到
- **個人股票研究 / 開發** → ⭐ 不相關

</div>
</div>


你目前主要工作流程是 Claude Code + Telegram（重度自動化＋知識庫），這 3 個 Skill 屬於 Claude.ai 創意路線，**跟現有工作流不衝突但也不互補**。

<div class="not-prose my-6 bg-green-500/10 border-l-4 border-green-500 rounded-r-lg p-4">
<p class="font-bold text-green-400 mb-2">💡 折衷方案</p>
<div class="text-sm text-gray-300">

如果你想試但不想付 Claude Pro，可以：
1. 把這 3 個 .md 檔案的內容讀進來
2. 改寫成 Claude Code 的 SKILL.md 格式
3. 放到 `~/.claude/skills/` 變成本機可用的版本
4. 透過 Telegram 跟我說「用 universal-image-prompt 幫我寫一段 Midjourney prompt」即可呼叫

</div>
</div>


---

## 與既有工具的關係

- Obsidian_Claude_Code_第二大腦_Claudian — 我們已裝的 5 個 Obsidian Skills
- Claude_Cowork_整合工作流_對應現況 — Claude.ai vs Claude Code 差異

---

## 後續行動

<div class="not-prose my-6 bg-purple-500/10 border-l-4 border-purple-500 rounded-r-lg p-4">
<p class="font-bold text-purple-400 mb-2">☑️ Todo</p>
<div class="text-sm text-gray-300">

- [ ] 評估是否需要這 3 個 Skill（依目前工作重心）
- [ ] 如果要安裝：先找到 .md 檔案下載點（聯繫威森或在他的網站找）
- [ ] 替代方案：把核心提示詞模板化後納入 Claude Code 的 skills

</div>
</div>

