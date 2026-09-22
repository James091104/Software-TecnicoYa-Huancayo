import React, {useEffect, useRef, useState} from 'react';
import FrameCache from './FrameCache';
import {activeScene, clamp, coverRect, frameAtTime, smoothstep, timeAtScroll} from './timeline';
import './scroll-services.css';

export const serviceScenes = [
  {id:'computo',label:'Cómputo',title:'Tu tecnología,',accent:'en marcha.',description:'Tu trabajo y tus ideas merecen un equipo que responda. Encuentra especialistas en PC, redes, impresoras y recuperación de datos.',steps:['Cuéntanos la falla de tu equipo.','Confirma al técnico propuesto para tu zona.','Recibe el diagnóstico y acuerda la solución.'],action:'Encontrar un técnico de cómputo'},
  {id:'refrigeracion',label:'Refrigeración comercial',title:'El frío que tu',accent:'negocio necesita.',description:'Congeladoras, vitrinas, aire acondicionado y cámaras frigoríficas. Conecta con el profesional adecuado para revisar tu instalación.',steps:['Indica el equipo y el problema de temperatura.','Coordina la revisión con un especialista.','Aprueba el trabajo antes de la intervención.'],action:'Buscar especialista en refrigeración'},
  {id:'electricidad',label:'Electricidad',title:'Todo conectado.',accent:'Todo en orden.',description:'Desde una nueva instalación hasta tableros, iluminación y cortocircuitos. Busca atención especializada para tu hogar o negocio.',steps:['Describe la instalación o la falla eléctrica.','Encuentra un técnico disponible en tu zona.','Confirma el servicio y sigue su avance.'],action:'Encontrar un técnico electricista'},
];
const frameUrl=(variant,index)=>`/media/scroll-sequence/${variant}/frame-${String(index).padStart(4,'0')}.webp`;

function SceneCopy({scene,index,onSelect}) {
  return <>
    <div className="scene-eyebrow"><span>0{index+1}</span><span>{scene.label}</span></div>
    <h2 id={`scene-heading-${scene.id}`}>{scene.title}<br/><em>{scene.accent}</em></h2>
    <p className="scene-description">{scene.description}</p>
    <ol className="scene-steps">{scene.steps.map((step,i)=><li key={step}><span aria-hidden="true">0{i+1}</span>{step}</li>)}</ol>
    <a className="button primary scene-cta" href="#plataforma" onClick={()=>onSelect(scene.id)}>{scene.action}<span aria-hidden="true">↗</span></a>
  </>;
}

