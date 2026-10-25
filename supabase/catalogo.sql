-- =====================================================================
-- Catálogo de Pez y Mar (generado desde supabase/catalogo.json).
-- Ejecutar en Supabase > SQL Editor > New query > Run.
--
-- ATENCIÓN: borra TODAS las categorías y productos actuales y los reemplaza
-- por el catálogo. El perfil no se toca; solo se activa el botón de WhatsApp.
-- =====================================================================

begin;

-- Precio por libra / unidad / kilo (por si la base se creó antes de esta opción).
alter table public.menu_items add column if not exists unit text check (unit in ('lb', 'unidad', 'kg'));

delete from public.menu_categories;  -- borra también sus productos (on delete cascade)

-- Pescados (24)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Pescados', 'Enteros, porcionados y filetes.', '🐟', 'media/catalogo/portada-pescados.webp', 0)
  returning id
)
insert into public.menu_items (category_id, name, price, unit, image_url, is_available, position)
select c.id, v.name, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Tilapia Roja', 9500, 'lb', 'media/catalogo/tilapia-roja.webp', true, 0),
    ('Tilapia Negra', 6500, 'lb', 'media/catalogo/tilapia-negra.webp', true, 1),
    ('Cachama', 6500, 'lb', 'media/catalogo/cachama.webp', true, 2),
    ('Bagre Importado', 6500, 'lb', 'media/catalogo/bagre-importado.webp', true, 3),
    ('Sierra', 12500, 'lb', 'media/catalogo/sierra.webp', true, 4),
    ('Sierrilla', 12500, 'lb', 'media/catalogo/sierrilla.webp', true, 5),
    ('Atún en rodaja', 12500, 'lb', 'media/catalogo/atun-en-rodaja.webp', true, 6),
    ('Bagre Nacional', 17000, 'lb', 'media/catalogo/bagre-nacional.webp', true, 7),
    ('Trucha', 12500, 'lb', 'media/catalogo/trucha.webp', true, 8),
    ('Pargo Rojo', 22500, 'lb', 'media/catalogo/pargo-rojo.webp', true, 9),
    ('Bocachico Argentino', 9500, 'lb', 'media/catalogo/bocachico-argentino.webp', true, 10),
    ('Bocachico Criollo', 0, 'lb', 'media/catalogo/bocachico-criollo.webp', false, 11),
    ('Guacuco', 0, 'lb', 'media/catalogo/guacuco.webp', false, 12),
    ('Pescado Seco', 18000, 'unidad', 'media/catalogo/pescado-seco.webp', true, 13),
    ('Filete de Atún', 20000, 'lb', 'media/catalogo/filete-de-atun.webp', true, 14),
    ('Filete de Salmón', 32500, 'lb', 'media/catalogo/filete-de-salmon.webp', true, 15),
    ('Filete de Basa', 15500, 'unidad', 'media/catalogo/filete-de-basa.webp', true, 16),
    ('Filete de Tilapia', 11000, 'lb', 'media/catalogo/filete-de-tilapia.webp', true, 17),
    ('Filete de Robalo', 22500, 'lb', 'media/catalogo/filete-de-robalo.webp', true, 18),
    ('Filete de Pargo', 0, 'lb', 'media/catalogo/filete-de-pargo.webp', false, 19),
    ('Filete de Merluza', 0, 'lb', 'media/catalogo/filete-de-merluza.webp', false, 20),
    ('Robalo Entero', 17500, 'lb', 'media/catalogo/robalo-entero.webp', true, 21),
    ('Recorte de Tilapia', 4500, 'lb', 'media/catalogo/recorte-de-tilapia.webp', true, 22),
    ('Cabeza de tilapia', 3000, 'lb', 'media/catalogo/cabeza-de-tilapia.webp', true, 23)
) as v (name, price, unit, image_url, is_available, position);

