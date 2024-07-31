import { resolve } from "path";
import { defineConfig } from "vite";

export default defineConfig(({ mode }) => {
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
    // If these are not defined, they will not be replaced in bundled code,
    // which will throw errors because `process` is not defined in the browser
    define: {
      "process.env.NODE_ENV": JSON.stringify(mode),
      "process.env.LANG": "en",
    },
    // Used by vitest
    test: {
      environment: "jsdom",
    },
  };
});
