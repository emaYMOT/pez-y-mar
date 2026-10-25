-- =====================================================================
-- Reemplaza TODO el contenido (perfil, botones, categorías y productos)
-- por el contenido inicial de Pez y Mar.
-- Úsalo si por error se cargó otro contenido (por ejemplo, el de Al Aire).
-- Ejecutar en Supabase > SQL Editor > New query > Run.
-- No toca la estructura, la seguridad ni los usuarios administradores.
-- =====================================================================

begin;

delete from public.links;
delete from public.menu_categories;  -- borra también sus productos (on delete cascade)

insert into public.site_settings (id, name, description, avatar_url)
values (1, 'Pez y Mar', E'Del mar a tu paladar.\nDistribuidora de pollo y pescado al por mayor y al detal.\nCR 50 # 54-64. Domicilios en toda el área metropolitana.', null)
on conflict (id) do update
set name = excluded.name, description = excluded.description, avatar_url = excluded.avatar_url;

-- El botón de WhatsApp queda oculto hasta poner el número real desde el panel.
insert into public.links (label, type, url, icon, position, is_active) values
  ('Ver catálogo',          'menu', null,                                                  'menu',      0, true),
  ('Pedir por WhatsApp',    'url',  'https://wa.me/570000000000',                          'whatsapp',  1, false),
  ('Síguenos en Instagram', 'url',  'https://www.instagram.com/pesquerapezymar/',          'instagram', 2, true),
  ('Página web',            'url',  'https://pesquerapezymar.com',                         'web',       3, true),
  ('Cómo llegar',           'url',  'https://maps.google.com/?q=Pez+y+Mar+CR+50+%23+54-64', 'map',       4, true);

insert into public.menu_categories (name, description, emoji, position) values
  ('Pescados', 'Frescos y congelados, enteros o en filete.', '🐟', 0),
  ('Mariscos', null,                                         '🦐', 1),
  ('Pollo',    'Por presas o entero.',                       '🐔', 2);

commit;

-- Comprobación
select (select name from public.site_settings where id = 1) as perfil,
       (select count(*) from public.links) as botones,
       (select count(*) from public.menu_categories) as categorias,
       (select count(*) from public.menu_items) as productos;
