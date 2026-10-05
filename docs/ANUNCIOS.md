# Anuncios por perfil

En la cuenta del administrador, abrir Centro de anuncios y pulsar Crear anuncio.

1. Escribir título y descripción.
2. Elegir Clientes, Técnicos o Clientes y técnicos.
3. Subir una imagen opcional PNG, JPG o WebP, de hasta 2 MB. Se exigen exactamente 1600 × 420 px, tanto al seleccionar el archivo como al guardarlo en el servidor. El título, mensaje y botón se muestran sobre la imagen, con un degradado para facilitar la lectura. En pantallas pequeñas se adapta el encuadre para mantener el texto legible y evitar bordes vacíos.
4. Añadir, si hace falta, un botón con texto y enlace http/https.
5. Definir prioridad (0–100; mayor prioridad aparece primero).
6. Revisar la vista previa y elegir Borrador o Publicado antes de guardar.

Editar permite cambiar audiencia, contenido y estado. Archivado retira el anuncio y conserva su contenido para una futura republicación. La vista «Comprobar qué ve cada perfil» muestra únicamente las publicaciones de ese perfil.

Clientes y técnicos ven el carrusel sobre el resumen de su cuenta. Los controles permiten avanzar sin rotación automática. Si no hay publicaciones para un perfil, no se muestra el carrusel. Los cambios llegan al resto de sesiones con la actualización periódica (aproximadamente 15 segundos) o al recargar.

La API filtra audiencia y estado en el servidor y exige el permiso administrativo announcement-save para guardar. El registro público no permite crear administradores. Las imágenes se validan por formato, tamaño y dimensiones antes de guardarlas; no se permiten SVG ni enlaces ejecutables.

La migración 2026_09_28_000003_create_announcements está aplicada al entorno local. En otros entornos ejecutar php artisan migrate. La demo incluye dos anuncios ficticios de bienvenida, uno por perfil. Las cuentas reales comienzan sin publicaciones: el administrador decide el contenido que se publicará.
