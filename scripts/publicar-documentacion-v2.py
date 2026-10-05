"""Instala PDFs ya revisados y conserva la colección anterior sin sobrescribirla."""
from pathlib import Path
import json,hashlib,shutil,csv
from pypdf import PdfReader
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'docs/documentacion';STAGE=ROOT/'tmp/pdfs/v2-final'
docs=json.loads((OUT/'editables/v2/contenido.json').read_text(encoding='utf-8'))
articles=json.loads((OUT/'editables/v2/articulos.json').read_text(encoding='utf-8'))
inventory=json.loads((ROOT/'tmp/pdfs/articulos/inventory.json').read_text(encoding='utf-8'))
assert len(docs)==17 and len(articles)==30 and len(inventory)==32
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for d in docs:
 p=STAGE/d['name'];assert len(PdfReader(p).pages)==d['page_count']==len(d['pages'])
hist=OUT/'historico/v1-previa-2026-09-29';hist.mkdir(parents=True,exist_ok=True)
newnames={d['name'] for d in docs}
oldfiles=[p for p in OUT.glob('*.pdf') if p.name not in newnames]
for p in oldfiles:
 assert p.resolve().parent==OUT.resolve()
 target=hist/p.name
 if target.exists():assert sha(target)==sha(p)
 else:shutil.copy2(p,target)
 assert sha(p)==sha(target)
 p.unlink()
for name in ['README.md','catalogo-pdfs.json']:
 p=OUT/name
 if p.exists() and not (hist/name).exists():shutil.copy2(p,hist/name)
sources=OUT/'fuentes/articulos';sources.mkdir(parents=True,exist_ok=True)
for item in inventory:
 src=Path(item['path']);dst=sources/(item['id']+'.pdf');shutil.copy2(src,dst)
 assert sha(dst)==item['sha256']
 item['stored_path']='fuentes/articulos/'+dst.name
 item.pop('first',None);item.pop('metadata',None)
(sources/'manifest.json').write_text(json.dumps(inventory,ensure_ascii=False,indent=2),encoding='utf-8')
trace=OUT/'trazabilidad/v2';trace.mkdir(parents=True,exist_ok=True)
with (trace/'articulos.csv').open('w',encoding='utf-8-sig',newline='') as f:
 writer=csv.DictWriter(f,fieldnames=list(articles[0]));writer.writeheader();writer.writerows(articles)
content=[]
for d in docs:
 shutil.copy2(STAGE/d['name'],OUT/d['name']);content.append({'file':d['name'],'title':d['title'],'pages':d['page_count'],'sha256':sha(OUT/d['name'])})
(OUT/'catalogo-pdfs.json').write_text(json.dumps({'version':'2.0','date':'2026-09-29','documents':content},ensure_ascii=False,indent=2),encoding='utf-8')
for n in range(1,11):
 ev=OUT/f'evidencias/v2/I{n:02}';ev.mkdir(parents=True,exist_ok=True)
 p=ev/'README.md'
 if not p.exists():p.write_text(f'# Iteración I{n:02}\n\nEstado: PLANIFICADA / NO EJECUTADA como iteración.\n\nRegistrar al ejecutar: commit, entorno, fecha, responsable, casos, resultado esperado y observado, logs, incidentes, retest, revisión y despliegue. No incluir secretos ni datos personales. Las pruebas anteriores no equivalen al cierre de esta iteración.\n',encoding='utf-8')
