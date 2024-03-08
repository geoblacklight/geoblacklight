import { defineConfig } from 'vite'
import rails from 'vite-plugin-rails'

export default defineConfig({
  plugins: [
    rails(),
  ],
  // GeoBlacklight: Import assets from arbitrary paths.
  resolve: {
    alias: {
      '@gbl/': `${process.env.GBL_ASSETS_PATH}/`,
    },
  },
  server: {
    fs: {
      allow: [process.env.GBL_ASSETS_PATH!],
    },
  },
})
