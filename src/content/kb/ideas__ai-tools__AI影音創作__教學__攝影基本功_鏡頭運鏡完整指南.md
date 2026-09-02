---
title: 攝影基本功 — 鏡頭運鏡完整指南
date: 2026-04-11
來源: 用戶整理 + universal-video-prompt skill 八層架構
連結: https://wilson-men.tw/3-skill/
tags:
- AI工具
- AI影音
- 教學
- 攝影基礎
- 鏡頭語言
- 運鏡
aliases:
- 鏡頭運鏡指南
- 攝影術語
- 鏡頭語言基本功
creator: claude_robin
co_creators:
- james
managed_by: claude_robin
managed_at: '2026-05-06'
transformed: false
private: false
published: false
version: 1
last_revised: null
revision_history: []
category: "AI影音-教學"
---

# 攝影基本功 — 鏡頭運鏡完整指南

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 這份筆記的角色</p>
<div class="text-sm text-gray-300">

把 威森的 universal-video-prompt 八層架構 跟用戶提供的鏡頭術語教學整合成一份**可作為查詢手冊**的完整指南。
用途：寫影片 prompt 之前先翻這份，找出對的鏡頭語言。

</div>
</div>


---

## 📐 為什麼要懂鏡頭語言

**鏡頭語言 = 把抽象情緒翻譯成具體畫面**

當你跟 AI 說「我要拍一個感人的廣告」，AI 不知道怎麼拍。
但你說「**ECU 大特寫眼角的淚光、static 靜態鏡頭、soft focus 柔焦、warm amber tones 暖琥珀色調**」，AI 立刻能產出對的東西。

這就是「八層漢堡公式」存在的價值。

---

## 🍔 八層漢堡公式（universal-video-prompt 架構）

每個影片鏡頭的 prompt 由 8 層組成，從最基本的「拍多遠」一路堆到「整體色調」：

```
       色調 Color
       光線 Lighting
       主體 Subject       ← 動什麼
       焦點 Focus
       運鏡 Movement
       角度 Angle
       鏡頭類型 Shot Type
       景別 Medium        ← 拍多遠（最底層）
```

接下來逐層展開。

---

## 第 1 層：Medium（景別 / 鏡位大小）

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 核心觀念</p>
<div class="text-sm text-gray-300">

景別決定了**觀眾與角色之間的「心理距離」**。
越特寫 → 越親密、越情緒；越遠 → 越客觀、越環境。

</div>
</div>


### 8 種標準景別

| 縮寫 | 全名 | 中文 | 教學說明 | 何時用 |
|------|------|------|---------|--------|
| **ECU** | Extreme Close-Up | 大特寫 | 專注於極小細節（眼睛、手指、流汗），用來強化情緒壓力 | 情緒高張、關鍵物件 |
| **CU** | Close-Up | 特寫 | 填滿畫面的頭部/臉部，展示角色的細微情緒 | 對話、表情戲 |
| **MCU** | Medium Close-Up | 中特寫 | 胸部以上到頭頂，**最常見的對話鏡頭** | 訪談、對白、肖像 |
| **MS** | Medium Shot | 中景 | 腰部以上到頭頂，能看清角色動作與部分環境 | 動作展示、對話 |
| **MFS** | Medium Full Shot | 中全景 | 膝蓋以上到頭頂，也稱「**牛仔鏡頭**」（Cowboy Shot），常用於對峙場面 | 西部片、雙人對峙 |
| **FS** | Full Shot | 全景 | 角色全身都在畫面內，強調角色在當前環境中的位置 | 舞蹈、武打、環境融入 |
| **WS** | Wide Shot | 遠景 / 寬景 | 環境比例大於角色，強調空間感 | 場景建立、孤獨感 |
| **EWS** | Extreme Wide Shot | 大遠景 | 角色渺小甚至看不見，用來交代壯闊的地理環境 | 自然紀錄片、史詩開場 |

### 選擇原則

<div class="not-prose my-6 bg-green-500/10 border-l-4 border-green-500 rounded-r-lg p-4">
<p class="font-bold text-green-400 mb-2">💡 Tip</p>
<div class="text-sm text-gray-300">

- **情緒戲** → CU / MCU
- **動作戲** → MS / MFS
- **建立環境** → WS / EWS
- **產品細節** → ECU
- **對話戲（標準）** → MCU 是 80% 場景的安全選擇

</div>
</div>


### 範例 prompt 寫法

```
ECU of a single tear forming at the corner of an eye, ...
```
```
MCU of two characters facing each other across a wooden table, ...
```
```
EWS of a lone figure walking through a vast desert at sunset, ...
```

---

## 第 2 層：Shot Type（鏡頭類型）

