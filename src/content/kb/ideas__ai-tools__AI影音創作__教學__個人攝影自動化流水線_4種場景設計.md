---
title: 個人攝影自動化流水線 — 4 種生活影片場景設計
date: 2026-04-12
來源: 用戶於 Telegram Ideas 群描述需求
連結:
tags:
  - AI工具
  - AI影音
  - 教學
  - 個人攝影
  - 生活紀錄
  - 自動化
  - CapCut
  - FCPX
  - 工作流設計
aliases:
  - 個人攝影流水線
  - 4 種影片設計
  - 生活影片自動化
category: "AI影音-教學"
---

# 個人攝影自動化流水線 — 4 種生活影片場景設計

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 用戶情境</p>
<div class="text-sm text-gray-300">

- 攝影是**休閒娛樂**，不做專業節目
- 主要工具：**手機攝錄**（素材零碎且量大）
- 已有：**CapCut + Final Cut Pro X**
- 平台：Mac
- 目標：IG 分享、生活記憶、旅遊回憶
- 痛點：零碎素材太多、需要整理分類

這份文件設計 4 條流水線對應 4 種典型生活影片場景。

</div>
</div>


---

## 🎯 4 種典型場景

| # | 類型 | 長度 | 風格 | 頻率 |
|---|------|------|------|------|
| 1 | **實境秀生活紀錄** | 1-3 分鐘 | 真實、極簡剪輯、時序排列 | 每日 / 每週 |
| 2 | **MTV 濃縮分享** | 30-90 秒 | 音樂驅動、緊湊剪接、情緒化 | 單一事件 / 假日 |
| 3 | **一段期間的回憶** | 3-10 分鐘 | 時序敘事、月/季剪輯 | 月底 / 季末 |
| 4 | **旅行精選** | 3-5 分鐘 | 地點導向、有節奏、有 BGM | 每趟旅行 |

---

## 🏗 共用基礎設施（4 種場景都會用到）

### 1. 素材來源管理

```
iPhone 拍攝
   ↓ iCloud Photos 自動同步
Mac 的 Photos.app
   ↓ AppleScript / Shortcuts 匯出
~/Movies/Raw Footage/<日期>/
```

### 2. Metadata 萃取（關鍵 ⭐）

每個影片片段都有：
- **拍攝時間**（datetime）
- **GPS 位置**（lat/lng）
- **時長**（duration）
- **解析度 / 規格**（4K / 1080p / slow-mo）
- **可能的人臉**（Photos.app 已分析）

Claude 利用這些 metadata **自動分組與排序**，這是你目前手動最痛苦的部分。

### 3. 工具堆疊

| 任務 | 工具 |
|------|------|
| 同步 + 匯出 | iCloud Photos + Apple Shortcuts |
| metadata 分析 | exiftool（CLI）|
| 場景分組 | Claude Code（自然語言處理）|
| 短影片自動剪 | **CapCut + mrbuslov MCP** |
| 長/精緻剪輯 | **FCPX + SpliceKit MCP** |
| 字卡 / 圖文 | **ig-card-generator skill**（你已裝）|
| 配樂 | Apple Music / YouTube Audio Library / Suno |

### 4. 安裝清單（一次裝完）

```bash
# 1. exiftool（讀 metadata）
brew install exiftool

# 2. CapCut + mrbuslov MCP
git clone https://github.com/mrbuslov/capcut-ai-editor.git
cd capcut-ai-editor && npm install && npm run build
# 註冊到 ~/.claude/settings.json

# 3. FCPX + SpliceKit
# 從 https://splicekit.fcp.cafe/ 下載
# 安裝後在 Claude Code MCP 註冊

# 4. ig-card-generator skill（已裝 ✅）

# 5. Photos.app 匯出腳本（自己寫）
```

跟我說「**幫我裝個人攝影流水線**」我會跑完整安裝。

---

## 📹 場景 1：實境秀生活紀錄

> **目標**：每天 / 每週把零碎手機影片變成 1-3 分鐘的真實生活集錦。

### 適合的人

- 想記錄日常、不要過度美化
- 每天拍很多但懶得整理
- 想要「日記式」影片

### 流水線設計