export default function ScrollServices({sequence,onSelect}) {
  const rootRef=useRef(null),stageRef=useRef(null),canvasRef=useRef(null),markersRef=useRef([]);
  const [reduced,setReduced]=useState(()=>window.matchMedia('(prefers-reduced-motion: reduce)').matches);
  const [scene,setScene]=useState(-1),[failed,setFailed]=useState(false);
  const staticMode=reduced||failed;
  useEffect(()=>{const media=window.matchMedia('(prefers-reduced-motion: reduce)');const change=()=>setReduced(media.matches);media.addEventListener('change',change);return()=>media.removeEventListener('change',change)},[]);

  useEffect(()=>{
    if(staticMode)return;
    const root=rootRef.current,stage=stageRef.current,canvas=canvasRef.current;
    const context=canvas.getContext('2d',{alpha:false});
    if(!context){setFailed(true);return;}
    const mobile=window.matchMedia('(max-width: 650px)').matches;
    let active=false,disposed=false,raf=0,target=0,lastTarget=0,currentScene=-1;
    let easedScroll=null,lastTick=0;
    let stops=[],width=0,height=0,entryStart=0,entryEnd=0;
    const times=[0,...sequence.scenes.map(s=>s.time),(sequence.frameCount-1)/sequence.fps];
    const cache=new FrameCache({count:sequence.frameCount,variant:mobile?'mobile':'desktop',max:mobile?14:22,onLoad:index=>{if(index===target)schedule()}});
    const draw=(now)=>{
      raf=0;if(disposed||!active||document.hidden)return;
      const desiredScroll=window.scrollY;
      const dt=Math.min(lastTick?now-lastTick:16.67,50);lastTick=now;
      if(easedScroll===null)easedScroll=desiredScroll;
      easedScroll+=(desiredScroll-easedScroll)*(1-Math.exp(-dt/100));
      if(Math.abs(desiredScroll-easedScroll)<.25)easedScroll=desiredScroll;
      const scroll=easedScroll;
      const time=timeAtScroll(scroll,stops,times);
      target=frameAtTime(time,sequence.fps,sequence.frameCount);
      const nextScene=activeScene(time,sequence.scenes.map(s=>s.time));
      if(nextScene!==currentScene){currentScene=nextScene;setScene(nextScene)}
      const entrance=smoothstep((scroll-entryStart)/Math.max(1,entryEnd-entryStart));
      stage.dataset.entered=entrance>0?'true':'false';
      const exit=smoothstep((scroll-(stops[4]-height*.28))/(height*.28));
      stage.style.setProperty('--scene-entrance',entrance.toFixed(4));
      stage.style.setProperty('--scene-mask',`${(1-entrance)*42}%`);
      stage.style.setProperty('--scene-exit',exit.toFixed(4));
      stage.style.setProperty('--scene-progress',clamp(time/times[4]).toFixed(4));
      const image=cache.get(target);
      if(image){
        const rect=coverRect(width,height,image.naturalWidth,image.naturalHeight,.56);
        context.drawImage(image,rect.x,rect.y,rect.width,rect.height);
        canvas.classList.add('frame-ready');
      }
      cache.request(target,target>=lastTarget?1:-1);lastTarget=target;
      if(easedScroll!==desiredScroll)schedule();
    };
    function schedule(){if(!raf&&!disposed&&active&&!document.hidden)raf=requestAnimationFrame(draw)}
    function measure(){
      const viewport=window.innerHeight,scroll=window.scrollY,box=root.getBoundingClientRect();
      width=stage.clientWidth;height=stage.clientHeight;
      const dpr=Math.min(window.devicePixelRatio||1,2);
      canvas.width=Math.round(width*dpr);canvas.height=Math.round(height*dpr);context.setTransform(dpr,0,0,dpr,0,0);
      context.imageSmoothingEnabled=true;context.imageSmoothingQuality='high';
      const start=scroll+box.top;
      stops=[start,...markersRef.current.map(marker=>scroll+marker.getBoundingClientRect().top-viewport*.24),scroll+box.bottom-viewport];
      entryStart=Math.max(0,start-viewport*.45);entryEnd=start+viewport*.15;
      schedule();
    }
    const observer=new IntersectionObserver(([entry])=>{active=entry.isIntersecting;cache.setActive(active&&!document.hidden);if(active){measure();schedule()}else if(raf){cancelAnimationFrame(raf);raf=0}},{rootMargin:'180px 0px'});
    observer.observe(root);
    const resize=new ResizeObserver(measure);resize.observe(root);resize.observe(stage);
    const visibility=()=>{cache.setActive(active&&!document.hidden);if(document.hidden&&raf){cancelAnimationFrame(raf);raf=0}else schedule()};
    window.addEventListener('scroll',schedule,{passive:true});window.addEventListener('resize',measure);
    document.addEventListener('visibilitychange',visibility);
    document.fonts?.ready.then(()=>{if(!disposed)measure()});
    measure();
    return()=>{disposed=true;cancelAnimationFrame(raf);observer.disconnect();resize.disconnect();cache.dispose();window.removeEventListener('scroll',schedule);window.removeEventListener('resize',measure);document.removeEventListener('visibilitychange',visibility)};
  },[sequence,staticMode]);

  function jump(index){const marker=markersRef.current[index];if(marker)window.scrollTo({top:window.scrollY+marker.getBoundingClientRect().top-window.innerHeight*.24+1,behavior:reduced?'auto':'smooth'})}

  if(staticMode)return <div id="servicios" className="scroll-services-static">{serviceScenes.map((item,index)=>{
    const frame=Math.min(sequence.frameCount-1,sequence.scenes[index].frame+Math.round(sequence.fps*.6));
    return <section key={item.id} id={`servicio-${item.id}`} className="static-scene" aria-labelledby={`scene-heading-${item.id}`}><picture><source media="(max-width:650px)" srcSet={frameUrl('mobile',frame)}/><img src={frameUrl('desktop',frame)} loading="lazy" alt={`Escena de ${item.label.toLowerCase()}`} width="1280" height="720"/></picture><div className="static-scene-copy"><SceneCopy scene={item} index={index} onSelect={onSelect}/></div></section>
  })}</div>;

  return <div id="servicios" ref={rootRef} className="scroll-services" aria-label="Especialidades de TécnicoYa">
    <div ref={stageRef} className="scroll-stage">
      <div className="scroll-visual" aria-hidden="true"><picture><source media="(max-width:650px)" srcSet={frameUrl('mobile',0)}/><img className="sequence-poster" src={frameUrl('desktop',0)} alt="" loading="lazy"/></picture><canvas ref={canvasRef}/></div>
      <div className={`scene-bridge ${scene<0?'is-active':''}`} aria-hidden="true"><span>TRES ESPECIALIDADES. UNA SOLA CONEXIÓN.</span><span className="bridge-scroll">Sigue explorando ↓</span></div>
      <div className="scene-panels">{serviceScenes.map((item,index)=><section key={item.id} className={`scene-panel ${scene===index?'is-active':''}`} aria-labelledby={`scene-heading-${item.id}`} aria-hidden={scene!==index} inert={scene===index?undefined:''}><SceneCopy scene={item} index={index} onSelect={onSelect}/></section>)}</div>
      <nav className="scene-navigation glass" aria-label="Escenas de especialidades">{serviceScenes.map((item,index)=><button key={item.id} aria-pressed={scene===index} onClick={()=>jump(index)}><span>0{index+1}</span>{item.label}</button>)}</nav>
      <div className="scene-progress" aria-hidden="true"><span/></div>
    </div>
    <div className="scroll-markers" aria-hidden="true"><div className="scene-entry-space"/>{serviceScenes.map((item,index)=><div key={item.id} id={`servicio-${item.id}`} ref={node=>{markersRef.current[index]=node}} className="scene-marker"/>)}<div className="scene-exit-space"/></div>
  </div>;
}
