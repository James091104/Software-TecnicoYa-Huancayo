import React from 'react';
import {afterEach,expect,test,vi} from 'vitest';
import {cleanup,fireEvent,render,screen} from '@testing-library/react';
import {activeScene,coverRect,frameAtTime,timeAtScroll} from './timeline';
import ScrollServices from './ScrollServices';
import FrameCache from './FrameCache';
import sequence from './sequence.json';
afterEach(()=>{cleanup();vi.unstubAllGlobals()});

test('the supplied timecodes map to the exact source frames at 24 fps',()=>{
 expect(sequence.fps).toBe(24);
 expect(sequence.scenes.map(s=>frameAtTime(s.time,sequence.fps,sequence.frameCount))).toEqual([56,126,175]);
 expect(sequence.scenes.map(s=>s.frame)).toEqual([56,126,175]);
});
test('scroll mapping is continuous, reversible and bounded at both ends',()=>{
 const stops=[100,300,800,1100,1500],times=[0,...sequence.scenes.map(s=>s.time),(sequence.frameCount-1)/sequence.fps];
 expect(timeAtScroll(0,stops,times)).toBe(0);
 expect(timeAtScroll(300,stops,times)).toBe(times[1]);
 expect(timeAtScroll(800,stops,times)).toBe(times[2]);
 expect(timeAtScroll(550,stops,times)).toBeCloseTo((times[1]+times[2])/2);
 expect(timeAtScroll(9999,stops,times)).toBe(times[4]);
 expect(frameAtTime(1000,24,240)).toBe(239);
 expect(frameAtTime(-10,24,240)).toBe(0);
 expect(activeScene(times[2]-.001,times.slice(1,4))).toBe(0);
 expect(activeScene(times[2],times.slice(1,4))).toBe(1);
});
test('portrait cover fills the viewport without stretching the image',()=>{
 const rect=coverRect(390,844,1280,720,.56);
 expect(rect.height).toBe(844);expect(rect.width).toBeGreaterThan(390);
 expect(rect.width/rect.height).toBeCloseTo(1280/720);
 expect(rect.x).toBeLessThan(0);
});
test('reduced motion exposes all three sections and keeps the service links functional',()=>{
 vi.stubGlobal('matchMedia',()=>({matches:true,addEventListener:vi.fn(),removeEventListener:vi.fn()}));
 const select=vi.fn();const {container}=render(<ScrollServices sequence={sequence} onSelect={select}/>);
 expect(container.querySelector('canvas')).toBeNull();
 expect(screen.getAllByRole('heading',{level:2})).toHaveLength(3);
 expect(container.querySelectorAll('ol')).toHaveLength(3);
 fireEvent.click(screen.getByRole('link',{name:/Buscar especialista en refrigeración/}));
 expect(select).toHaveBeenCalledWith('refrigeracion');
});
test('cache limits concurrent loads, pauses prefetch and discards decoded frames on disposal',()=>{
 const images=[];vi.stubGlobal('Image',class{constructor(){images.push(this)}set src(value){this.url=value}});
 const cache=new FrameCache({count:240,variant:'mobile',max:4,onLoad:()=>{}});
 cache.request(100);expect(cache.pending.size).toBe(3);
 cache.setActive(false);images[0].onload();expect(cache.pending.size).toBe(2);
 cache.request(200);expect(cache.pending.size).toBe(2);
 cache.setActive(true);expect(cache.pending.size).toBe(3);
 for(let i=1;i<images.length;i++){images[i].onload?.();expect(cache.images.size).toBeLessThanOrEqual(4)}
 cache.dispose();expect(cache.images.size).toBe(0);expect(cache.pending.size).toBe(0);
});
