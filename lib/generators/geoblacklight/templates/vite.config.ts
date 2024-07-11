import { defineConfig } from 'vite'
import rails from 'vite-plugin-rails'

export default defineConfig(({ mode }) => {
  return {
    build: {
      minify: mode === 'production',
      manifest: true,
      sourcemap: true,
    },
    plugins: [
      rails(),
    ]
  }
})
