---
title: 影片素材 VLM 抽幀 + 腳本剪輯 SOP
date: 2026-05-16
creator: robert
co_creators:
  - james
tags:
  - 攝影
  - 剪輯
  - 影片
  - VLM
  - workflow
  - 自動化
  - skill
aliases:
  - 影片 pipeline SOP
  - VLM 抽幀剪輯
來源: 2026-05-16 James + Robert 在 1-on-1(msg 1833~1852)共 18 輪討論拍板
連結: _attachments/photo_grade_kb_2026-05-11.html
version: 1
category: "其他"
---

# 影片素材 VLM 抽幀 + 腳本剪輯 SOP

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 一句話定義</p>
<div class="text-sm text-gray-300">

一整套從「整理影片素材」到「出片剪輯版上雲」的 7 步 pipeline。**核心**:VLM 自動抽幀 + 評分(預設,James 沒空時)+ FCP 手動標(精修,James 想細控時)雙軌並行,Pick 後依顏色(紅 = 精彩瞬間 / 黃 = 長篇紀錄)自動分流到 NAS 永久存檔(`_FCPX/`)或雲端壓縮版(`_export/`),最後我以導演視角寫運鏡腳本輸出 HTML,你 review 通過後剪輯。

</div>
</div>


<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">📝 與 FCP_Marker_Workflow 的關係</p>
<div class="text-sm text-gray-300">

本 SOP 涵蓋並擴展 FCP_Marker_Workflow（VLM 抽幀整合 + 雙軌設計 + 四象限分流），為影片端 production source-of-truth。FCP_Marker_Workflow 留作 marker 機制的基礎參考，不廢棄、不重複維護。

</div>
</div>


## 適用情境

- 整批旅遊 / 活動拍完(混合影片 + 照片)的影片端處理
- 影片素材需要「精彩瞬間集錦 MV + 長篇紀錄實境秀」雙輸出
- 你想要影片素材跟照片一樣**有評分系統 + 自動工作流**,不是手動逐段處理
- 對單一場景的多段影片,需要**運鏡 + 剪輯腳本**(不是純直接剪)

<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">ℹ️ 這份 SOP 跟既有 Backlog_5階段SOP 的關係</p>
<div class="text-sm text-gray-300">

Backlog SOP 5 階段是**照片端** workflow。本 SOP 是**影片端**對應,跟照片端共用 LR catalog(STILL 進去評分時融入照片管線)。

</div>
</div>


---

## 🗺️ 整體架構圖

```
[原始素材 NAS]
  _MOV/<scene>/<clip>.MP4         ← 母檔(永久保存)
        └ _STILL/<clip>_t<秒>.jpg ← VLM 抽幀(4K 原寬,LR 評分用)

[去 NG 處理(只對有 NG 段的 clip)]
  _FCPX/<scene>/<clip>_clean.mp4  ← ffmpeg lossless trim 後(原寬)
  _FCPX/<scene>/MANIFEST.md       ← 紀錄哪些 clip 是 trimmed / 哪些用原檔

[剪輯素材(FCP import)]
  FCP 雙資料夾 import:
    _MOV/<scene>/    (沒 NG 的 clip)→ keyword `original`
    _FCPX/<scene>/   (有 NG 切過的)→ keyword `trimmed`

[出片(壓縮上雲)]
  _export/<scene>/photos/      ← LR 精修照片(已 cover by Backlog_5階段SOP)
  _export/<scene>/highlights/  ← 紅 P=1 → 1080p H.265 8Mbps 壓縮版 ☁️
  _export/<scene>/memoirs/     ← 黃 P=1 剪輯完成 → 1080p H.265 8Mbps ☁️
```

**三層儲存對應**:

| 層 | 內容 | 上雲? |
|---|---|---|
| `_MOV/` 原檔 | 全集母檔 | ❌ NAS only |
| `_FCPX/<clean>` | 紅黃 P=1 + 有 NG 切過的 | ❌ NAS only(原寬) |
| `_export/highlights/<cloud>` | 紅 P=1 → 1080p H.265 壓縮版 | ✅ |
| `_export/memoirs/<edited>` | 黃 P=1 剪輯完成版 | ✅ |

