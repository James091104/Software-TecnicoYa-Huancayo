const hero = document.querySelector('.hero');
const video = hero.querySelector('video');
const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
let visible = false;
hero.classList.add('motion-ready');
function syncPlayback() {
  const active = visible && !document.hidden;
  hero.classList.toggle('is-visible', active);
  if (active && !reducedMotion.matches) {
    video.play().catch(() => {});
  } else {
    video.pause();
  }
}
new IntersectionObserver(([entry]) => {
  visible = entry.isIntersecting;
  syncPlayback();
}, { threshold: 0 }).observe(hero);
reducedMotion.addEventListener('change', syncPlayback);
document.addEventListener('visibilitychange', syncPlayback);
syncPlayback();
