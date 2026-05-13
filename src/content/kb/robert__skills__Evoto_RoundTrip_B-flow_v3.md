---
title: Evoto Round-Trip B-flow v3
date: 2026-05-12
creator: robert
co_creators: []
tags:
  - 攝影
  - 修圖
  - Evoto
  - workflow
  - skill
aliases:
  - Evoto round-trip
  - Evoto B-flow v3
  - 質感肌工作流
來源: photo-grade KB v1 (2026-05-08~2026-05-12) + 2026-05-10_evoto_roundtrip_kb.md
連結: _attachments/photo_grade_kb_2026-05-11.html
version: 1
category: "其他"
---

# Evoto Round-Trip B-flow v3

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 一句話定義</p>
<div class="text-sm text-gray-300">

把 LR 評過分的 Red 軸照片送進 Evoto 套質感肌精修 → JPG 直接落到 `_export/<scene>/`(出片軌)的完整工作流。**v3 的關鍵差異**:LR 端要做完所有 RAW 處理(含鏡頭校正 / Upright / AI Remove)再 export TIFF;Evoto 修完不再回 `<scene>/Evotofu/` 而是直接到 `_export/`。

</div>
</div>


## 適用情境

- Red 軸照片(人臉清楚可辨)走完評分 + Pick 後送 Evoto AI 質感肌精修
- 整批旅遊照片(數十到上百張)的 production-grade 修圖
- 多 trip 累積的人像 backlog 一次清(門司港 130 張 Red+Pick 是首批實證)
- 需要把編輯版獨立於原檔保存、可隨時溯源回 ARW

<div class="not-prose my-6 bg-yellow-500/10 border-l-4 border-yellow-500 rounded-r-lg p-4">
<p class="font-bold text-yellow-400 mb-2">⚠️ v3 之前踩過的雷</p>
<div class="text-sm text-gray-300">

- v1 讓 Evoto 讀 `.lrcat` → AI Remove 跑回來、Upright 沒套 → **必須 TIFF 燒錄路線**
- v2 把 JPG 回 `<scene>/Evotofu/` → 雙重 catalog 註冊麻煩 → **v3 直接到 `_export/<scene>/`**
- 抄 ARW orientation flag → JPG 反向旋轉 → **永遠讀 JPG 實際 dims 設 "AB"**

</div>
</div>


---

## v3 SOP(2026-05-10 最終版)

```
LR:
  1. 評分 + 色標 + Pick(Red + P)
  2. 完整 RAW 處理(全部燒進 pixel):
     - 曝光 / 對比 / HSL / 色彩分級 / 白平衡
     - 鏡頭校正 + Upright + AI Remove ← 必須做完才送
  3. Export TIFF → /<trip>/to_evoto/(flat)
     • Format: TIFF 16-bit, ProPhoto RGB, no compression
     • Preset: to_Evoto.lrtemplate(已寫好)
     • collisionHandling = "rename"(重 export 同檔名加 -2)
  4. 關閉 LR

Evoto:
  5. 拖 to_evoto/ 整個 folder 進 Evoto
  6. 套 推薦 → 質感肌01 → Sync 全部
  7. ⚠️ 匯出前確認 panel = 精修 / 臉部
  8. 匯出 JPG Larger Print A3 → to_evoto/Evotofu/(flat)

Python(一條龍):
  9. python 2026-05-10_evoto_to_export.py
     ├─ Step 1: 解析 -2 重複(保留新版)
     ├─ Step 2: 每張 JPG 對 catalog 找 ARW scene
     ├─ Step 3: 移動 JPG → _export/<scene_top>/(flat, stills 折平)
     ├─ Step 4: 註冊 JPG 到 catalog(9 張表 + folder _export/<scene>/)
     │  • Pick=0(保留作未來篩選)、色標 / 星等 / EXIF 繼承自 ARW
     │  • orientation="AB"、dims 讀實際 JPG(不抄 ARW)
     ├─ Step 5: ARW Pick=1 維持(不轉移)
     └─ Step 6: 清掉 to_evoto/ 整個資料夾

LR:
  10. 開啟 → Folder Tree 多了 `_export/<scene>/` 層
  11. 出片直接從 _export/ 拿,雲端三軌備份
```

---

## 子資料夾命名約定

<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">ℹ️ 多編輯器並存設計</p>
<div class="text-sm text-gray-300">

同一張 ARW 可同時有 `Evotofu/` / `psd/` / `luminar/` 等子版本。子資料夾名是每個編輯器的「身份證」。

</div>
</div>


| 編輯器 | 子資料夾名 |
|---|---|
| **Evoto** | `Evotofu/`(**注意大小寫,是 Evoto 預設名,不是 evoto**)|
| Photoshop | `psd/` |
| Luminar Neo | `luminar/` |
| Capture One | `c1/` |
| Photomator | `photomator/` |
| LR Develop preset only | 不開子資料夾,直接改 ARW 的 develop_settings |

