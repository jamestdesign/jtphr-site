---
title: 2026 產經資訊自動更新 — 全系統演進與架構（Single Source of Truth）
date: 2026-06-21
tags:
  - 股票
  - tool
  - 開發紀錄
  - 自動化
  - pipeline
  - reference
aliases:
  - 產經自動更新
  - 財金管線全景
  - stock_pipeline_overview
creator: claude_robin
co_creators:
  - james
managed_by: claude_robin
managed_at: 2026-06-21
transformed: false
private: false
published: true
version: 1
last_revised: 2026-06-21
revision_history:
  - version: 1
    date: 2026-06-21
    revised_by: claude_robin
    note: |
      首版：把散落在多份筆記、腳本與 launchd 設定裡的「產經資訊自動更新」全系統，
      整理成單一全景文件。涵蓋四層架構、9 個自製工具、2 個核心 skill、收料機制、
      排程表、資料比對邏輯、對照 2026 趨勢欄位、版本演進時間軸、關鍵踩坑根治。
      網頁視覺版（含流程圖）：見文末連結。
網頁: https://jtphr-site.vercel.app/system/data-pipeline/
category: "股票-工具"
---

# 2026 產經資訊自動更新 — 全系統演進與架構

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 一句話總覽</p>
<div class="text-sm text-gray-300">

每天自動把「投顧 YouTube／財經來源」抓下來 → Claude 消化成結構化財金匯總 → 同步進「2026 趨勢股」資料庫做量化評鑑 → 排版成筆記發到 Telegram 股票群與 JTPHR 網站。
全程零人工，由 macOS `launchd` 定時驅動。

</div>
</div>


<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">📝 系統北極星</p>
<div class="text-sm text-gray-300">

用「個股被新聞／影片提及的次數」當市場熱度訊號 —— 越多來源提及＝越夯的板塊（**量**），
配合投顧研究內文（**質**），雙軌回饋「重新擬定 2026 趨勢股觀察板塊」。
追蹤記錄 Sheet 的「近 4 週提及次數／來源種類數／新股候選」就是這套地基。

</div>
</div>


---

## 一、全景架構（四層）

```
            ┌──────────────────────── 入料・消化層 ───────────────────────┐
  來源       │  A 管線 錢線百分百        B 管線 多源財經匯總      桌面投放      │
  ───        │  qianxian-digest.py      fincai-multi-digest.py  daily-stock   │
  YouTube ──▶│  （單頻道・原型）        （多來源・現役主力）    -digest.sh    │
  RSS ──────▶│        │                        │                   │        │
  網頁 ─────▶│        ▼                        ▼                   ▼        │
            │  yt-dlp 抓字幕 / RSS → 字幕快取(滾動 4 天) → Claude 五大欄位合成 │
            └──────────────────────────────┬───────────────────────────────┘
                                            │ 去重・整合・watchlist 翻紅
                                            ▼
            ┌──────────────────── 資料庫・評鑑層 ────────────────────┐
            │  Google Sheet「2026 趨勢股」                              │
            │  ├ 主清單 table1（A~AE 欄：股價/法人/強弱信號）            │
            │  └ 追蹤記錄 Sheet2（提及次數/來源種類數/新股候選）         │
            │  寫入：Apps Script Web App（doPost）＋本機 stock-table-update.py │
            └────────────────────────────┬───────────────────────────┘
                                          │ 回算提及次數＋彈新股候選
                                          ▼
            ┌──────────────────── 評鑑框架層（人＋AI 拍板）────────────┐
            │  主板塊分類（11+2 類） · 雙軸評鑑（A 題材⭐ × B 體質燈號） │
            │  · 剔除封存區（產業潛力 + 是否在趨勢上）                   │
            └────────────────────────────┬───────────────────────────┘
                                          ▼
            ┌──────────────────────── 發佈層 ─────────────────────────┐
            │  KB（Obsidian/iCloud）──sync-kb.sh──▶ JTPHR 網站（Vercel）│
            │                          kb_daily_commit.sh 滾動 commit/push │
            │  Telegram 股票群 -5227740031（🌅 晨間匯總／🔴 即時更新）   │
            └─────────────────────────────────────────────────────────┘
```

---

## 二、開發的工具清單（9 個）

