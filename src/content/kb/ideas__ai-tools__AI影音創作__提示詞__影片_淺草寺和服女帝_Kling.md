---
title: 影片 — 淺草寺和服女帝（Kling）
date: 2026-04-11
來源: 用戶於 Telegram Ideas 群測試 universal-video-prompt skill
連結:
平台: Kling AI / Google Veo3 / Runway / 即夢 Seedance
類型: 影片 / text-to-video
tags:
  - AI影音
  - 提示詞
  - 影片prompt
  - 人像
  - 文化
  - 和服
  - 日本
aliases:
  - 淺草寺和服女帝
  - 和服女帝影片prompt
category: "AI影音-提示詞"
---

# 影片提示詞 — 淺草寺和服女帝

> [!important] 用途
> 一段 5 秒的高貴和服女性站在淺草寺的電影感人像影片，主打「女帝千金的氣勢」與服裝細節，適合精品文化／時尚／藝術短片。

---

## 來源

用戶於 Telegram Ideas 群（chat_id -5231583145, msg 846）測試 universal-video-prompt skill 時提供的描述：

> 「測試一下 照片中的和服女孩 服裝細節完整，在日本淺草寺參拜，有女帝千金的氣勢」

由 Claude 透過 universal-video-prompt skill 自動套用八層架構產出。

---

## Prompt 全文（英文，主版本）

```
A cinematic 5-second portrait shot of an elegant young Japanese woman in her early-to-mid 20s standing at Sensoji Temple in Asakusa, Tokyo. She wears a meticulously detailed formal houmongi kimono in deep crimson with intricate gold chrysanthemum and crane embroidery, a traditional brocade obi belt, white tabi socks, and lacquered geta. Her hair is styled in a classical Japanese updo with ornamental kanzashi pins. Camera holds a slow dolly-in from medium shot to medium close-up, slight low angle to emphasize her regal poise. She stands still with the commanding presence of an empress's daughter, takes a single natural blink, and her chin lifts almost imperceptibly. Wisps of incense smoke from the bronze burner drift continuously across the frame, catching warm golden hour rim light. The vermilion Kaminarimon gate and five-story pagoda sit in soft bokeh background. Shallow depth of field with 85mm cinematic look, sharp focus on her composed face and the embroidery texture. Premium commercial cinematography, warm crimson-and-gold color palette, photorealistic, no zooms, no whip pans, no rapid motion. Match first and last frame loosely to allow seamless extension.
```

---

## 八層架構拆解

### 📐 Medium（景別）— MS → MCU
從中景緩緩推進到中特寫。開頭給服裝全貌，結尾給情緒。

### 📷 Shot Type（鏡頭類型）— Establishing portrait + 隱含 insert
主鏡頭是人像，香爐煙霧自然成為前景插入元素。

### 📐 Angle（角度）— slight low angle（微仰角）
仰角讓主體**強大、威嚴** → 直接服務「女帝千金」氣勢。
用 `slight` 而非全仰角，保留古典端莊。

### 🎥 Movement（運鏡）— slow dolly-in
- 為什麼選 dolly 不選 zoom：dolly 真的「走近她」，透視會變
- `slow` 保持戲劇張力與莊重感
- 明確 prompt：`no zooms, no whip pans, no rapid motion`（防止 AI 自作主張）

### 🔍 Focus（焦點）— shallow DOF + 85mm look
- 淺景深 → 背景的雷門、五重塔柔焦成意境
- 雙焦點：表情 + 刺繡細節

### 🎭 Subject（主體動作層）— 克制
- `single natural blink`（一次眨眼）
- `chin lifts almost imperceptibly`（下巴微抬，強化威嚴）
- `incense smoke drift continuously`（煙霧是唯一連續動的元素）
- 衣物完全靜止 → 古典感

> [!warning] 為什麼動作這麼少
> 5 秒影片如果動作太大會破壞「莊重」氛圍。「微動」才有質感。這是區別「廉價 AI 動畫」與「電影感」的關鍵。

### 💡 Lighting（光線）— golden hour + rim light + smoke catching light
- 黃金時段暖光是基底
- 側光輪廓光（rim light）強調刺繡的金線反光
- 煙霧捕捉光線 → 神聖光暈

### 🎨 Color（色調）— warm crimson-and-gold cinematic
- 深紅 + 金（和服主色）主導
- 商業電影級色調

---

## 預期成果（描述視覺效果）

🎬 **5 秒高質感人像短片**：

**0-1 秒**：中景畫面，和服女子站在淺草寺前，服裝細節完整入鏡，雷門與五重塔在背景柔焦。香爐煙霧已開始飄散。

**2-3 秒**：相機緩慢推近（dolly-in），畫面從中景轉為中特寫。她的下巴幾乎察覺不到地微抬，眼神更加專注。

**3-4 秒**：自然眨眼一次。煙霧繼續飄散，金線刺繡在側光下閃爍。

