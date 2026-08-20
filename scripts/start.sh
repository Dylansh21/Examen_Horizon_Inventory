#!/bin/bash
# ============================================================
# Horizonte Inventory - Script de arranque (Linux)
# Universidad Técnica Nacional - ITI-522
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"
DB_DIR="$PROJECT_DIR/database"
APP_DIR="$PROJECT_DIR/source"

echo "=============================================="
echo "  Horizonte Inventory - Sistema de inicio"
echo "=============================================="

# ── 1. Crear carpeta de logs si no existe ─────────────────────
mkdir -p "$LOG_DIR"

# ── 2. Verificar Node.js ──────────────────────────────────────
if ! command -v node &>/dev/null; then
  echo "[ERROR] Node.js no está instalado. Ejecuta primero:"
  echo "  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
  echo "  sudo apt-get install -y nodejs"
  exit 1
fi
echo "[OK] Node.js $(node -v) encontrado"

# ── 3. Instalar dependencias si es necesario ──────────────────
if [ ! -d "$APP_DIR/node_modules" ]; then
  echo "[INFO] Instalando dependencias npm..."
  cd "$APP_DIR" && npm install
fi
echo "[OK] Dependencias listas"

# ── 4. Inicializar base de datos SQLite ───────────────────────
DB_FILE="$DB_DIR/horizonte.db"
if [ ! -f "$DB_FILE" ]; then
  echo "[INFO] Inicializando base de datos..."
  if command -v sqlite3 &>/dev/null; then
    sqlite3 "$DB_FILE" < "$DB_DIR/schema.sql"
    sqlite3 "$DB_FILE" < "$DB_DIR/seed.sql"
    echo "[OK] Base de datos creada con datos de prueba"
  else
    echo "[INFO] sqlite3 CLI no encontrado, la app crea la BD automáticamente"
  fi
else
  echo "[OK] Base de datos existente encontrada"
fi

# ── 5. Matar proceso anterior en puerto 8080 (si existe) ──────
PORT=8080
PID=$(lsof -ti:$PORT 2>/dev/null || true)
if [ -n "$PID" ]; then
  echo "[INFO] Cerrando proceso anterior en puerto $PORT (PID $PID)..."
  kill "$PID" 2>/dev/null || true
  sleep 1
fi

# ── 6. Iniciar aplicación ─────────────────────────────────────
echo "[INFO] Iniciando Horizonte Inventory en puerto $PORT..."
cd "$APP_DIR"
nohup node app.js > "$LOG_DIR/stdout.log" 2>&1 &
APP_PID=$!
echo $APP_PID > "$PROJECT_DIR/.pid"

# ── 7. Verificar arranque ─────────────────────────────────────
sleep 2
if kill -0 "$APP_PID" 2>/dev/null; then
  echo ""
  echo "=============================================="
  echo "  ✅ Horizonte Inventory iniciado!"
  echo "  📌 URL:    http://localhost:$PORT"
  echo "  📋 Health: http://localhost:$PORT/health"
  echo "  📄 Logs:   $LOG_DIR/application.log"
  echo "  🔢 PID:    $APP_PID"
  echo "=============================================="
else
  echo "[ERROR] La aplicación no pudo iniciarse."
  echo "Revisa los logs en: $LOG_DIR/stdout.log"
  exit 1
fi