index=['# TécnicoYa Huancayo - Documentación v2.0','', 'Fecha: 29/09/2026. Colección adaptada al marketplace de servicios técnicos; no es un proyecto de salud.','',f'17 PDF, {sum(d["page_count"] for d in docs)} páginas. La versión anterior se conserva en `historico/v1-previa-2026-09-29/`; originales académicos, matrices RF/RNF y plan consolidado previo permanecen en sus carpetas.','','## Documentos base','']
for d in docs[:7]:index.append(f'- [{d["title"]}]({d["name"]}) ({d["page_count"]} páginas).')
index+=['','## Iteraciones','']
for d in docs[7:]:index.append(f'- [{d["title"]}]({d["name"]}) ({d["page_count"]} páginas).')
index+=['','## Qué cambió respecto de la lista de referencia','','- Los dos análisis son definición del MVP con evidencia y análisis detallado del flujo.','- Los dos diccionarios son físico PostgreSQL y conceptual/contratos. No se migró a MySQL.','- Los dos diseños técnicos son arquitectura e integración/servidor/calidad. No se generaron duplicados «(1)».','- La iteración 2 documenta roles y propiedad; no inventa multitenencia.','- La iteración 3 trata habilitación y condiciones, sin suscripción obligatoria.','- La agenda sanitaria se adapta al matching y disponibilidad inmediata.','- I06, I07 e I09 son ampliaciones propuestas (asistente, LLM y pagos), no código existente.','- Cada iteración distingue preparación, frontend, Laravel, Python, datos, pruebas, despliegue y criterios de salida.','','## Sustento científico','','32 archivos, 30 documentos únicos y dos duplicados exactos (A04=A03, A16=A15). Se extrajo texto de 894 páginas; 813 sin duplicados. La revisión es crítica de un corpus proporcionado, no revisión sistemática exhaustiva.','Las fichas del documento 01 incluyen método, hallazgo, limitaciones, aplicación y páginas de origen. No trasladar porcentajes de otros países/ciudades a Huancayo.','- Copias íntegras: `fuentes/articulos/Axx.pdf`.','- Inventario con SHA-256, origen y duplicados: `fuentes/articulos/manifest.json`.','- Matriz: `trazabilidad/v2/articulos.csv`.','- Estructura editable y diccionario: `editables/v2/`.','','## Pruebas y estado de implementación','','El documento 07 y la iteración 10 organizan el plan transversal de pruebas; el maestro previo se conserva en el histórico. Las matrices RF/RNF originales no se marcan aprobadas automáticamente. Evidencias de nuevas iteraciones: `evidencias/v2/I01` a `I10`, inicialmente no ejecutadas.','Referencias de calidad: ISO 9001:2026 (edición publicada según ficha oficial consultada), ISO/IEC 25010:2023, ISO/IEC/IEEE 29148:2018 y 29119-3:2021, WCAG 2.2 y ASVS. Alineación documental no significa certificación.','','## Regeneración y revisión','','Desde la raíz: `python scripts/generar-documentacion-v2.py` genera los 17 PDF en `tmp/pdfs/v2-final/`. Requiere ReportLab, pypdf y Arial de Windows. El generador es la fuente de autoría; JSON conserva la estructura editable de la versión.','Renderizar y revisar páginas antes de instalar una revisión. `scripts/publicar-documentacion-v2.py` conserva la colección anterior y copia los resultados revisados. No ejecutar este publicador para otra versión sin actualizar explícitamente el destino histórico.','','## Control de fuentes','','Los PDF de referencia sanitaria no se proporcionaron: se adaptó la estructura de sus títulos, no se atribuye una lectura de su contenido. Los archivos en `C:/Users/James/Documents/articulos` se leyeron y copiaron sin modificaciones. No se cambió el código de la aplicación en esta revisión documental.']
(OUT/'README.md').write_text('\n'.join(index)+'\n',encoding='utf-8')
(hist/'LEEME-HISTORICO.md').write_text('# Versión histórica\n\nPDF previos conservados el 29/09/2026. Sus rutas relativas a fuentes, trazabilidad y editables deben resolverse desde docs/documentacion, ubicación original. El README de este directorio es la copia original y sus enlaces auxiliares pueden requerir esa raíz. Para la colección vigente consultar ../../README.md.\n',encoding='utf-8')
(OUT.parent/'README.md').write_text('# Documentación del proyecto\n\nConsulta la [colección v2 de 17 documentos](documentacion/README.md): análisis científico, MVP, backlog, diccionarios, diseños técnicos y diez iteraciones de TécnicoYa Huancayo.\n\nEl plan transversal está en el documento 07 y la iteración 10; los originales, plan maestro previo y evidencias históricas se conservan para trazabilidad.\n',encoding='utf-8')
print(json.dumps({'pdfs':len(content),'pages':sum(x['pages'] for x in content),'archived':len(oldfiles),'sources':len(inventory)},ensure_ascii=False))
