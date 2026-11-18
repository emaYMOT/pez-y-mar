-- =====================================================================
-- Agrega la categoría Promociones de Pez y Mar SIN tocar el resto del catálogo.
-- Ejecutar en Supabase > SQL Editor > New query > Run. Se puede correr varias veces.
-- =====================================================================

begin;

alter table public.menu_items add column if not exists unit text check (unit in ('lb', 'unidad', 'kg'));

-- Si ya existía, se reemplaza (con sus productos).
delete from public.menu_categories where name = 'Promociones';

-- Promociones va de primera: las demás quedan numeradas desde 1, en su mismo orden.
update public.menu_categories m set position = r.n
from (select id, row_number() over (order by position, name) as n from public.menu_categories) r
where m.id = r.id;

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
    ('Oferta Salmón x10', '10 porciones de salmón de 200 g.', 99000, null, 'media/catalogo/promo-oferta-salmon.webp', true, 6),
    ('Caja Langosta Cajun', '4 langostas, 1 lb de mejillones, 1 lb de langostinos, 1 lb de camarón y 1 lb de jaiba.', 150000, null, 'media/catalogo/promo-langosta-cajun.webp', true, 7)
) as v (name, description, price, unit, image_url, is_available, position);

commit;

select c.position, c.name, count(i.id) as productos
from public.menu_categories c left join public.menu_items i on i.category_id = c.id
group by c.id order by c.position;