**4-5 秒**：相機停在中特寫位置，她保持靜止。整個畫面像一張會動的高貴肖像。

📐 **整體視覺特性**：
- 像是一段精品時尚廣告或文化紀錄片片頭
- 主色調為**深紅** + **金色** + 背景**米色寺廟**
- 唯一明顯動的元素是**煙霧** + 一次**眨眼** + 微微的**鏡頭推進**
- 給人「靜中有動，動中有靜」的東方美學感
- 整體情緒：**莊嚴、神聖、高貴、克制**

📐 **適合的構圖比例**：
- 直式 9:16（IG Reels / TikTok / Shorts）
- 直式 4:5（IG / Facebook）
- 橫式 16:9（YouTube / 大屏）

---

## 多平台適配版本

### ▸ Kling AI 版本（首推）

```
Cinematic 5-second portrait at Sensoji Temple Tokyo. Elegant young Japanese woman in deep crimson houmongi kimono with gold chrysanthemum and crane embroidery, brocade obi, classical updo with kanzashi. Slow dolly-in from medium shot to medium close-up, slight low angle. She stands still, single natural blink, chin lifts almost imperceptibly. Continuous incense smoke from bronze burner drifting across frame, golden hour warm rim light. Vermilion Kaminarimon and pagoda in soft bokeh. 85mm shallow DOF, premium cinematic, warm crimson-gold palette.
```

設定：
- Mode: text-to-video
- Duration: 5 秒
- Motion strength: Low（保持微動）

### ▸ Google Veo3 版本（結構化）

```
Subject: an elegant young Japanese woman in deep crimson houmongi kimono with gold embroidery, classical updo, standing with regal poise.
Action: she stands still, blinks naturally once, chin lifts subtly. Continuous incense smoke drifts across the frame.
Camera: slow dolly-in from MS to MCU, slight low angle, 85mm shallow depth of field.
Setting: Sensoji Temple, Asakusa Tokyo, vermilion Kaminarimon and five-story pagoda in soft bokeh background, bronze incense burner foreground.
Lighting: golden hour warm side lighting with rim light highlighting embroidery details.
Style: premium cinematic, warm crimson-gold palette, photorealistic, no rapid motion.
```

### ▸ Runway Gen-3/4 版本

直接用主版本的英文 prompt 即可。建議補上：
`Style reference: cinematic editorial fashion film, Wong Kar-wai meets Vogue Japan`

### ▸ 即夢 Seedance / Pika 版本（簡化）

```
Japanese woman in red gold kimono at Sensoji Temple, slow dolly-in, single natural blink, incense smoke drifting, golden hour rim light, vermilion gate background bokeh, 85mm shallow DOF, cinematic, 5s
```

---

## 變體建議

### 變體 A — 環繞展示和服全貌
把 `slow dolly-in` 改成 `slow orbit shot circling 90 degrees around her`。
效果：360 度展示和服刺繡細節，更像精品時尚廣告。
缺點：循環會比較難 loop，適合 hero shot。

### 變體 B — 雪夜孤高版
```
... at Sensoji Temple at night during gentle snowfall, lanterns glowing softly,
the woman's breath visible in the cold air, snowflakes catching the warm lantern light,
deep blue and warm amber color contrast, more intimate and solitary mood ...
```
從「黃金時段女帝」變「雪夜孤高貴族」。色調轉冷藍 + 暖黃對比。

### 變體 C — 揭幕儀式感
加入動作序列：
```
... she slowly raises both hands holding a lit incense stick to chest level,
takes a single deep breath, then bows once in a dignified manner ...
```
從「靜態微動」變成「儀式性動作」。秒數拉到 8-10 秒。

---

## 適用情境

- 日本文化 / 觀光宣傳影片
- 高端日式品牌（清酒、和菓子、精品和服）
- 藝術電影開場
- 婚紗 / 文化攝影工作室宣傳
- IG / TikTok 文化主題短片

---

## 實測心得

（待用戶實際跑過後補充）

---

## 變化用法：直接呼叫 skill

不用每次來抄，可以直接跟 Claude 說：

```
用 universal-video-prompt 幫我寫一個 [情境/角色/場景]
```

例如：
- 「用 universal-video-prompt 幫我寫一個茶道師父在京都茶室點茶的 5 秒鏡頭」
- 「用 universal-video-prompt 幫我寫一個劍道少女在道場揮劍的 8 秒分鏡」

skill 會自動依八層架構產出 prompt + 多平台版本 + 變體建議。

---

## 相關筆記

- 攝影基本功_鏡頭運鏡完整指南 — 八層架構完整教學
- 威森_Claude_Skill_3個實用技能_安裝教學 — universal-video-prompt skill 安裝
- 影片_AI模特舉杯聞香_Kling — 同類型循環影片範例
- AI影音創作 INDEX
