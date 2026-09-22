# backend/

Directorio para los módulos de backend / APIs del sistema.
Cada subdirectorio dentro de `backend/` es descubierto, construido y probado automáticamente por el Framework DevOps.

---

## 🟢 Matriz de Comandos Backend por Ecosistema

### Node.js / TypeScript
| Framework | Comando en el Pipeline (CI) | Comando Local del Estudiante | ¿Qué evalúa y prueba? | Archivo para SonarQube |
|---|---|---|---|---|
| **Express** | `npm run test:cov` (o `npm test`) | `npm test` | Middlewares de autenticación, rutas HTTP con Supertest (status 200, 201, 400). | `coverage/lcov.info` |
| **NestJS** | `npm run test:cov` | `npm run test:cov` | Guards, Interceptors, Pipes y Controllers mediante Jest. | `coverage/lcov.info` |
| **Fastify** | `npm test` | `npm test` | Invocación en memoria mediante `fastify.inject()` sin latencia TCP. | `coverage/lcov.info` |
| **AdonisJS** | `node ace test` | `node ace test` | Modelos Lucid ORM, migraciones de prueba y el test runner Japa. | `coverage/lcov.info` |

### Java
| Framework | Comando en el Pipeline (CI) | Comando Local del Estudiante | ¿Qué evalúa y prueba? | Archivo para SonarQube |
|---|---|---|---|---|
| **Spring Boot** | `mvn test -B` (o `./gradlew test`) | `mvn test` | Servicios con `@MockBean`, repositorios JPA y controladores con MockMvc. | `target/site/jacoco/jacoco.xml` |
| **Quarkus** | `mvn test -B` | `mvn test` | Inyección CDI ArC, REST Panache y testing reactivo Mutiny. | `target/jacoco-report/jacoco.xml` |
| **Micronaut** | `mvn test -B` | `mvn test` | Inyección de dependencias en tiempo de compilación y clientes HTTP reactivos. | `JaCoCo XML` |
| **Jakarta EE** | `mvn test -B` | `mvn test` | Validadores de entidad (`@Valid`), EJBs y endpoints JAX-RS. | `JaCoCo XML` |

### Go (Golang)
| Framework | Comando en el Pipeline (CI) | Comando Local del Estudiante | ¿Qué evalúa y prueba? | Archivo para SonarQube |
|---|---|---|---|---|
| **Gin** | `go test -v -covermode=atomic -coverprofile=coverage.out ./...` | `go test ./...` | Routers de Gin simulados con `httptest.NewRecorder()` y binding de structs. | `coverage.out` |
| **Fiber** | `go test -v -covermode=atomic -coverprofile=coverage.out ./...` | `go test ./...` | Handlers FastHTTP simulados con `app.Test()` sin levantar puerto de red. | `coverage.out` |
| **Echo** | `go test -v -covermode=atomic -coverprofile=coverage.out ./...` | `go test ./...` | Contextos `echo.Context`, middlewares y parseo de peticiones JSON. | `coverage.out` |
| **Chi** | `go test -v -covermode=atomic -coverprofile=coverage.out ./...` | `go test ./...` | Routers livianos compatibles con la interfaz `http.Handler` estándar. | `coverage.out` |

### C# / .NET
| Framework | Comando en el Pipeline (CI) | Comando Local del Estudiante | ¿Qué evalúa y prueba? | Archivo para SonarQube |
|---|---|---|---|---|
| **ASP.NET Core** | `dotnet test --collect:"XPlat Code Coverage"` | `dotnet test` | APIs con `WebApplicationFactory<Program>` y Entity Framework InMemory. | `TestResults/.../coverage.cobertura.xml` |
| **ABP Framework** | `dotnet test` | `dotnet test` | Módulos DDD, Domain Services y permisos de aplicación. | `coverage.cobertura.xml` |
| **ServiceStack** | `dotnet test` | `dotnet test` | DTOs fuertemente tipados y contratos de servicio. | `coverage.cobertura.xml` |

