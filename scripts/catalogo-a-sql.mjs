// Convierte supabase/catalogo.json en supabase/catalogo.sql (reemplaza todo el catálogo en Supabase).
// Uso: node scripts/catalogo-a-sql.mjs
import { readFile, writeFile } from 'node:fs/promises'

const data = JSON.parse(await readFile(new URL('../supabase/catalogo.json', import.meta.url), 'utf8'))
const q = (v) => (v === null || v === undefined ? 'null' : `'${String(v).replaceAll("'", "''")}'`)

let sql = `-- =====================================================================
-- Catálogo de Pez y Mar (generada desde supabase/catalogo.json).
-- Ejecutar en Supabase > SQL Editor > New query > Run.
--
-- ATENCIÓN: borra TODAS las categorías y platos actuales y los reemplaza
-- por el catálogo. Los botones del inicio y el perfil no se tocan.
-- =====================================================================

begin;

delete from public.menu_categories;  -- borra también sus platos (on delete cascade)
`

data.categorias.forEach((cat, ci) => {
  const rows = cat.platos.map(([name, price, desc], pi) => `    (${q(name)}, ${q(desc)}, ${price}, ${pi})`).join(',\n')
  sql += `
-- ${cat.nombre} (${cat.platos.length})
with c as (
  insert into public.menu_categories (name, description, emoji, position)
  values (${q(cat.nombre)}, ${q(cat.descripcion)}, ${q(cat.emoji)}, ${ci})
  returning id
)
insert into public.menu_items (category_id, name, description, price, position)
select c.id, v.name, v.description, v.price, v.position
from c, (values
${rows}
) as v (name, description, price, position);
`
})

sql += `
commit;

-- Comprobación: debe mostrar cada categoría con su número de platos.
select c.position, c.name, count(i.id) as platos
from public.menu_categories c left join public.menu_items i on i.category_id = c.id
group by c.id order by c.position;
`

await writeFile(new URL('../supabase/catalogo.sql', import.meta.url), sql)
const total = data.categorias.reduce((n, c) => n + c.platos.length, 0)
console.log(`catalogo.sql: ${data.categorias.length} categorías, ${total} productos`)
