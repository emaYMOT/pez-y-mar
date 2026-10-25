import type { PublicCategory } from '../lib/store'

// Tonos para las portadas sin foto: todos de la misma familia marina.
const TINTS = ['#38bfc6', '#1f6fd1', '#2a9bb5', '#1d4f9c', '#3fa7d6', '#2b7a9e']

/** Foto de la categoría; si no hay, la del primer producto con foto; si tampoco, un fondo marino con su emoji. */
export function coverImage(category: PublicCategory): string | null {
  return category.image_url || category.items.find((i) => i.image_url)?.image_url || null
}

export default function CategoryCover({ category, index, eager }: { category: PublicCategory; index: number; eager?: boolean }) {
  const image = coverImage(category)

  if (image) {
    return (
      <img
        src={image}
        alt=""
        loading={eager ? 'eager' : 'lazy'}
        className="absolute inset-0 h-full w-full object-cover transition duration-700 ease-out group-hover:scale-[1.04]"
      />
    )
  }

  const tint = TINTS[index % TINTS.length]
  return (
    <div
      className="vidrio absolute inset-0"
      style={{
        background: `radial-gradient(120% 90% at ${index % 2 ? '15%' : '85%'} 0%, ${tint}cc, transparent 60%), radial-gradient(80% 70% at ${index % 2 ? '90%' : '10%'} 100%, ${tint}55, transparent 70%), rgba(12, 31, 48, .5)`,
      }}
    >
      {category.emoji && (
        <span
          aria-hidden
          className={`absolute top-1/2 -translate-y-[60%] text-[7.5rem] leading-none drop-shadow-[0_20px_30px_rgba(0,0,0,.45)] transition duration-700 ease-out group-hover:scale-110 sm:text-[9rem] ${index % 2 ? 'left-[8%] -rotate-12' : 'right-[8%] rotate-12'}`}
        >
          {category.emoji}
        </span>
      )}
    </div>
  )
}