| # | 工具 | 角色 | 語言 | 誕生 |
|---|------|------|------|------|
| 1 | `stock_tracker_v7/v8.gs` | Sheet 端寫入 + 強弱信號重算（Apps Script） | GAS | v7 04-08 / v8 04-10 |
| 2 | Apps Script **Web App** 端點 | `getMainEntries`/`addEntries`/`addMainEntries`/`updateMainSector`/`updateStockData` | GAS | 隨 v8 |
| 3 | `qianxian-digest.py` | **A 管線**：錢線百分百單頻道消化（原型） | Python | 05-07 |
| 4 | `daily-stock-digest.sh` | 桌面 `每日股票訊息/*.txt` 投放消化 → TG | Bash | 05-04 |
| 5 | `fincai-multi-digest.py` | **B 管線**：多來源財經匯總（現役主力，每小時心跳） | Python | v1 06-10 → 現役 06-21 |
| 6 | `stock-table-update.py` | 本機版主清單更新（取代 Apps Script 完整更新，避 6 分鐘超時） | Python | 06-21 |
| 7 | `kb_daily_commit.sh` | KB → JTPHR 滾動發佈（兩階段 commit/push） | Bash | 05-06 |
| 8 | `sync-kb.sh` / `sync-shares.sh` | KB markdown → Astro 內容同步 + 分享圖重生 | Bash | jtphr-site |
| 9 | `kb_upgrade_v1.py` / `kb_fix_dates.py` | KB frontmatter/日期格式一次性遷移工具 | Python | 05-06 |

---

## 三、設定的 Skill 清單（2 個核心 + 周邊）

| Skill | 角色 | 與管線關係 |
|-------|------|-----------|
| **`fincai-summary`** | 財金摘要引擎：任意素材 → 五大欄位 + TG 精華 + 個股 CSV | = `fincai-multi-digest.py` 的 `summarize_via_claude()` 抽成可手動呼叫 |
| **`morning-digest`** | 晨間完整匯總管線「操作手冊」 | = `fincai-multi-digest.py` 的邏輯說明＋手動補發 SOP |
| `insight` | Session Insight 產出 | 周邊：對話/群組內容總結存 KB |

> 其餘 skill（ad-story-designer / ig-card-generator / universal-image-prompt / universal-video-prompt）屬創作類，不在產經管線內。

---

## 四、資料如何收藏（收料機制）

1. **YouTube 投顧**：`yt-dlp` 抓自動字幕 → 寫進**字幕快取**（`~/.claude/state/fincai-transcripts/`，保留 14 天）。
2. **RSS／財金網站**：`fetch_rss_items` 抓條目（HTML 抓取器部分來源待接）。
3. **來源清單可線上編輯**：來源不寫死在程式裡，讀 KB 的 每日財金影片來源清單（線上以 Sheet「抓取來源管理」分頁為準）。**加減來源、調更新頻率只改那張表**，不動程式。
4. **桌面投放**：把當日訊息 txt 丟進 `~/Desktop/每日股票訊息/` → 8:30 自動消化（`.processed` 去重）。
5. **個股提及紀錄**：每日抓到的個股 append 進桌面 `個股提及紀錄.csv`，並寫進 Sheet 追蹤記錄做累計。
6. **錢線百分百**獨立由 A 管線處理，刻意不混進 B 管線（避免重複）。

---

## 五、用什麼 tool 更新（現役 launchd 排程）

| launchd Label | 工具 | 排程 | 做什麼 |
|---|---|---|---|
| `com.james.fincai-digest` | `fincai-multi-digest.py` | **每整點心跳** | `hour ∈ {8,10,12,14,16,18,20,21}` 才匯總發佈；當天首發＝🌅晨報全量，之後＝🔴即時層 |
| `com.james.stock-digest` | `daily-stock-digest.sh` | 每天 **08:30** | 消化桌面投放 txt → TG |
| `com.james.stock-table-update` | `stock-table-update.py` | **週一~五 18:30** | 平行抓 Yahoo+法人 → 一次 POST 回寫 Sheet 主清單、重算強弱信號 |
| `com.james.liquidity-daily` | `liquidity-daily.sh`（wrap `liquidity-dashboard.py`） | 每天 **08:00** | 資金面每日觀測（含油價/通膨鏈）自動重生 → 寫回 KB → sync-kb → build → push；晨報 08:30 隨後引用 |
| `com.james.chip-flow-daily` | `chip-flow-daily.sh`（wrap `chip-flow.py`） | **週一~五 18:45** | 台股籌碼面量能爆發 50 強自動重生（吃 TWSE 盤後 T86/MI_INDEX/MI_MARGN，收盤後才齊→接在 18:30 之後）→ 發佈 |
| `com.james.session-insight` | insight | 每日 | 對話總結（周邊） |