```
Step 1: 自動匯入（每天晚上跑）
   iPhone → iCloud → Mac Photos.app
        ↓
Step 2: Claude 分析 metadata
   讀取今天 / 本週新增的影片
   按時間排序
   讀取地點、時長
        ↓
Step 3: 自動分組
   同一地點的連續片段 = 一個 scene
   例：早上家裡 → 通勤 → 公司 → 午餐 → ...
        ↓
Step 4: CapCut MCP 處理每個 scene
   - mrbuslov：移除靜音段、去重複 take
   - 自動生成字幕（CapCut 內建）
   - 套用 LUT（你預設的色調）
        ↓
Step 5: 串聯成 1-3 分鐘
   每個 scene 取 5-10 秒
   按時間軸排列
   加入時間戳字卡（"早上 8:30 通勤"）
        ↓
Step 6: 配音樂
   選 calming / lo-fi 背景音樂
        ↓
Step 7: 匯出
   IG Reels 9:16 規格
   存到 ~/Movies/Daily Logs/<日期>.mp4
        ↓
Step 8: 推送通知
   Telegram bot 通知「今日剪好了，要看嗎？」
```

### 觸發指令範例

> 「幫我整理今天的影片，做一個 90 秒的日常生活集錦，淡淡的 lo-fi 風格」

→ Claude 自動跑 step 2-7，最後問你要不要發 IG。

### 排程化

可以用 macOS launchd（跟之前的 daily-session-insight 一樣的機制）：
- 每天晚上 11 點自動跑
- 早上起床看到當日剪好的版本
- 不喜歡的話跟 Claude 說「重剪，這次更慢一點」

---

## 🎵 場景 2：MTV 濃縮分享

> **目標**：把單一事件（一頓飯、一個展覽、一個聚會）的素材濃縮成 30-90 秒的音樂感影片。

### 適合的人

- 想把美好時刻精緻化分享
- 喜歡情緒化、節奏感的影片
- 想做 IG Reels / TikTok 爆款風

### 流水線設計

```
Step 1: 你選定主題
   跟 Claude 說：「上週六的生日聚會，做成 60 秒 MTV」
        ↓
Step 2: Claude 篩選素材
   時間範圍：上週六
   讀取所有 GPS 在同地點的片段
        ↓
Step 3: 你選歌
   或讓 Claude 推薦（依氛圍：「歡樂、80s、女聲」）
        ↓
Step 4: FCPX + SpliceKit 處理
   - 偵測歌曲節拍（beat detection）
   - 自動把片段切成跟節拍同步的長度
   - 好的精彩瞬間放在 chorus
   - 套用一致的色調 LUT
        ↓
Step 5: 加入轉場
   - 卡點剪接（hard cut on beat）
   - 偶爾加 whip pan / 漸變
        ↓
Step 6: 加字卡
   開頭：「2026.04.06 — 生日聚會」
   結尾：「Happy Birthday」
        ↓
Step 7: 匯出
   9:16 IG Reels 60 秒
        ↓
Step 8: 推送
   Telegram 通知 + 直接傳檔給你
```

### 為什麼用 FCPX 不用 CapCut

- **節拍偵測**：FCPX 的音頻分析比 CapCut 強
- **色彩一致性**：FCPX 的 LUT + Color Wheels 比 CapCut 細緻
- **多軌音樂**：MTV 需要 BGM + 同期音的混合
- **匯出品質**：FCPX 預設色彩管理優

### 觸發指令範例

> 「上週六的生日聚會做成 60 秒 MTV，用 [歌名]，淡藍青橙色調」

→ Claude 透過 SpliceKit MCP 操控 FCPX 自動完成

---

## 📅 場景 3：一段期間的回憶

> **目標**：把一個月 / 一季 / 一年的生活濃縮成 3-10 分鐘有敘事的回憶影片。

### 適合的人

- 月底 / 季末做總結
- 想要長一點、有故事感的回憶
- 像「2026 年我的 4 月」這種

### 流水線設計

```
Step 1: 你定範圍
   「2026 年 4 月所有素材，做成 5 分鐘月度回憶」
        ↓
Step 2: Claude 全月掃描
   讀取整月所有 .mov / .mp4
   按日期分組
   依事件聚類（用 GPS + 時間 cluster）
        ↓
Step 3: Claude 寫敘事大綱
   - 第一週：開頭主題
   - 第二週：發展
   - 第三週：高潮
   - 第四週：總結
   你確認 / 修改大綱
        ↓
Step 4: FCPX + SpliceKit 製作
   - 每個事件取 10-30 秒
   - 加入日期字卡（"2026.04.01"）
   - 加入地點字卡（"台北 大安森林公園"）
   - 配 BGM（淡淡敘事感、純樂器）
        ↓
Step 5: 章節結構
   - 開頭蒙太奇（30 秒）
   - 4 個週的章節
   - 結尾總結（30 秒）
        ↓
Step 6: 匯出
   16:9 horizontal 給 YouTube / 1:1 給 IG
   3-10 分鐘
        ↓
Step 7: 存檔到時光膠囊
   ~/Movies/Memories/2026/04-April.mp4
   也存一份到 Obsidian 筆記附件
```

