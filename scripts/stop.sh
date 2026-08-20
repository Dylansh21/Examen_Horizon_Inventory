#!/bin/bash
# ============================================================
# Horizonte Inventory - Script de parada (Linux)
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PID_FILE="$PROJECT_DIR/.pid"

if [ -f "$PID_FILE" ]; then
  PID=$(cat "$PID_FILE")
  if kill -0 "$PID" 2>/dev/null; then
    echo "[INFO] Deteniendo Horizonte Inventory (PID $PID)..."
    kill "$PID"
    rm -f "$PID_FILE"
    echo "[OK] Aplicación detenida correctamente."
  else
    echo "[WARN] Proceso $PID no encontrado (puede que ya esté detenido)."
    rm -f "$PID_FILE"
  fi
else
  # Fallback: buscar por puerto
  PID=$(lsof -ti:8080 2>/dev/null || true)
  if [ -n "$PID" ]; then
    kill "$PID"
    echo "[OK] Proceso en puerto 8080 detenido."
  else
    echo "[INFO] No hay ninguna instancia corriendo."
  fi
fi