-- Mariscos (14)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Mariscos', 'Mariscos y moluscos.', '🦐', 'media/catalogo/portada-mariscos.webp', 1)
  returning id
)
insert into public.menu_items (category_id, name, price, unit, image_url, is_available, position)
select c.id, v.name, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Camarón Precocido', 18000, 'lb', 'media/catalogo/camaron-precocido.webp', true, 0),
    ('Camarón Crudo', 18000, 'lb', 'media/catalogo/camaron-crudo.webp', true, 1),
    ('Anillos de Calamar', 15000, 'lb', 'media/catalogo/anillos-de-calamar.webp', true, 2),
    ('Rejos de Calamar', 12000, 'lb', 'media/catalogo/rejos-de-calamar.webp', true, 3),
    ('Calamar Pota', 12000, 'lb', 'media/catalogo/calamar-pota.webp', true, 4),
    ('Langostino', 40000, 'lb', 'media/catalogo/langostino.webp', true, 5),
    ('Mixtura', 20000, 'unidad', 'media/catalogo/mixtura.webp', true, 6),
    ('Palmitos', 7500, 'unidad', 'media/catalogo/palmitos.webp', true, 7),
    ('Mejillones', 11000, 'unidad', 'media/catalogo/mejillones.webp', true, 8),
    ('Almeja', 5000, 'lb', 'media/catalogo/almeja.webp', true, 9),
    ('Jaiba', 17000, 'lb', 'media/catalogo/jaiba.webp', true, 10),
    ('Pulpo Entero', 30000, 'lb', 'media/catalogo/pulpo-entero.webp', true, 11),
    ('Cola de Langosta', 100000, 'lb', 'media/catalogo/cola-de-langosta.webp', true, 12),
    ('Langosta', 50000, 'lb', 'media/catalogo/langosta.webp', true, 13)
) as v (name, price, unit, image_url, is_available, position);

-- Pollo (15)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Pollo', 'Entero, porcionado y filetes.', '🐔', 'media/catalogo/portada-pollo.webp', 2)
  returning id
)
insert into public.menu_items (category_id, name, price, unit, image_url, is_available, position)
select c.id, v.name, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Pollo Entero', 6500, 'lb', 'media/catalogo/pollo-entero.webp', true, 0),
    ('Pollo Bucanero', 6500, 'lb', 'media/catalogo/pollo-bucanero.webp', true, 1),
    ('Gallina', 6750, 'lb', 'media/catalogo/gallina.webp', true, 2),
    ('Pechuga Entera', 6500, 'lb', 'media/catalogo/pechuga-entera.webp', true, 3),
    ('Alas', 5500, 'lb', 'media/catalogo/alas.webp', true, 4),
    ('Muslo', 4500, 'lb', 'media/catalogo/muslo.webp', true, 5),
    ('Pernil', 4000, 'lb', 'media/catalogo/pernil.webp', true, 6),
    ('Recorte de Pollo', 4500, 'lb', 'media/catalogo/recorte-de-pollo.webp', true, 7),
    ('Mollejas', 0, 'unidad', 'media/catalogo/mollejas.webp', false, 8),
    ('Menudencias', 4500, 'unidad', 'media/catalogo/menudencias.webp', true, 9),
    ('Patas y Cabezas', 5000, 'unidad', 'media/catalogo/patas-y-cabezas.webp', true, 10),
    ('Molipollo', 5500, 'unidad', 'media/catalogo/molipollo.webp', true, 11),
    ('Filete de pechuga 100 g', 26500, 'unidad', 'media/catalogo/filete-de-pechuga-100-g.webp', true, 12),
    ('Filete de pechuga 120 g', 29000, 'unidad', 'media/catalogo/filete-de-pechuga-120-g.webp', true, 13),
    ('Patas', 6000, 'unidad', 'media/catalogo/patas.webp', true, 14)
) as v (name, price, unit, image_url, is_available, position);

