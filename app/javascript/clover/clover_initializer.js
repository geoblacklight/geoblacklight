import { createElement } from 'react'
import { createRoot } from 'react-dom/client'
import Viewer from '@samvera/clover-iiif/viewer'

export default class CloverInitializer {
  constructor () {
    this.element = document.getElementById('clover-viewer')
    if (this.element) {
      this.iiif_content = this.element.attributes['iiif_content'].value
    }
  }

  run () {
    if (!this.iiif_content) return false
    const root = createRoot(document.getElementById('clover-viewer'))
    root.render(createElement(Viewer, { id: this.iiif_content, options: this.config }))
  }

  get config () {
    return {
      showTitle: false,
      showIIIFBadge: false,
      informationPanel: {
        renderToggle: false,
        renderAbout: false
      }
    }
  }
}
