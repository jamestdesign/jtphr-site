---
title: 影片 — AI 模特舉杯聞香（Kling）
date: 2026-04-11
來源: 部落格 — 理工威森（Wilson Chang）
連結: https://wilson-men.tw/ai-model/
平台: Kling AI / Google Veo3 / Runway
類型: 影片 / image-to-video
tags:
  - AI影音
  - 提示詞
  - 影片prompt
  - 商業廣告
  - 循環影片
aliases:
  - 舉杯聞香影片prompt
category: "AI影音-提示詞"
---

# 影片提示詞 — AI 模特舉杯聞香（循環）

<div class="not-prose my-6 bg-red-500/10 border-l-4 border-red-500 rounded-r-lg p-4">
<p class="font-bold text-red-400 mb-2">🔴 用途</p>
<div class="text-sm text-gray-300">

把 靜態人像圖 變成 5-10 秒**首尾循環**的微動態影片。重點是「自然眨眼 + 呼吸 + 杯子小動作 + 蒸氣連續釋放」，可作為飲品 / 保溫杯 / 茶飲品牌的循環廣告。

</div>
</div>


---

## 來源

威森（理工威森）在 免費AI模特代言教學 中提供的進階範例 prompt，作為 Step 4（讓圖片動起來）的示範。

---

## Prompt 全文（英文，可直接複製貼上）

```
Use the reference image as the subject: profile head-and-shoulders, clean light-beige/gray background, golden-hour side lighting. Keep the pose elegant and relaxed; include a single natural blink and subtle chest breathing. Fingers make a tiny adjustment on a matte pastel-blue stainless tumbler while soft steam rises continuously from the rim. Camera is static at an 85mm look with shallow depth of field; skin highlights are refined and not over-sharpened. Clean, noise-free, premium commercial look. Match the first and last frame to enable a seamless loop. Remove readable logos/text.
```

中文版（理解用，**生成時請用英文**）：

> 以參考圖片為主體：側臉半身特寫、乾淨米灰背景、黃金時段側光。人物保持優雅放鬆，出現一次自然眨眼與極輕微胸腔呼吸起伏；手指在霧面粉藍不鏽鋼隨行杯上有細小移動，杯口持續釋放柔和熱氣。相機固定 85mm 視角，淺景深，肌膚高光細膩且不過銳。畫面純淨無雜訊、時尚商業質感。首尾姿態一致，實現無縫循環。移除可讀商標與文字。

---

## 八層架構拆解

### 📐 Medium（景別）
- **profile head-and-shoulders**（側臉半身特寫）
- 對應 MCU（Medium Close-Up）— 頭到胸口
- 為什麼：讓觀眾既看到表情又看到杯子，是最 balance 的選擇

### 📷 Shot Type（鏡頭類型）
- **Insert shot**（產品插入鏡頭，杯子是配角但很重要）
- 沒明確指定但隱含在「fingers make a tiny adjustment on a matte pastel-blue stainless tumbler」
- 主體＋產品同框

### 📐 Angle（角度）
- 預設 **eye level**（平視）— 沒明確寫，因為 reference image 已決定角度
- 平視最自然，適合商業質感

### 🎥 Movement（運鏡）
- **Camera is static**（攝影機固定）
- 為什麼：循環廣告必須首尾一致，動的是人物而不是相機，相機動會難以 loop
- **動的是人物本身**：眨眼、呼吸、手指微調
- **動的是物理元素**：蒸氣連續上升

<div class="not-prose my-6 bg-green-500/10 border-l-4 border-green-500 rounded-r-lg p-4">
<p class="font-bold text-green-400 mb-2">💡 循環廣告秘訣</p>
<div class="text-sm text-gray-300">

「Match the first and last frame to enable a seamless loop」是這個 prompt 的關鍵句 — 強制 AI 讓首尾畫面一致，這樣可以無限播放不會跳。

</div>
</div>


### 🔍 Focus（焦點）
- **shallow depth of field**（淺景深）
- **85mm look**（85mm 鏡頭視角，人像專用）
- **skin highlights are refined and not over-sharpened**（肌膚高光細膩、不過銳）

<div class="not-prose my-6 bg-blue-500/10 border-l-4 border-blue-500 rounded-r-lg p-4">
<p class="font-bold text-blue-400 mb-2">📝 為什麼用 85mm</p>
<div class="text-sm text-gray-300">

85mm 是人像攝影的「黃金焦距」— 透視自然、背景模糊度漂亮、不變形。用在 AI 影片裡能暗示模型「我要的是商業人像感而不是手機快照」。

</div>
</div>


### 🎭 Subject（主體）
動作清單（小但精確）：
- **a single natural blink**（一次自然眨眼）— 不是連續眨，避免假
- **subtle chest breathing**（極輕微胸腔呼吸起伏）— 真實感
- **fingers make a tiny adjustment on a matte pastel-blue stainless tumbler**（手指在霧面粉藍不鏽鋼隨行杯上有細小移動）— 產品是焦點
- **soft steam rises continuously from the rim**（杯口持續釋放柔和熱氣）— 動態元素

