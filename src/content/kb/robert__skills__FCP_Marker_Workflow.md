---
title: FCP Marker Workflow
date: 2026-05-12
creator: robert
co_creators: []
tags:
  - 剪輯
  - FCP
  - SpliceKit
  - workflow
  - skill
aliases:
  - FCP Marker → Stills SOP
  - SpliceKit marker workflow
來源: photo-grade KB v1 (2026-05-08~2026-05-12) + 2026-05-10_fcp_marker_workflow_kb.md
連結: _attachments/photo_grade_kb_2026-05-11.html
version: 1
category: "其他"
---

# FCP Marker Workflow(影片端)

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 一句話定義</p>
<div class="text-sm text-gray-300">

James 在 Final Cut Pro 邊看 clip 邊用 `M` 加 marker(顏色 = 用途、note = 檔名後綴),Robert 透過 SpliceKit MCP 讀取所有 marker,用 ffmpeg 抽 4K 原寬 still,輸出到 `_MOV/<scene>/stills/`。**James 的 M 永遠優先,Robert 不抽沒 mark 的時點**。

</div>
</div>


## 適用情境

- 一趟旅遊裡有混合錄影素材(Sony A7 4K + iPhone),要從中抽 still 作出片或剪片參考
- 對影片做 hero 鏡頭篩選(配合後續 16:9 / 9:16 剪片)
- 把影片內容轉成可被 LR catalog 評分的 still(統一照片 / 影片管理)
- 任何「人工標記時間點 + 程式批次處理」的影片工作流(本 SOP 誕生於門司港 44 段影片)

<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">ℹ️ 環境前提</p>
<div class="text-sm text-gray-300">

- FCP Library:`<trip 名>`(如「2026-05-03 門司港一日遊」)
- Event:`All Clips`
- HDR 設定:SDR(跟照片端一致)
- Codec:原始 HEVC + iPhone H.264(**不轉檔**)
- 素材位置:`/Volumes/X10 Pro2/input/<trip>/_MOV/<scene>/`(leave in place,FCP 引用而非拷貝)
- SpliceKit MCP 已透過 dylib 注入 FCP(連 127.0.0.1:9876 JSON-RPC)

</div>
</div>


---

## James 端 — 邊看邊 mark

### 進入 clip viewer

- Browser 區找到 clip → **雙擊** → viewer 右上、timeline 在下
- 或單擊選取 → `Space` 直接 skim / play
- 雙擊後 timeline 變空白是正常的(進的是 clip viewer 不是 sequence)

### 播放與導覽鍵盤快捷

| 動作 | 鍵 |
|---|---|
| 播 / 暫停 | `Space` |
| 前進 / 後退 1 幀 | `→` / `←` |
| 前進 / 後退 10 幀 | `Shift + →` / `Shift + ←` |
| 跳到 clip 開頭 / 結尾 | `↑` / `↓` |
| 跳到下個 / 上個 marker | `Cmd + '` / `Cmd + ;` |
| 倒帶 / 暫停 / 快轉 | `J` / `K` / `L`(連按 L 加速 2x → 4x → 8x) |

### 加 Marker

| 動作 | 鍵 |
|---|---|
| 加 marker(無 note) | **`M`** |
| 加 marker + 編輯框 | **`M` 連按兩下** 或 `Option + M` |
| 移除 playhead 上的 marker | `Control + M` |
| 刪除最近一個 marker | `Cmd + Shift + M` |

註記框出現後:
- 直接 Enter = marker 留空
- 打字 → Enter = marker 帶 note

### Marker 顏色約定

點選 marker → 右下 inspector 改顏色:

| 顏色 | 意義 | Robert 抽幀時的對應 |
|---|---|---|
| 🔵 **藍**(預設) | 一般 still 候選 | 抽 → `<clip>_t<秒>.jpg` |
| 🔴 **紅**(Standard "to do") | hero / flagship 鏡頭 | 抽 + 加 `_hero` 後綴 |
| 🟢 **綠**(Standard "complete") | 剪片用點(暫不抽 still) | 略過(之後剪片時用) |

<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">ℹ️ 不想記顏色?</p>
<div class="text-sm text-gray-300">

全部用 `M` 預設藍。Robert 把所有藍色都當 still 抽。

</div>
</div>


### Note 後綴(會接到檔名)

打的字會變抽幀後 JPG 檔名後綴,方便日後檢索:

| James 打的 | Robert 輸出檔名 |
|---|---|
| (空) | `C0855_t7.20.jpg` |
| `smile` | `C0855_t7.20_smile.jpg` |
| `composition` | `IMG_5587_t12.30_composition.jpg` |
| `rain ground` | `IMG_5680_t45.50_rain-ground.jpg`(空格→`-`)|

