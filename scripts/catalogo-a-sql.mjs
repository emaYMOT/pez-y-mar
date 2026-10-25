// Convierte supabase/catalogo.json en supabase/catalogo.sql (reemplaza todo el catálogo en Supabase).
// Uso: node scripts/catalogo-a-sql.mjs
import { readFile, writeFile } from 'node:fs/promises'

const data = JSON.parse(await readFile(new URL('../supabase/catalogo.json', import.meta.url), 'utf8'))
const q = (v) => (v === null || v === undefined ? 'null' : `'${String(v).replaceAll("'", "''")}'`)

let sql = `-- =====================================================================
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
`

data.categorias.forEach((cat, ci) => {
  const rows = cat.productos
    .map((p, pi) => `    (${q(p.nombre)}, ${q(p.descripcion)}, ${p.precio}, ${q(p.unidad)}, ${q(p.foto)}, ${p.disponible}, ${pi})`)
    .join(',\n')
  sql += `
-- ${cat.nombre} (${cat.productos.length})
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values (${q(cat.nombre)}, ${q(cat.descripcion)}, ${q(cat.emoji)}, ${q(cat.portada)}, ${ci})
  returning id
)
insert into public.menu_items (category_id, name, description, price, unit, image_url, is_available, position)
select c.id, v.name, v.description, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
${rows}
) as v (name, description, price, unit, image_url, is_available, position);
`
})

if (data.whatsapp) {
  sql += `
-- Número para pedidos que aparece en el catálogo.
update public.links set url = ${q(data.whatsapp)}, is_active = true where icon = 'whatsapp';
`
}

sql += `
commit;

-- Comprobación: cada categoría con su número de productos.
select c.position, c.name, count(i.id) as productos
from public.menu_categories c left join public.menu_items i on i.category_id = c.id
group by c.id order by c.position;
`

await writeFile(new URL('../supabase/catalogo.sql', import.meta.url), sql)
const total = data.categorias.reduce((n, c) => n + c.productos.length, 0)
console.log(`catalogo.sql: ${data.categorias.length} categorías, ${total} productos`)

// Archivo aparte que solo agrega Promociones (para una base que ya tiene el resto del catálogo).
const promo = data.categorias.find((c) => c.nombre === 'Promociones')
if (promo) {
  const rows = promo.productos
    .map((p, pi) => `    (${q(p.nombre)}, ${q(p.descripcion)}, ${p.precio}, ${q(p.unidad)}, ${q(p.foto)}, ${p.disponible}, ${pi})`)
    .join(',\n')
  const sqlPromo = `-- =====================================================================
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
  values (${q(promo.nombre)}, ${q(promo.descripcion)}, ${q(promo.emoji)}, ${q(promo.portada)}, 0)
  returning id
)
insert into public.menu_items (category_id, name, description, price, unit, image_url, is_available, position)
select c.id, v.name, v.description, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
${rows}
) as v (name, description, price, unit, image_url, is_available, position);

commit;

select c.position, c.name, count(i.id) as productos
from public.menu_categories c left join public.menu_items i on i.category_id = c.id
group by c.id order by c.position;
`
  await writeFile(new URL('../supabase/promociones.sql', import.meta.url), sqlPromo)
  console.log(`promociones.sql: ${promo.productos.length} promociones`)
}