---

## 📋 7 步 Pipeline

### Step 1 — 抽幀(VLM 預備)

**輸入**:`_MOV/<scene>/<clip>.MP4`(整批)
**輸出**:`_MOV/<scene>/_STILL/<clip>_t<秒>.jpg` 每秒 1 張

**工具**:ffmpeg

```bash
ffmpeg -i <clip>.MP4 -vf fps=1 -q:v 1 \
  _STILL/<clip>_t%04d.jpg
```

- **`fps=1`** = 每秒 1 幀(可調 `fps=0.5` 太密 / `fps=2` 太疏)
- **`-q:v 1`** = JPG 最高品質
- **解析度**:**抽 4K 原寬**(母檔多大抽多大,好看的可後置 / 印刷 / re-frame)
- **後置生 1080p 縮圖**(VLM 判讀用,節省 token):
  ```bash
  for f in _STILL/*.jpg; do
    sips -Z 1080 "$f" --out "_STILL/preview_$(basename $f)"
  done
  ```
- **EXIF 元資料**:每張 STILL 寫 `source_video=<clip>.MP4` + `timestamp_sec=<秒>` 到 XMP UserComment(VLM 可讀)

### Step 2 — VLM Stage A + Stage B 評分

**走既有 SKILL**(完全複用照片管線):
- 人像評分_4軸法 — 4 軸 Label(紅黃綠紫)
- VLM評分_防幻覺紅線 — 6 條 hard constraint(`objective_description` 必填 / Opus only / 拆兩階段...)

**輸入**:1080p 縮圖 + scene 資訊
**輸出**:每張 STILL 一筆 JSON entry

**JSON schema 加兩欄**:
```json
{
  "filename": "IMG_5680_t0007.jpg",
  "source_video": "IMG_5680.MP4",     // 🆕
  "timestamp_sec": 7.0,                // 🆕
  "objective_description": "...",
  "subject_type": "human_face_clear",
  "label": "Red",
  "rating": 4,
  "pick": true,
  "scene_id": "0830_golf_morning",
  "confidence": 0.92,
  "needs_human_review": false,
  "notes": "..."
}
```

### Step 3 — STILL 進 LR catalog(跟 photo 一起)

走 LR_Catalog_v4_Metadata_Schema 寫入規範:
- 關鍵字承載 `objective_description`(用 `+` 切)
- 註解承載機器 tag + 對話日誌(`|` 數標輪次)
- 評等 / 旗標 / 色標 維持 v3 軸

走 LR_Catalog_SQL寫入安全 SOP:
- LR Cmd+Q
- backup + integrity_check
- /tmp 工作
- UPDATE 必加 WHERE

### Step 4 — James 在 LR review

**Clip 層(影片本身)**:
- LR 內看 clip 影片預覽
- 給**色標**:🔴 紅 = 精彩瞬間 / 🟡 黃 = 長篇紀錄 / 其他維持
- 給 **Pick(P)旗標**:值得處理 = P
- **去 NG 寫 caption**(若有 NG 段):
  ```
  NG: 1:20-1:35, 3:05-3:12
  ```
  或:
  ```
  keep: 0:00-1:19, 1:36-3:04, 3:13-5:00
  ```
  (兩種任一,腳本都讀)

**STILL 層**:
- LR 看抽出來的 STILL 縮圖
- 跟一般照片一樣評分(若 VLM 評錯可改)
- Pick 心儀的 frame

### Step 5 — 自動分流 batch(我跑)

**讀 LR catalog**:
- 每個 clip 的 colorLabel / pick / caption(NG 段)

**四象限分流邏輯**:

```
🔴 color=紅 AND pick=1:
  if has_NG:
    → _FCPX/<scene>/<clip>_clean.mp4 (原寬,NAS)
    → _export/<scene>/highlights/<clip>_cloud.mp4 (1080p H.265 8Mbps,上雲)
  else (整段 OK):
    → _export/<scene>/highlights/<clip>_cloud.mp4 (從 _MOV 壓縮,上雲)
    _MOV/<clip> 留 NAS(沒 _clean 版,原檔即母檔)

🔴 color=紅 AND pick=0:
  → 不上雲,_MOV 維持

🟡 color=黃 AND pick=1:
  if has_NG:
    → _FCPX/<scene>/<clip>_clean.mp4 (進 FCP 剪輯)
  else:
    → FCP import 時直接讀 _MOV/<clip>
  剪輯完成 → _export/<scene>/memoirs/<edited>.mp4 (1080p H.265 上雲)

🟡 color=黃 AND pick=0:
  → 不剪輯不上雲,_MOV 維持
```

