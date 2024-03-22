import { createElement } from 'react'
import { createRoot } from 'react-dom/client'
import Viewer from '@samvera/clover-iiif/viewer'

import CloverInitializer from '@gbl/clover/clover_initializer'

document.addEventListener('DOMContentLoaded', () => {
  new CloverInitializer().run()
})
