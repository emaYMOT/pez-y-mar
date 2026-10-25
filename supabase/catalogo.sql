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

-- Promociones (7)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Promociones', 'Cajas y ofertas especiales. Pídelas a domicilio por WhatsApp.', '⭐', 'media/catalogo/portada-promociones.webp', 0)
  returning id
)
insert into public.menu_items (category_id, name, description, price, unit, image_url, is_available, position)
select c.id, v.name, v.description, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Caja Mar y agua dulce', '4 tilapias rojas, 2 lb de bagre importado, 2 truchas, 2 lb de sierra en rodaja y 1 lb de camarones.', 80000, null, 'media/catalogo/promo-caja-mar-y-agua-dulce.webp', true, 0),
    ('Caja Mar', '2 lb de sierra, 2 lb de atún en rodaja y 1 lb de pargo.', 70000, null, 'media/catalogo/promo-caja-mar.webp', true, 1),
    ('Caja Mixta', '10 tilapias apanadas, 3½ lb de bagre importado, 10 carnes de hamburguesa, 5 muslos, 4 tilapias y 1 lb de camarones.', 75000, null, 'media/catalogo/promo-caja-mixta.webp', true, 2),
    ('Caja Fitness', '10 filetes de pechuga de 120 g, 10 filetes de salmón de 150 g y 10 filetes de tilapia de 200 g.', 140000, null, 'media/catalogo/promo-caja-fitness.webp', true, 3),
    ('Caja Pollo', '2 bandejas de menudencias, 3 perniles, 3 contramuslos, 5 muslos, 1 pechuga, 1 kg de alas y 1 molipollo.', 70000, null, 'media/catalogo/promo-caja-pollo.webp', true, 4),
    ('Caja Cevichera', '2 lb de camarón, 1 lb de calamar pota, 1 lb de rejos de pulpo y 1 lb de filete de tilapia.', 65000, null, 'media/catalogo/promo-caja-cevichera.webp', true, 5),
    ('Oferta Salmón x10', '10 porciones de salmón de 200 g.', 99000, null, 'media/catalogo/promo-oferta-salmon.webp', true, 6)
) as v (name, description, price, unit, image_url, is_available, position);

-- Pescados (24)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Pescados', 'Enteros, porcionados y filetes.', '🐟', 'media/catalogo/portada-pescados.webp', 1)
  returning id
)
insert into public.menu_items (category_id, name, description, price, unit, image_url, is_available, position)
select c.id, v.name, v.description, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Tilapia Roja', null, 9500, 'lb', 'media/catalogo/tilapia-roja.webp', true, 0),
    ('Tilapia Negra', null, 6500, 'lb', 'media/catalogo/tilapia-negra.webp', true, 1),
    ('Cachama', null, 6500, 'lb', 'media/catalogo/cachama.webp', true, 2),
    ('Bagre Importado', null, 6500, 'lb', 'media/catalogo/bagre-importado.webp', true, 3),
    ('Sierra', null, 12500, 'lb', 'media/catalogo/sierra.webp', true, 4),
    ('Sierrilla', null, 12500, 'lb', 'media/catalogo/sierrilla.webp', true, 5),
    ('Atún en rodaja', null, 12500, 'lb', 'media/catalogo/atun-en-rodaja.webp', true, 6),
    ('Bagre Nacional', null, 17000, 'lb', 'media/catalogo/bagre-nacional.webp', true, 7),
    ('Trucha', null, 12500, 'lb', 'media/catalogo/trucha.webp', true, 8),
    ('Pargo Rojo', null, 22500, 'lb', 'media/catalogo/pargo-rojo.webp', true, 9),
    ('Bocachico Argentino', null, 9500, 'lb', 'media/catalogo/bocachico-argentino.webp', true, 10),
    ('Bocachico Criollo', null, 0, 'lb', 'media/catalogo/bocachico-criollo.webp', false, 11),
    ('Guacuco', null, 0, 'lb', 'media/catalogo/guacuco.webp', false, 12),
    ('Pescado Seco', null, 18000, 'unidad', 'media/catalogo/pescado-seco.webp', true, 13),
    ('Filete de Atún', null, 20000, 'lb', 'media/catalogo/filete-de-atun.webp', true, 14),
    ('Filete de Salmón', null, 32500, 'lb', 'media/catalogo/filete-de-salmon.webp', true, 15),
    ('Filete de Basa', null, 15500, 'unidad', 'media/catalogo/filete-de-basa.webp', true, 16),
    ('Filete de Tilapia', null, 11000, 'lb', 'media/catalogo/filete-de-tilapia.webp', true, 17),
    ('Filete de Robalo', null, 22500, 'lb', 'media/catalogo/filete-de-robalo.webp', true, 18),
    ('Filete de Pargo', null, 0, 'lb', 'media/catalogo/filete-de-pargo.webp', false, 19),
    ('Filete de Merluza', null, 0, 'lb', 'media/catalogo/filete-de-merluza.webp', false, 20),
    ('Robalo Entero', null, 17500, 'lb', 'media/catalogo/robalo-entero.webp', true, 21),
    ('Recorte de Tilapia', null, 4500, 'lb', 'media/catalogo/recorte-de-tilapia.webp', true, 22),
    ('Cabeza de tilapia', null, 3000, 'lb', 'media/catalogo/cabeza-de-tilapia.webp', true, 23)
) as v (name, description, price, unit, image_url, is_available, position);

