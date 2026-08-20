const express = require('express');
const Database = require('better-sqlite3');
const path = require('path');
const fs = require('fs');

// ─── Logging Setup ────────────────────────────────────────────────────────────
const LOG_DIR = path.join(__dirname, '..', 'logs');
const LOG_FILE = path.join(LOG_DIR, 'application.log');
if (!fs.existsSync(LOG_DIR)) fs.mkdirSync(LOG_DIR, { recursive: true });

function log(level, message) {
  const ts = new Date().toISOString().replace('T', ' ').substring(0, 19);
  const line = `${ts} ${level.padEnd(5)} ${message}\n`;
  fs.appendFileSync(LOG_FILE, line);
  process.stdout.write(line);
}

// ─── Database Setup ───────────────────────────────────────────────────────────
const DB_DIR = path.join(__dirname, '..', 'database');
if (!fs.existsSync(DB_DIR)) fs.mkdirSync(DB_DIR, { recursive: true });
const db = new Database(path.join(DB_DIR, 'horizonte.db'));

db.exec(`
  CREATE TABLE IF NOT EXISTS products (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    code      TEXT    NOT NULL UNIQUE,
    name      TEXT    NOT NULL,
    category  TEXT    NOT NULL,
    price     REAL    NOT NULL,
    quantity  INTEGER NOT NULL DEFAULT 0,
    created_at TEXT   NOT NULL DEFAULT (datetime('now'))
  );
`);

// ─── Express App ──────────────────────────────────────────────────────────────
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// Request logger middleware
app.use((req, _res, next) => {
  log('INFO', `${req.method} ${req.path}`);
  next();
});

// ─── Health ───────────────────────────────────────────────────────────────────
app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

// ─── API Routes ───────────────────────────────────────────────────────────────
// GET all products (with optional filter)
app.get('/api/products', (req, res) => {
  const { category, available } = req.query;
  let query = 'SELECT * FROM products';
  const params = [];
  const conditions = [];

  if (category) { conditions.push('category = ?'); params.push(category); }
  if (available === 'true')  conditions.push('quantity > 0');
  if (available === 'false') conditions.push('quantity = 0');

  if (conditions.length) query += ' WHERE ' + conditions.join(' AND ');
  query += ' ORDER BY id DESC';

  res.json(db.prepare(query).all(...params));
});

// GET single product
app.get('/api/products/:id', (req, res) => {
  const product = db.prepare('SELECT * FROM products WHERE id = ?').get(req.params.id);
  if (!product) return res.status(404).json({ error: 'Product not found' });
  res.json(product);
});

// POST create product
app.post('/api/products', (req, res) => {
  const { code, name, category, price, quantity } = req.body;
  if (!code || !name || !category || price == null || quantity == null) {
    return res.status(400).json({ error: 'All fields are required' });
  }
  try {
    const stmt = db.prepare(
      'INSERT INTO products (code, name, category, price, quantity) VALUES (?, ?, ?, ?, ?)'
    );
    const info = stmt.run(code, name, category, parseFloat(price), parseInt(quantity));
    log('INFO', `Product created: ${code} - ${name}`);
    res.status(201).json({ id: info.lastInsertRowid, code, name, category, price, quantity });
  } catch (e) {
    log('ERROR', `Failed to create product: ${e.message}`);
    res.status(409).json({ error: 'Code already exists' });
  }
});

// PUT update product
app.put('/api/products/:id', (req, res) => {
  const { code, name, category, price, quantity } = req.body;
  const existing = db.prepare('SELECT * FROM products WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'Product not found' });
  try {
    db.prepare(
      'UPDATE products SET code=?, name=?, category=?, price=?, quantity=? WHERE id=?'
    ).run(
      code ?? existing.code,
      name ?? existing.name,
      category ?? existing.category,
      price != null ? parseFloat(price) : existing.price,
      quantity != null ? parseInt(quantity) : existing.quantity,
      req.params.id
    );
    log('INFO', `Product updated: ${existing.code} (id=${req.params.id})`);
    res.json({ id: parseInt(req.params.id), ...existing, code, name, category, price, quantity });
  } catch (e) {
    log('ERROR', `Failed to update product: ${e.message}`);
    res.status(500).json({ error: e.message });
  }
});

// DELETE product
app.delete('/api/products/:id', (req, res) => {
  const existing = db.prepare('SELECT * FROM products WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'Product not found' });
  db.prepare('DELETE FROM products WHERE id = ?').run(req.params.id);
  log('INFO', `Product deleted: ${existing.code} (id=${req.params.id})`);
  res.json({ message: 'Product deleted' });
});

// GET categories list
app.get('/api/categories', (_req, res) => {
  const rows = db.prepare('SELECT DISTINCT category FROM products ORDER BY category').all();
  res.json(rows.map(r => r.category));
});

// ─── Start ────────────────────────────────────────────────────────────────────
const PORT = process.env.PORT || 8080;
app.listen(PORT, '0.0.0.0', () => {
  log('INFO', `Application started on port ${PORT}`);
  console.log(`Horizonte Inventory running at http://0.0.0.0:${PORT}`);
});
