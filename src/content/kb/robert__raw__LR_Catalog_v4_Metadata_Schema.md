---
title: LR Catalog v4 Metadata Schema 規範
date: 2026-05-13
creator: robert
co_creators: []
tags:
  - 攝影
  - 規範
  - LR
  - metadata
  - VLM
  - catalog
aliases:
  - v4 metadata schema
  - LR catalog metadata 寫入規範
來源: photo-grade KB v1 (2026-05-08~2026-05-12) §2.1 + feedback_lr_metadata_schema.md memory (2026-05-12 James 拍板)
連結: _attachments/photo_grade_kb_2026-05-11.html
version: 1
note_to_robin: |
  這份是「規範」不是「技能」,依你的指示放 robert/raw/(不放 skills/)。
  轉化目的地建議:_meta/ 或 ideas/ai-tools/規範/(你決定)。
category: "其他"
---

# LR Catalog v4 Metadata Schema 規範

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 一句話定義</p>
<div class="text-sm text-gray-300">

VLM 跑完照片把結果寫入 LR Classic catalog 時的**欄位分工標準**(2026-05-12 James 拍板):關鍵字承載 `objective_description`(用 `+` 切)、註解承載機器 tag + 雙方對話日誌(`|` 數標輪次)、評等/旗標/色標維持 v3。**替代文字 / 延伸描述暫不用**(LR Classic 13+ 對這兩欄 SQL 直寫不顯示)。

</div>
</div>


## 為什麼有這份規範(Why)

2026-05-12 實測發現:LR Classic 對 `altTextAccessibility` / `extDescrAccessibility` 兩個 IPTC 2017 新欄位,**直接 SQL 寫入 column 不會在 UI 顯示**。原因是 LR 同時檢查 `AgMetadataSearchIndex` 是否同步;走 LR-native UI 寫入或 XMP Read Metadata 才正常。

為了**避免 XMP round-trip**(慢、易壞、要 user 手動「從檔案讀取」),改用 SQL 一定吃的欄位重新配置中繼資料分工 — 這就是 v4。

—

## 欄位分工表(VLM CSV → LR catalog)

| LR UI | SQL 表 / 欄位 | 內容 | 主用者 |
|---|---|---|---|
| **關鍵字** | `AgLibraryKeyword.name` + `AgLibraryKeywordImage` | `objective_description` 用 `+` 切分,每段一個 keyword | Robert(VLM 寫入) |
| **註解** | `AgLibraryIPTC.caption` | 機器 tag + 雙方對話日誌 | 雙方共用 |
| 替代文字 | `AgLibraryIPTC.altTextAccessibility` | **暫不用**(LR SQL 直寫不顯示) | — |
| 延伸描述 | `AgLibraryIPTC.extDescrAccessibility` | **暫不用**(LR SQL 直寫不顯示) | — |
| 評等 / 旗標 / 色標 | `Adobe_images.rating / pick / colorLabels` | 標準 v3 評分(沿用) | Robert |

---

## 關鍵字寫入規則(符合 LR 規範)

從 VLM 的 `objective_description` 欄位拆解成多個 keyword:

- 用 `+` 切分 `objective_description` 字串
- 每段 `strip()` 前後空白
- 跳過空字串、跳過 1 字元雜訊、跳過純標點
- **不重複既有 keyword**(查 `AgLibraryKeyword.lc_name` 確認)
- 既有 scene / 人物 tag(`1112_N`, `女A`, `男A` 等)**保留不動**

**範例**:
```
objective_description = "熊本城石碑+石牆+樹+施工鷹架+陰天"
→ 5 個獨立 keyword:["熊本城石碑", "石牆", "樹", "施工鷹架", "陰天"]
```

---

## 註解格式(共用對話日誌)

註解(`AgLibraryIPTC.caption`)是 Robert + James + Robin 三方共用的對話日誌容器。**用 `|` 個數判斷輪次,新內容永遠 append 在最末**。

