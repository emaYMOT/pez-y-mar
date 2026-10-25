import catalogoJson from '../../supabase/catalogo.json'
import type { Category, LinkButton, MenuItem, PriceUnit, SiteSettings } from './types'

// Contenido de ejemplo del modo demo (sin Supabase).
// Perfil y botones iguales a supabase/seed.sql; el catálogo es el real (supabase/catalogo.json).

export const seedSettings: SiteSettings = {
  name: 'Pez y Mar',
  description: 'Del mar a tu paladar.\nDistribuidora de pollo y pescado al por mayor y al detal.\nCR 50 # 54-64. Domicilios en toda el área metropolitana.',
  avatar_url: null,
}

export const seedLinks: LinkButton[] = [
  { id: 'l1', label: 'Ver catálogo', type: 'menu', url: null, icon: 'menu', position: 0, is_active: true },
  { id: 'l2', label: 'Pedir por WhatsApp', type: 'url', url: 'https://wa.me/573015214809', icon: 'whatsapp', position: 1, is_active: true },
  { id: 'l3', label: 'Síguenos en Instagram', type: 'url', url: 'https://www.instagram.com/pesquerapezymar/', icon: 'instagram', position: 2, is_active: true },
  { id: 'l4', label: 'Página web', type: 'url', url: 'https://pesquerapezymar.com', icon: 'web', position: 3, is_active: true },
  { id: 'l5', label: 'Cómo llegar', type: 'url', url: 'https://maps.google.com/?q=Pez+y+Mar+CR+50+%23+54-64', icon: 'map', position: 4, is_active: true },
]

// El modo demo muestra el catálogo real (el mismo que carga supabase/catalogo.sql).
const catalogo = catalogoJson as {
  categorias: { nombre: string; emoji: string; descripcion: string; portada: string; productos: { nombre: string; descripcion?: string; precio: number; unidad: PriceUnit | null; foto: string; disponible: boolean }[] }[]
}

export const seedCategories: Category[] = catalogo.categorias.map((c, i) => ({
  id: `c${i + 1}`, name: c.nombre, description: c.descripcion, image_url: c.portada, emoji: c.emoji, position: i, is_active: true,
}))

export const seedItems: MenuItem[] = catalogo.categorias.flatMap((c, ci) =>
  c.productos.map((p, pi) => ({
    id: `i${ci + 1}-${pi + 1}`, category_id: `c${ci + 1}`, position: pi, name: p.nombre, description: p.descripcion ?? null, price: p.precio,
    unit: p.unidad, image_url: p.foto, is_available: p.disponible, is_active: true,
  })),
)
