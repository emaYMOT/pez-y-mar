import { useMemo, useState } from 'react'

const base = import.meta.env.BASE_URL

/**
 * Video de fondo compartido por el inicio y el catálogo (vive en el layout, así no se reinicia al navegar).
 * Video de fondo (public/media/hero.mp4 y hero.webm). Mientras carga, o si todavía
 * no se ha subido, se ve el fondo del mar con rayos de luz y burbujas.
 */
export default function HeroBackground({ dim = false }: { dim?: boolean }) {
  const [ready, setReady] = useState(false)
  const [failed, setFailed] = useState(false)

  return (
    <div className="fixed inset-0 -z-10 overflow-hidden bg-noche" aria-hidden>
      <Mar />
      {!failed && (
        <video
          className={`absolute inset-0 h-full w-full object-cover transition-opacity duration-1000 ${ready ? 'opacity-100' : 'opacity-0'}`}
          autoPlay
          muted
          loop
          playsInline
          preload="auto"
          poster={`${base}media/hero-poster.jpg`}
          onPlaying={() => setReady(true)}
        >
          <source src={`${base}media/hero.webm`} type="video/webm" />
          <source src={`${base}media/hero.mp4`} type="video/mp4" onError={() => setFailed(true)} />
        </video>
      )}
      {/* Tinte azul sobre el video, como agua. */}
      <div className="absolute inset-0 bg-[#0a3a5c]/25 mix-blend-multiply" />
      {/* Viñeta: los bordes se hunden en negro y la luz queda arriba a la derecha. */}
      <div className="absolute inset-0 bg-[radial-gradient(120%_80%_at_78%_10%,transparent_0%,rgba(6,18,29,.45)_55%,rgba(6,18,29,.85)_100%)]" />
      {/* Abajo, donde va el texto, se oscurece del todo para que se lea. */}
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-noche/35 via-50% to-noche/75" />
      {/* En el catálogo, una capa más oscura para leer productos y precios; se funde al cambiar de página. */}
      <div className={`absolute inset-0 bg-noche/60 transition-opacity duration-700 ease-out ${dim ? 'opacity-100' : 'opacity-0'}`} />
    </div>
  )
}

function Mar() {
  const bubbles = useMemo(() => {
    let seed = 7
    const rand = () => ((seed = (seed * 16807) % 2147483647) - 1) / 2147483646
    return Array.from({ length: 46 }, () => ({
      x: rand() * 100,
      y: 60 + rand() * 50, // nacen abajo y suben
      r: 0.15 + rand() * 0.55,
      d: 9 + rand() * 12,
      delay: rand() * -20,
    }))
  }, [])

  return (
    <svg className="absolute inset-0 h-full w-full" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid slice">
      <defs>
        <linearGradient id="agua" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#0f4a6b" />
          <stop offset="0.45" stopColor="#0a2a44" />
          <stop offset="1" stopColor="#06121d" />
        </linearGradient>
        <radialGradient id="superficie" cx="0.5" cy="0.5" r="0.5">
          <stop offset="0" stopColor="#7fe3e8" stopOpacity="0.55" />
          <stop offset="0.5" stopColor="#38bfc6" stopOpacity="0.2" />
          <stop offset="1" stopColor="#38bfc6" stopOpacity="0" />
        </radialGradient>
        <linearGradient id="rayo" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#bff4f6" stopOpacity="0.35" />
          <stop offset="1" stopColor="#bff4f6" stopOpacity="0" />
        </linearGradient>
      </defs>
      <rect width="100" height="100" fill="url(#agua)" />
      <ellipse cx="78" cy="0" rx="60" ry="30" fill="url(#superficie)" />
      {/* Rayos de luz que entran desde la superficie. */}
      <g className="rayos">
        <polygon points="58,0 66,0 52,80 40,80" fill="url(#rayo)" />
        <polygon points="72,0 77,0 70,70 62,70" fill="url(#rayo)" opacity="0.7" />
        <polygon points="84,0 92,0 90,90 78,90" fill="url(#rayo)" opacity="0.8" />
        <polygon points="40,0 44,0 30,60 24,60" fill="url(#rayo)" opacity="0.5" />
      </g>
      {bubbles.map((b, i) => (
        <circle
          key={i}
          className="burbuja"
          cx={b.x}
          cy={b.y}
          r={b.r}
          fill="none"
          stroke="#bff4f6"
          strokeOpacity="0.45"
          strokeWidth="0.12"
          style={{ ['--d' as string]: `${b.d}s`, ['--delay' as string]: `${b.delay}s` }}
        />
      ))}
    </svg>
  )
}