**ffmpeg 規格**:

```bash
# lossless trim(去 NG)
ffmpeg -ss <start> -i <clip>.MP4 -t <duration> \
       -c copy -avoid_negative_ts make_zero \
       _FCPX/<scene>/<clip>_clean.mp4

# 壓縮上雲(highlights / memoirs)
ffmpeg -i <input> -c:v libx265 -crf 24 -b:v 8M -preset slow \
       -c:a aac -b:a 192k -movflags +faststart \
       _export/<scene>/highlights/<clip>_cloud.mp4
```

**`+faststart`** 是雲端串流關鍵,**別漏**。

### Step 6 — 導演視角腳本生成(我做)

對於黃色 P=1 的 clip(長篇紀錄)+ Pick=1 的 STILL,我以導演視角分析輸出腳本:

**腳本內容**(每個鏡頭 / clip):
- **鏡頭類型**:大景 / 中景 / 特寫 / 環境 / 主體
- **動作 / 主體 / 情緒**
- **運鏡建議**:推 / 拉 / 搖 / 移 / dolly / zoom
- **剪輯順序建議**(時序連貫性)
- **配樂節拍對齊建議**
- **節奏建議**:
  - 首鏡 establishing shot 用大景 5-7s
  - 中段用 2s 中景 + 1s 特寫交叉
  - 轉場節點放在「節拍重音」
  - 音樂高潮對齊 hero clip(紅 marker)
  - 結尾留 1-2s reverse 大景

**輸出 HTML**:
- 縮圖 + 時間軸 + 運鏡腳本 + 評論框
- 路徑:`robert/handoff/<trip>_director_script_<date>.html`(或 `_export/<scene>/script.html`,Robin 決定)
- James 在 HTML 內 annotate / comment
- 我讀 annotation → 出 v2 腳本

### Step 7 — 剪輯出片

**腳本通過後**:
- 我輸出 **FCPXML 1.x** 格式 → FCP Import → timeline 自動生成
- 或 ffmpeg 直接切接(若簡單剪輯)
- 配音樂節拍
- 出片 → `_export/<scene>/memoirs/<edited>.mp4`(1080p H.265 8Mbps + faststart)

精彩瞬間集錦(紅色軌)類似邏輯:
- Pick=1 的 highlights 用同套腳本邏輯做集錦 MV
- 出 `_export/<scene>/highlights/MV_<theme>.mp4`

---

## 🔁 雙軌設計

| 軌 | 標的 | 何時 | 流向 |
|---|---|---|---|
| 🅐 **James 在 FCP 手動標(精修時)** | Marker(時間點)+ Keyword(clip 層) | 你有時間 + 對某段有特別意向 | SpliceKit MCP 讀 → 當錨點 |
| 🅑 **Robert 自動抽幀 + VLM 評分(預設)** | ffmpeg fps=1 → STILL → VLM 評分 → Pick | 預設,99% 情境 | Pick 集合當錨點 |
| 🅒 **Robert 回寫 FCP marker(選用)** | 把 Pick=1 的 frame 反向寫回 FCP 變藍色 marker | 你想之後在 FCP review/adjust | 軌 🅑 結果可被你進 FCP 細修 |

軌 🅐 跟 🅑 **可混合** — 重要 clip James 自己標,其他全交給 Robert。

軌 🅒 的觸發:每次 Step 5 跑完,自動跑 SpliceKit MCP 寫 marker 進 FCP(Pick=1 的 frame 對應的時間點都加藍色 marker)。James 之後在 FCP 開該 clip,可以直接看到「我評過的精選幀」。

---

## 🎯 FCP 內顏色 / Keyword 設計

