import { resolve } from "path";
import { defineConfig } from "vite";

export default defineConfig(() => {
  return {
    build: {
      outDir: "app/assets/javascripts/geoblacklight",
      emptyOutDir: true,
      sourcemap: true,
      lib: {
        entry: resolve(__dirname, "app/javascript/geoblacklight/index.js"),
        name: "@geoblacklight/frontend",
        fileName: "geoblacklight",
      },
    },
    test: {
      environment: "jsdom",
    },
  };
});
