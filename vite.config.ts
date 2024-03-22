import { resolve } from 'path'
import { defineConfig } from 'vite'
import { exec } from 'child_process'

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
  },
  "plugins": [
    {
      name: 'clobber internal test app vite files and cache',
      buildEnd: async() => {
        exec("cd .internal_test_app && bundle exec vite clobber")
      }
    }
  ]
})
