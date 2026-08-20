# Diagrama de Arquitectura — Horizonte Inventory

## Descripcion General

La solucion se ejecuta completamente dentro de una unica maquina virtual en VirtualBox,
simulando la arquitectura que podria migrarse a un proveedor de nube.

## Diagrama

```
+==============================================================+
|              HOST (Windows 11)                               |
|                                                              |
|  Navegador Web <--> localhost:8080 (Port Forwarding NAT)     |
|  SSH Client    <--> localhost:2222 (Port Forwarding NAT)     |
|                       |                                      |
|  +--------------------v---------------------------------+    |
|  |     Maquina Virtual: Horizonte-Inventory             |    |
|  |     VirtualBox 7.x — Ubuntu Server 26.04 LTS         |    |
|  |     2 vCPU | 4 GB RAM | 50 GB VDI                    |    |
|  |                                                      |    |
|  |  +------------------------------------------------+  |    |
|  |  |           Node.js 20 LTS                       |  |    |
|  |  |       Express.js Framework                     |  |    |
|  |  |    Horizonte Inventory App  :8080              |  |    |
|  |  |                                                |  |    |
|  |  |  GET  /health           -> {"status":"ok"}     |  |    |
|  |  |  GET  /api/products     -> JSON list           |  |    |
|  |  |  POST /api/products     -> Create              |  |    |
|  |  |  PUT  /api/products/:id -> Update              |  |    |
|  |  |  DEL  /api/products/:id -> Delete              |  |    |
|  |  +------------------+-----+----------------------+  |    |
|  |                     |     |                          |    |
|  |  +------------------v--+  +---------------------+   |    |
|  |  |  SQLite 3           |  |  Logger (fs)        |   |    |
|  |  |  database/          |  |  logs/              |   |    |
|  |  |  horizonte.db       |  |  application.log    |   |    |
|  |  |                     |  |                     |   |    |
|  |  |  TABLE: products    |  |  INFO / ERROR       |   |    |
|  |  |  - id               |  |  con timestamp      |   |    |
|  |  |  - code             |  |                     |   |    |
|  |  |  - name             |  +---------------------+   |    |
|  |  |  - category         |                            |    |
|  |  |  - price            |                            |    |
|  |  |  - quantity         |                            |    |
|  |  |  - created_at       |                            |    |
|  |  +---------------------+                            |    |
|  +------------------------------------------------------+    |
+==============================================================+
```

## Flujo de una Peticion

```
Usuario (Navegador)
       |
       | HTTP Request (puerto 8080)
       v
  VirtualBox NAT Port Forwarding
       |
       v
  Express.js Route Handler
       |
       +---> SQLite 3 (lectura/escritura de datos)
       |
       +---> Logger (escribe en application.log)
       |
       v
  HTTP Response (JSON / HTML)
       |
       v
  Navegador del Usuario
```

## Tecnologias Utilizadas

| Capa | Tecnologia | Version |
|------|-----------|---------|
| Virtualizacion | VirtualBox | 7.x |
| Sistema Operativo | Ubuntu Server | 26.04 LTS |
| Runtime | Node.js | 20 LTS |
| Framework Web | Express.js | 4.18 |
| Base de Datos | SQLite | 3 (via better-sqlite3) |
| Frontend | HTML5 / CSS3 / JavaScript | Vanilla |
| Scripts | Bash | 5.x |