### PHP
| Framework | Comando en el Pipeline (CI) | Comando Local del Estudiante | ¿Qué evalúa y prueba? | Archivo para SonarQube |
|---|---|---|---|---|
| **Laravel** | `php artisan test` (Pest / PHPUnit) | `php artisan test` | Modelos Eloquent con SQLite en memoria, factories y pruebas HTTP. | `coverage.xml` |
| **Symfony** | `php bin/phpunit` | `php bin/phpunit` | Inyección de dependencias, controladores `WebTestCase` y votantes de seguridad. | `coverage.xml` |
| **CodeIgniter** | `phpunit` | `phpunit` | Controladores MVC y modelos de persistencia. | `coverage.xml` |
| **Yii** | `vendor/bin/codecept run` | `vendor/bin/codecept run` | Pruebas funcionales y de aceptación de Codeception. | `coverage.xml` |

### Rust
| Framework | Comando en el Pipeline (CI) | Comando Local del Estudiante | ¿Qué evalúa y prueba? | Archivo para SonarQube |
|---|---|---|---|---|
| **Actix-Web** | `cargo test` | `cargo test` | App factories con `actix_web::test`, extractores tipados y servicios. | Tarpaulin / Salida CLI |
| **Axum** | `cargo test` | `cargo test` | Handlers con Tower Services y llamadas simuladas con `tower::ServiceExt`. | Tarpaulin / Salida CLI |
| **Rocket** | `cargo test` | `cargo test` | Clientes locales con `rocket::local::blocking::Client`. | Salida CLI |
| **Warp** | `cargo test` | `cargo test` | Filtros combinables con `warp::test::request()`. | Salida CLI |

### Ruby
| Framework | Comando en el Pipeline (CI) | Comando Local del Estudiante | ¿Qué evalúa y prueba? | Archivo para SonarQube |
|---|---|---|---|---|
| **Ruby on Rails** | `bundle exec rails test` | `rails test` | Controladores ActionDispatch, validaciones de modelos ActiveRecord y Jobs. | `coverage/.resultset.json` |
| **Sinatra** | `bundle exec rspec` o `rake test` | `rspec` | Endpoints minimalistas y middlewares Rack con `Rack::Test::Methods`. | SimpleCov LCOV |
| **Grape** | `bundle exec rspec` | `rspec` | APIs REST montadas en Rack con validación de parámetros tipados. | SimpleCov LCOV |
| **Hanami** | `bundle exec rake test` | `bundle exec rake test` | Acciones independientes, vistas y entidades con arquitectura limpia. | SimpleCov LCOV |

### Elixir
| Framework | Comando en el Pipeline (CI) | Comando Local del Estudiante | ¿Qué evalúa y prueba? | Archivo para SonarQube |
|---|---|---|---|---|
| **Phoenix** | `mix test` | `mix test` | `ConnTest` (controladores), LiveViews, canales WebSocket y cambios Ecto. | `cover/excoveralls.json` |
| **Ash Framework** | `mix test` | `mix test` | Acciones de recursos (create, read, update), políticas y cálculos. | `cover/excoveralls.json` |
| **Plug** | `mix test` | `mix test` | Pipelines de plugs y transformación de conexiones `Plug.Conn`. | `cover/excoveralls.json` |

---

## ⚙️ Activación de un Módulo
Para que un módulo backend sea construido y desplegado automáticamente, debe contener estos 3 archivos:
1. Manifiesto de dependencias según el lenguaje (`package.json`, `pom.xml`, `go.mod`, `composer.json`, `Cargo.toml`, `mix.exs`, `Gemfile`, `*.csproj`).
2. `Dockerfile` configurado con `ARG PORT`, `ENV PORT=${PORT}` y usuario no root.
3. `.env.example` con las variables de base de datos y puerto:
   * `PORT=3000`
   * `DB_HOST=192.168.0.203`
   * `DB_PORT=5432`
   * `DB_NAME=database_name`
   * `DB_USER=user_name`
   * `DB_PASSWORD=secret_password`

## Puerto Asignado por Defecto
* `3000` (Rango de puertos backend: 3000 - 3099)