### 範本

```
turn 0 (Robert 初寫,無 |):
[表情:big_laughing] [動作:hugging_mascot_full_joy] [主體:human_face_clear] [conf:0.92]

turn 1 (James 加註,單 |):
[表情:...] [動作:...] [主體:...] [conf:0.92] | 大笑表情完美,主體判斷正確 ★★★★★

turn 2 (Robert 回應,雙 ||):
[表情:...] ... ★★★★★ || 已加入 SKILL hugging_mascot 權重 ✓

turn 3 (James 再加,三 |||):
... ✓ ||| 確認 SKILL update
```

### 規則

- **數 `|` 個數判斷輪次**,新內容永遠 append 在最末
- **永不覆蓋既有內容** — UPDATE 前先讀 caption,在原文後 append
- 缺機器 tag 的照片(312/1280 v2 schema)→ 註解寫 `[需補tag]` 標記
- Robert 想標 user audit 的張數 → 註解加 `[需複查]`

---

## Smart Collection 篩選範例

v4 schema 設計時保留了 Smart Collection 篩選能力(這也是為什麼選關鍵字 + 註解):

| 想找什麼 | Smart Collection 條件 |
|---|---|
| 所有有施工背景的照片 | `關鍵字 包含 "施工鷹架"` |
| 我標記要 James audit 的張數 | `註解 包含 "[需複查]"` |
| 缺 v3 tag 的 312 張 | `註解 包含 "[需補tag]"` |
| 已經有對話往返的照片 | `註解 包含 " || "`(雙 pipe = ≥2 輪) |
| James 標 5 星的回饋 | `註解 包含 "★★★★★"` |

<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">ℹ️ 為什麼 keyword filter 不能放 `表情:laughing`</p>
<div class="text-sm text-gray-300">

表情 / 動作 / 主體這類機器 tag 走的是 caption(註解)的 `[表情:...]` 格式,**不是** keyword。
原因:這些 tag 不是「畫面描繪」(那個交給 keyword),是「分類軸」 — 適合 search index 文字搜尋,不適合走 keyword tree。

</div>
</div>


---

## 為什麼這樣分?(4 條設計原則)

1. **關鍵字** = scene 描繪的天然容器,每段獨立 = LR keyword filter / Smart Collection 都能用
2. **註解** = 唯一同時滿足「SQL 直寫即顯示」+「文字長」+「Smart Collection 文字搜尋」的欄位 → 適合放機器 tag + 對話日誌
3. **延伸描述 / 替代文字** = LR Classic 13+ 加的新欄位,需要走 XMP 或 LR-UI 寫入才會顯示,SQL 直寫只進 column 不進 index → 避開
4. 未來如要救活延伸描述 / 替代文字 → 得寫 XMP sidecar + LR 觸發「中繼資料 → 從檔案讀取」(增加一步 user 手動,不在 v4 範圍)

---

## 已驗證的 SQL 寫入 pattern

```python
# 清除舊註解 + 寫新內容(僅限 master scope 1280 baseName)
cur.execute("""
  UPDATE AgLibraryIPTC SET caption=? WHERE image=?
""", (new_caption, img_id))

# 新增 keyword(若 lc_name 不存在則建,再 link 到照片)
cur.execute("INSERT OR IGNORE INTO AgLibraryKeyword (id_global, name, lc_name, ...) VALUES (?, ?, ?, ...)")
cur.execute("INSERT OR IGNORE INTO AgLibraryKeywordImage (image, tag) VALUES (?, ?)")
```

**Append 對話日誌(不覆蓋)的安全 pattern**:

```python
# 1. 讀現有 caption
cur = conn.execute("SELECT caption FROM AgLibraryIPTC WHERE image=?", (img_id,))
existing = cur.fetchone()[0] or ""

# 2. 數現有最大 | 個數,本次用 +1
pipe_count = max([line.count('|') for line in existing.split('\n')] or [-1]) + 1
separator = ' ' + '|' * pipe_count + ' ' if pipe_count > 0 else ''

# 3. Append 新內容
new_caption = existing + separator + new_content if existing else new_content

# 4. 寫回
conn.execute("UPDATE AgLibraryIPTC SET caption=? WHERE image=?", (new_caption, img_id))
```

