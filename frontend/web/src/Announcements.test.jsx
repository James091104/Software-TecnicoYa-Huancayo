import React from 'react';
import {render,screen,fireEvent,cleanup,waitFor} from '@testing-library/react';
import {afterEach,test,expect,vi} from 'vitest';
import {AnnouncementFeed,AnnouncementManager,AnnouncementBanner} from './Announcements';
import {actDemo,loadDemo} from './domain/demo';
const item={id:'one',title:'Anuncio para clientes',body:'Información para tu siguiente servicio.',audience:'client',status:'published',priority:1};
afterEach(()=>{cleanup();localStorage.clear();vi.unstubAllGlobals()});
test('feed hides other audiences and drafts and lets users navigate',()=>{
 render(<AnnouncementFeed role="client" items={[item,{...item,id:'two',title:'Para ambos',audience:'both',priority:2},{...item,id:'three',title:'Solo técnicos',audience:'technician'},{...item,id:'four',title:'Borrador secreto',status:'draft'}]}/>);
 expect(screen.getByText('Para ambos')).toBeInTheDocument();
 expect(screen.queryByText('Solo técnicos')).not.toBeInTheDocument();expect(screen.queryByText('Borrador secreto')).not.toBeInTheDocument();
 fireEvent.click(screen.getByRole('button',{name:'Anuncio siguiente'}));expect(screen.getByText(item.title)).toBeInTheDocument();
});
test('unsafe links never render',()=>{render(<AnnouncementBanner item={{...item,linkLabel:'Abrir',linkUrl:'javascript:alert(1)'}}/>);expect(screen.queryByRole('link')).not.toBeInTheDocument()});
test('administrator creates a targeted draft and can publish an edit',async()=>{
 const act=vi.fn().mockResolvedValue(true);const {container}=render(<AnnouncementManager items={[item]} act={act}/>);
 fireEvent.click(screen.getByRole('button',{name:'+ Crear anuncio'}));
 fireEvent.change(screen.getByLabelText('Título del anuncio'),{target:{value:'Aviso de prueba'}});
 fireEvent.change(screen.getByLabelText('Descripción'),{target:{value:'Aviso para técnicos.'}});
 fireEvent.change(screen.getByLabelText('Mostrar a'),{target:{value:'technician'}});
 fireEvent.submit(container.querySelector('form'));await waitFor(()=>expect(act).toHaveBeenCalledWith('announcement-save',expect.objectContaining({title:'Aviso de prueba',audience:'technician',status:'draft'})));
 await waitFor(()=>expect(screen.queryByText('Nuevo anuncio')).not.toBeInTheDocument());
 fireEvent.click(screen.getByRole('button',{name:'Editar '+item.title}));
 fireEvent.change(screen.getByLabelText('Estado del anuncio'),{target:{value:'archived'}});
 fireEvent.submit(container.querySelector('form'));await waitFor(()=>expect(act).toHaveBeenLastCalledWith('announcement-save',expect.objectContaining({id:'one',status:'archived'})));
});
test('failed save keeps the draft for retry',async()=>{const act=vi.fn().mockResolvedValue(false);const {container}=render(<AnnouncementManager items={[item]} act={act}/>);fireEvent.click(screen.getByRole('button',{name:'Editar '+item.title}));fireEvent.submit(container.querySelector('form'));await waitFor(()=>expect(act).toHaveBeenCalled());expect(screen.getByLabelText('Título del anuncio')).toHaveValue(item.title)});
test('demo persists edits and refuses non-administrators',()=>{const s=loadDemo();expect(()=>actDemo(s,{id:'client-demo',role:'client'},'announcement-save',item)).toThrow();const result=actDemo(s,{id:'admin-demo',role:'admin'},'announcement-save',{...item,id:undefined});expect(result.announcements.some(a=>a.title===item.title)).toBe(true)});

test.each([[1600,420,true],[1200,420,false],[1600,600,false]])('image upload enforces exact dimensions %s x %s',async(width,height,valid)=>{
 vi.stubGlobal('Image',class {naturalWidth=width;naturalHeight=height;set src(value){queueMicrotask(()=>this.onload())}});
 const {container}=render(<AnnouncementManager act={vi.fn()}/>);
 fireEvent.click(screen.getByRole('button',{name:'+ Crear anuncio'}));
 fireEvent.change(screen.getByLabelText('Imagen del banner'),{target:{files:[new File(['png'],'banner.png',{type:'image/png'})]}});
 if(valid){await waitFor(()=>expect(container.querySelector('.announcement-image')).toBeInTheDocument());expect(screen.queryByRole('alert')).not.toBeInTheDocument()}
 else{expect(await screen.findByRole('alert')).toHaveTextContent('exactamente 1600 × 420 px');expect(container.querySelector('.announcement-image')).not.toBeInTheDocument()}
});