**v3 不用子資料夾的場合**:Evoto JPG 直接到 `_export/<scene>/`(出片軌),不再走 `<scene>/Evotofu/` 中繼層。

---

## 四大踩坑紀錄

### 🚧 坑 1 — Evoto 不接 LR AI Remove(2026-05-10 實測)

LR 的「AI 移除干擾物」(Generative Remove)是生成式像素貼補,存在 catalog 的 generative cache。**Evoto 讀 `.lrcat` 不會還原**。

**影響**:在 LR 用 AI Remove 消掉的東西,到 Evoto 那邊會跑回來。Evotofu/JPG 不含這些移除。

**v3 對策(順序對調)**:
1. LR 做純參數調整:曝光 / 對比 / HSL / 色彩分級 / 白平衡
2. **不在 LR 做 AI Remove**
3. Export TIFF(把上述全部燒進 pixel)
4. Evoto 套質感肌
5. 回 JPG 後在 LR 對 JPG 做 AI Remove(8-bit 上做、畫質略低但流程乾淨)

### 🚧 坑 2 — Orientation 反向(2026-05-10 修補)

**症狀**:某些 Evotofu JPG 在 LR 顯示轉了 90°(橫拍變直拍或反之)。

**根因**:
1. ARW pixel data 是 sensor 原生(橫向),EXIF Orientation 標記告訴 LR 要轉
2. LR catalog `Adobe_images.orientation` 用 2 字母代碼:
   - `AB` = 不旋轉
   - `BC` = 90° CW
   - `CD` = 180°
   - `DA` = 90° CCW
3. Evoto 匯出時**已經把 pixel data 轉正**,並把 EXIF Orientation 設為 1 (normal)
4. sync script 把 ARW 的 orientation flag(DA/BC)複製給 JPG → LR 對已轉正的畫素再轉一次 → 反向

**v3 修法**(已套用):
- 讀 JPG 實際 `pixelWidth/pixelHeight`(用 `sips` 或 PIL)
- `Adobe_images.orientation = 'AB'`
- `fileWidth = 實際寬, fileHeight = 實際高`(**不要按 ARW 的順序填**)
- `aspectRatioCache = max(w,h) / min(w,h)`
- `Adobe_imageDevelopSettings.text` 裡的 `orientation = "AB"`

### 🚧 坑 3 — Evoto 匯出 panel 必須在「精修 / 臉部」

**症狀**:Sync 質感肌後匯出,但 AI 修改沒套用,看起來跟原 TIFF 一樣。

**根因**:Evoto 匯出時讀的是「當前 active panel」的設定。Sync 完之後若 panel 切到「色彩」或「銳化」,匯出就不會帶上臉部 AI。

**v3 SOP**:按匯出前先確認 **active panel = 精修 / 臉部**(畫面右側 panel 切換器)。

### 🚧 坑 4 — Smart Preview 大小不堪用

**症狀**:第一次匯出全 2540px(Smart Preview 限制),整批不堪用於 A3 列印或 4K 螢幕。

**v3 修法**:
- 匯出格式:**JPG (Larger Print A3)** 或 100%
- 解析度:6336×9504(Sony A7R V 直拍實際)
- ❌ 不要用 Smart Preview 大小(2540px)
- ❌ 不要用 TIFF(後處理麻煩,且 LR 重複堆疊複雜)

---

## LR Catalog SQL — 註冊一張新影像必須寫的 9 張表

```
1. AgLibraryFile             — 檔案物理位置(folder + baseName + extension)
2. Adobe_images              — 主表(orientation, fileWidth, fileHeight, pick, rating, colorLabels)
3. Adobe_imageDevelopSettings — 沖洗參數 Lua(text 欄)
4. Adobe_imageProperties     — 預設裁切等屬性
5. Adobe_AdditionalMetadata  — XMP / metadata 旗標
6. AgLibraryIPTC             — IPTC 寫入 stub(必須有 row 否則 LR 不認)
7. AgHarvestedExifMetadata   — 拍攝參數(從 ARW 複製)
8. AgLibraryImageAttributes / AgLibraryImageChangeCounter / AgMetadataSearchIndex /
   AgSourceColorProfileConstants / AgLibraryImportImage / AgHarvestedIptcMetadata
9. Adobe_libraryImageDevelopHistoryStep(在原檔加一筆 "Pick transferred to evoto/")
```

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 cache pointers 不能漏</p>
<div class="text-sm text-gray-300">

寫完後必須 UPDATE:
```sql
UPDATE Adobe_images SET
  developSettingsIDCache = (Adobe_imageDevelopSettings.id_local),
  propertiesCache = (Adobe_imageProperties.id_local)
WHERE id_local = ?
```
**漏掉這步 → 縮圖會顯示,但 Develop 模組打不開**。

</div>
</div>


完整 SQL 安全 SOP 走 LR_Catalog_SQL寫入安全。

---

## Pick / Color / Rating 對照