**建議用簡短英文 / 拼音**:`smile / laugh / serious / wide / closeup / mid / mojiko / train / food / bridge / rain / sunny / night`。

---

## 失敗 / 不要的片段排除

### Reject 機制(推薦)

爛 clip(沒對焦 / 抖動 / 沒拍到 / 測試錄影 / 進出黑場):
- Browser 選中 clip → 按 **`R`** → clip 左上角出現紅色 **X**
- 解除 reject = 按 **`U`**

Robert 抽幀腳本會**跳過所有 reject clips**,整段不處理。

### 為什麼用 Reject 而不是刪除

| Reject | 刪除 |
|---|---|
| ✅ 可逆(按 U 一鍵還原) | ❌ 不可逆 |
| ✅ 原始檔不動(metadata flag) | ❌ 動原始檔 |
| ✅ 之後 Browser Filter "Show Rejected" 找得回 | ❌ 找不回 |

### 部分片段爛、部分好

整段 clip 沒問題、只是中間 1-2 秒爛 → **不用 reject,不在那段 mark 即可**。Robert 只抽 mark 的時點。

---

## Robert 端 — 讀 marker + 抽幀

### Step 1 — SpliceKit MCP 讀所有 marker

連 FCP(127.0.0.1:9876 JSON-RPC),遍歷 `All Clips` event 中每個 clip:
- 跳過 reject
- 對每個 marker 撈:clip basename / 時間戳(秒) / 顏色 / note
- 整理成清單

工具:`mcp__splicekit__get_timeline_clips` / `mcp__splicekit__add_markers_at_times` / 自訂 marker 讀取流程。

### Step 2 — ffmpeg 抽幀(4K 原寬)

```bash
ffmpeg -ss <秒> -i <clip>.MP4 \
       -frames:v 1 -q:v 1 \
       _MOV/<scene>/stills/<clip>_t<秒>_<note>.jpg
```

- 解析度:4K(HEVC 源 3840×2160 / iPhone 1920×1080)
- JPG q1(最高品質)
- 檔名按 marker note 帶後綴

### Step 3 — 同步 catalog(選擇性)

抽完後問 James:要不要把 stills 加進 LR catalog?
- ✅ 加 → 跟 ARW 一樣可評分 / 篩選 / 進 Evoto(走 Evoto_RoundTrip_B-flow_v3)
- ❌ 不加 → 純檔案系統 deliverable,LR 不可見

### Step 4 — 報告

```
=== Result ===
44 clips processed
38 had markers (6 had no marker = 0 stills)
Total markers: ~120
Stills extracted: 119(1 失敗)
By color:
  Blue (still): 110
  Red (hero): 9
By scene:
  1016 海峡夢タワー展望: 22
  1454 門司港駅: 18
  ...
```

---

## 邊 mark 邊整理場景的小撇步

### 用左側 Keyword Collection 一場景一場景看

Library 左側 `<trip>` → `Smart Collections / Keywords`:點哪個 keyword 就只看那場景的 clips,順序處理避免來回切腦袋。

### 縮圖大小 & 排序

Browser 右上滑桿可調縮圖大小、切 list / filmstrip 模式。filmstrip 模式 hover 預覽,不用真的播也能粗看內容。

### 標籤輔助

如果 marker 太多怕亂,可給 clip 加 keyword(不只場景):
- 選 clip → `Cmd + K` 開 keyword editor
- 加自定 keyword:`hero-clips` / `tour-end` / `must-include`

Robert 不會用這些 keyword,但 James 之後找 clip 方便。

---

## 16:9 / 9:16 混合素材處理

| 來源 | 寬高 |
|---|---|
| Sony A7 4K(C0855-C0861) | 16:9 橫向 |
| iPhone(IMG_*) | 16:9 或 9:16(視當下舉法) |

**Mark 階段不用考慮 aspect ratio** — marker 跟構圖無關。

剪片時:
- 想做 16:9 主片 → iPhone 直片要 reframe / 加裝飾邊
- 想做 9:16 Reels → Sony 橫片要 reframe / center crop
- 兩個都做 → 兩條 timeline 各別處理

---

## 後續剪片判斷依據(James 的 M 永遠優先)

