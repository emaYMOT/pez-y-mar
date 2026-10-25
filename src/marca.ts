/**
 * Todo lo que cambia de un negocio a otro: nombre y vocabulario.
 * Para hacer una réplica para otro negocio, edita este archivo, los colores en src/index.css,
 * index.html (título y descripción) y el contenido inicial en src/lib/seed.ts y supabase/seed.sql.
 */
export const marca = {
  nombre: 'Pez y Mar',

  // La sección de productos ("carta" en un restaurante, "catálogo" en una tienda).
  catalogo: {
    ruta: '/catalogo', // dirección en la web: /#/catalogo
    titulo: 'Nuestro catálogo',
    subtitulo: 'Del mar a tu paladar. Elige tus productos.',
    pestana: 'Catálogo', // pestaña del panel e ícono del botón
    boton: 'Ver catálogo', // texto sugerido al crear el botón
    el: 'el catálogo',
    del: 'del catálogo',
    en: 'en el catálogo',
  },

  // Cómo se llama cada cosa dentro del catálogo (masculino: "producto guardado").
  producto: { uno: 'producto', varios: 'productos', Uno: 'Producto' },

  agotado: 'Agotado',

  // Unidades de venta que se pueden elegir en el panel (vacío = no se muestra la opción).
  unidades: ['lb', 'unidad', 'kg'],
  unidadPorDefecto: 'lb',
  disponible: { etiqueta: 'Disponible', ayuda: 'Apágalo cuando no haya existencias: se verá como agotado.' },

  // Ejemplos que aparecen en los formularios del panel.
  ejemplos: {
    producto: 'Filete de tilapia roja',
    descripcionProducto: 'Presentación, corte o peso. Por ejemplo: bandeja de 500 g.',
    categoria: 'Mariscos',
    categoriaVacia: '“Pescados”',
    boton: 'Pedir por WhatsApp',
  },
} as const

export const rutaCatalogo = marca.catalogo.ruta
