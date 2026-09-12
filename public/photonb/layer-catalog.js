// 圖層總目錄（單一更新點）— James 2026-09-12 拍板：版型庫／初剪規格選擇器／長篇景色模板三頁共用同一張表。
// kind T = 文字類（FCPX 內建 title，James 在 FCP 改字、Robert 程式帶字）；G = 生成類（FCP 做不到，Robert 出透明 ProRes）。
window.LAYER_CAT = [
  {id:'T1',  kind:'T', name:'主標題',        how:'FCP 內建 title（Custom 3D）',  lib:'①',   note:'地名大字',                         lv:'lock', ic:'edit'},
  {id:'T2',  kind:'T', name:'副標',          how:'FCP 內建 title',              lib:'①',   note:'中文草寫一句／第二行',               lv:'lock', ic:'edit'},
  {id:'T3',  kind:'T', name:'場景字卡',      how:'FCP 內建 title（Zoom）',       lib:'⑤',   note:'跟著段落換',                        lv:'lock', ic:'edit'},
  {id:'T4',  kind:'T', name:'SCENES 清單',   how:'FCP 內建 title（Line Reveal）',lib:'⑤',   note:'✦ 標現在這段，逐段下移',            lv:'lock', ic:'edit'},
  {id:'T5',  kind:'T', name:'地名條',        how:'FCP 內建 title（2026-09-12 起）',lib:'③', note:'英文小字＋｜中文地名｜，GPS 自動帶', lv:'na',   ic:'edit'},
  {id:'T6',  kind:'T', name:'曲名跑馬燈',    how:'FCP 內建 Ticker',              lib:'④',   note:'每首歌開頭跑 8 秒',                  lv:'opt',  ic:'edit'},
  {id:'G1',  kind:'G', name:'移動中 票券＋地圖', how:'Robert 透明 ProRes',       lib:'②',   note:'子碼 A 洲際／B 跨區／C 跨都市／D 市內／E 水路／F 蝕刻', lv:'na', ic:'gen',
     sub:[['G1-A','✈️ 洲際 機票'],['G1-B','🚌 跨區 遊覽車票'],['G1-C','🚄 跨都市 高鐵票'],['G1-D','🚏 市內 巴士票'],['G1-E','⛴️ 水路 船票'],['G1-F','🎟️ 蝕刻車票']]},
  {id:'G2',  kind:'G', name:'音波緞帶',      how:'Robert 透明 ProRes',           lib:'④',   note:'振幅跟音樂走',                       lv:'opt',  ic:'gen'},
  {id:'G3',  kind:'G', name:'LOGO 標',       how:'Robert 透明 ProRes',           lib:'—',   note:'圓形／橫式，版位・大小・掃光',        lv:'opt',  ic:'gen'},
  {id:'G4',  kind:'G', name:'霓虹標題',      how:'Robert 透明 ProRes（變體 G4-A…）', lib:'⑥', note:'文字夾在人物後面，4K 去背',      lv:'na',   ic:'gen'},
  {id:'G5',  kind:'G', name:'手寫 write-on 標題', how:'Robert 透明 ProRes（變體 G5-A…）', lib:'—', note:'逐劃寫出→劃白線→內文淡入', lv:'na', ic:'gen'},
  {id:'G6',  kind:'G', name:'建築卡',        how:'規劃中',                       lib:'⑦',   note:'建築名＋風格＋年代',                lv:'na',   ic:'plan'},
  {id:'G7',  kind:'G', name:'郵戳／明信片',  how:'規劃中',                       lib:'⑧',   note:'地名＋座標＋日期',                  lv:'na',   ic:'plan'},
  {id:'G8',  kind:'G', name:'餐券／收據',    how:'規劃中',                       lib:'⑨',   note:'店名／菜名',                        lv:'na',   ic:'plan'},
  {id:'G9',  kind:'G', name:'對話日記泡泡',  how:'規劃中',                       lib:'中場', note:'左下角訊息一句句跳出',              lv:'na',   ic:'plan'},
];
// 渲染總目錄表（三頁共用）。opts.lock=true 時，依 lv 顯示長景模板的鎖定狀態。
window.renderLayerCat = function(el, opts){
  opts = opts || {};
  const lvTxt = {lock:'🔒 預設鎖定', opt:'🔘 預設開・可關', na:'— 不用'};
  const rows = window.LAYER_CAT.map(r => {
    const kindTxt = r.kind==='T' ? '🔤 文字（你在 FCP 改字）' : (r.ic==='plan' ? '⏳ 規劃中' : '🎨 生成（我出 ProRes）');
    const lv = opts.lock ? `<td>${lvTxt[r.lv]||''}</td>` : '';
    return `<tr><td><b>${r.id}</b></td><td>${r.name}</td><td>${kindTxt}</td><td>${r.how}</td><td>${r.lib}</td><td>${r.note}</td>${lv}</tr>`;
  }).join('');
  el.innerHTML = `<div style="overflow-x:auto"><table class="lcat" style="width:100%;border-collapse:collapse;font-size:.82rem">
    <tr><th>編號</th><th>圖層</th><th>類型</th><th>怎麼出</th><th>版型庫</th><th>說明</th>${opts.lock?'<th>長景模板</th>':''}</tr>${rows}</table></div>
    <style>.lcat td,.lcat th{border:1px solid rgba(216,182,90,.3);padding:.35rem .5rem;text-align:left;vertical-align:top}.lcat th{color:#d8b65a;white-space:nowrap;background:rgba(216,182,90,.06)}</style>`;
};