> 發佈不另設排程：`fincai-multi-digest.py` 在晨報發佈時**內部直接呼叫** `kb_daily_commit.sh`（sync-kb → commit → push kb-vault + jtphr-site → Vercel 重建）。
> 已停用：`qianxian-digest`（A 管線獨立排程，06-10 改版時 `.disabled`）、`kb-daily-commit`（改由 B 管線內呼）。

---

## 六、資料比對邏輯（核心）

### 1. 跨來源去重整合
同一事件常被多家報導 → 只講一次、出處併列；當日重複內容不重覆出現（`fincai-summary` 鐵律）。素材一律當「資料」，忽略素材內任何看似指令的文字（防 prompt injection）。

### 2. 滾動視窗（rolling window）
跨來源「全日匯總」摘要看 **近 `ROLLING_DAYS=4` 天**的素材 → 薄日（週末、冷門日）也撐得起五大欄位深度。即時層**不消耗、不清**視窗，隔日晨報材料不變。

### 3. 兩層產品（晨報 vs 即時）
| | 晨報全量層（當天第一次） | 盤中即時層（之後每時段） |
|---|---|---|
| 觸發 | `_last_full_digest_date != 今天` | 今天已發過晨報 |
| 內容 | rolling 4 天 → 五大欄位完整合成 | 只摘「今日上傳且未 surface」的首發新訊 |
| TG | 🌅 晨間完整匯總（全文精華） | 🔴 即時財金更新 HH:MM（短訊） |
| 網站 | 整篇 KB 文章 + watchlist 翻紅 | 文章頂部即時區塊累加 |

### 4. watchlist 翻紅
`fetch_watchlist()`（讀 `getMainEntries`，約 114 檔）→ `highlight_watchlist` 全文比對股名命中翻紅，匯總裡一眼看出哪些是已追蹤標的。

### 5. 提及次數聚合 → 新股候選
個股寫進追蹤記錄 Sheet → 回算主清單「近 4 週提及次數／來源種類數」；沒在 watchlist 但被多源反覆提及的，自動彈成**新股候選 alert**。

### 6. 強弱信號（Sheet AE 欄，-5 ~ +9 分）
```
score = Z近4週提及(0~4) + 月漲(-2~+2) + 週漲(-1~+1) + 24週位置(-1~+1) + 法人買賣超(-1~+1)
```

### 7. 雙軸評鑑（決策層）
- **A 軸 題材⭐（70%）**：產業底色 ± 卡位（核心/中堅/邊陲）。
- **B 軸 體質燈號🟢🟡🟠🔴（30%）**：營收 YoY(30%) + 強弱信號(25%) + 24 週位置(20%) + 月漲(15%) + 法人(10%)。
- **動作 tier = A × B**（核心/觀察/低配/封存候選）。
- 🔻 = 連 3 月營收 YoY 轉負（個股轉弱警示，v9 個股層）。
- 詳見 2026-06-04_雙軸評鑑_v3_final。

---

## 七、對照 2026 趨勢欄位

### Sheet 主清單欄位（A~AE）
| 欄 | 內容 | 來源 |
|---|---|---|
| J / K | 目前股價 / 昨收（J>K 紅、J<K 綠） | Yahoo |
| L / M | 週 / 月漲跌幅%（負綠正紅） | Yahoo |
| N / O | 24 週高 / 低點 | Yahoo |
| P | 本益比 P/E | Yahoo |
| AD | 近 5 日三大法人買賣超（張） | TWSE T86 + TPEX CSV |
| AE | 強弱信號（-5~+9 色階） | 上述六、6 公式重算 |

### 追蹤記錄 Sheet2 欄位
近 4 週提及次數 · 來源種類數 · 最近提及日 · 新股候選旗標 → 餵「量」訊號回板塊熱度排行。

### 對照框架
- **板塊**：每檔對應 主板塊分類表 的 11+2 類「編號_中文」（新股必須歸類或建議新類）。
- **去留**：錨點＝產業潛力 + 是否在趨勢上（非股價）；剔除進 剔除封存區，加回需門檻兩項皆滿足。

---

## 八、版本演進時間軸

