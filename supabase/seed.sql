-- =====================================================================
-- Contenido inicial de Pez y Mar. Ejecutar después de schema.sql.
-- Trae el perfil, los botones y las categorías base. El catálogo queda vacío:
-- los productos se cargan después (desde el PDF del negocio o desde el panel).
-- =====================================================================

insert into public.site_settings (id, name, description)
values (1, 'Pez y Mar', E'Del mar a tu paladar.\nDistribuidora de pollo y pescado al por mayor y al detal.\nCR 50 # 54-64. Domicilios en toda el área metropolitana.')
on conflict (id) do nothing;

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