<div class="not-prose my-6 bg-yellow-500/10 border-l-4 border-yellow-500 rounded-r-lg p-4">
<p class="font-bold text-yellow-400 mb-2">⚠️ 動作要「微」</p>
<div class="text-sm text-gray-300">

5-10 秒影片如果動作太大，AI 容易產出不自然的動畫感。「眨眼一次」「呼吸極輕微」「手指微調」這種「克制」的描述能保持商業感。

</div>
</div>


### 💡 Lighting（光線）
- **golden-hour side lighting**（黃金時段側光）
- 跟靜態圖一致 → 確保視覺連續性

### 🎨 Color（色調）
- **clean light-beige/gray background**（乾淨米灰背景）
- **noise-free, premium commercial look**（無雜訊、時尚商業質感）
- 整體：低飽和、暖調、商業精緻

---

## 預期成果（描述視覺效果）

執行這個 prompt 應該會產出：

🎬 **一段 5-10 秒的循環影片**：

**0-2 秒**：模特微側臉看著前方，手指輕扶霧面粉藍隨行杯，杯口冒著柔和熱氣
**3-5 秒**：模特自然眨一下眼，胸口微微起伏（呼吸），手指做極小幅度調整
**6-10 秒**：回到接近開頭的姿態，準備無縫循環

📐 **視覺特性**：
- 整段影片看起來像「**靜止照片活起來**」，不是大幅運動
- 蒸氣是**唯一連續移動**的元素，創造流動感
- 模特保持**優雅平靜**，不會有大表情變化
- 背景**完全靜止**，景深保持淺
- 色調**暖調米色**，整體像精品咖啡 / 保溫杯品牌的形象廣告

---

## 多平台適配版本

### ▸ Kling AI 版本（威森推薦）

直接用上面的英文 prompt，加上：
- **Mode**: Image-to-video
- **Duration**: 5 秒（免費版）/ 10 秒（付費）
- **Motion strength**: Low（保持微動）
- **Reference image**: 上傳靜態人像圖

Kling 對「seamless loop」指令支援良好，適合這種循環廣告。

### ▸ Google Veo3 版本

```
Subject: an elegant young Asian woman in profile, head-and-shoulders shot, holding a matte pastel-blue stainless tumbler.
Action: She blinks naturally once, breathes subtly. Her fingers slightly adjust the tumbler. Soft steam rises continuously from the rim.
Camera: static, 85mm equivalent, shallow depth of field.
Lighting: golden hour side light, warm tones.
Background: clean light beige/gray, blurred.
Style: premium commercial, photorealistic, seamless loop.
```

Veo3 偏好結構化 prompt（用 Subject/Action/Camera/Lighting 分段）。

### ▸ Runway Gen-3/4 版本

直接用威森的英文 prompt 即可，Runway 對自然語言友善。建議補上 `Cinematic, advertising commercial style` 強化商業感。

### ▸ 即夢 Seedance / Pika 版本

需要把 prompt 簡化：
```
Asian woman in profile, holds matte blue tumbler, soft steam rising, natural blink, gentle breathing, golden side light, beige background, 85mm shallow depth of field, seamless loop, premium ad style
```

---

## 變體建議

### 變體 A：換產品類型
把 `matte pastel-blue stainless tumbler` 改成：
- `transparent glass perfume bottle` → 香水廣告
- `wooden coffee mug with foam art` → 手沖咖啡品牌
- `clear skincare serum bottle` → 精華液品牌

### 變體 B：換動作節奏
- 加快版：`a quick smile forming, eyes lighting up` → 廣告 hero shot
- 慢動作：`extremely slow blink, languid head turn` → 高奢品牌

### 變體 C：加入產品 reveal
```
Start with hands cradling the tumbler at chest level, then slowly lift to face level, ending with a soft inhale of the steam.
```
這個版本不是循環，是 hero shot 動作。

---

## 適用情境

- 飲品品牌（咖啡 / 茶 / 機能飲料）
- 保溫杯 / 隨行杯
- 香水 / 香氛
- 訂閱制商品（每月精選）
- IG / TikTok 商品宣傳影片

---

## 實測心得

（待用戶實際跑過後補充）

---

## 變化用法：直接呼叫 skill

不用每次來抄，可以直接跟 Claude 說：

```
用 universal-video-prompt 幫我寫一個側臉半身的女性循環廣告影片，
她拿著一個透明香水瓶，主題是淡雅、療癒
```

universal-video-prompt skill 會自動依八層架構產出 prompt + 多平台版本。

---

## 相關筆記

- 威森_免費AI模特代言_3步驟教學 — 完整教學流程
- 圖片_亞洲女模特鎖骨特寫_Midjourney — 同系列的圖片版 prompt
- 威森_Claude_Skill_3個實用技能_安裝教學 — universal-video-prompt skill 安裝