-- Mariscos (14)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Mariscos', 'Mariscos y moluscos.', '🦐', 'media/catalogo/portada-mariscos.webp', 2)
  returning id
)
insert into public.menu_items (category_id, name, description, price, unit, image_url, is_available, position)
select c.id, v.name, v.description, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Camarón Precocido', null, 18000, 'lb', 'media/catalogo/camaron-precocido.webp', true, 0),
    ('Camarón Crudo', null, 18000, 'lb', 'media/catalogo/camaron-crudo.webp', true, 1),
    ('Anillos de Calamar', null, 15000, 'lb', 'media/catalogo/anillos-de-calamar.webp', true, 2),
    ('Rejos de Calamar', null, 12000, 'lb', 'media/catalogo/rejos-de-calamar.webp', true, 3),
    ('Calamar Pota', null, 12000, 'lb', 'media/catalogo/calamar-pota.webp', true, 4),
    ('Langostino', null, 40000, 'lb', 'media/catalogo/langostino.webp', true, 5),
    ('Mixtura', null, 20000, 'unidad', 'media/catalogo/mixtura.webp', true, 6),
    ('Palmitos', null, 7500, 'unidad', 'media/catalogo/palmitos.webp', true, 7),
    ('Mejillones', null, 11000, 'unidad', 'media/catalogo/mejillones.webp', true, 8),
    ('Almeja', null, 5000, 'lb', 'media/catalogo/almeja.webp', true, 9),
    ('Jaiba', null, 17000, 'lb', 'media/catalogo/jaiba.webp', true, 10),
    ('Pulpo Entero', null, 30000, 'lb', 'media/catalogo/pulpo-entero.webp', true, 11),
    ('Cola de Langosta', null, 100000, 'lb', 'media/catalogo/cola-de-langosta.webp', true, 12),
    ('Langosta', null, 50000, 'lb', 'media/catalogo/langosta.webp', true, 13)
) as v (name, description, price, unit, image_url, is_available, position);

-- Pollo (15)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Pollo', 'Entero, porcionado y filetes.', '🐔', 'media/catalogo/portada-pollo.webp', 3)
  returning id
)
insert into public.menu_items (category_id, name, description, price, unit, image_url, is_available, position)
select c.id, v.name, v.description, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Pollo Entero', null, 6500, 'lb', 'media/catalogo/pollo-entero.webp', true, 0),
    ('Pollo Bucanero', null, 6500, 'lb', 'media/catalogo/pollo-bucanero.webp', true, 1),
    ('Gallina', null, 6750, 'lb', 'media/catalogo/gallina.webp', true, 2),
    ('Pechuga Entera', null, 6500, 'lb', 'media/catalogo/pechuga-entera.webp', true, 3),
    ('Alas', null, 5500, 'lb', 'media/catalogo/alas.webp', true, 4),
    ('Muslo', null, 4500, 'lb', 'media/catalogo/muslo.webp', true, 5),
    ('Pernil', null, 4000, 'lb', 'media/catalogo/pernil.webp', true, 6),
    ('Recorte de Pollo', null, 4500, 'lb', 'media/catalogo/recorte-de-pollo.webp', true, 7),
    ('Mollejas', null, 0, 'unidad', 'media/catalogo/mollejas.webp', false, 8),
    ('Menudencias', null, 4500, 'unidad', 'media/catalogo/menudencias.webp', true, 9),
    ('Patas y Cabezas', null, 5000, 'unidad', 'media/catalogo/patas-y-cabezas.webp', true, 10),
    ('Molipollo', null, 5500, 'unidad', 'media/catalogo/molipollo.webp', true, 11),
    ('Filete de pechuga 100 g', null, 26500, 'unidad', 'media/catalogo/filete-de-pechuga-100-g.webp', true, 12),
    ('Filete de pechuga 120 g', null, 29000, 'unidad', 'media/catalogo/filete-de-pechuga-120-g.webp', true, 13),
    ('Patas', null, 6000, 'unidad', 'media/catalogo/patas.webp', true, 14)
) as v (name, description, price, unit, image_url, is_available, position);

