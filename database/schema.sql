-- ============================================================
-- Horizonte Inventory - Schema Principal
-- Motor: SQLite (compatible con MySQL/PostgreSQL con ajustes menores)
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    code       TEXT    NOT NULL UNIQUE,
    name       TEXT    NOT NULL,
    category   TEXT    NOT NULL,
    price      REAL    NOT NULL CHECK(price >= 0),
    quantity   INTEGER NOT NULL DEFAULT 0 CHECK(quantity >= 0),
    created_at TEXT    NOT NULL DEFAULT (datetime('now'))
);

-- Índices para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_code     ON products(code);
