import React, {useEffect, useRef, useState} from 'react';
import './service-carousel.css';
import {subcategoriesFor} from './domain/matching';

const services = [
  {id:'computo',label:'Cómputo',title:'Tu tecnología,',accent:'en marcha.',alt:'Técnico revisando los componentes de una laptop en un taller',description:'Equipos que responden. Soluciones para tu trabajo, tu hogar y tu negocio.'},
  {id:'refrigeracion',label:'Refrigeración',title:'El frío que tu',accent:'negocio necesita.',alt:'Especialista inspeccionando una vitrina refrigerada comercial',description:'Desde una refrigeradora hasta una cámara de frío. Encuentra atención para tu equipo.'},
  {id:'electricidad',label:'Electricidad',title:'Todo conectado.',accent:'Todo en orden.',alt:'Electricista inspeccionando un tablero eléctrico con herramientas y protección',description:'Instalaciones y mantenimiento para espacios que necesitan seguir funcionando.'},
];



function SubcategoryDeck({scene}) {
  const root=useRef(null);
  const [index,setIndex]=useState(0),[paused,setPaused]=useState(false),[hover,setHover]=useState(false),[focus,setFocus]=useState(false);
  const [visible,setVisible]=useState(false),[hidden,setHidden]=useState(document.hidden);
  const [reduced,setReduced]=useState(()=>window.matchMedia('(prefers-reduced-motion: reduce)').matches);
  const items=subcategoriesFor(scene.id);
  const count=items.length;
  useEffect(()=>{
    const media=window.matchMedia('(prefers-reduced-motion: reduce)');
    const motion=()=>setReduced(media.matches),visibility=()=>setHidden(document.hidden);
    const observer=new IntersectionObserver(([entry])=>setVisible(entry.isIntersecting),{threshold:.15});
    observer.observe(root.current);media.addEventListener('change',motion);document.addEventListener('visibilitychange',visibility);
    return()=>{observer.disconnect();media.removeEventListener('change',motion);document.removeEventListener('visibilitychange',visibility)};
  },[]);
  useEffect(()=>{
    if(count<2||paused||hover||focus||!visible||hidden||reduced)return;
    const timer=setInterval(()=>setIndex(i=>(i+1)%count),2500);
    return()=>clearInterval(timer);
  },[paused,hover,focus,visible,hidden,reduced,count]);
  const move=direction=>{if(count<2)return;setPaused(true);setIndex(i=>(i+direction+count)%count)};
  return <div className="subcategory-deck" ref={root} onMouseEnter={()=>setHover(true)} onMouseLeave={()=>setHover(false)} onFocusCapture={()=>setFocus(true)} onBlurCapture={event=>{if(!event.currentTarget.contains(event.relatedTarget))setFocus(false)}}>
    <div className="deck-heading"><span className="kicker">ESPECIALISTAS EN CADA DETALLE</span><h3>¿Qué necesitas <em>resolver?</em></h3></div>
    <div className="deck-stage" aria-roledescription="carrusel" aria-label={`Servicios de ${scene.label}`}>
      {count===0&&<p>No hay subcategorías disponibles en este momento.</p>}
      {items.map((item,i)=>{
        const title=item.name;
        const offset=(i-index+count)%count;
        const position=offset===0?'current':offset===1?'next':offset===count-1?'previous':'away';
        return <article className={`subcategory-card ${position}`} key={title} aria-hidden={i!==index}>
          <img src={item.image} alt="" width="1672" height="941" decoding="async" loading={i<3?'eager':'lazy'}/>
          <div className="subcategory-caption"><span>SERVICIO {String(i+1).padStart(2,'0')}</span><h4>{title}</h4></div>
        </article>;
      })}
    </div>
    <div className="deck-controls"><button type="button" disabled={count<2} onClick={()=>move(-1)} aria-label="Subcategoría anterior">←</button><span>{String(count?index+1:0).padStart(2,'0')} <span className="deck-total">/ {count}</span></span><button type="button" disabled={count<2} onClick={()=>move(1)} aria-label="Subcategoría siguiente">→</button><button type="button" className="deck-pause" disabled={reduced||count<2} onClick={()=>setPaused(!paused)} aria-label={paused?'Reanudar subcategorías':'Pausar subcategorías'}>{reduced?'Sin animación':paused?'Reanudar':'Pausar'}</button></div>
    <p className="deck-note">Explora las opciones. Describe lo que necesitas al solicitar atención.</p>
  </div>;
}

export default function ServiceCarousel({onSelect}) {
  const [active,setActive]=useState(0);
  const scene=services[active];
  const move=direction=>setActive(index=>(index+direction+services.length)%services.length);
  return <section id="servicios" className="service-carousel" aria-label="Especialidades de TécnicoYa">
    <div className="service-carousel-heading"><span className="kicker">01 / ENCUENTRA TU ESPECIALIDAD</span><span>Talento local. Soluciones cerca.</span></div>
    <nav className="service-tabs" aria-label="Seleccionar especialidad">{services.map((service,index)=><button type="button" key={service.id} aria-pressed={active===index} aria-controls="service-slide" onClick={()=>setActive(index)}><span>0{index+1}</span>{service.label}</button>)}</nav>
    <div className="service-split" id="service-slide">
      <div className="service-main">
        <h2 className="service-category-heading">{scene.label}</h2>
        <div className="service-main-photo"><img src={`/media/services/${scene.id}.png`} alt={scene.alt} width="1672" height="941" decoding="async"/></div>
        <div className="service-slide-copy"><h3>{scene.title}<br/><em>{scene.accent}</em></h3><p>{scene.description}</p><a href="#plataforma" className="button primary" onClick={()=>onSelect(scene.id)}>Encontrar un técnico <span aria-hidden="true">↗</span></a></div>
        <div className="category-controls"><button type="button" onClick={()=>move(-1)} aria-label="Especialidad anterior">←</button><span aria-live="polite">{scene.label} · 0{active+1} / 03</span><button type="button" onClick={()=>move(1)} aria-label="Especialidad siguiente">→</button></div>
      </div>
      <SubcategoryDeck key={scene.id} scene={scene}/>
    </div>
  </section>;
}
