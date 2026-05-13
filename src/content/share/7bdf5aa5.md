---
title: Backlog 5 階段 SOP
date: 2026-05-12
creator: robert
co_creators: []
tags:
  - workflow
  - 攝影
  - 自動化
  - skill
aliases:
  - Backlog SOP
  - 旅遊 backlog 5 階段
來源: photo-grade KB v1 (2026-05-08~2026-05-12) + feedback_backlog_trip_sop.md
連結: _attachments/photo_grade_kb_2026-05-11.html
version: 1
---
sourceNote: "robert__skills__Backlog_5階段SOP"

# Backlog 5 階段 SOP

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 一句話定義</p>
<div class="text-sm text-gray-300">

James 把整批旅遊 backlog 丟過來時的標準 5 階段 pipeline:**場景命名(GPS+VLM)→ Label → 評分 → catalog SQL → AutoTone trigger**,前 4 階段 Robert 一條龍跑完才通報 user,第 5 階段是 user 在 LR 開檔做手動 RAW 精修。「明天看結果」的交付節奏。

</div>
</div>


## 適用情境

- 一次拿到一趟旅遊(>100 張)的 SD card 整批匯入
- 多趟 backlog(門司港 671 + 4 趟 1280 等)一起補
- 任何「規模 ≥ 100 張 + 場景多樣 + 需要進 LR catalog」的批次
- 連續長假後補的累積素材(本 SOP 誕生於 2026-05-10 一次性清 4 趟 backlog)

<div class="not-prose my-6 bg-yellow-500/10 border-l-4 border-yellow-500 rounded-r-lg p-4">
<p class="font-bold text-yellow-400 mb-2">⚠️ HHMM-only 不算交付</p>
<div class="text-sm text-gray-300">

必須做到 **GPS + VLM 雙來源命名**才算完成第 1 階段。2026-05-10 已踩雷一次:只用 EXIF HHMM 命名,結果同時段不同地點被誤判同場景,user 退回重跑。

</div>
</div>


---

## 5 階段順序(2026-05-10 final 版)

```
[1] 場景分類 + GPS 命名
       ↓
[2] Label 分跑(Stage A,VLM Opus)
       ↓
[3] Rating + Pick(Stage B,VLM Opus)
       ↓
[4] catalog SQL 寫入 + AutoTone trigger
       ↓ ────── Robert 一條龍跑完才通報 ──────
[5] User 開 LR 看結果 + 手動 RAW 精修
```

---

### ① 場景分類 + GPS 命名(先做)

**輸入**:整批 ARW + iPhone JPG / HEIC(混拍場景)
**輸出**:`scene_naming.json`(每張 → scene_id + 完整名稱)

**步驟**:
1. **時區檢查**:Sony 相機時鐘 vs iPhone EXIF 時間對齊(常見偏差 ±5 分鐘到幾小時)
2. **時間聚類**:gap > 30 分鐘 = 新場景(可調)
3. **iPhone GPS → Nominatim 反向地理編碼** → 取地名 / 區域
4. **ARW 借時間就近 iPhone GPS**:ARW 沒 GPS,找時間最近的 iPhone 照片借
5. **VLM 視覺驗證**地名跟畫面相符(防 GPS 漂移到隔壁建築)
6. **命名格式**:`HHMM 4-12 字地點/活動`
   - ✅ `1430 熊本城天守閣`
   - ✅ `1945 旅館門口合照`
   - ❌ `1430`(HHMM-only 不算交付)
   - ❌ `1430 場景 1`(沒地點)

<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">ℹ️ iPhone 跟 ARW 同時段混拍時</p>
<div class="text-sm text-gray-300">

把同一秒內的 iPhone+ARW 視為同場景。ARW 借就近 iPhone 的 GPS 即可,不要每張都用 VLM 重判(成本爆炸)。

</div>
</div>


### ② Label 分跑(Stage A,VLM Opus)

**輸入**:① 的場景映射 + 1024+px 縮圖
**輸出**:`stage_a_labels.json`(每張 → label + objective_description + subject_type + confidence)