| James 做的 | Robert 怎麼用 |
|---|---|
| 🔵 Marker(still) | 抽幀 + 之後剪片時可作短切點 |
| 🔴 Marker(hero) | 重點 / 出片開頭結尾候選 |
| 🟢 Marker(cut) | 剪輯入點 / 出點 |
| keyword `hero-clips` | 整段 clip 列為主軸 |
| Reject(R) | 完全跳過 |

**Robert 不會做的事**:
- 抽 James 沒 mark 的時點當 still
- 用 Robert 覺得好的 clip 但 James reject 的
- 蓋過 James 的標記

**Robert 會做(技術面補充)**:
- 過渡銜接 / 配樂節拍對齊
- 自動 reframe(16:9 ↔ 9:16)
- 顏色一致化(match grade)

---

## 常見小問題

**Q: M 按下去沒反應?**
A: 確認在 viewer 而非 timeline。clip 沒在播也沒關係,playhead 停在哪 marker 加哪。

**Q: marker 在 timeline 上但沒在 clip 上?**
A: 可能不小心把 clip 拖到 timeline 變 sequence。撤回(`Cmd+Z`)。回 browser 雙擊 clip 進 viewer mode。

**Q: 我想暫存 / 離開明天繼續?**
A: FCP 自動存,直接關 FCP 沒事。明天再開 marker 都在。

**Q: 邊 mark 邊聽音樂判斷?**
A: 可以,但建議用 monitor headphones + 把 FCP 音量拉低或靜音其他 clip 干擾。FCP 默認的 skimmer 會發出聲音(按 `S` 切換)。

---

## 紅線清單

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 mark / 抽幀流程自我檢查</p>
<div class="text-sm text-gray-300">


**James 端**:
- [ ] 確認在 clip viewer 不是 sequence editor?
- [ ] 顏色約定有對齊?(藍 still / 紅 hero / 綠 cut)
- [ ] 爛 clip 用 `R` reject 不是直接刪?
- [ ] note 用簡短英文 / 拼音,空格用 `-`?

**Robert 端**:
- [ ] SpliceKit MCP 抓 marker 有跳過 reject 嗎?
- [ ] ffmpeg 抽幀用 4K 原寬 + q:v 1?
- [ ] 檔名按 `<clip>_t<秒>_<note>.jpg` 規則?
- [ ] 抽完報告含:總 marker 數 / 抽出 stills 數 / by color / by scene?
- [ ] 問 James「要不要進 LR catalog」?

</div>
</div>


---

## 對接資料

- 工作目錄:`~/Desktop/Claude-Workspace/photo-grade/`
- LR catalog:`/Volumes/X10 Pro2/115-00-00 Robert 剪輯日常/`
- Trip 根:`/Volumes/X10 Pro2/input/<trip>/`
- `_MOV/<scene>/`:素材原檔(FCP 引用源)
- `_MOV/<scene>/stills/`:抽幀輸出
- SpliceKit dylib + JSON-RPC:`127.0.0.1:9876`
- 抽幀腳本:`~/Desktop/Claude-Workspace/photo-grade/2026-05-XX_marker_to_stills.py`

---

## 範例 — 門司港 44 段影片(2026-05-03 trip)

**輸入**:44 個 clips(Sony 4K HEVC + iPhone H.264)

**James 流程**:
1. 開 FCP → Library `2026-05-03 門司港一日遊` → Event `All Clips`
2. 左側 Keyword Collection 點 `1016 海峡夢タワー展望` → 22 clips 過一遍
3. 每個 clip 雙擊進 viewer → 邊看邊 M(藍 / 紅)+ 短英文 note
4. 爛 clip 直接 R(共 6 個)
5. 場景跑完換下一個 Keyword Collection

**Robert 流程**:
1. SpliceKit MCP 讀 marker → 跳過 reject → 收集 ~120 markers
2. ffmpeg 抽 4K still → `_MOV/<scene>/stills/`
3. 報告 by color / by scene
4. 問 James 要不要 sync 進 LR catalog

---

## 相關技能

- Evoto_RoundTrip_B-flow_v3 — stills 若 sync 進 LR catalog,Red 軸後續可走這個 Evoto 流程
- 人像評分_4軸法 — stills 進 catalog 後可走 VLM 評分
- LR_Catalog_SQL寫入安全 — sync stills 到 catalog 的 SQL 鐵則
- LR_Catalog_v4_Metadata_Schema — stills metadata 寫入欄位分工(尚未建立)
- SpliceKit / FCP MCP 整合說明見記憶 `reference_splicekit.md`

---

## 修訂歷史

- **2026-05-12**:初版。從 `2026-05-10_fcp_marker_workflow_kb.md` + photo-grade KB v1 §8 + 門司港 44 段影片實證萃取。
