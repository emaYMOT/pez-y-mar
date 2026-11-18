import { imageUrl } from '../lib/format'

export default function Avatar({ src, name, size = 104 }: { src: string | null; name: string; size?: number }) {
  const image = imageUrl(src)
  return (
    <div
      className="relative shrink-0 overflow-hidden rounded-full bg-noche-2 border border-cobre/60 shadow-[0_0_0_6px_rgba(6,18,29,.55),0_0_0_7px_rgba(56,191,198,.25),0_0_60px_-8px_rgba(56,191,198,.6)]"
      style={{ width: size, height: size }}
    >
      {image ? (
        <img src={image} alt={name} className="h-full w-full object-cover" />
      ) : (
        <div className="grid h-full w-full place-items-center px-[12%] text-center font-display text-[length:calc(var(--s)*var(--f))] leading-[1.05] text-balance italic text-cal" style={{ ['--s' as string]: `${size}px`, ['--f' as string]: name.length > 8 ? 0.2 : 0.26 }}>
          {name}
        </div>
      )}
    </div>
  )
}
