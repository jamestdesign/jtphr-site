---
title: FCPXML 拼貼 grid transform 校正（含單位坑）
date: 2026-07-12
creator: robert
co_creators: []
tags:
  - 影片
  - fcpxml
  - 拼貼
  - grid
  - transform
  - 校正
  - current-truth
aliases:
  - 拼貼grid校正
  - grid transform
  - FCPXML position 單位
category: "其他"
---

# FCPXML 拼貼 grid transform 校正（含單位坑）

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 為什麼有這頁（2026-07-12 James 明令）</p>
<div class="text-sm text-gray-300">

這個 position 單位坑 **上次就更正過，但只留在 Robert 記憶、沒寫進 KB**，結果 day2 移動中 v4 又踩一次（James 截圖抓到 inspector 顯示 6912px）。**動工做拼貼 grid 前先看這頁。** 相關 memory reference_grid_transform_calibration、reference_fcpxml_schema_gotchas。

</div>
</div>


## 🚨 單位坑（最重要）

FCPXML `<adjust-transform position="X Y">` 的值 **不是像素**。

- **單位 = 畫布高的 1%** = `canvas_height / 100` px／單位。
- 1080p 畫布 → **10.8 px／單位**。
- 要讓 FCP inspector 顯示 **±640 px**，FCPXML 原始值要寫 **640 ÷ 10.8 = ±59.26**。
- 誤寫 `640` → FCP 讀成 640 單位 = **6912 px**（整個飛出畫面）。← 就是這個坑。
- 9:16（1920 高）→ 19.2 px／單位；640px = `640/19.2` = **33.33**。
- **scale 不受影響**：是純比例，`1.053` = inspector 105.3%，直接對應。

換算公式：`FCPXML值 = 目標px × 100 / canvas_height`

## 📐 校正表（inspector px 值，James 校正過）

軸向由「**專案比例 × 素材方向**」決定：

| 專案 | 素材方向 | 軸 | position（inspector px） | scale | crop |
|---|---|---|---|---|---|
| **16:9 橫** | 直式 portrait | X | **−640 / 0 / +640** | **1.0（留框，見下）** | 不 crop |
| **9:16 直** | 橫式 landscape | Y | **+640 / 0 / −640** | 填滿寬 | 不 crop |
| 1:1 方 | 混合 | — | 四角 (±480, ±270) | 裁至 1:1 | 依素材 |

- 上表是 **inspector 顯示值**；寫進 FCPXML 記得先除 10.8（1080p）→ 例如 −640px 寫成 `-59.26`。
- 🎨 **scale 用 100%（James 2026-07-12 拍板）**：直式 4K 原檔 fit 後約 608 寬，放在 640 寬的 1/3 裡 scale 1.0 會**留一點空隙／框**——James 覺得「留一點裁切比較好看」，**不要放大填滿**。（曾算過 ×1.053 可填滿 640，但 James 選擇不填、留框。要填滿才用 1.053。）
- **例外（保留匡）**：橫式素材硬塞 16:9 直向三格、想留一點邊框 → **crop left 645 / right 645**。

## 三格為何剛好對齊

1920 寬畫布：三格中心 −640 / 0 / +640 px，每格素材縮到 640 寬 → 左格 [−960,−320]、中格 [−320,+320]、右格 [+320,+960]，邊緣相接、填滿無縫。

## 落地位置

- 產生器 `mtv/build_fcpxml4.py`：`PX2U = 100/1080`、`POSX = 640*PX2U`。
- 初剪選擇器 `photonb/initcut-spec-picker.html` 拼貼版型段：選比例即時顯示對應數值（顯示的是 inspector px）。
- day2 移動中 pilot = 16:9＋直式 → 第一列（±640px→FCPXML ±59.26 / scale 1.053 / 不 crop）。
