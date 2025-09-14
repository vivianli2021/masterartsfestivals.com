(() => {
  const imgs = Array.from(document.querySelectorAll('.gallery img'));
  if (!imgs.length) return;
  const overlay = document.createElement('div');
  overlay.className = 'lightbox';
  overlay.innerHTML = `
    <button class="lb-btn lb-prev" aria-label="Previous">‹</button>
    <img alt="photo" />
    <button class="lb-btn lb-next" aria-label="Next">›</button>
    <button class="lb-btn lb-close" aria-label="Close">×</button>
  `;
  document.body.appendChild(overlay);
  const imgEl = overlay.querySelector('img');
  const prevBtn = overlay.querySelector('.lb-prev');
  const nextBtn = overlay.querySelector('.lb-next');
  const closeBtn = overlay.querySelector('.lb-close');
  let index = 0;
  const open = (i) => {
    index = (i + imgs.length) % imgs.length;
    imgEl.src = imgs[index].src;
    overlay.classList.add('open');
  };
  const close = () => overlay.classList.remove('open');
  const next = () => open(index + 1);
  const prev = () => open(index - 1);

  overlay.addEventListener('click', (e) => { if (e.target === overlay) close(); });
  nextBtn.addEventListener('click', (e) => { e.stopPropagation(); next(); });
  prevBtn.addEventListener('click', (e) => { e.stopPropagation(); prev(); });
  closeBtn.addEventListener('click', (e) => { e.stopPropagation(); close(); });
  document.addEventListener('keydown', (e) => {
    if (!overlay.classList.contains('open')) return;
    if (e.key === 'Escape') close();
    else if (e.key === 'ArrowRight') next();
    else if (e.key === 'ArrowLeft') prev();
  });
  imgs.forEach((img, i) => img.addEventListener('click', () => open(i)));
})();
