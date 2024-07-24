import { defineConfig } from 'vite'
import rails from 'vite-plugin-rails'
import path from 'path'

export default defineConfig(({ mode }) => {
  return {
    build: {
      minify: mode === 'production',
      manifest: true,
      sourcemap: true,
    },
    plugins: [
      rails(),
    ],
    resolve: {
      alias: {
        '@leaflet_images': path.resolve(__dirname, './node_modules/@geoblacklight/frontend/node_modules/leaflet/dist/images'),
        '@geoblacklight_images': path.resolve(__dirname, './node_modules/@geoblacklight/frontend/dist/images')
      },
      preserveSymlinks: true
    }
  }
})
