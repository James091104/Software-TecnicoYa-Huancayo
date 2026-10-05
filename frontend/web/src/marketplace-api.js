const TOKEN_KEY='tecnicoya.api-session';
export const apiSession=()=>{try{return JSON.parse(sessionStorage.getItem(TOKEN_KEY))}catch{return null}};
export const storeSession=(data)=>data?sessionStorage.setItem(TOKEN_KEY,JSON.stringify(data)):sessionStorage.removeItem(TOKEN_KEY);
export async function api(path,body,method=body?'POST':'GET'){
 const token=apiSession()?.token;
 const response=await fetch('/api'+path,{method,headers:{Accept:'application/json',...(body?{'Content-Type':'application/json'}:{}),...(token?{Authorization:'Bearer '+token}:{})},...(body?{body:JSON.stringify(body)}:{}),signal:AbortSignal.timeout(12000)});
 let result;try{result=await response.json()}catch{throw Error('No se pudo conectar con Laravel. Comprueba que la API esté iniciada.')}
 if(response.status===401&&token&&apiSession()?.token===token){storeSession(null);window.dispatchEvent(new Event('tecnicoya:session-expired'));}
 if(!response.ok)throw Error(Object.values(result.errors||{}).flat().join(' ')||result.message||'No se pudo completar la acción.');return result;
}