-- Cerdo (3)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Cerdo', 'Porcionados y chuletas.', '🥩', 'media/catalogo/portada-cerdo.webp', 4)
  returning id
)
insert into public.menu_items (category_id, name, description, price, unit, image_url, is_available, position)
select c.id, v.name, v.description, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Recorte de Costilla', null, 5500, 'lb', 'media/catalogo/recorte-de-costilla.webp', true, 0),
    ('Cañón de Cerdo', null, 12500, 'lb', 'media/catalogo/canon-de-cerdo.webp', true, 1),
    ('Chuleta de Cerdo', null, 11500, 'lb', 'media/catalogo/chuleta-de-cerdo.webp', true, 2)
) as v (name, description, price, unit, image_url, is_available, position);

-- Carnes frías (9)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Carnes frías', 'Salchichas y chorizos.', '🌭', 'media/catalogo/portada-carnes-frias.webp', 5)
  returning id
)
insert into public.menu_items (category_id, name, description, price, unit, image_url, is_available, position)
select c.id, v.name, v.description, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Salchichón cervecero 500 g', null, 0, 'unidad', 'media/catalogo/salchichon-cervecero-500-g.webp', true, 0),
    ('Salchichón cervecero 750 g', null, 0, 'unidad', 'media/catalogo/salchichon-cervecero-750-g.webp', true, 1),
    ('Salchichón cervecero 3 lb', null, 0, 'unidad', 'media/catalogo/salchichon-cervecero-3-lb.webp', true, 2),
    ('Butifarras', null, 6000, 'unidad', 'media/catalogo/butifarras.webp', true, 3),
    ('Salchicha Manguera', null, 7800, 'unidad', 'media/catalogo/salchicha-manguera.webp', true, 4),
    ('Tocineta', null, 12500, 'unidad', 'media/catalogo/tocineta.webp', true, 5),
    ('Chorizo x 16', null, 12500, 'unidad', 'media/catalogo/chorizo-x-16.webp', true, 6),
    ('Chorizo Santa Rosano', null, 12500, 'unidad', 'media/catalogo/chorizo-santa-rosano.webp', true, 7),
    ('Hamburguesa Yumaes', null, 9500, 'unidad', 'media/catalogo/hamburguesa-yumaes.webp', true, 8)
) as v (name, description, price, unit, image_url, is_available, position);

-- Varios (11)
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values ('Varios', 'Varios y procesados.', '🛒', 'media/catalogo/portada-varios.webp', 6)
  returning id
)
insert into public.menu_items (category_id, name, description, price, unit, image_url, is_available, position)
select c.id, v.name, v.description, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
    ('Coctel de Camarón', null, 12000, 'unidad', 'media/catalogo/coctel-de-camaron.webp', true, 0),
    ('Panzerottis', null, 9500, 'unidad', 'media/catalogo/panzerottis.webp', true, 1),
    ('Palitos de Queso', null, 6000, 'unidad', 'media/catalogo/palitos-de-queso.webp', true, 2),
    ('Masa de Pastelito', null, 5500, 'unidad', 'media/catalogo/masa-de-pastelito.webp', true, 3),
    ('Apanados x10', null, 6000, 'unidad', 'media/catalogo/apanados-x10.webp', true, 4),
    ('Apanados x6', null, 6000, 'unidad', 'media/catalogo/apanados-x6.webp', true, 5),
    ('Lomitos de Tilapia', null, 7500, 'unidad', 'media/catalogo/lomitos-de-tilapia.webp', true, 6),
    ('Patacón grande', null, 5500, 'unidad', 'media/catalogo/patacon-grande.webp', true, 7),
    ('Patacón mediano', null, 5500, 'unidad', 'media/catalogo/patacon-mediano.webp', true, 8),
    ('Patacón pequeño', null, 5500, 'unidad', 'media/catalogo/patacon-pequeno.webp', true, 9),
    ('Torta de pescado x9', null, 8000, 'unidad', 'media/catalogo/torta-de-pescado-x9.webp', true, 10)
) as v (name, description, price, unit, image_url, is_available, position);

-- Número para pedidos que aparece en el catálogo.
update public.links set url = 'https://wa.me/573015214809', is_active = true where icon = 'whatsapp';

commit;

-- Comprobación: cada categoría con su número de productos.
select c.position, c.name, count(i.id) as productos
from public.menu_categories c left join public.menu_items i on i.category_id = c.id
group by c.id order by c.position;
