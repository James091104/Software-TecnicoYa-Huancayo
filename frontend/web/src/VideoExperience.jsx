import React, {useEffect, useRef, useState} from 'react';

/** Reveal the page once at a cue in the video's own playback timeline. */
export default function VideoExperience({children, revealAt}) {
  const videoRef = useRef(null);
  const observerRef = useRef(null);
  const [revealed, setRevealed] = useState(false);

  useEffect(() => {
    const video = videoRef.current;
    const motion = window.matchMedia('(prefers-reduced-motion: reduce)');
    let visible = true;
    let disposed = false;
    let completed = false;
    let frameRequest;
    let watchdog;
    let previousTime = 0;
    const reveal = () => {
      completed = true;
      if (!disposed) setRevealed(true);
      clearTimeout(watchdog);
      if (frameRequest !== undefined) video.cancelVideoFrameCallback?.(frameRequest);
    };
    const checkCue = () => {
      // An explicit cue is required; do not guess where the zoom finishes.
      if (Number.isFinite(revealAt) && video.currentTime >= revealAt) reveal();
    };
    const checkFrame = (_now, metadata) => {
      if (disposed || completed) return;
      if (metadata.mediaTime >= revealAt) reveal();
      else frameRequest = video.requestVideoFrameCallback(checkFrame);
    };
    const watchProgress = () => {
      clearTimeout(watchdog);
      if (completed || disposed) return;
      previousTime = video.currentTime;
      watchdog = setTimeout(() => {
        if (!document.hidden && visible && video.currentTime === previousTime) reveal();
        else watchProgress();
      }, 12000);
    };
    const sync = () => {
      if (motion.matches) {
        video.pause();
        reveal();
      } else if (!visible || document.hidden) {
        video.pause();
        clearTimeout(watchdog);
      } else {
        video.play()?.catch(error => {
          if (error.name !== 'AbortError') reveal();
        });
        watchProgress();
      }
    };
    const observer = new IntersectionObserver(([entry]) => {
      visible = entry.isIntersecting;
      sync();
    });
    observerRef.current = observer;
    observer.observe(video);
    video.addEventListener('timeupdate', checkCue);
    if (video.requestVideoFrameCallback) frameRequest = video.requestVideoFrameCallback(checkFrame);
    video.addEventListener('error', reveal);
    motion.addEventListener('change', sync);
    document.addEventListener('visibilitychange', sync);
    sync();
    return () => {
      disposed = true;
      clearTimeout(watchdog);
      if (frameRequest !== undefined) video.cancelVideoFrameCallback?.(frameRequest);
      observer.disconnect();
      observerRef.current = null;
      video.pause();
      video.removeEventListener('timeupdate', checkCue);
      video.removeEventListener('error', reveal);
      motion.removeEventListener('change', sync);
      document.removeEventListener('visibilitychange', sync);
    };
  }, [revealAt]);

  // Once the page exists, visibility follows the hero, not its fixed background.
  // This releases video decoding while the image sequence takes over below it.
  useEffect(() => {
    if (!revealed) return;
    const hero = document.getElementById('inicio');
    if (hero && observerRef.current) {
      observerRef.current.disconnect();
      observerRef.current.observe(hero);
    }
  }, [revealed]);

  return <div className={`video-experience ${revealed ? 'content-visible' : 'intro-playing'}`}>
    <div className="background">
      <video ref={videoRef} src="/media/habitacion.mp4" autoPlay muted loop playsInline aria-hidden="true" />
      <div />
    </div>
    {revealed && <div className="page-content">{children}</div>}
  </div>;
}
