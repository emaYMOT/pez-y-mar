const cop = new Intl.NumberFormat('es-CO', { maximumFractionDigits: 0 })

/** 25000 -> "$25.000" */
export function formatPrice(value: number): string {
  return `$${cop.format(value)}`
}

/** Unidades de venta: texto corto junto al precio y nombre en el panel. */
export const UNITS = {
  lb: { short: 'lb', long: 'Libra' },
  unidad: { short: 'und.', long: 'Unidad' },
  kg: { short: 'kg', long: 'Kilo' },
} as const

/** "$9.500 / lb" — o "Consultar precio" si el precio es 0. */
export function priceText(price: number, unit: keyof typeof UNITS | null | undefined): string {
  if (!price) return 'Consultar precio'
  return unit ? `${formatPrice(price)} / ${UNITS[unit].short}` : formatPrice(price)
}

/** "25.000" | "$25,000" -> 25000 */
export function parsePrice(input: string): number {
  const digits = input.replace(/\D/g, '')
  return digits ? Number(digits) : 0
}

/** Agrega https:// si el admin escribió "wa.me/57..." */
export function normalizeUrl(input: string): string {
  const value = input.trim()
  if (!value) return value
  if (/^(https?:|mailto:|tel:)/i.test(value)) return value
  return `https://${value}`
}

export function isValidUrl(input: string): boolean {
  try {
    const url = new URL(normalizeUrl(input))
    if (url.protocol === 'http:' || url.protocol === 'https:') return url.hostname.includes('.')
    return url.protocol === 'mailto:' || url.protocol === 'tel:'
  } catch {
    return false
  }
}

/**
 * Las fotos del catálogo están guardadas como rutas relativas ("media/...").
 * Con rutas limpias (/catalogo, /admin) el navegador las resolvería dentro de
 * esa ruta (/catalogo/media/...) y no las encontraría: las anclamos a la raíz.
 * URLs completas, data: y blob: se dejan intactas.
 */
export function imageUrl(src: string | null | undefined): string | null {
  if (!src) return null
  if (/^(?:[a-z][a-z\d+.-]*:|\/\/|\/|#|\?)/i.test(src)) return src
  return `/${src.replace(/^\.\//, '')}`
}

export function bySort<T extends { position: number }>(a: T, b: T) {
  return a.position - b.position
}