- `pick`:`1.0` = Picked, `0.0` = Unflagged, `-1.0` = Reject
- `colorLabels`:`'紅色'` / `'黃色'` / `'綠色'` / `'藍色'` / `'紫色'`(**繁中字串**,不是英文)
- `rating`:`0.0`–`5.0`

英文 ↔ 繁中對應與 VLM 評分軸:見 人像評分_4軸法 的「Label 命名雙軌」段。

---

## Smart Collection 通用模板

每趟旅遊一個 SC:
- 名稱:`Red_P_<旅遊名>`(例:`Red_P_門司港`)
- 條件(全部 Match):
  1. 色彩標籤 = 紅色
  2. 旗標狀態 = 已加旗標
  3. 拍攝日期介於 旅遊開始 ~ 結束
  4. (選)資料夾路徑包含 `Evotofu` 或 `_export`(限定編輯器來源)

LR Smart Collection **沒有上限**(但隨資料量增加更新會慢)。

---

## 不需要 LR Stack

新設計下不用 LR Stack:
- 原檔 vs 編輯版用 Pick 旗標分隔(SC 篩 Pick=1 只看編輯版)
- 子資料夾物理分隔
- 同名 basename 直接配對
- LR Stack 透過 SQL 寫入太脆弱(要正確設多張 cache table),維護負擔大

---

## 自我檢查清單(每次新批次前)

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 啟動 Evoto round-trip 前對照</p>
<div class="text-sm text-gray-300">

- [ ] LR Classic 已 `Cmd+Q`(catalog lock 釋出)
- [ ] LR 端 RAW 處理含鏡頭校正 + Upright(AI Remove 留到後面)
- [ ] Export 設定:TIFF 16-bit / ProPhoto RGB / no compression / preset = to_Evoto
- [ ] 縮圖足夠(不用 Smart Preview)
- [ ] Evoto 匯出格式 = JPG Larger Print A3 / 100%
- [ ] Evoto 匯出前確認 active panel = 精修 / 臉部
- [ ] 子資料夾名 = `Evotofu`(大寫 E,Evoto 預設)
- [ ] sync script 跑完看 console:Registered 數 + Pick transferred 數**相等**
- [ ] JPG orientation 永遠讀實際 dims 設 "AB",**不抄 ARW**
- [ ] 開 LR 抽幾張看 orientation + 修圖品質
- [ ] Smart Collection 條件對得上

</div>
</div>


任一沒勾 → 不要按 enter。

---

## 範例 — 門司港 130 張 Red+P(2026-05-10 首批實證)

**輸入**:門司港 671 張 → SKILL 評分 → 130 張 Red+Pick

**執行**:
```
LR  → Export TIFF 130 張 → to_evoto/ flat
Evoto → 套質感肌01 → Sync → 匯出 JPG → to_evoto/Evotofu/ flat
Python → 解析 -2 / 找 scene / 移到 _export/<scene_top>/ / 註冊 catalog(9 張表)
       → ARW Pick=1 保留 / JPG Pick=0(保留作未來篩選)
LR  → 開啟驗證
```

**結果**:
- 130 張全進 _export/、folder tree 多 `_export/<scene>/` 層
- 35 張 orientation 一次性修補(`2026-05-10_fix_evotofu_orientation.py`)
- 質感肌 AI 全套上(panel 確認步驟救了批次)

---

## 對接資料

- LR catalog:`/Volumes/X10 Pro2/115-00-00 Robert 剪輯日常/115-00-00 Robert 剪輯日常.lrcat`
- 輸入根:`/Volumes/X10 Pro2/input/<scene>/`
- 工作腳本:`~/Desktop/Claude-Workspace/photo-grade/`
- Evoto DB:`~/Library/Application Support/Evoto_pro/`
- Excire DB:`~/Library/Application Support/excire-foto/backend.db`

主要 scripts:
- `2026-05-09_evoto_subfolder_sync.py`(舊版,寫 `<scene>/Evotofu/`)
- `2026-05-10_evoto_to_export.py`(v3 主腳本,寫 `_export/<scene>/`)
- `2026-05-10_fix_evotofu_orientation.py`(一次性修補,已套用)

---

## 相關技能

- 人像評分_4軸法 — Red 軸照片走本流程,評分依此 skill
- VLM評分_防幻覺紅線 — Evoto 前的 Red 識別必走 6 條紅線
- LR_Catalog_SQL寫入安全 — sync script 寫 catalog 的 SQL 鐵則
- Backlog_5階段SOP — 評分管線整體上下游
- LR_Catalog_v4_Metadata_Schema — 註冊 JPG 時的 keyword + caption 欄位分工(尚未建立)
- LR_AutoTone_SQL觸發 — 註冊新 JPG 時若要套 AutoTone 的細節

---

## 修訂歷史

- **2026-05-12**:初版。從 `2026-05-10_evoto_roundtrip_kb.md` + photo-grade KB v1 §6 + 門司港 130 張 + 四大坑實證萃取。
