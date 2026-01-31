import React from 'react'
import { createInertiaApp } from '@inertiajs/react'
import { createRoot } from 'react-dom/client'

import DashboardShow from './pages/Dashboard/Show'
import DocumentsShow from './pages/Documents/Show'
import SkillsShow from './pages/Skills/Show'
import UmlDiagramsShow from './pages/UmlDiagrams/Show'

const pages = {
  'Dashboard/Show': DashboardShow,
  'Documents/Show': DocumentsShow,
  'Skills/Show': SkillsShow,
  'UmlDiagrams/Show': UmlDiagramsShow,
}

createInertiaApp({
  resolve: name => {
    const page = pages[name]
    if (!page) {
      throw new Error(`Unknown page: ${name}`)
    }
    return page
  },
  setup({ el, App, props }) {
    createRoot(el).render(<App {...props} />)
  },
})
