import React from 'react';
import {render,screen,fireEvent,cleanup,waitFor,act} from '@testing-library/react';
import {afterEach,test,expect,vi} from 'vitest';
import {AccessManager,AccountPanel} from './AccountPanel';
import {actDemo,loadDemo} from './domain/demo';
import {can} from './domain/permissions';
import {api,storeSession,apiSession} from './marketplace-api';
import * as apiModule from './marketplace-api';
import Marketplace from './Marketplace';
import Auth from './Auth';
afterEach(()=>{cleanup();localStorage.clear();sessionStorage.clear();vi.restoreAllMocks();vi.unstubAllGlobals()});
test('unknown roles and foreign operations are denied',()=>{expect(can({role:'owner'},'verify')).toBe(false);expect(can({role:'client'},'accounts')).toBe(false);expect(()=>actDemo(loadDemo(),{id:'client-demo',role:'client'},'accounts',{userId:'tech-ana',active:false})).toThrow()});
test('suspended demo technician cannot accept operations',()=>{const s=actDemo(loadDemo(),{id:'admin-demo',role:'admin'},'accounts',{userId:'tech-ana',active:false});expect(s.accessEvents).toHaveLength(1);expect(()=>actDemo(s,{id:'tech-ana',role:'technician'},'availability',{available:true})).toThrow('suspendida')});
test('account search and suspension confirmation target the correct user',async()=>{const act=vi.fn().mockResolvedValue(true);render(<AccessManager users={[{id:'1',name:'Ana',email:'ana@test.pe',role:'technician',active:true},{id:'2',name:'Admin',role:'admin',active:true}]} act={act}/>);fireEvent.change(screen.getByLabelText('Buscar usuario'),{target:{value:'ana@'}});expect(screen.queryByText('Cuenta protegida')).not.toBeInTheDocument();fireEvent.click(screen.getByRole('button',{name:'Suspender'}));expect(act).not.toHaveBeenCalled();fireEvent.click(screen.getByRole('button',{name:'Confirmar cambio'}));await waitFor(()=>expect(act).toHaveBeenCalledWith('accounts',{userId:'1',active:false}));});
test('profile shows only permissions belonging to the actor',()=>{render(<AccountPanel actor={{id:'1',name:'Ana',role:'client'}} requests={[]} act={vi.fn()}/>);expect(screen.getByText('Solicitar servicios')).toBeInTheDocument();expect(screen.queryByText('Verificar técnicos')).not.toBeInTheDocument();});
test('expired sessions clear local credentials and emit logout event',async()=>{storeSession({token:'expired',actor:{id:'1',role:'client'}});const listener=vi.fn();window.addEventListener('tecnicoya:session-expired',listener);vi.stubGlobal('fetch',vi.fn().mockResolvedValue({ok:false,status:401,json:async()=>({message:'Sesión vencida'})}));await expect(api('/state')).rejects.toThrow('Sesión vencida');expect(apiSession()).toBeNull();expect(listener).toHaveBeenCalledOnce();window.removeEventListener('tecnicoya:session-expired',listener);});

test('a delayed account response cannot replace the demo actor',async()=>{
 storeSession({token:'test-token',actor:{id:'admin-real',name:'Administrador real',role:'admin'}});
 let resolve;vi.spyOn(apiModule,'api').mockImplementation(()=>new Promise(done=>{resolve=done}));
 render(<Marketplace/>);
 fireEvent.click(screen.getByRole('button',{name:'Mi cuenta'}));
 fireEvent.click(screen.getByRole('button',{name:'Explorar demo'}));
 await act(async()=>resolve({actor:{id:'admin-real',name:'Administrador real',role:'admin'},state:{requests:[],technicians:[]}}));
 expect(screen.getByText('Hola, Cliente de demostración')).toBeInTheDocument();
 expect(screen.queryByText('Hola, Administrador real')).not.toBeInTheDocument();
});

test('registration returns to login without signing in and clears password',async()=>{
 const login=vi.fn();vi.spyOn(apiModule,'api').mockResolvedValue({message:'Cuenta creada'});
 const {container}=render(<Auth onLogin={login}/>);
 fireEvent.click(screen.getAllByRole('button',{name:/Crear una cuenta/})[0]);
 fireEvent.change(screen.getByLabelText('Nombre'),{target:{value:'Cuenta de prueba'}});
 fireEvent.change(screen.getByLabelText('Correo'),{target:{value:'prueba@example.test'}});
 fireEvent.change(screen.getByLabelText('Contraseña'),{target:{value:'Prueba123!'}});
 fireEvent.submit(container.querySelector('form'));
 await screen.findByRole('heading',{name:'Iniciar sesión'});
 expect(login).not.toHaveBeenCalled();
 expect(screen.getByLabelText('Correo')).toHaveValue('prueba@example.test');
 expect(screen.getByLabelText('Contraseña')).toHaveValue('');
 expect(screen.getByRole('status')).toHaveTextContent('Cuenta creada correctamente');
});
test('logout clears the session and returns to login for another account',async()=>{
 const actor={id:'1',name:'Cliente de prueba',role:'client'};storeSession({token:'current',actor});
 const mock=vi.spyOn(apiModule,'api').mockImplementation(async path=>path==='/state'?{actor,state:{requests:[],technicians:[]}}:{ok:true});
 render(<Marketplace accountOnly/>);
 await screen.findByText('Hola, Cliente de prueba');
 fireEvent.click(screen.getByRole('button',{name:'Cerrar sesión / Cambiar cuenta'}));
 await screen.findByRole('heading',{name:'Iniciar sesión'});
 expect(mock).toHaveBeenCalledWith('/logout',{});
 expect(apiSession()).toBeNull();
 expect(screen.queryByText('Hola, Cliente de prueba')).not.toBeInTheDocument();
});
