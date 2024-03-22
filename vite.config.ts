import { resolve } from 'path'
import { defineConfig } from 'vite'

export default defineConfig({
  build: {
    manifest: true,
    minify: true,
    reportCompressedSize: true,
    lib: {
      entry: resolve(__dirname, 'app/javascript/index.js'),
      name: '@geoblacklight/frontend',
      fileName: 'frontend'
    }
  }
})
