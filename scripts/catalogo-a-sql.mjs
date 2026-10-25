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
    .map((p, pi) => `    (${q(p.nombre)}, ${p.precio}, ${q(p.unidad)}, ${q(p.foto)}, ${p.disponible}, ${pi})`)
    .join(',\n')
  sql += `
-- ${cat.nombre} (${cat.productos.length})
with c as (
  insert into public.menu_categories (name, description, emoji, image_url, position)
  values (${q(cat.nombre)}, ${q(cat.descripcion)}, ${q(cat.emoji)}, ${q(cat.portada)}, ${ci})
  returning id
)
insert into public.menu_items (category_id, name, price, unit, image_url, is_available, position)
select c.id, v.name, v.price, v.unit, v.image_url, v.is_available, v.position
from c, (values
${rows}
) as v (name, price, unit, image_url, is_available, position);
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
