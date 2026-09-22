import React from 'react';
import {render,screen,fireEvent,cleanup} from '@testing-library/react';
import {afterEach,test,expect,vi} from 'vitest';
import {RequestForm} from './Marketplace';
afterEach(cleanup);
test('request form passes specialty, zone, address and description',()=>{
 const submit=vi.fn();const {container}=render(<RequestForm specialty="refrigeracion" busy={false} onSubmit={submit}/>);
 expect(screen.getByLabelText('Rubro')).toHaveValue('refrigeracion');
 fireEvent.change(screen.getByLabelText('Dirección o referencia'),{target:{value:'Calle de prueba 123'}});
 fireEvent.change(screen.getByLabelText('Describe la falla'),{target:{value:'La congeladora no está enfriando.'}});
 fireEvent.submit(container.querySelector('form'));
 expect(submit).toHaveBeenCalledWith({specialty:'refrigeracion',zone:'Huancayo',address:'Calle de prueba 123',description:'La congeladora no está enfriando.'});
});