不同的「拍攝視角」會產生不同的敘事效果。

### POV (Point of View) — 主觀鏡頭

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 Quote</p>
<div class="text-sm text-gray-300">

將攝影機模擬成角色的「**雙眼**」。觀眾看到的畫面就是角色看到的景物。

</div>
</div>


**特性**：
- 極大增強代入感
- 常用於**恐怖片**（凶手視角）
- 常用於**動作片**（第一人稱視角）
- 常用於**遊戲畫面**

**範例**：
```
POV shot of a hand reaching out to open a creaking door, dim light from behind
```

### 其他常用 Shot Type

| 類型 | 中文 | 用途 |
|------|------|------|
| Over-the-shoulder shot | 過肩鏡頭 | 對話戲，從一方肩膀看另一方 |
| Two-shot | 雙人鏡頭 | 兩人同框互動 |
| Insert shot | 插入鏡頭 | 物品/細節特寫插入主敘事 |
| Establishing shot | 環境建立鏡頭 | 場景開場交代地點 |
| Reaction shot | 反應鏡頭 | 拍角色聽到/看到事情後的反應 |

---

## 第 3 層：Angle（角度）

攝影機在什麼**高度**？這影響觀眾對主體的心理判讀。

| 角度 | 英文 | 心理效果 |
|------|------|---------|
| 平視 | Eye level | 自然、平等 |
| 仰角 | Low angle | 主體顯得**強大、英雄、威嚴** |
| 俯角 | High angle | 主體顯得**弱小、無助、被觀察** |
| 鳥瞰 | Bird's eye view | 上帝視角、客觀宏觀 |
| 蟲視角 | Worm's eye view | 極端仰角，戲劇張力 |
| 歪斜角 | Dutch angle | **不安、混亂、心理失衡** |

---

## 第 4 層：Movement（運鏡 / 鏡頭運動）

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 核心觀念</p>
<div class="text-sm text-gray-300">

動態鏡頭能**賦予畫面生命力**，**引導觀眾的注意力**。

</div>
</div>


### 11 種運鏡完整教學

#### Static（靜態鏡頭）
攝影機完全不動。
- 用途：營造**穩定、壓抑或觀察者**的感覺
- 適合：循環廣告、訪談、靜物、冥想場景
- 範例：訪談時的固定鏡頭

#### Pan（水平搖鏡）
攝影機底座不動，鏡頭**左右**旋轉。
- 模擬：人轉頭看的動作
- 用途：跟隨水平移動的物體、揭示寬廣場景
- 範例：跟拍跑過的車

#### Tilt（垂直搖鏡）
攝影機底座不動，鏡頭**上下**旋轉。
- 用途：展現高大建築、從腳到頭觀察人物
- 範例：從鞋子往上 tilt 到臉，展示角色全貌

#### Dolly（推拉鏡頭）
攝影機架在軌道上「**實體前進**」或「**後退**」。
- 關鍵差異：跟 Zoom 不同，**會改變背景的透視感**
- 效果：讓觀眾更靠近角色心境
- 範例：Dolly in 進入角色的內心世界

<div class="not-prose my-6 bg-yellow-500/10 border-l-4 border-yellow-500 rounded-r-lg p-4">
<p class="font-bold text-yellow-400 mb-2">⚠️ Dolly vs Zoom</p>
<div class="text-sm text-gray-300">

Dolly 是「腳走過去」，Zoom 是「眼睛瞇起來」。Dolly 透視會變、Zoom 不會。專業片絕大多數選 Dolly。

</div>
</div>


#### Tracking shot（跟拍鏡頭）
攝影機**跟隨角色並排移動**。
- 效果：陪著角色前進的動態感
- 範例：跟著主角走過大廳

#### Crane shot（搖臂鏡頭）
攝影機安裝在吊臂上，進行**高低落差極大**的運動。
- 用途：大場面的**開場**或**結尾**
- 範例：從高空俯瞰戰場 → 緩緩降到主角身邊

#### Handheld（手持鏡頭）
攝影師直接手持，畫面有**自然的晃動感**。
- 用途：紀錄片風格、戰爭、營造**不安**情緒
- 範例：戰場第一人稱、災難現場

#### Zoom（變焦）
攝影機不動，僅調整鏡頭焦距（放大/縮小）。
- 特性：**畫面透視不變**，但物體看起來更近
- 注意：跟 Dolly 不一樣！Zoom 是壓縮，Dolly 是位移
- 範例：突然 Zoom in 強調震驚

#### Orbit / Arc shot（環繞鏡頭）
攝影機圍繞著主體做 **360 度圓周運動**。
- 用途：**英雄時刻**或**孤立感**
- 範例：主角覺醒的瞬間、漫威英雄登場
- AI 影片技巧：對 Kling/Runway 描述「camera orbits around the subject」

