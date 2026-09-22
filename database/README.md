# database/

Directorio para scripts de base de datos y esquemas iniciales.

## Archivos Principales
* `init.sql`: Script DDL para creación de tablas, esquemas, tipos y restricciones iniciales.
* `seeds.sql`: Script DML para inserción de datos iniciales o datos de prueba para desarrollo.

## Detección Automática de Base de Datos
El Framework DevOps detecta automáticamente el motor de base de datos a partir de las dependencias declaradas en el código:
* `package.json` con `pg` / `sequelize` / `prisma` → **PostgreSQL**
* `package.json` con `mysql2` → **MySQL**
* `requirements.txt` con `psycopg2` / `asyncpg` → **PostgreSQL**
* `requirements.txt` con `pymongo` → **MongoDB**
* `requirements.txt` con `redis` → **Redis**
