# Pez y Mar · página web

Página tipo Linktree con video de fondo, catálogo digital por categorías y panel de administración. Réplica de la plantilla de Al Aire Gastrobar: el nombre y el vocabulario están en `src/marca.ts` y los colores en `src/index.css`.

- **Inicio** (`/#/`): foto de perfil, descripción y botones.
- **Catálogo** (`/#/catalogo`): cada categoría es un botón; al tocarla se ven solo sus productos.
- **Panel** (`/#/admin`): editar botones, catálogo (categorías, productos, precios, fotos, agotados) y perfil.

Hecha con React + Vite + Tailwind. Los datos viven en **Supabase** y la web se publica gratis en **Cloudflare Pages**.

> Sin Supabase configurado la web funciona en **modo demo**: el panel guarda los cambios solo en tu navegador. Sirve para probar.

---

## 1. Probar en tu computador

Necesitas [Node.js](https://nodejs.org) 20 o más reciente.

```bash
npm install
npm run dev
```

Abre http://localhost:5173. El panel está en http://localhost:5173/#/admin.

### Ver en el celular

Con el celular conectado al **mismo Wi-Fi** que el computador:

```bash
npm run dev:movil
```

En la salida aparece una línea `Network: http://192.168.x.x:5173/`. Abre esa dirección en el navegador del celular. Si Windows pregunta por el firewall, elige *Permitir en redes privadas* (la red Wi-Fi debe estar marcada como **Privada** en Windows).

## 2. Crear la base de datos en Supabase

1. Crea una cuenta en [supabase.com](https://supabase.com) y un proyecto nuevo (región: São Paulo o la más cercana).
2. Ve a **SQL Editor → New query**, pega todo el contenido de [`supabase/schema.sql`](supabase/schema.sql) y dale **Run**.
3. (Opcional) Haz lo mismo con [`supabase/seed.sql`](supabase/seed.sql) para cargar el perfil, los botones y las categorías base.
4. **Desactiva el registro público:** Authentication → Sign In / Providers → apaga *Allow new users to sign up*.
5. **Crea el usuario administrador:** Authentication → Users → *Add user → Create new user*. Pon el correo y una contraseña, y marca *Auto Confirm User*.
6. **Dale permiso de admin** en el SQL Editor (cambia el correo):

   ```sql
   insert into public.admins (user_id)
   select id from auth.users where email = 'correo-del-admin@ejemplo.com';
   ```

   Repite los pasos 5 y 6 para cada persona que deba editar.

7. Copia los datos de conexión desde **Project Settings → API**: *Project URL* y la clave *anon public*.

Para usarlos en tu computador, copia `.env.example` como `.env` y pégalos ahí. La clave *anon* es pública por diseño; lo que protege los datos son las reglas de seguridad de `schema.sql` (solo los usuarios en la tabla `admins` pueden escribir).

## 3. Publicar en Cloudflare Pages

El proyecto ya está creado y conectado al repositorio de GitHub:

- **Sitio:** https://pezymar.pages.dev
- **Repositorio:** `emaYMOT/pez-y-mar`, rama `main`
- **Build:** `npm run build` → carpeta `dist`, con Node 22

Cada vez que subas cambios a `main`, Cloudflare compila y publica solo (en **Workers & Pages → pez-y-mar → Deployments** puedes ver el progreso). Las ramas y los PR generan despliegues de vista previa.

Las variables de entorno se configuran en **Workers & Pages → pez-y-mar → Settings → Environment variables** (para *Production* y *Preview*):

| Variable | Valor |
| --- | --- |
| `NODE_VERSION` | `22` |
| `VITE_SUPABASE_URL` | el Project URL de Supabase |
| `VITE_SUPABASE_ANON_KEY` | la clave anon public |

### Dominio propio

En **Workers & Pages → pez-y-mar → Custom domains** puedes agregar un dominio (por ejemplo `pesquerapezymar.com`). Si el dominio está en Cloudflare, se configura automáticamente; si no, te dan los registros DNS a copiar. No hay que cambiar nada en el código.

Para crear un proyecto nuevo desde cero: **Workers & Pages → Create → Pages → Connect to Git**, eliges el repo, y en *Build settings* pones el comando `npm run build`, el directorio `dist` y las tres variables de arriba. La URL queda en `https://<nombre-del-proyecto>.pages.dev`.

### GitHub Pages (opción anterior)

Si prefieres volver a GitHub Pages, el flujo [`deploy.yml`](.github/workflows/deploy.yml) sigue funcionando: crea los secretos `VITE_SUPABASE_URL` y `VITE_SUPABASE_ANON_KEY` en el repo, activa **Settings → Pages → Source: GitHub Actions**, y la web queda en `https://<tu-usuario>.github.io/<nombre-del-repo>/`.

**Supabase en pausa:** el plan gratis pausa los proyectos tras unos 7 días sin uso. El flujo [`keepalive.yml`](.github/workflows/keepalive.yml) hace una consulta cada 3 días para evitarlo (sigue activo aunque el sitio se publique en Cloudflare, porque vive en GitHub Actions).

## 4. Cambiar el video de fondo

El video vive en el repositorio, en `public/media/`, para no gastar el límite de transferencia de Supabase.

1. Prepara el video: **720p, sin audio, idealmente menos de 6 MB** (límite de Cloudflare Pages: 25 MB por archivo). Entre más liviano, más rápido carga en celular.
   - Fácil: [HandBrake](https://handbrake.fr) → preset *Web / Creator 720p*, quita la pista de audio.
   - Con ffmpeg:
     ```bash
     ffmpeg -i original.mp4 -vf "scale=-2:720" -an -c:v libx264 -crf 28 -preset slow -movflags +faststart public/media/hero.mp4
     ```
     ```bash
     ffmpeg -i public/media/hero.mp4 -frames:v 1 -q:v 4 public/media/hero-poster.jpg
     ```
2. Guárdalo como `public/media/hero.mp4` (y la foto fija como `hero-poster.jpg`).
3. Sube el cambio a GitHub; en un par de minutos se ve en la web.

Mientras no haya video, el inicio muestra una ladera de noche con luces animadas.

## 5. Usar el panel

Entra a `/#/admin` con el correo y contraseña del administrador.

| Pestaña | Qué se hace |
| --- | --- |
| **Botones** | Agregar, editar, ocultar (interruptor) y reordenar (arrastrar ⋮⋮) los botones del inicio. Cada botón abre un enlace o la carta. Al pegar un enlace de WhatsApp, Instagram, Maps, etc. el ícono se elige solo. |
| **Catálogo** | Crear categorías con emoji, reordenarlas y ocultarlas. Dentro de cada categoría: agregar productos con descripción, precio y foto; marcarlos como **agotado** u ocultarlos sin borrarlos. |
| **Perfil** | Foto de perfil, nombre y descripción del inicio. |

Las fotos se comprimen automáticamente antes de subirse. Eliminar algo se hace desde su ventana de edición y siempre pide confirmación.

## Estructura

```
src/
  pages/Home.tsx, Menu.tsx, MenuCategory.tsx   vista pública
  pages/admin/                                 panel
  components/                                  piezas reutilizables (modal, lista arrastrable, subir foto…)
  lib/store.ts                                 acceso a datos (Supabase o modo demo)
  lib/seed.ts                                  contenido de ejemplo del modo demo
supabase/schema.sql, seed.sql                  base de datos
public/media/                                  video de fondo
scripts/                                       capturas y prueba automática con Playwright
```

Pruebas visuales y de funcionamiento (con `npm run dev` corriendo):

```bash
npm run shots
```

```bash
node scripts/e2e.mjs
```