### 觸發指令範例

> 「幫我做 2026 年 4 月的月度回憶，5 分鐘，敘事感、純樂器 BGM」

### 自動化建議

- **每月 1 號** 自動跑（launchd 排程）
- 跑完上個月的剪輯
- Telegram 通知你看
- 你滿意就發 / 不滿意就重剪

---

## ✈️ 場景 4：旅行精選

> **目標**：每趟旅行回來後快速產出 3-5 分鐘精選影片。

### 適合的人

- 常旅行
- 不想花一週剪片
- 要在朋友圈 / IG 第一時間發

### 流水線設計

```
Step 1: 旅行前 — 標記
   建立「2026/04 京都」相簿
   旅行中拍的東西自動入這個相簿（手動 or 用 Smart Album by GPS）
        ↓
Step 2: 旅行中 — 即時整理（可選）
   每天晚上 Claude 跑場景 1 的「日常集錦」
   產出當日 90 秒短片（每天有得發 IG Stories）
        ↓
Step 3: 旅行結束 — 大合集
   跟 Claude 說：「京都旅行做成 5 分鐘精選」
        ↓
Step 4: Claude 結構化
   - 開頭：飛機 / 抵達
   - 第 1 天：清水寺
   - 第 2 天：嵐山
   - 第 3 天：祇園
   - 結尾：離開 / 回家
        ↓
Step 5: 智慧選片
   每個地點選 3-5 個最美的瞬間
   優先選「人物 + 風景」「動作 + 反應」「特寫 + 全景」對比
        ↓
Step 6: FCPX 加入旅行模板
   - 開頭地圖動畫 / 機票
   - 各地點字卡（中英日三語）
   - 結尾「Until next time, 京都」
   - BGM（日式或抒情）
        ↓
Step 7: 兩個版本
   - 5 分鐘 horizontal（YouTube / 朋友分享）
   - 60 秒 vertical（IG Reels 精華）
        ↓
Step 8: 存到回憶資料庫
   ~/Movies/Travel/2026-04-京都/
        ├── full-5min.mp4
        ├── reels-60s.mp4
        └── source-album.zip
```

### 觸發指令範例

> 「京都旅行做成 5 分鐘精選 + 60 秒 IG Reels 版本，日式 BGM，每個地點開頭加字卡」

### 旅行前準備

可以做一個「旅行模板 skill」：
- `~/.claude/skills/travel-recap/SKILL.md`
- 內含旅行影片的固定格式
- 每次旅行回來只要說「用 travel-recap 處理 [城市]」

跟我說「**幫我做 travel-recap skill**」我可以直接寫好。

---

## 🎯 4 種場景的工具選擇對照表

| 場景 | 主要工具 | MCP | 為什麼 |
|------|---------|-----|--------|
| 實境秀生活紀錄 | **CapCut** | mrbuslov | 行動端友善、字幕內建強、輕量快速 |
| MTV 濃縮分享 | **FCPX** | SpliceKit | 節拍偵測強、色彩管理優 |
| 一段期間回憶 | **FCPX** | SpliceKit | 長片必備、章節結構 |
| 旅行精選 | **FCPX**（主）+ CapCut（IG 版）| 兩者並用 | 桌面長版 + 手機短版 |

→ 你已經有 CapCut + FCPX，**完美對應**所有 4 種場景。

---

## 🚀 推薦的安裝順序

### 階段 1：基礎建設（1 小時）
1. 安裝 exiftool：`brew install exiftool`
2. 確認 iCloud Photos 同步正常
3. 在 ~/Movies/ 建立目錄結構：
   ```
   ~/Movies/
   ├── Raw Footage/        # 原始素材
   ├── Daily Logs/          # 場景 1 輸出
   ├── MTV Highlights/      # 場景 2 輸出
   ├── Memories/            # 場景 3 輸出
   └── Travel/              # 場景 4 輸出
   ```

### 階段 2：CapCut 自動化（試水溫，30 分鐘）
1. 裝 mrbuslov/capcut-ai-editor
2. 試跑：「幫我用今天的素材做一個 60 秒日常」
3. 看效果是否符合預期

### 階段 3：FCPX 進階（90 分鐘）
1. 裝 SpliceKit（從 fcp.cafe）
2. 試跑：「上週的素材做成 90 秒 MTV」
3. 看 SpliceKit 的節拍偵測效果

