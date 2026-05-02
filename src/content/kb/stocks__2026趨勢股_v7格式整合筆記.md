---
title: "2026趨勢股 v7格式整合筆記"
category: "股票"
---
# 2026趨勢股 Google Sheets v7 格式整合筆記

**日期：** 2026-04-08  
**版本：** stock_tracker_v7_stable.gs  

---

## 完成的格式設定

| 欄位 | 說明 | 格式規則 |
|------|------|---------|
| J（目前股價） | 數字 | 小數兩位 ＋ J>K→紅字、J<K→綠字 |
| K（昨日收盤價） | 數字 | 小數兩位，無顏色 |
| N（24週高點） | 數字 | 小數兩位，無顏色 |
| O（24週低點） | 數字 | 小數兩位，無顏色 |
| I（持倉漲跌幅%） | %字串 | 負值→綠字，正值→紅字 |
| L（週漲跌幅%） | %字串 | 負值→綠字，正值→紅字 |
| M（月漲跌幅%） | %字串 | 負值→綠字，正值→紅字 |
| P（本益比P/E） | 整數 | 無格式，無顏色 |
| AE（強弱信號） | 數值 | 色階：最小綠 → 中間黃 → 最大紅 |

---

## 關鍵實作細節

### 資料儲存型別
- N、O 用 `parseFloat(Math.max/min.apply(...).toFixed(2))` → 確保存成**數字**，不是字串
- I、L、M 用 `.toFixed(2) + '%'` → 存成**字串**，保留 % 符號
- P 用 `Math.round()` → 存成**整數**

### 顏色判斷邏輯
- %字串欄位（I、L、M）無法用數值比較，改用首字元判斷：
  - 負值：`=LEFT(欄,1)="-"`
  - 正值：`=AND(LEN(欄)>1,LEFT(欄,1)<>"-")`
- 避免使用 `IFERROR(VALUE(SUBSTITUTE(...)))` → 在 Apps Script 條件格式不穩定

### 條件格式規則管理
- **不能用** `sheet.clearConditionalFormatRules()` → 會清掉所有欄位，包含使用者自訂的 L、M、AE 規則
- **正確做法**：只清除指定欄位（H、I、J、K、L、M、O、P、AE）的舊規則，其他欄位保留

```javascript
var clearCols = [cH, cI, cJ, cK, cL, cM, cO, cP, cAE].filter(c => c > 0);
var rules = sheet.getConditionalFormatRules().filter(rule =>
  rule.getRanges().every(rng => clearCols.indexOf(rng.getColumn()) === -1)
);
```

---

## 踩過的坑

1. **N/O 格式無效** → `.toFixed(2)` 回傳字串，`setNumberFormat('0.00')` 對字串無效 → 改 `parseFloat()`
2. **清除規則太徹底** → `clearConditionalFormatRules()` 把 L、M、AE 的規則也清掉 → 改精準清除
3. **%字串顏色失效** → `IFERROR(VALUE(SUBSTITUTE(...)))` 在 Apps Script 不穩定 → 改 `LEFT()` 首字元判斷
4. **殘留舊規則** → 歷史版本在 H、O、P 欄留下條件格式，需納入清除清單

---

## applyColumnFormatting_() 呼叫時機
- 在 `updateStockPrices()` 執行完畢後自動呼叫
- 每日自動更新（每天15:00）也會觸發