-- Cerdo (3)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Cerdo', 'Porcionados y chuletas.', '🥩', 'media/catalogo/portada-cerdo.webp', 3)
  returning id
)
insert into public.menu_items (category_id, name, price, unit, image_url, is_available, position)
select c.id, v.name, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Recorte de Costilla', 5500, 'lb', 'media/catalogo/recorte-de-costilla.webp', true, 0),
    ('Cañón de Cerdo', 12500, 'lb', 'media/catalogo/canon-de-cerdo.webp', true, 1),
    ('Chuleta de Cerdo', 11500, 'lb', 'media/catalogo/chuleta-de-cerdo.webp', true, 2)
) as v (name, price, unit, image_url, is_available, position);

-- Carnes frías (9)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Carnes frías', 'Salchichas y chorizos.', '🌭', 'media/catalogo/portada-carnes-frias.webp', 4)
  returning id
)
insert into public.menu_items (category_id, name, price, unit, image_url, is_available, position)
select c.id, v.name, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Salchichón cervecero 500 g', 0, 'unidad', 'media/catalogo/salchichon-cervecero-500-g.webp', true, 0),
    ('Salchichón cervecero 750 g', 0, 'unidad', 'media/catalogo/salchichon-cervecero-750-g.webp', true, 1),
    ('Salchichón cervecero 3 lb', 0, 'unidad', 'media/catalogo/salchichon-cervecero-3-lb.webp', true, 2),
    ('Butifarras', 6000, 'unidad', 'media/catalogo/butifarras.webp', true, 3),
    ('Salchicha Manguera', 7800, 'unidad', 'media/catalogo/salchicha-manguera.webp', true, 4),
    ('Tocineta', 12500, 'unidad', 'media/catalogo/tocineta.webp', true, 5),
    ('Chorizo x 16', 12500, 'unidad', 'media/catalogo/chorizo-x-16.webp', true, 6),
    ('Chorizo Santa Rosano', 12500, 'unidad', 'media/catalogo/chorizo-santa-rosano.webp', true, 7),
    ('Hamburguesa Yumaes', 9500, 'unidad', 'media/catalogo/hamburguesa-yumaes.webp', true, 8)
) as v (name, price, unit, image_url, is_available, position);

-- Varios (11)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Varios', 'Varios y procesados.', '🛒', 'media/catalogo/portada-varios.webp', 5)
  returning id
)
insert into public.menu_items (category_id, name, price, unit, image_url, is_available, position)
select c.id, v.name, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Coctel de Camarón', 12000, 'unidad', 'media/catalogo/coctel-de-camaron.webp', true, 0),
    ('Panzerottis', 9500, 'unidad', 'media/catalogo/panzerottis.webp', true, 1),
    ('Palitos de Queso', 6000, 'unidad', 'media/catalogo/palitos-de-queso.webp', true, 2),
    ('Masa de Pastelito', 5500, 'unidad', 'media/catalogo/masa-de-pastelito.webp', true, 3),
    ('Apanados x10', 6000, 'unidad', 'media/catalogo/apanados-x10.webp', true, 4),
    ('Apanados x6', 6000, 'unidad', 'media/catalogo/apanados-x6.webp', true, 5),
    ('Lomitos de Tilapia', 7500, 'unidad', 'media/catalogo/lomitos-de-tilapia.webp', true, 6),
    ('Patacón grande', 5500, 'unidad', 'media/catalogo/patacon-grande.webp', true, 7),
    ('Patacón mediano', 5500, 'unidad', 'media/catalogo/patacon-mediano.webp', true, 8),
    ('Patacón pequeño', 5500, 'unidad', 'media/catalogo/patacon-pequeno.webp', true, 9),
    ('Torta de pescado x9', 8000, 'unidad', 'media/catalogo/torta-de-pescado-x9.webp', true, 10)
) as v (name, price, unit, image_url, is_available, position);

-- Número para pedidos que aparece en el catálogo.
update public.links set url = 'https://wa.me/573015214809', is_active = true where icon = 'whatsapp';

commit;

-- Comprobación: cada categoría con su número de productos.
select c.position, c.name, count(i.id) as productos
from public.menu_categories c left join public.menu_items i on i.category_id = c.id
group by c.id order by c.position;
