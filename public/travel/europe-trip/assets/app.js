
const back = document.querySelector('.backtop');
back?.addEventListener('click',()=>window.scrollTo({top:0,behavior:'smooth'}));
document.querySelectorAll('[data-print]').forEach(btn=>btn.addEventListener('click',()=>window.print()));
const today = new Date();
document.querySelectorAll('.day').forEach(d=>{
  const date = d.dataset.date;
  if(!date) return;
  const target = new Date(date+'T00:00:00');
  const diff = Math.ceil((target - today)/(1000*60*60*24));
  const el = d.querySelector('.countdown');
  if(el){ if(diff>0) el.textContent = `距離此日約 ${diff} 天`; else if(diff===0) el.textContent = '就是今天'; else el.textContent = '已完成'; }
});
const lb=document.getElementById('lightbox');
const lbImg=lb?.querySelector('img');
document.querySelectorAll('[data-lightbox]').forEach(a=>{
  a.addEventListener('click',e=>{ e.preventDefault(); if(lb&&lbImg){lbImg.src=a.href; lb.classList.add('open'); lb.setAttribute('aria-hidden','false');} });
});
lb?.querySelector('button')?.addEventListener('click',()=>{lb.classList.remove('open');lb.setAttribute('aria-hidden','true');lbImg.src='';});
lb?.addEventListener('click',e=>{ if(e.target===lb){lb.classList.remove('open');lb.setAttribute('aria-hidden','true');lbImg.src='';}});
document.addEventListener('keydown',e=>{ if(e.key==='Escape'&&lb?.classList.contains('open')){lb.classList.remove('open');lb.setAttribute('aria-hidden','true');lbImg.src='';}});
