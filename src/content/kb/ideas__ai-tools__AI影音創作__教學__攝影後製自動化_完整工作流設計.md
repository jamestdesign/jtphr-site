---
title: 攝影後製自動化 — 完整工作流設計（500 張一次處理）
date: 2026-05-04
來源: Ideas 群討論整理
連結:
tags:
  - AI工具
  - 攝影
  - Lightroom
  - 自動化
  - 修圖
  - Evoto
  - 工作流
aliases:
  - 攝影批次修圖
  - AI 修圖工作流
category: AI影音-教學
---

# 攝影後製自動化 — 完整工作流設計

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 核心</p>
<div class="text-sm text-gray-300">

每趟旅行 300-500 張照片（手機 + 相機混合，含影片），透過 AI 自動化處理到 70-80 分的初修品質。分場景 → 分類 → 評分 → 調色 → 匯出，全流程半自動。

</div>
</div>


---

## 📐 完整流程（六步驟）

### ⓪ AI 初篩（刪除廢片）
- 自動刪除模糊/曝光失敗的照片
- 500 張 → 約 350 張
- 工具：Lightroom 內建 Assisted Culling 或 FilterPixel

### ① 分場景（按地點/時間）

**時差校正（重要！）**
- 相機出國常沒調時區 → 手機和相機時間不同
- 解法：找同場景的手機+相機照片 → 比對時間差 → exiftool 一次校正整批
- `exiftool -AllDates+=1 *.DNG`（加一小時）

**三合一分場景：**
1. 時間斷點（>30 分鐘沒拍 = 換場景）
2. GPS 定位地標（有 GPS 的照片，包含手機照片）
3. Claude Vision 看縮圖確認/修正

**資料夾結構：**
```
2026-05-01 熊本一日遊/
  ├── 1030 熊本城/
  ├── 1230 午餐拉麵/
  ├── 1400 水前寺公園/
  ├── 1700 商店街/
  └── 2200 居酒屋/
```

### ② 分類（主題辨識）

| 類別 | 判斷依據 |
|------|---------|
| 人像-帶景 | 人物 + 明顯背景 |
| 人像-特寫 | 人物佔畫面 50%+ |
| 風景 | 大面積天空/山/海/城市 |
| 食物 | 桌面/餐盤/飲料 |
| 建築物 | 建築主體/室內空間 |
| 藝術品 | 雕塑/畫作/裝置 |

工具：Excire Search 2026（$199 買斷，LR Classic 外掛，完全本機）

### ③ 五星評分 + P 旗（Pick Flag）

AI 依構圖、對焦、曝光、表情自動評 1-5 星

**P 旗規則：**
- ⭐⭐⭐⭐⭐ 五星 → 自動 P
- ⭐⭐⭐⭐ 四星 → 自動 P
- ⭐⭐⭐ 以下 → 不 P
- **場景保底**：如果某場景沒有 4-5 星 → AI 挑最佳一張 P（確保每個場景都有回憶）

工具：FilterPixel（免費 4 專案）或 Lightroom 內建 Assisted Culling

### ④ 調色（分類套 Preset）

**非人像（Lightroom Preset）：**
| 類別 | 風格參數 |
|------|---------|
| 🏔 風景 | 飽和度+30~40、鮮豔度+20、清晰度+15、水平校正、色溫偏暖 |
| 🍜 食物 | 飽和度+20、色溫偏暖+15、清晰度+10、陰影提亮+20 |
| 🏛 建築物 | 清晰度+25、對比+15、垂直校正、去霧+10 |
| 🎨 藝術品 | 最小修改、白平衡校正、曝光微調 |

**人像（Evoto Preset）：**
| 類別 | 風格參數 |
|------|---------|
| 👩 人像-帶景 | 中性日系、飽和度-5~0、清晰度-15、膚色平滑+30、暗角+10 |
| 👤 人像-特寫 | 強柔化、清晰度-25、眼睛銳化+30、膚色 HSL 微調、去瑕疵 |