**Marker(時間點)層**:

| 顏色 | 用途 |
|---|---|
| 🔵 藍 | 一般 still 候選(Robert 軌 🅒 自動寫 + James 手動) |
| 🔴 紅(to-do) | 精彩瞬間 keyframe(James 手動標,精修時用) |
| 🟢 綠(complete) | 剪片入點 / 出點(James 手動,剪輯時用) |

**Keyword(clip 層)**:

| Keyword | 用途 |
|---|---|
| `精彩瞬間` | 對應 LR colorLabel = 紅色 |
| `長篇紀錄` | 對應 LR colorLabel = 黃色 |
| `trimmed` | 從 `_FCPX/<scene>/` import 的(已 trim 過) |
| `original` | 從 `_MOV/<scene>/` import 的(沒 NG 過) |

Smart Collection 範例:
- `Keyword 含 "trimmed"` → 已去 NG 可直接用
- `Keyword 含 "精彩瞬間" + 有藍色 marker` → 走 highlights 出片
- `Keyword 含 "長篇紀錄"` → 走 memoirs 剪輯

---

## 📝 LR caption NG 段格式

兩種寫法,腳本都讀:

**寫法 A — NG mode(列 NG 段)**:
```
NG: 1:20-1:35, 3:05-3:12
```

**寫法 B — keep mode(列保留段)**:
```
keep: 0:00-1:19, 1:36-3:04, 3:13-5:00
```

**腳本解析**:
- 找 `NG:` 或 `keep:` 開頭
- 各段 `start-end` 格式為 `M:SS` 或 `MM:SS` 或 `H:MM:SS`
- 反推(keep mode = 直接用 / NG mode = 用片長減 NG 段)

**機器 tag 共用註解**:
caption 同時也是 v4 metadata schema 的對話日誌容器(見 LR_Catalog_v4_Metadata_Schema)。**永遠 append,不覆寫**。NG 段寫在 caption 第一行,對話日誌往下 append。

---

## 📊 Master CSV Schema 擴展

**既有**(來自 Backlog_5階段SOP):
- `filename / label / rating / pick / scene_id / scene_role / confidence / needs_human_review / notes`

**本 SOP 新增 2 欄**(剪輯時用得到):
- `source_video` — 該 STILL 來自哪個影片
- `timestamp_sec` — 該 STILL 在影片中的時間(秒)

範例:
```csv
filename,source_video,timestamp_sec,label,rating,pick,...
IMG_5680.MP4,_self,N/A,Red,4,1,...     ← clip 本身
IMG_5680_t0007.jpg,IMG_5680.MP4,7.0,Red,3,0,...  ← STILL
IMG_5680_t0012.jpg,IMG_5680.MP4,12.0,Red,4,1,... ← STILL(P)
```

---

## 🖥️ HTML 導演腳本格式

**結構**:
```html
<header>
  <h1>永漢高爾夫球場 — 長篇紀錄 director script v1</h1>
  <meta>scene: 0830_golf_morning / 5 clips / 18 STILLs P / total ~5min</meta>
</header>

<timeline>
  <clip id="IMG_5680">
    <thumbnail src="t0007.jpg" />
    <timestamp>00:07 (clip start)</timestamp>
    <shot-type>大景</shot-type>
    <description>球場全景,陽光從左斜射</description>
    <camera-movement>固定 → 緩慢右搖</camera-movement>
    <duration-recommend>5s</duration-recommend>
    <music-cue>節拍 1-2 重音對齊</music-cue>
    <comment-box editable="true"></comment-box>
  </clip>
  
  ... 每個 frame 一個 block
</timeline>

<footer>
  <button onclick="exportFCPXML()">通過 → 產 FCPXML</button>
</footer>
```

**互動功能**:
- 點縮圖跳影片時間軸
- 留言框可寫 annotation
- 通過後自動產 FCPXML 給 FCP import

---

## 🚨 紅線清單

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 啟動本 pipeline 前自我檢查</p>
<div class="text-sm text-gray-300">


**資料完整性**:
- [ ] LR Cmd+Q?(`lsof | grep .lrcat` 空)
- [ ] backup + integrity_check 'ok'?
- [ ] master CSV 限定範圍?(只動本 trip 的 baseName)

