import React from 'react';
import {test,expect,vi,beforeEach,afterEach} from 'vitest';
import {render,screen,fireEvent,cleanup,act} from '@testing-library/react';
import ServiceCarousel from './ServiceCarousel';

beforeEach(()=>{vi.stubGlobal('matchMedia',()=>({matches:false,addEventListener:vi.fn(),removeEventListener:vi.fn()}));vi.stubGlobal('IntersectionObserver',class{constructor(cb){this.cb=cb}observe(){this.cb([{isIntersecting:true}])}disconnect(){}})});
afterEach(()=>{cleanup();vi.useRealTimers();vi.unstubAllGlobals()});

test('carousel wraps, changes its catalog and preserves the selected specialty on the request link',()=>{
 const select=vi.fn();const {container}=render(<ServiceCarousel onSelect={select}/>);
 expect(container.querySelector('canvas')).toBeNull();
 fireEvent.click(screen.getByRole('button',{name:'Especialidad anterior'}));
 expect(screen.getByText('Puesta a tierra')).toBeTruthy();
 fireEvent.click(screen.getByRole('button',{name:'Especialidad siguiente'}));
 expect(screen.getByText('Recuperación de datos')).toBeTruthy();
 fireEvent.click(screen.getByRole('button',{name:/Refrigeración/}));
 expect(screen.getByText('Cámaras de frío')).toBeTruthy();
 expect(screen.queryByText('Recuperación de datos')).toBeNull();
 const link=screen.getByRole('link',{name:/Encontrar un técnico/});
 expect(link.getAttribute('href')).toBe('#plataforma');fireEvent.click(link);
 expect(select).toHaveBeenCalledWith('refrigeracion');cleanup();
});


test('automatic deck advances and pauses on interaction',()=>{
 vi.useFakeTimers();const {container}=render(<ServiceCarousel onSelect={()=>{}}/>);
 const title=()=>container.querySelector('.subcategory-card.current h4').textContent;
 expect(title()).toBe('Reparación de hardware');
 act(()=>vi.advanceTimersByTime(2499));expect(title()).toBe('Reparación de hardware');
 act(()=>vi.advanceTimersByTime(1));expect(title()).toBe('Mantenimiento preventivo');
 fireEvent.click(screen.getByRole('button',{name:'Pausar subcategorías'}));
 act(()=>vi.advanceTimersByTime(5000));expect(title()).toBe('Mantenimiento preventivo');
 fireEvent.click(screen.getByRole('button',{name:'Subcategoría anterior'}));expect(title()).toBe('Reparación de hardware');
});
