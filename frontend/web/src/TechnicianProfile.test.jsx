import React from 'react';
import {render,screen,fireEvent,cleanup} from '@testing-library/react';
import {afterEach,test,expect,vi} from 'vitest';
import TechnicianProfile from './TechnicianProfile';
import {actDemo,loadDemo} from './domain/demo';

afterEach(()=>{cleanup();localStorage.clear()});
test('technician can update their coverage and fee without granting verification',()=>{
 const state=loadDemo(), technician=state.technicians[0], act=vi.fn();
 render(<TechnicianProfile technician={technician} requests={[]} act={act}/>);
 fireEvent.click(screen.getByText('Mi tarifa y cobertura'));
 fireEvent.change(screen.getByLabelText('Tarifa de visita (S/)'),{target:{value:'55'}});
 fireEvent.click(screen.getByRole('button',{name:'Guardar tarifa y cobertura'}));
 expect(act).toHaveBeenCalledWith('technician-profile',{zone:technician.zone,zones:technician.zones,fee:55,subcategories:technician.subcategories});
 const pending=state.technicians.find(t=>!t.verified);
 const updated=actDemo(state,{id:pending.id,role:'technician'},'technician-profile',{zone:'Huancayo',zones:['El Tambo'],fee:55,verified:true});
 expect(updated.technicians.find(t=>t.id===pending.id)).toMatchObject({fee:55,zone:'Huancayo',zones:['Huancayo','El Tambo'],verified:false});
});
test('pending offers prevent changing service terms in the UI and demo',()=>{
 const state=actDemo(loadDemo(),{id:'client-demo',role:'client'},'create',{specialty:'computo',subcategory:'computo-hardware',zone:'Huancayo',address:'Calle prueba 123',description:'Mi computadora no enciende'});
 const technician=state.technicians.find(t=>t.id===state.requests[0].offers[0].technicianId);
 render(<TechnicianProfile technician={technician} requests={state.requests} act={vi.fn()}/>);
 fireEvent.click(screen.getByText('Mi tarifa y cobertura'));
 expect(screen.getByRole('button',{name:'Guardar tarifa y cobertura'})).toBeDisabled();
 expect(()=>actDemo(state,{id:technician.id,role:'technician'},'technician-profile',{zone:'Huancayo',zones:['Huancayo'],fee:90})).toThrow('Responde tus ofertas');
});