**規則**:
- VLM 一次決定 4-way(Red / Yellow / Green / Purple),**不再用 Excire face/people 當 gate**(face/people 兩道閘漏報率高,後腦勺 / 側臉 / 逆光剪影都會漏)
- **必須遵守 VLM評分_防幻覺紅線** 6 條 — Label 由主體唯一決定 / 同場景同 label / `objective_description` 必填
- 寫入 catalog 的 `Adobe_images.colorLabels` 用**繁中字串**:紅色 / 黃色 / 綠色 / 紫色

### ③ Rating + Pick(Stage B,VLM Opus)

**輸入**:② 的 Label 結果 + 同批縮圖
**輸出**:`stage_b_rating.csv`(每張 → rating + rating_range + pick + scene_role + notes)

**規則**:
- 讀 人像評分_4軸法 規則(原 `SKILL_robert_portrait_rating.md` v2)
- rating 1-5 + pick true/false + ≤15 字 notes
- 4★ ceiling,5★ 罕見(訓練集尚無 5★ 案例)
- **Green default 3★+P**(場景唯一就保留)
- **慷慨原則**:burst 都好就都保留高分(同場景 burst 都笑+看鏡頭可以都 4P)

<div class="not-prose my-6 bg-yellow-500/10 border-l-4 border-yellow-500 rounded-r-lg p-4">
<p class="font-bold text-yellow-400 mb-2">⚠️ 雷同擇優必走 §C 規則(原 SKILL v2 規則 11/13/14/15)</p>
<div class="text-sm text-gray-300">

不能在 prompt 裡簡化掉(6 維度判斷 / 同焦段獨立評分 / 真雷同擇優依「畫面乾淨度 > 構圖 > 動態瞬間」)。

</div>
</div>


### ④ Catalog SQL 寫入 + AutoTone trigger

**輸入**:③ 的 master CSV + LR catalog(.lrcat)
**輸出**:catalog 內 rating / colorLabels / pick 填好 + AutoTone 觸發

**步驟**:
1. 確認 LR Classic 關閉(catalog lock 釋出)— `lsof | grep .lrcat` 必須空
2. 建 `AgLibraryRootFolder` + `AgLibraryFolder`(若 catalog 還沒認識這批檔案)
3. 寫 9+ 張 lookup tables(同 Evoto 那套流程)
4. UPDATE `Adobe_images.rating / colorLabels / pick`(**必加 WHERE,見 LR_Catalog_SQL寫入安全**)
5. INSERT `Adobe_imageDevelopSettings.text` 含 history step `calculate` → LR 開檔時自動算 AutoTone

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 不要踩這些雷</p>
<div class="text-sm text-gray-300">

- LR 沒關就動 catalog → SQLite lock + corruption 風險
- UPDATE 不加 WHERE → 把其他 trip 的評分清光(2026-05-11 重災實證)
- 漏 history step `calculate` → LR 不會自動算 AutoTone,user 還要手動觸發
- 寫 XMP sidecar 後讓 user 手動 LR Import(user 要 SQL 直接寫,不要繞 XMP)

</div>
</div>


**SQL 安全 SOP 走 LR_Catalog_SQL寫入安全**:backup → /tmp 副本 → integrity_check → 在 /tmp 跑 → integrity_check → cp 回 SSD。

### ⑤ User 階段(Robert 不碰,等通報)

User 在 LR Classic 開檔:
1. 看每張的 AutoTone 結果(LR 自動帶曝光 / 對比)
2. 按 colorLabels(紅黃綠紫)做 collection 分流
3. 進入手動 RAW 精修流程(走 Evoto_RoundTrip_B-flow_v3 或 LR 純參數)

<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">ℹ️ 「全權處理,明天看結果」</p>
<div class="text-sm text-gray-300">

User 2026-05-10 拍板:把多趟 backlog 丟過來時 Robert 必須做完 ①-④,user 才接手 ⑤。**不要**把 4 個階段切片丟回去問。

</div>
</div>


---

