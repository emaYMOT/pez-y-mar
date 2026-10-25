import type { Category, LinkButton, MenuItem, SiteSettings } from './types'

// Contenido de ejemplo del modo demo (sin Supabase).
// Los productos y precios son de muestra: el catálogo real se carga desde el PDF del negocio.
// supabase/seed.sql trae el mismo perfil y botones, pero el catálogo vacío.

export const seedSettings: SiteSettings = {
  name: 'Pez y Mar',
  description: 'Del mar a tu paladar.\nDistribuidora de pollo y pescado al por mayor y al detal.\nCR 50 # 54-64. Domicilios en toda el área metropolitana.',
  avatar_url: null,
}

export const seedLinks: LinkButton[] = [
  { id: 'l1', label: 'Ver catálogo', type: 'menu', url: null, icon: 'menu', position: 0, is_active: true },
  // Falta el número real: el botón queda oculto hasta que lo completen en el panel.
  { id: 'l2', label: 'Pedir por WhatsApp', type: 'url', url: 'https://wa.me/570000000000', icon: 'whatsapp', position: 1, is_active: false },
  { id: 'l3', label: 'Síguenos en Instagram', type: 'url', url: 'https://www.instagram.com/pesquerapezymar/', icon: 'instagram', position: 2, is_active: true },
  { id: 'l4', label: 'Página web', type: 'url', url: 'https://pesquerapezymar.com', icon: 'web', position: 3, is_active: true },
  { id: 'l5', label: 'Cómo llegar', type: 'url', url: 'https://maps.google.com/?q=Pez+y+Mar+CR+50+%23+54-64', icon: 'map', position: 4, is_active: true },
]

export const seedCategories: Category[] = [
  { id: 'c1', name: 'Pescados', description: 'Frescos y congelados, enteros o en filete.', image_url: null, emoji: '🐟', position: 0, is_active: true },
  { id: 'c2', name: 'Mariscos', description: null, image_url: null, emoji: '🦐', position: 1, is_active: true },
  { id: 'c3', name: 'Pollo', description: 'Por presas o entero.', image_url: null, emoji: '🐔', position: 2, is_active: true },
]

const item = (id: string, category_id: string, position: number, name: string, description: string, price: number, extra: Partial<MenuItem> = {}): MenuItem => ({
  id, category_id, position, name, description, price, image_url: null, is_available: true, is_active: true, ...extra,
})

export const seedItems: MenuItem[] = [
  item('i1', 'c1', 0, 'Filete de tilapia roja', 'Ejemplo. Bandeja de 500 g.', 18000),
  item('i2', 'c1', 1, 'Mojarra roja entera', 'Ejemplo. Precio por libra.', 14000),
  item('i3', 'c1', 2, 'Salmón en porciones', 'Ejemplo. Bandeja de 400 g.', 32000),
  item('i4', 'c2', 0, 'Camarón pelado', 'Ejemplo. Bolsa de 500 g.', 28000),
  item('i5', 'c2', 1, 'Langostinos', 'Ejemplo. Precio por libra.', 45000, { is_available: false }),
  item('i6', 'c3', 0, 'Pechuga de pollo', 'Ejemplo. Precio por kilo.', 19000),
  item('i7', 'c3', 1, 'Alas de pollo', 'Ejemplo. Precio por kilo.', 15000),
]
