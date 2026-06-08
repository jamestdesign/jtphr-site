---
title: fcpxmld-export — FCPX 撿片出圖工具（工作說明）
date: 2026-06-08
creator: robert
co_creators:
  - james
tags:
  - 攝影
  - 剪輯
  - 影片
  - 自動化
  - workflow
  - skill
  - fcpxml
aliases:
  - fcpxmld-export
  - 9V-c 批次出圖工具
  - FCPX 撿片出圖
來源: 2026-06-08 James 1-on-1 拍板（北海道 day1/day4 出圖 + 工具定型）
連結: _attachments/
version: 1
category: "其他"
---

# fcpxmld-export — FCPX 撿片出圖工具（工作說明）

> James 拍板（2026-06-08）：「之前已經都是這樣匯出，請做成工作說明，不要每次都不一樣。」
> 此文鎖死自動化出圖段的**固定 I/O 慣例**，每趟 trip 都照這個跑，不再每次變。
> 對應 pipeline 步驟 **9V-c 批次出圖**（見 project-video-kb-v2-1 / 影片素材_VLM抽幀_腳本剪輯_SOP）。

## 角色分工（兩段，別混）

| 段 | 誰做 | 內容 |
|----|------|------|
| **人工撿片** | James（FCPX） | i/o 框範圍 + keyword/star 註記。**不可外包的藝術判斷**。詳見下方撿片 schema。 |
| **自動化出圖** | Robert（本工具） | 讀 `.fcpxmld` → 切 HL 片段 + 抽 KP 單禎 → 分場景輸出 + 寫 LR 可讀標註。 |

> 🔭 未來方向（James）：人工撿片段日後找 **AI 代理人**（VLM 看片自動標 star/KP/HL）替代。見 project_todo_video_autopilot_kit。

## 工具

- **指令**：`fcpxmld-export <path/to/xxx.fcpxmld>`
- **engine**：`~/Desktop/Claude-Workspace/photo-grade/tools/fcpxmld-export.py`
- **CLI shim**：`~/.local/bin/fcpxmld-export`
- **前置**：`ffmpeg` + `exiftool`（已裝）；素材 SSD 掛載（X10 Pro2）

## 人工撿片 schema（James 在 FCPX 標，工具讀）

- **KP_R / KP_Y / KP_G / KP_P**（keeper 單禎）：i/o 同一禎 + 該 keyword。R=臉/人像、Y=背影、G=風景、P=物件。→ 抽原生解析度 JPG。
- **Star4 / Star5**（HL 精彩瞬間）：clip 給 4★/5★，段邊界 = i/o 範圍。→ 切 1080p H.264 片段。
- **Star3**：只記不切（非 HL）。
- **Star1「長篇發表（去 NG）」**：i/o 框整段 + 段內壞鏡頭按 Delete(Reject) → 「移除 Reject 段後 concat 成一支」。成品**也匯出到 `_preview_mov_HL/<場景>/`**，但**檔名標 `Star1`**（James 從檔名即知這是 Star1 去 NG 長片），屬「**另外出片**」（獨立長片成品，非 Star4/5 那種動態照片短片）。⚠️ **本工具目前尚未實作此 concat，待補**。

## 輸出慣例（🔒 鎖死，不要每次不一樣）

```
<trip>/_preview_mov_KP/<場景>/    ← KP 單禎 JPG
<trip>/_preview_mov_HL/<場景>/    ← HL 片段 mp4
```

> 檔名定案（James 2026-06-08）：`_preview_mov_KP` / `_preview_mov_HL` —— 一眼看出是「mov 導出的預覽檔」，好辨識。

- `<場景>` = **day 場景夾名**（如 `day1 趕赴札幌帝王蟹之旅/1801 札幌薄野蟹本家品蟹`）。
- ⚠️ **素材解析鐵則**：FCP 常把素材託管進 `.fcpbundle`，XML 的 media-rep 會指向 bundle 內副本。工具的 `resolve()` **一律優先用 day 場景夾的原檔**（大小寫不敏感、排除 bundle/fcpxmld），輸出才會落到正確場景；**絕不可**讓輸出套進 `…fcpbundle/…/Original Media/` 深層路徑。
- 檔名：KP = `{原檔名}_KP{色}_t{時碼}.jpg`；HL = `{原檔名}_{Star4/5}_{序號}.mp4`。

## LR 可讀標註（KP JPG，exiftool 寫）

| 欄位 | 內容 |
|------|------|
| `XMP:Label`（色標） | R→Red / Y→Yellow / G→Green / P→Purple |
| `Keywords` | `KP_{色}` + 場景關鍵字 |
| `Source` | `{來源檔} @ t={時碼}s` |
| `XMP-dc:Description` | KP 色（中文義）｜來源｜場景 |
| `XMP-lr:hierarchicalSubject` | `影片來源|{clip}` |

→ LR import 直接讀色標 + 關鍵字，不用再標。色標對照見 reference_lr_xmp_dev。

## 色彩（HLG→SDR）

依每支素材 `<format>` colorSpace 自動判定：
- **Rec.2020 HLG**（iPhone `IMG_*.MOV`）→ zscale+tonemap=hable 轉 Rec.709 SDR（直抽會灰）。
- **Rec.709**（手機 `VID*.mp4`）→ 原樣。

## 實證

- 2026-06-06 day2（115-05-26）：KP 61 + HL 42，零錯誤。
- 2026-06-08 day1（115-05-25）：HL 25 + KP 10；day4（115-05-28）：HL 6 + KP 1（4HL+1KP 走 HLG→SDR），零錯誤。

## 待補 / 日後個別優化

- [ ] Star1「去 NG」concat（移除 Reject 段拼檔）。
- [ ] **套 LUT**（James 2026-06-08「之後還要加上套 LUT，找時間來嘗試」）：出圖時對 HL 片段 / KP 單禎套用 LUT 調色，ffmpeg `lut3d` filter，與 HLG→SDR tonemap 串接順序待測。
- [ ] 正式 KB 化（含人工撿片完整注意事項）→ 屬知識庫建構，需 loop Robin（@jamestang_bot，走群）。
- [ ] AI 代理人撿片工具調研（待 James 點頭）。