#### Whip pan（甩鏡）
**極快速的 Pan**。
- 效果：畫面因為速度過快而模糊
- 用途：**轉場**或強調兩個物體間的關聯
- 範例：甩到左邊 → 切換場景 → 甩回來

### 運鏡選擇原則

<div class="not-prose my-6 bg-green-500/10 border-l-4 border-green-500 rounded-r-lg p-4">
<p class="font-bold text-green-400 mb-2">💡 Tip</p>
<div class="text-sm text-gray-300">

| 想要的效果 | 選什麼運鏡 |
|-----------|-----------|
| 穩定質感 | Dolly / Crane / Static |
| 真實紀錄感 | Handheld |
| 戲劇張力 | Slow zoom in |
| 動態能量 | Tracking / Orbit |
| 循環廣告 | Static（首尾一致才能 loop）|
| 揭示空間 | Pan / Tilt |
| 強烈轉場 | Whip pan |

</div>
</div>


---

## 第 5 層：Focus（焦點運用）

<div class="not-prose my-6 bg-gray-500/10 border-l-4 border-gray-500 rounded-r-lg p-4">
<p class="font-bold text-gray-400 mb-2">📌 Quote</p>
<div class="text-sm text-gray-300">

焦點不僅是清晰度，**更是說故事的工具**。

</div>
</div>


### Rack focus（變焦 / 換焦）
在同一個畫面中，將**焦點從前景的主體轉移到背景的主體**（或反之）。

- 效果：**引導觀眾的視線**，揭示隱藏的信息
- 經典範例：前景拍 A 角色臉，rack focus 到背景的 B 角色 → 揭示伏筆

### Split diopter（分離焦距鏡）
使用特殊濾鏡，讓畫面中**極近處和極遠處的景物「同時清晰」**。

- 特性：傳統攝影中很難達成（自然景深做不到）
- 效果：**超現實且充滿資訊量**
- 經典範例：杜比恩、布萊恩狄帕瑪的電影中常見

### Soft focus（柔焦）
故意讓畫面看起來**霧濛濛、輪廓模糊**。

- 用途：**回憶、夢境**，或在老電影中**美化女主角的皮膚**
- 效果：浪漫、夢幻、懷舊
- 範例：婚紗影片、回憶鏡頭

### 其他焦點手法

| 術語 | 中文 | 效果 |
|------|------|------|
| Shallow depth of field | 淺景深 | 主體清晰、背景糊（人像最常用）|
| Deep focus | 全域對焦 | 前後景都清楚（紀錄片、奇士勞斯基電影）|

---

## 第 6 層：Subject（主體）

主體要寫得**具體到 AI 看得到**。

### 寫法規則

| ❌ 抽象 | ✅ 具體 |
|--------|--------|
| 「漂亮的女人」 | 「porcelain skin, almond eyes, wearing a vintage silk dress」 |
| 「站著」 | 「leaning against a weathered brick wall, arms crossed」 |
| 「開心」 | 「a subtle smile forming at the corner of the lips」 |
| 「夾克」 | 「worn denim jacket with frayed cuffs」 |

### 動作要有起始與結束

❌ 「他在喝咖啡」
✅ 「He picks up the ceramic mug from the table, blows softly on the surface, then takes a slow sip」

---

## 第 7 層：Lighting（光線）

光線決定情緒。寫 prompt 時**先想要什麼情緒，再選光線**。

### 常用 8 種影片光線

| 英文 | 中文 | 情緒 |
|------|------|------|
| Natural golden hour light | 黃金時段自然光 | 溫暖、希望、商業 |
| Soft window light | 柔和窗光 | 親密、寧靜、生活 |
| Dramatic chiaroscuro | 明暗對比光 | 戲劇、神秘、油畫感 |
| Neon ambient glow | 霓虹環境光 | 賽博龐克、夜城、未來 |
| Overhead fluorescent | 頭頂日光燈 | 辦公室、官僚、冷漠 |
| Backlit haze | 逆光煙霧 | 神秘、夢幻、英雄登場 |
| Practical lights | 場景內實際光源（檯燈、螢幕光）| 真實、有故事 |
| Candlelit warmth | 燭光暖調 | 浪漫、復古、儀式 |

---

## 第 8 層：Color（色調）

整體色彩氛圍。

