import { lazy, Suspense } from 'react'
import { createHashRouter, Outlet, RouterProvider, ScrollRestoration, useLocation } from 'react-router-dom'
import HeroBackground from './components/HeroBackground'
import Home from './pages/Home'
import Menu from './pages/Menu'
import MenuCategory from './pages/MenuCategory'
import { marca } from './marca'

// El panel se descarga solo cuando alguien entra a #/admin.
const Admin = lazy(() => import('./pages/admin/AdminApp'))

// Al volver atrás, cada página recupera la posición donde la persona estaba.
// El video de fondo vive aquí para que siga corriendo al pasar del inicio al catálogo.
function Root() {
  const { pathname } = useLocation()
  const isAdmin = pathname.startsWith('/admin')
  return (
    <>
      <ScrollRestoration />
      {!isAdmin && <HeroBackground dim={pathname.startsWith(marca.catalogo.ruta)} />}
      <Outlet />
    </>
  )
}

const router = createHashRouter([
  {
    element: <Root />,
    children: [
      { path: '/', element: <Home /> },
      { path: marca.catalogo.ruta, element: <Menu /> },
      { path: `${marca.catalogo.ruta}/:categoryId`, element: <MenuCategory /> },
      {
        path: '/admin/*',
        element: (
          <Suspense fallback={<div className="min-h-dvh bg-papel" />}>
            <Admin />
          </Suspense>
        ),
      },
      { path: '*', element: <Home /> },
    ],
  },
])

export default function App() {
  return <RouterProvider router={router} />
}
