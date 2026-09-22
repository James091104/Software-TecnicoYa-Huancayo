# Secuencia de especialidades

La sección `servicios` dibuja fotogramas WebP en un canvas según el desplazamiento, después del hero existente. El fundido de entrada solapa ambas secciones y el desplazamiento inverso reproduce el recorrido en sentido contrario.

El video utilizado es el archivo de Descargas `Technicians_working_on_various_e…_20260922125620.mp4`: 1280 × 720, 24 fps, aproximadamente 10 segundos. Se generaron 240 imágenes por variante: escritorio (1280 px, 19,49 MB en total) y móvil (1280 px, 14,88 MB en total).

Los códigos se interpretan como segundos y fotogramas a 24 fps:

| Sección | Código | Fotograma |
| --- | --- | --- |
| Tu tecnología, en marcha. | 00:02:08 | 56 |
| Refrigeración comercial | 00:05:06 | 126 |
| Electricidad | 00:07:07 | 175 |

Los archivos públicos están en `frontend/web/public/media/scroll-sequence`. El manifiesto está en `frontend/web/src/scroll/sequence.json` y el componente en `frontend/web/src/scroll/ScrollServices.jsx`.

La caché mantiene hasta 14 imágenes en móvil y 22 en escritorio, con un máximo de tres cargas simultáneas. Fuera de pantalla o con la pestaña oculta se detiene la precarga. Con movimiento reducido se muestran tres secciones estáticas con sus procedimientos y enlaces al formulario existente. El video del hero se pausa cuando este sale de pantalla.

Para regenerar la secuencia, instala `imageio-ffmpeg` en el entorno Python y ejecuta `python scripts/build-scroll-sequence.py "ruta-al-video.mp4"`. Los tiempos de las escenas se definen en ese script. El video original no se necesita para servir las imágenes generadas.

Validación: 15 pruebas del frontend y compilación Vite; revisión visual de las tres escenas y de la transición desde el hero, incluido un viewport móvil de 390 × 844.

El seguimiento del scroll usa amortiguación exponencial de 100 ms, independiente de la frecuencia de pantalla, y se detiene al alcanzar la posición objetivo. Se precargan hasta diez fotogramas en la dirección de avance. La extracción usa WebP de calidad 92/88 y el canvas admite DPR hasta 2 con escalado de alta calidad.
