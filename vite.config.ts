import { resolve } from "path";
import { defineConfig } from "vite";

export default defineConfig(() => {
  return {
    publicDir: 'app/assets',
    build: {
      outDir: 'dist',
      copyPublicDir: true,
      emptyOutDir: true,
      manifest: true,
      minify: false,
      sourcemap: true,
      lib: {
        entry: resolve(__dirname, "app/javascript/index.js"),
        name: "@geoblacklight/frontend",
        fileName: "geoblacklight",
      },
      rollupOptions: {
        output: {
          entryFileNames: 'javascript/geoblacklight.js',
          chunkFileNames: 'javascript/[name].js',
          assetFileNames: 'javascript/[name].[ext]'
        },
      }
    },
    test: {
      environment: 'jsdom',
    }
  };
});