---

## 安全前置(走完整 SQL 安全 SOP)

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 動 catalog 之前</p>
<div class="text-sm text-gray-300">

完整 SQL 安全 SOP 走 LR_Catalog_SQL寫入安全 — 鐵則:
- LR 必須 `Cmd+Q`(catalog lock 釋出)
- backup 到 `/Volumes/X10 Pro2/.../*.lrcat.backup_<reason>_<ts>` + `PRAGMA integrity_check` 'ok'
- 複製到 `/tmp/work.lrcat` 工作(ExFAT 不友善 SQLite)
- 在 /tmp 跑完所有 UPDATE(注意 keyword INSERT 跟 caption UPDATE 是兩種操作,合併成單一 transaction)
- `PRAGMA integrity_check` 'ok' 才 `cp` 回 SSD
- UPDATE 必加 WHERE,範圍要明確 print(2026-05-11 重災教訓)

</div>
</div>


---

## 紅線清單(寫入 catalog 前對照)

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 v4 schema 寫入前自我檢查</p>
<div class="text-sm text-gray-300">

- [ ] LR `Cmd+Q`?(`lsof | grep .lrcat` 空)
- [ ] master CSV 限定範圍(baseName 白名單)?
- [ ] `objective_description` 用 `+` 切,每段 `strip()` + 跳雜訊?
- [ ] keyword INSERT 用 `INSERT OR IGNORE`(避免重複建)?
- [ ] caption UPDATE 是 **append**,不是覆蓋?(讀現有 → 加 `|` 分隔 → append)
- [ ] 缺機器 tag 的張數有寫 `[需補tag]` flag?
- [ ] 既有 scene / 人物 tag(`1112_N` / `女A` / `男A`)沒被誤刪?
- [ ] 走 LR_Catalog_SQL寫入安全 SOP(backup / /tmp / integrity_check)?

</div>
</div>


---

## 相關技能 / 規範

- LR_Catalog_SQL寫入安全 — 跑 v4 寫入前必走的 SQL 安全鐵則
- 人像評分_4軸法 — VLM 評分系統(產生 rating / pick / colorLabels 的源頭)
- VLM評分_防幻覺紅線 — VLM 評分必守 6 條紅線(產生 objective_description 的源頭)
- Backlog_5階段SOP — ④ Catalog SQL 寫入階段套用本 v4 schema
- Evoto_RoundTrip_B-flow_v3 — 註冊 Evotofu JPG 時可同步寫 v4 metadata
- LR_AutoTone_SQL觸發 — v4 寫入同時可以觸發 AutoTone

---

## 修訂歷史

- **2026-05-13**:初版(寫到 `robert/raw/` 等 Robin 轉化)。從 2026-05-12 James 拍板事件 + `feedback_lr_metadata_schema.md` memory + photo-grade KB v1 §2.1 萃取。

---

## ✋ 留給 Robin 的轉化指示

- **檔案類型**:這是「規範」不是「技能」,**不要**進 `robert/skills/`
- **建議去處**:`_meta/規範/LR_Catalog_v4_Metadata_Schema.md` 或 `ideas/ai-tools/規範/LR_Catalog_v4_Metadata_Schema.md`,你決定哪個比較合 KB 編目
- **wikilink 更新**:`robert/skills/` 裡 6 份檔案都有 `LR_Catalog_v4_Metadata_Schema` 連結指向這份,轉化後請確認 wikilink 仍然 resolve
- **append-only 邏輯**:這份 v4 schema 是 production 寫入規範,**未來改版 (v5) 必走 schema 規範的 revision_history append 流程**,不要另開新檔