### 階段 4：自定義 skills（看需求）
- `daily-life-log` skill — 場景 1 專用
- `mtv-highlight` skill — 場景 2 專用
- `monthly-memory` skill — 場景 3 專用
- `travel-recap` skill — 場景 4 專用

---

## 💡 你會問的問題

### Q1: 我要先做哪個場景？
**A**: 從**場景 1（實境秀生活紀錄）**開始。
- 門檻最低、頻率最高
- 累積失敗經驗最快
- CapCut + mrbuslov 是最簡單的起點

### Q2: 旅行的時候要拍什麼？
**A**: 別管太多，**多拍**。AI 會幫你篩選。原則：
- 同一個景點拍 2-3 個角度（廣角 + 特寫）
- 「動」的東西比「靜」的好（人在走、車在動、煙在飄）
- 對話 / 笑聲也要錄
- 拍前 30 秒空鏡（過場好用）

### Q3: 配樂版權怎麼處理？
**A**: 三種免費來源：
1. **YouTube Audio Library**（YouTube 內建，完全免費 + 商用）
2. **Pixabay Music**（免費 + 商用）
3. **Apple Music for Artists**（選有商業授權的）
- 不要用 Spotify 抓的音樂發 IG（會被靜音）

### Q4: 多久剪一次？
**A**: 建議節奏：
- 場景 1：**每天**（自動排程）
- 場景 2：**有事件時手動觸發**
- 場景 3：**每月 1 號自動跑**
- 場景 4：**每趟旅行回來當週**

### Q5: 失敗 / 不滿意怎麼辦？
**A**: 直接跟 Claude 說：
- 「太快了，每段拉長 50%」
- 「換一個 BGM，要更安靜」
- 「移除前 30 秒的通勤畫面」
- Claude 會重跑那一段，不是全部重做。

---

## 🎬 終極願景

當這 4 條流水線都跑順之後，你的生活影片產出會變成：

```
每天晚上 11 PM
├── 日常生活集錦自動產出（場景 1）
├── 通知 → 你看 → 滿意就發 IG Stories
│
週末 / 有事件
├── 你說「上週六做 MTV」
├── Claude 跑場景 2
├── 你看 → 發 IG Reels
│
每月 1 號
├── 上月回憶自動產出（場景 3）
├── 通知 → 你看 → 存到雲端 / 分享朋友
│
旅行回家當週
└── 你說「京都做精選」
    └── Claude 跑場景 4
        └── 5 分鐘 + 60 秒兩版本
```

→ 你只負責**拍**和**選**，剩下都是 AI。

---

## 📝 後續行動

<div class="not-prose my-6 bg-purple-500/10 border-l-4 border-purple-500 rounded-r-lg p-4">
<p class="font-bold text-purple-400 mb-2">☑️ 立即可做</p>
<div class="text-sm text-gray-300">

- [ ] 跟我說「**幫我裝個人攝影流水線**」→ 我跑階段 1+2 的安裝
- [ ] 安裝後試跑第一支日常生活集錦
- [ ] 評估效果決定要不要做場景 2-4

</div>
</div>


<div class="not-prose my-6 bg-purple-500/10 border-l-4 border-purple-500 rounded-r-lg p-4">
<p class="font-bold text-purple-400 mb-2">☑️ 中期 (1 週內)</p>
<div class="text-sm text-gray-300">

- [ ] 試 SpliceKit + FCPX
- [ ] 跑一支 MTV 試試
- [ ] 決定是否做自動排程（launchd 每天 11 PM）

</div>
</div>


<div class="not-prose my-6 bg-purple-500/10 border-l-4 border-purple-500 rounded-r-lg p-4">
<p class="font-bold text-purple-400 mb-2">☑️ 長期</p>
<div class="text-sm text-gray-300">

- [ ] 為每種場景寫專用 skill
- [ ] 建立旅行模板資料庫
- [ ] 整合 ig-card-generator 做文字片段（介紹卡 / 結尾卡）

</div>
</div>


---

## 🔗 相關筆記

- Claude_自動剪輯_Premiere_MCP_完整整理 — 三大平台 MCP 完整對比
- AIBunny_Claude_HTML_IG輪播圖文工作流 — 字卡產生（場景 4 旅行模板會用）
- Google_Veo3_完整使用指南 — 如果想加入 AI 生成過場
- 威森_免費AI模特代言_3步驟教學 — 圖生模特技巧
- AI影音創作 INDEX
