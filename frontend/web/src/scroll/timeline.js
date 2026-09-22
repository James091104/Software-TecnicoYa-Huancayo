export const clamp = (value, min = 0, max = 1) => Math.max(min, Math.min(max, value));
export const smoothstep = value => { const t = clamp(value); return t*t*(3-2*t); };

// Interpolate the original video timeline between the independently positioned sections.
export function timeAtScroll(scroll, stops, times) {
  if (scroll <= stops[0]) return times[0];
  for (let i = 1; i < stops.length; i++) {
    if (scroll <= stops[i]) {
      const progress = clamp((scroll-stops[i-1]) / Math.max(1, stops[i]-stops[i-1]));
      return times[i-1] + (times[i]-times[i-1])*progress;
    }
  }
  return times[times.length-1];
}
export function frameAtTime(time, fps, count) {
  return clamp(Math.floor(time*fps+1e-7), 0, count-1);
}
export function activeScene(time, cues) {
  let index = -1;
  cues.forEach((cue, i) => {if (time+1e-7 >= cue) index = i;});
  return index;
}
export function coverRect(width, height, imageWidth, imageHeight, focusX = .5) {
  const scale = Math.max(width/imageWidth, height/imageHeight);
  const w=imageWidth*scale, h=imageHeight*scale;
  return {x:(width-w)*focusX, y:(height-h)*.5, width:w, height:h};
}
