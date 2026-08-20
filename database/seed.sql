-- ============================================================
-- Horizonte Inventory - Seed de datos (mínimo 20 productos)
-- ============================================================

INSERT OR IGNORE INTO products (code, name, category, price, quantity, created_at) VALUES
-- Libros
('BOOK-001', 'Cien años de soledad',           'Libros',             8500.00, 12, '2026-01-10 08:00:00'),
('BOOK-002', 'El principito',                   'Libros',             4200.00, 25, '2026-01-10 08:00:00'),
('BOOK-003', 'Sapiens: De animales a dioses',   'Libros',            11900.00,  8, '2026-01-15 09:00:00'),
('BOOK-004', 'Don Quijote de la Mancha',        'Libros',            14500.00,  5, '2026-01-15 09:00:00'),
('BOOK-005', 'El alquimista',                   'Libros',             6300.00, 18, '2026-01-20 10:00:00'),
('BOOK-006', 'Yo soy Malala',                   'Libros',             9800.00,  3, '2026-01-20 10:00:00'),
('BOOK-007', 'Hábitos atómicos',                'Libros',            12500.00, 20, '2026-02-01 08:30:00'),
('BOOK-008', 'El poder del ahora',              'Libros',             7600.00, 11, '2026-02-01 08:30:00'),

-- Material educativo
('EDU-001',  'Cuaderno rayado 100 hojas',       'Material Educativo',  1200.00, 50, '2026-01-12 09:00:00'),
('EDU-002',  'Cuaderno cuadriculado 100 hojas', 'Material Educativo',  1200.00, 45, '2026-01-12 09:00:00'),
('EDU-003',  'Diccionario Español-Inglés',       'Material Educativo', 17500.00,  7, '2026-01-18 10:00:00'),
('EDU-004',  'Atlas Geográfico Universal',       'Material Educativo', 22000.00,  4, '2026-01-18 10:00:00'),
('EDU-005',  'Calculadora científica Casio',     'Material Educativo', 18900.00,  6, '2026-02-05 11:00:00'),

-- Artículos de oficina
('OFC-001',  'Bolígrafo azul BIC (paq. 12)',    'Artículos de Oficina', 2400.00, 30, '2026-01-14 08:00:00'),
('OFC-002',  'Lápiz HB Staedtler (paq. 12)',    'Artículos de Oficina', 2800.00, 28, '2026-01-14 08:00:00'),
('OFC-003',  'Resma papel bond A4 75g',          'Artículos de Oficina', 9500.00, 15, '2026-01-22 09:00:00'),
('OFC-004',  'Cinta adhesiva transparente',      'Artículos de Oficina',  850.00, 40, '2026-01-22 09:00:00'),
('OFC-005',  'Engrapadora de escritorio',        'Artículos de Oficina', 5600.00,  9, '2026-02-08 08:00:00'),
('OFC-006',  'Tijeras escolares 7 pulgadas',     'Artículos de Oficina', 1900.00, 22, '2026-02-08 08:00:00'),
('OFC-007',  'Folder manila carta (paq. 25)',    'Artículos de Oficina', 3200.00, 35, '2026-02-10 09:00:00'),
('OFC-008',  'Marcador permanente negro',        'Artículos de Oficina', 1100.00,  0, '2026-02-10 09:00:00'),

-- Sin stock (para mostrar filtro)
('BOOK-009', 'Historia de la Filosofía',         'Libros',            16500.00,  0, '2026-02-15 10:00:00'),
('EDU-006',  'Compás de precisión',              'Material Educativo',  4500.00,  0, '2026-02-15 10:00:00');
