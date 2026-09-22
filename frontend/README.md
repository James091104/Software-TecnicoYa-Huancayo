# frontend/

Directorio para los módulos de frontend de la aplicación.
Cada subdirectorio dentro de `frontend/` es descubierto, construido y probado automáticamente por el Framework DevOps.

---

## 🌐 Matriz de Comandos Frontend

| Framework | Comando en el Pipeline (CI) | Comando Local del Estudiante | ¿Qué evalúa y prueba? | Archivo para SonarQube |
|---|---|---|---|---|
| **React (Vite / CRA)** | `npm run test -- --coverage --watchAll=false` | `npm test` | Renderizado con React Testing Library, hooks personalizados y eventos DOM. | `coverage/lcov.info` |
| **Angular** | `ng test --watch=false --browsers=ChromeHeadless` | `ng test` | Componentes, servicios inyectables, pipes y directivas con Jasmine/Karma. | `coverage/lcov.info` |
| **Vue.js** | `npx vitest run --coverage` | `npm run test` | Reactividad (ref/reactive), mutaciones Pinia y componentes .vue. | `coverage/lcov.info` |
| **Next.js** | `npm run test` (Jest / Vitest) | `npm test` | Server Components, Server Actions y rutas API de `app/api/`. | `coverage/lcov.info` |
| **Nuxt** | `npm run test` | `npm test` | Auto-imports de composición y renderizado SSR de páginas Nuxt. | `coverage/lcov.info` |
| **SvelteKit** | `npx vitest run --coverage` | `npm test` | Stores reactivos Svelte y carga de datos en `+page.server.js`. | `coverage/lcov.info` |
| **Astro** | `npm run test` o `astro check` | `npx astro check` | Validación de tipos TypeScript y componentes isla. | Salida JUnit / CLI |
| **Remix** | `npm run test` | `npm test` | Loaders, Actions y enrutamiento basado en URLs. | `coverage/lcov.info` |
| **Blazor (WASM)** | `dotnet test --collect:"XPlat Code Coverage"` | `dotnet test` | Componentes Razor e inyección de dependencias C# en cliente. | `coverage.cobertura.xml` |

---

## ⚙️ Activación de un Módulo
Para que un módulo frontend sea construido y desplegado automáticamente, debe contener estos 3 archivos:
1. `package.json` (o manifiesto según tecnología) con scripts de construcción (`build`, `dev`, `test`).
2. `Dockerfile` configurado con `ARG PORT` y `ENV PORT=${PORT}`.
3. `.env.example` con la variable `PORT=4200` y `VITE_API_URL` (o equivalente).

## Puerto Asignado por Defecto
* `4200` (Rango de puertos frontend: 4200 - 4299)
