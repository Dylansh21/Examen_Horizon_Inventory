# Horizonte Inventory

> Sistema de gestión de inventario para **Librería Horizonte S.R.L.**  
> Proyecto académico — ITI-522 Computación en la Nube — Universidad Técnica Nacional

---

## 1. Objetivo del proyecto

Implementar una aplicación web full-stack completamente funcional dentro de una máquina virtual, que permita a la librería gestionar su catálogo de productos (CRUD) con persistencia de datos, logs de operaciones y un endpoint de salud. La arquitectura simula la infraestructura que podría migrarse hacia un proveedor de nube.

---

## 2. Sistema operativo utilizado

| Componente | Detalle |
|---|---|
| Sistema Operativo | Ubuntu Server 26.04 LTS |
| Plataforma VM | VirtualBox |
| vCPU | 2 |
| RAM | 4 GB |
| Disco | 50 GB |

---

## 3. Lenguaje utilizado

**JavaScript (Node.js 20 LTS)**

---

## 4. Framework utilizado

**Express.js v4.18** — Framework minimalista para servidores HTTP en Node.js.

---

## 5. Motor de base de datos

**SQLite 3** — Motor embebido sin servidor separado, accedido vía `better-sqlite3`.  
Archivo: `database/horizonte.db`

---

## 6. Puerto de la aplicación

```
http://localhost:8080
```

---

## 7. Cómo iniciar la aplicación

### Pre-requisitos (dentro de la VM)

```bash
# Instalar Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs sqlite3

# Clonar el repositorio
git clone https://github.com/<usuario>/horizonte-inventory.git
cd horizonte-inventory
```

### Arrancar

```bash
chmod +x scripts/start.sh
./scripts/start.sh
```

El script:
1. Verifica Node.js instalado
2. Instala dependencias npm si es necesario
3. Inicializa la base de datos con el esquema y los 23 productos de prueba
4. Inicia la aplicación en segundo plano en el puerto 8080

---

## 8. Cómo detener la aplicación

```bash
./scripts/stop.sh
```

---

## 9. Cómo acceder mediante navegador

Desde **dentro de la VM** (o desde el host si hay port-forwarding activo):

```
http://localhost:8080
```

Desde el **host** (con port-forwarding VirtualBox NAT configurado):

```
http://127.0.0.1:8080
```

---

## 10. Cómo comprobar /health

```bash
curl http://localhost:8080/health
# Respuesta esperada:
# {"status":"ok"}
```

---

## 11. Ubicación de los logs

```
logs/application.log
```

Ejemplo de contenido:
```
2026-08-20 13:15:32 INFO  Application started on port 8080
2026-08-20 13:17:10 INFO  POST /api/products
2026-08-20 13:17:10 INFO  Product created: BOOK-001 - Cien años de soledad
2026-08-20 13:20:45 INFO  PUT /api/products/1
2026-08-20 13:20:45 INFO  Product updated: BOOK-001 (id=1)
```

---

## 12. Estructura del repositorio

```
horizonte-inventory/
├── source/
│   ├── app.js
│   ├── package.json
│   └── public/
│       └── index.html
├── database/
│   ├── schema.sql
│   └── seed.sql
├── logs/
│   └── application.log
├── scripts/
│   ├── start.sh
│   └── stop.sh
├── docs/
│   └── architecture.md
├── evidence/
├── README.md
└── CHANGELOG.md
```

---

## 13. Diagrama de arquitectura

```
+--------------------------------------------+
|    Maquina Virtual (VirtualBox)             |
|    Ubuntu Server 26.04 LTS                  |
|                                            |
|  +--------------------------------------+  |
|  |     Node.js 20 / Express             |  |
|  |   Horizonte Inventory :8080          |  |
|  +----------+---------------------------+  |
|             |                              |
|  +----------v-----------+  +-----------+  |
|  |  SQLite 3            |  |  Logs     |  |
|  |  database/           |  |  logs/    |  |
|  |  horizonte.db        |  |  app.log  |  |
|  +----------------------+  +-----------+  |
|                                            |
+--------------------------------------------+
               | Port Forwarding NAT
               | Host:8080 -> Guest:8080
               v
        Navegador Web (Host)
        http://127.0.0.1:8080
```

---

## 14. API Reference

| Metodo | Endpoint | Descripcion |
|--------|----------|-------------|
| GET | `/health` | Estado de la aplicacion |
| GET | `/api/products` | Listar todos los productos |
| GET | `/api/products?available=true` | Solo con stock |
| GET | `/api/products?available=false` | Sin stock |
| GET | `/api/products?category=Libros` | Por categoria |
| GET | `/api/products/:id` | Obtener un producto |
| POST | `/api/products` | Crear producto |
| PUT | `/api/products/:id` | Actualizar producto |
| DELETE | `/api/products/:id` | Eliminar producto |
| GET | `/api/categories` | Lista de categorias |
