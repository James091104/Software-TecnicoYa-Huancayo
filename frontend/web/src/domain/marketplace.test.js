import {describe,test,expect} from 'vitest';
import {initialState,actDemo,advance} from './demo';
import {rankTechnicians,rules} from './matching';
import fixture from './matching-fixture.json';
const client={id:'c',role:'client'},request={specialty:'computo',subcategory:'computo-hardware',zone:'Huancayo',address:'Calle de prueba 123',description:'Mi laptop no puede encender.'};
describe('matching shared contract',()=>{
 test('same ranking and scores as Python and PHP',()=>{const result=rankTechnicians(fixture.request,fixture.technicians);expect(result.map(t=>t.id)).toEqual(fixture.expectedIds);expect(result.map(t=>t.score)).toEqual(fixture.expectedScores)});
 test('filters unavailable, unverified and uncovered technicians',()=>{const state=initialState();expect(rankTechnicians({...request,zone:'Fuera'},state.technicians)).toEqual([]);expect(rankTechnicians(request,state.technicians.map(t=>({...t,available:false})))).toEqual([])});
 test('ties prioritize rating',()=>{const base={...fixture.technicians[0],subcategories:['computo-hardware']};const result=rankTechnicians(request,[{...base,id:'a',rating:4,years:10},{...base,id:'b',rating:5,years:6}]);expect(result[0].score).toBe(result[1].score);expect(result[0].id).toBe('b')});
});
test('complete service lifecycle, role controls and no duplicate rating',()=>{let s=actDemo(initialState(),client,'create',request,1000);const id=s.requests[0].id;expect(s.requests[0].offers.length).toBe(3);const t={id:s.requests[0].offers[0].technicianId,role:'technician'};s=actDemo(s,t,'accept',{id},2000);expect(s.requests[0].status).toBe('proposed');expect(()=>actDemo(s,t,'confirm',{id},2000)).toThrow();s=actDemo(s,client,'confirm',{id},3000);s=actDemo(s,t,'start',{id},4000);s=actDemo(s,t,'complete',{id},5000);s=actDemo(s,client,'rate',{id,rating:5},6000);expect(s.requests[0].status).toBe('rated');expect(()=>actDemo(s,client,'rate',{id,rating:5},7000)).toThrow()});
test('offers expire exactly at ten minutes and unassigned closes at 24 hours',()=>{const s=actDemo(initialState(),client,'create',request,0);advance(s,rules.responseMinutes*60000);expect(s.requests[0].offers.every(o=>o.status==='expired')).toBe(true);expect(s.requests[0].status).toBe('pending_availability');advance(s,rules.pendingHours*3600000);expect(s.requests[0].status).toBe('unassigned')});
test('new availability triggers matching and rating closes exactly at 48 hours',()=>{const base=initialState();base.technicians.forEach(t=>t.available=false);let s=actDemo(base,client,'create',request,0);expect(s.requests[0].status).toBe('pending_availability');s=actDemo(s,{id:'tech-ana',role:'technician'},'availability',{available:true},1000);expect(s.requests[0].offers).toHaveLength(1);const id=s.requests[0].id,t={id:'tech-ana',role:'technician'};for(const [a,action] of [[t,'accept'],[client,'confirm'],[t,'start'],[t,'complete']])s=actDemo(s,a,action,{id},2000);expect(()=>actDemo(s,client,'rate',{id,rating:5},2000+rules.ratingHours*3600000)).toThrow()});


test('subcategory filters fail closed for unrelated, missing, inactive and unknown skills',()=>{
 const base={...fixture.technicians[0],specialties:['computo'],subcategories:['computo-hardware'],verified:true,available:true};
 expect(rankTechnicians(request,[{...base,id:'ok'},{...base,id:'other',subcategories:['computo-redes']},{...base,id:'legacy',subcategories:undefined},{...base,id:'disabled',active:false}]).map(t=>t.id)).toEqual(['ok']);
 expect(rankTechnicians({...request,subcategory:'electricidad-tableros'},[base])).toEqual([]);
 expect(rankTechnicians({...request,subcategory:'unknown'},[base])).toEqual([]);
 const category=rules.subcategories.find(s=>s.id===request.subcategory);category.active=false;
 try{expect(rankTechnicians(request,[base])).toEqual([])}finally{category.active=true}
});
test('demo rejects cross-specialty skills and requests',()=>{
 const s=initialState();
 expect(()=>actDemo(s,client,'create',{...request,subcategory:'electricidad-tableros'})).toThrow('subcategoría');
 expect(()=>actDemo(s,{id:'tech-ana',role:'technician'},'technician-profile',{zone:'Huancayo',zones:['Huancayo'],fee:45,subcategories:['electricidad-tableros']})).toThrow('subcategorías');
});