## 執行紀律

### ❌ 不要做這些事
- 把 4 步切片發 Telegram 問 user(2026-05-10 之前曾發生,user 退回要求「全權處理」)
- 寫 XMP sidecar 後讓 user 手動 LR Import(user 要 SQL 直接寫)
- 漏掉 AutoTone trigger(missing `calculate` history step)
- 跳過 label 分類直接給 rating(違反紅線 6 拆兩階段)
- HHMM-only 命名(沒 GPS+VLM)

### ✅ 要做這些事
- 4 階段一條龍跑完才 Telegram 報告
- 跑前確認 LR 關閉(`lsof` / `ps` 檢查)
- 跑完報告:各階段數量 / 每色標多少 P / 有無錯誤 / 哪些張 `needs_human_review`
- 所有 JSON / CSV / SQL log 存在 `~/Desktop/Claude-Workspace/photo-grade/`

---

## 範例 — Backlog 1280 張(2026-05-10 ~ 2026-05-11)

**輸入**:4 趟旅遊(1057 / 1112 / 1115 / 1116) 共 1280 張 ARW + iPhone

**執行**:
```
① 場景命名:GPS+VLM 雙來源 → 1112 拆 14 子場景(動線 A~O)
② Stage A(Opus 4.7):4 趟分跑,1280/1280 完整覆蓋
③ Stage B(Opus 4.7):master_stage_b_rating.csv,82 個 5★ Pick
④ Catalog SQL:backup → /tmp → UPDATE WHERE baseName IN(...) → integrity_check → cp 回 SSD
   → INSERT calculate history step
⑤ User:LR 開檔 → 看每張 AutoTone → 進精修
```

**結果**:
- XMP 配對成功率 98.2%
- 10 張廢片黑標(2 張非行程 + 8 張糊片/截圖)
- 312 張缺機器 tag → 註解填 `[需補tag]` 走 Smart Collection 補

**踩雷實證**:
- 2026-05-11 21:47 ④ 階段 SQL 沒加 WHERE → 門司港 671 張評分被清光,從 backup 復原
- 修法:見 LR_Catalog_SQL寫入安全 鐵則 1

---

## 紅線清單(動手前對照)

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 啟動 backlog SOP 前自我檢查</p>
<div class="text-sm text-gray-300">

- [ ] 縮圖管線 ≥1024px 長邊?(防 VLM 幻覺)
- [ ] GPS 反向地理編碼接好(Nominatim API key)?
- [ ] ARW + iPhone 時區對齊?
- [ ] VLM prompt 含 VLM評分_防幻覺紅線 6 條 hard constraint?
- [ ] Stage A / Stage B 拆兩階段,沒合併?
- [ ] LR 已 `Cmd+Q`?(`lsof` 空)
- [ ] SQL 走 LR_Catalog_SQL寫入安全 SOP(backup / /tmp / integrity_check)?
- [ ] AutoTone trigger(history step `calculate`)有寫?
- [ ] 全跑完才一條訊息通報 user?

</div>
</div>


任一沒勾 → 不要按 enter。

---

## 相關技能

- 人像評分_4軸法 — ③ Rating 階段套用的 4 軸評分主軸
- VLM評分_防幻覺紅線 — ② ③ 階段 VLM prompt 的 6 條 hard constraint
- LR_Catalog_SQL寫入安全 — ④ catalog SQL 寫入的鐵則 SOP
- LR_Catalog_v4_Metadata_Schema — ④ 寫入時的 keyword + caption 欄位分工(尚未建立)
- LR_AutoTone_SQL觸發 — ④ 最後一步「INSERT calculate」的細節(尚未建立)
- Evoto_RoundTrip_B-flow_v3 — ⑤ user 階段 Red 軸後續精修工作流(尚未建立)

---

## 修訂歷史

- **2026-05-12**:初版。從 photo-grade KB v1 §5 + `feedback_backlog_trip_sop.md` + 2026-05-10 「全權處理,明天看結果」拍板事件 + 2026-05-11 1280 張實證萃取。