| 英文 | 中文 | 用途 |
|------|------|------|
| Warm amber tones | 暖琥珀色調 | 懷舊、回憶、家庭 |
| Cool blue desaturated | 冷藍去飽和 | 科技、悲傷、孤獨 |
| High contrast cinematic | 高對比電影感 | 商業廣告、預告片 |
| Pastel muted palette | 粉彩柔和色盤 | 文青、IG 風 |
| Monochromatic | 單色調 | 藝術、復古、紀錄片 |
| Teal and orange | 青橙對比（好萊塢經典）| 商業片、爽片 |
| Earthy natural tones | 大地自然色調 | 自然、有機、紀錄片 |
| Vibrant saturated | 鮮豔飽和 | 動畫、卡通、廣告 |

---

## 🎯 八層整合範例：拆解一個 prompt

以 影片_AI模特舉杯聞香_Kling 為例：

```
profile head-and-shoulders                          ← Medium (MCU)
[隱含 insert shot 因為產品入鏡]                       ← Shot Type
[隱含 eye level，由參考圖決定]                         ← Angle
Camera is static                                    ← Movement (Static)
shallow depth of field, 85mm look                   ← Focus
single natural blink, subtle chest breathing,
fingers make a tiny adjustment on a tumbler         ← Subject
golden-hour side lighting                           ← Lighting
clean light-beige/gray background, premium look    ← Color
```

每一層都對應到八層公式中的一格。漂亮、可掃讀、AI 看得懂。

---

## 🛠 實戰用法：寫 AI 影片 prompt 的 SOP

**Step 1**：先想清楚「我要傳達什麼情緒」
**Step 2**：用八層公式從**底層往上**填：
1. 我要拍多遠？（Medium）
2. 用什麼視角？（Shot Type）
3. 攝影機在哪個高度？（Angle）
4. 鏡頭怎麼動？（Movement）
5. 對焦在哪？（Focus）
6. 主體在做什麼？（Subject）— **這裡寫最具體**
7. 光從哪來？（Lighting）
8. 整體什麼色調？（Color）

**Step 3**：組成英文 prompt
**Step 4**：丟給 universal-video-prompt skill 檢查並產出多平台版本

或更簡單：直接跟 Claude 說「用 universal-video-prompt 幫我寫一個 [情境] 的影片」，skill 會自動套用八層架構。

---

## 🎬 各情境推薦組合（速查）

### 商業廣告 — 產品 Hero Shot
```
Medium: ECU/CU
Movement: slow dolly in
Focus: shallow depth of field, 85mm
Lighting: dramatic side lighting
Color: high contrast cinematic
```

### 訪談 / 對話戲
```
Medium: MCU
Movement: static
Focus: shallow depth of field
Lighting: soft window light
Color: warm amber tones
```

### 動作戲
```
Medium: MS / MFS
Movement: tracking shot or handheld
Focus: deep focus
Lighting: practical + dramatic
Color: high contrast or teal-orange
```

### 紀錄片
```
Medium: 多種混搭
Movement: handheld
Focus: deep focus
Lighting: natural existing light
Color: earthy natural tones
```

### 浪漫 / 婚紗
```
Medium: CU / MCU
Movement: slow dolly / orbit
Focus: soft focus
Lighting: golden hour / candlelight
Color: warm amber, pastel
```

### 驚悚 / 懸疑
```
Medium: ECU + WS 交錯
Angle: low angle / dutch angle
Movement: handheld + slow zoom in
Focus: rack focus
Lighting: backlit haze, practical
Color: cool blue desaturated
```

### IG / TikTok 商品
```
Medium: MCU
Movement: static (循環) 或 quick dolly
Focus: shallow depth of field
Lighting: soft natural / practical
Color: vibrant saturated 或 pastel
```

---

## 📚 相關筆記

- 威森_Claude_Skill_3個實用技能_安裝教學 — universal-video-prompt skill 安裝筆記
- 威森_免費AI模特代言_3步驟教學 — 完整 AI 模特代言流程
- 影片_AI模特舉杯聞香_Kling — 八層公式實戰範例
- 圖片_亞洲女模特鎖骨特寫_Midjourney — 五層公式實戰範例
- AI影音創作 INDEX
- 工具評比 — waigo vs 替代

---

## 🔄 後續擴充

<div class="not-prose my-6 bg-purple-500/10 border-l-4 border-purple-500 rounded-r-lg p-4">
<p class="font-bold text-purple-400 mb-2">☑️ 待補完</p>
<div class="text-sm text-gray-300">

- [ ] 加入鏡頭組合（剪接邏輯）— 兩個鏡頭如何銜接
- [ ] 加入聲音設計（diegetic vs non-diegetic）
- [ ] 加入色彩心理學的對應表
- [ ] 蒐集 10 個經典電影的鏡頭拆解（學習範例）
- [ ] 把 universal-image-prompt 的五層架構也整合一份對應指南

</div>
</div>