**抽幀規格**:
- [ ] fps=1?
- [ ] 抽 4K 原寬 + 生 1080p 縮圖判讀?
- [ ] EXIF / XMP 寫 `source_video` + `timestamp_sec`?

**VLM 評分**:
- [ ] Opus 4.7?(Sonnet 大批量幻覺率 70-80%)
- [ ] Stage A / Stage B 拆兩階段不合併?
- [ ] `objective_description` 必填且先於 label?

**分流 batch**:
- [ ] 紅 P=1 沒 NG → 直接 _export/highlights,不過 _FCPX?
- [ ] 紅 P=1 有 NG → _FCPX + _export/highlights 雙存?
- [ ] 紅 P=0 → 都不動?
- [ ] 黃 P=1 → _FCPX 進剪輯?
- [ ] 黃 P=0 → 不動?

**ffmpeg**:
- [ ] trim 走 `-c copy`(lossless,不重編碼)?
- [ ] 壓縮走 H.265 8Mbps + `+faststart`?

**軌 🅒**:
- [ ] Pick=1 frame 回寫 FCP 變藍色 marker?

</div>
</div>


任一沒勾 → 不要按 enter。

---

## ⏸ 未來功能(待 James 拍板再設計)

- **`_MOV/` cleanup batch**:定期清理沒 P 的 _MOV 原檔(三階段安全:列清單 → 移垃圾桶 → 清空垃圾桶)— **暫不實作,2026-05-16 James 拍板「未來可能但還沒決定」**
- **三層儲存長期保存策略** — 用了再說
- **Purple 軸食物影片**(食物 / 創作物影片有沒有專屬軸)— 跟 人像評分_4軸法 Purple 軸訓練接

---

## 📁 範例 — 永漢高爾夫球場 19 張處理

**輸入**:2026-05-15 拍的 19 個檔案(iPhone) — 部分照片 + 部分影片(0:07 / 0:15 / 0:18)

**走 pipeline**:
```
Step 1 抽幀:
  IMG_5680.MP4 (0:18 = 18s) → 18 張 STILL
  IMG_5723.MP4 (0:15 = 15s) → 15 張 STILL
  ...
  總計 ~80 張 STILL

Step 2 VLM:
  Stage A label: 80/80
  Stage B rating: 80/80
  Pick=1 約 8-12 張(視內容)

Step 3 LR catalog 寫入:
  80 張 STILL 進 LR(走 v4 schema)
  + 4-5 個 clip 也進 catalog 給 color label

Step 4 James review:
  在 LR 給 clip 色標(紅 / 黃)+ pick
  STILL 微調(若 VLM 有評錯)
  caption 寫 NG(若有)

Step 5 分流 batch:
  跑 _FCPX symlink/clean + _export 壓縮上雲

Step 6 導演腳本(若黃色 P=1 有素材):
  HTML 輸出 → review

Step 7 剪輯出片:
  FCPXML → FCP → 出片 → _export/memoirs/
```

---

## 相關技能 / 規範

- Backlog_5階段SOP — 照片端對應 SOP
- 人像評分_4軸法 — Stage B 評分主軸(複用)
- VLM評分_防幻覺紅線 — Stage A/B 6 條 hard constraint
- LR_Catalog_v4_Metadata_Schema — Step 3 寫入規範
- LR_Catalog_SQL寫入安全 — Step 3 + Step 5 catalog SQL 安全
- LR_AutoTone_SQL觸發 — STILL 寫入時可同步觸發 AutoTone
- FCP_Marker_Workflow — 本 SOP 含其精神 + 大幅擴展(VLM 整合)
- Evoto_RoundTrip_B-flow_v3 — 對 STILL 走 Evoto 精修可走的後續流程(若需要)

---

## 修訂歷史

- **2026-05-16**:初版。從 1-on-1 msg 1833~1852 共 18 輪討論(包含 8 件拍板 + Option E folder + 雙軌設計 + 四象限分流 + 軌 🅒 marker 回寫 + LR caption NG 規格 + HTML 腳本格式 + ffmpeg 規格)整理。
