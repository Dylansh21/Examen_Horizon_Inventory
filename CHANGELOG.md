# CHANGELOG

Todos los cambios notables de Horizonte Inventory están documentados en este archivo.
Formato basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/).

---

## [1.0.0] - 2026-08-20

### Agregado
- Creación de la VM `Horizonte-Inventory` en VirtualBox (Ubuntu Server 26.04 LTS, 2 vCPU, 4GB RAM, 50GB disco)
- Configuración de port-forwarding NAT: SSH 2222→22, WebApp 8080→8080
- Aplicación web **Horizonte Inventory** con Express.js + SQLite
- CRUD completo de productos (crear, listar, editar, eliminar)
- Filtros de inventario: todos / disponibles / sin stock / por categoría
- Endpoint `/health` que retorna `{"status":"ok"}`
- Sistema de logs en `logs/application.log` con timestamp
- 23 productos de prueba en 3 categorías (Libros, Material Educativo, Artículos de Oficina)
- Script de arranque `scripts/start.sh`
- Script de parada `scripts/stop.sh`
- Esquema SQL `database/schema.sql`
- Seed de datos `database/seed.sql`
- README.md con instrucciones completas
- Diagrama de arquitectura en `docs/architecture.md`
- Carpeta `evidence/` con capturas de pantalla

---

## [Próximas versiones]

### Planeado
- Migración a PostgreSQL
- Autenticación de usuarios
- Exportación de inventario a CSV
- Paginación en la tabla de productos
