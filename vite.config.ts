import { resolve } from "path";
import { defineConfig } from "vite";
import { exec } from "child_process";

export default defineConfig(() => {
  return {
    build: {
      outDir: 'app/assets/javascripts/geoblacklight',
      emptyOutDir: true,
      manifest: true,
      minify: false,
      sourcemap: true,
      lib: {
        entry: resolve(__dirname, "app/javascript/index.js"),
        name: "@geoblacklight/frontend",
        fileName: "geoblacklight",
      },
    },
    test: {
      environment: 'jsdom',
    }
  };
});
