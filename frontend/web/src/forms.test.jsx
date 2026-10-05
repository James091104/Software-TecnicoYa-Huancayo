import React from 'react';
import {render,screen,fireEvent,cleanup} from '@testing-library/react';
import {afterEach,test,expect,vi} from 'vitest';
import {RequestForm} from './Marketplace';
afterEach(cleanup);
test('request form passes specialty, zone, address and description',()=>{
 const submit=vi.fn();const {container}=render(<RequestForm specialty="refrigeracion" busy={false} onSubmit={submit}/>);
 expect(screen.getByLabelText('Rubro')).toHaveValue('refrigeracion');
 fireEvent.change(screen.getByLabelText('Subcategoría'),{target:{value:'refrigeracion-vitrinas'}});
 fireEvent.change(screen.getByLabelText('Dirección o referencia'),{target:{value:'Calle de prueba 123'}});
 fireEvent.change(screen.getByLabelText('Describe la falla'),{target:{value:'La congeladora no está enfriando.'}});
 fireEvent.submit(container.querySelector('form'));
 expect(submit).toHaveBeenCalledWith({specialty:'refrigeracion',subcategory:'refrigeracion-vitrinas',zone:'Huancayo',address:'Calle de prueba 123',description:'La congeladora no está enfriando.'});
});


test('changing specialty clears subcategory and only exposes relevant options',()=>{
 render(<RequestForm specialty="computo" busy={false} onSubmit={()=>{}}/>);
 fireEvent.change(screen.getByLabelText('Subcategoría'),{target:{value:'computo-hardware'}});
 fireEvent.change(screen.getByLabelText('Rubro'),{target:{value:'electricidad'}});
 expect(screen.getByLabelText('Subcategoría')).toHaveValue('');
 expect(screen.queryByRole('option',{name:'Reparación de hardware'})).toBeNull();
 expect(screen.getByRole('option',{name:'Tableros eléctricos'})).toBeTruthy();
});