### ⑤ 影片處理

影片和照片在 ① 分場景時一起歸類，照片優先處理：

1. **AI 自動截圖**：每段影片用 ffmpeg + Claude Vision 截出最佳畫面
2. 截圖參與評分和 P 旗（某場景只有影片時，截圖就是回憶代表）
3. **影片剪輯放最後**：照片全部搞定 → 再回來用 FCPX + SpliceKit 剪影片

```
場景資料夾/
  ├── 📸 photos/     ← 照片（已修完）
  ├── 🎬 videos/     ← 原始影片
  └── 📷 stills/     ← AI 截圖
```

### ⑥ 精修 + 發布（下階段規劃）
- Claude + Adobe Connector 做最後調整
- 發布到 JTpHR 網站 / IG / 500px
- 待討論

---

## 🛠 工具清單與成本

### 已有（不需額外費用）
| 工具 | 用途 |
|------|------|
| Adobe 攝影方案（LR + PS）| 核心修圖 |
| exiftool | EXIF/GPS 讀取、時差校正 |
| FCPX + SpliceKit | 影片剪輯 |
| Claude Code + Vision | AI 分類/截圖/場景辨識 |
| ffmpeg | 影片截圖 |

### 需要新增
| 工具 | 用途 | 費用 | 類型 |
|------|------|------|------|
| **Excire Search 2026** | AI 分類+搜尋+關鍵字 | **$199 買斷** | 一次性 ✅ |
| **Evoto AI** | 人像修圖 Preset 批次套用 | $0.07~0.14/張（按張計費） | 按量 |
| **FilterPixel** | AI 篩選五星評分 | 免費 4 專案，之後 $14.99/月 | 免費起步 |
| **Claude Desktop App** | Adobe Connector 整合 | 免費（含在 Claude Pro） | 免費 ✅ |
| **Automaat/lightroom-mcp** | Claude 操控 LR Classic | 免費開源 | 免費 ✅ |

### 替代方案評估
| 需求 | 首選（推薦） | 替代方案 |
|------|-------------|---------|
| AI 分類 | Excire $199 買斷 | LrTag（免費但功能較少） |
| AI 篩選 | FilterPixel 免費起步 | LR 內建 Assisted Culling（免費） |
| 人像修圖 | Evoto 按張計費 | LR 內建 + Claude Adobe（免費但效果差些） |
| 批次調色 | LR Preset（免費） | Imagen AI $0.05/張（學你風格） |

### 總成本估算
- **一次性**：Excire $199（約 NT$6,400）
- **每趟旅行**：Evoto 約 $15-35（100-250 張人像 × $0.07-0.14）
- **其他**：全免費或已有

---

## 📝 後續行動

<div class="not-prose my-6 bg-purple-500/10 border-l-4 border-purple-500 rounded-r-lg p-4">
<p class="font-bold text-purple-400 mb-2">☑️ Todo</p>
<div class="text-sm text-gray-300">

- [ ] 安裝 Claude Desktop App + Adobe Connector
- [ ] 購買 Excire Search 2026（$199 買斷）
- [ ] 註冊 Evoto AI 帳號
- [ ] 註冊 FilterPixel 帳號（免費 4 專案）
- [ ] 安裝 Automaat/lightroom-mcp（Claude 操控 LR）
- [ ] 在 LR 建立 4 組非人像 Preset（風景/食物/建築/藝術品）
- [ ] 在 Evoto 建立 2 組人像 Preset（帶景/特寫）
- [ ] 用一趟旅行照片跑完整流程測試
- [ ] 下階段：討論精修、發布、上傳評論流程

</div>
</div>


---

## 🔗 相關筆記

- Claude_Adobe_整合教學_aiposthub — Claude × Adobe 官方整合
- 個人攝影自動化流水線_4種場景設計 — 4 種場景流水線設計
- DaVinci_Resolve_21_AI功能_MCP自動化分析 — 影片後製方案
- 攝影基本功_鏡頭運鏡完整指南 — 鏡頭語言參考