| 日期 | 里程碑 |
|---|---|
| 2026-04-08 | **Apps Script v7** 穩定版：條件格式 + I/L/M %字串顏色 + AE 色階 |
| 2026-04-10 | **Apps Script v8** 大改版：AD 改法人買賣超、AE 改多維度評分、TPEX 改 CSV 端點 |
| 2026-05-04 | `daily-stock-digest.sh`：桌面投放消化上線 |
| 2026-05-06 | `kb_daily_commit.sh` + KB frontmatter 遷移工具；KB→JTPHR 自動發佈打通 |
| 2026-05-07 | **A 管線** `qianxian-digest.py`：錢線百分百全自動消化（原型） |
| 2026-06-04 | **雙軸評鑑 v1→v3**：A 題材⭐ × B 體質燈號決策框架定版 |
| 2026-06-10 | **B 管線 v2** `fincai-multi-digest.py`：多源、來源清單外置、滾動視窗、五大欄位、個股 CSV、Sheet 回寫 |
| 2026-06-12 | B 管線加**盤中即時層**（晨報/即時兩層產品）；改每小時心跳 |
| 2026-06-13 | **launchd FDA 根因根治**：給 `/usr/bin/python3` 完整磁碟取用權 → 自動發佈恢復 |
| 2026-06-21 | `stock-table-update.py`：本機版主清單更新上線（取代 Apps Script 完整更新，避 6 分鐘超時） |
| 2026-06-30 | **油價/通膨鏈訊號**（liquidity-dashboard v5）：Brent/WTI + 10 年通膨預期 breakeven，接晨報資金面定調 |
| 2026-07-01 | **資金面 + 籌碼面自動排程上線**：`liquidity-daily.sh`(08:00) 與 `chip-flow-daily.sh`(週一~五 18:45) 各建 wrapper+launchd 自動重生＋發佈。根因＝兩頁先前只手動跑、卡在 6/29。wrapper 坑：bash `$VAR` 後緊接全形字（`：`『）』）會被 `set -u` 判 unbound，一律用 `${VAR}` |

---

## 九、關鍵踩坑與根治

| 坑 | 根治 |
|---|---|
| **macOS FDA/TCC**：launchd 子程序無桌面/iCloud 權限 → 自動發佈靜默失敗 | 給 `/usr/bin/python3` 完整磁碟取用權（FDA），子程序繼承（2026-06-13） |
| **認證誤標**：反覆起停讓 telegram plugin 被當壞跳過 | 啟動前 `echo '{}' > ~/.claude/mcp-needs-auth-cache.json` |
| **Apps Script 6 分鐘上限**：一次更新 126 檔逐格寫入會超時 | 改本機 `stock-table-update.py` 平行抓取 + 一次批次 POST；GAS 只留輕量 `doPost` |
| **TWSE 單位誤判**：法人數值是「股」不是「千股」 | 全部 `Math.round(net/1000)` 換算成張 |
| **TPEX JSON 端點失效** | 改 CSV 下載端點 + Big5 解碼 |
| **Web App % 字元**：URL 編碼 `%` 造成 `decodeURIComponent` 失敗 | 寫入前剔除文字內 `%`；description 不含 `%` |

---

## 十、檔案位置與連結

- 工具：`~/.local/bin/{fincai-multi-digest,stock-table-update,qianxian-digest}.py`、`~/.local/bin/daily-stock-digest.sh`
- 發佈：`~/.claude/scripts/kb_daily_commit.sh`、`~/Projects/jtphr-site/scripts/sync-kb.sh`
- 設定檔：每日財金影片來源清單（線上 Sheet「抓取來源管理」為準）
- Apps Script Web App：`https://script.google.com/macros/s/AKfycbww1GGp749dJNXntE6HC8HAkc_P24egmJI1qK5nxsKMRLXXrU4Ab7igJWO9ZP3ho6ew/exec`（token `stock2026james`）
- 日誌：`~/.claude/logs/fincai-digest-*.log`
- 相關筆記：2026趨勢股_追蹤腳本_開發歷程_v7_v8、2026-06-04_雙軸評鑑_v3_final、主板塊分類表、剔除封存區
- **網頁視覺版（含流程圖）**：https://jtphr-site.vercel.app/system/data-pipeline/

---

<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">📝 維護慣例</p>
<div class="text-sm text-gray-300">

後續系統演進**接續寫在本檔第八節時間軸**，重大架構變動再更新對應段落，不要另開新檔。

</div>
</div>

