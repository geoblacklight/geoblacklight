import { resolve } from "path";
import { defineConfig } from "vite";
import includePaths from "rollup-plugin-includepaths";

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
      // Rewrite importmap-friendly bare specifiers like geoblacklight/foo/bar 
      // to bundler-friendly local paths like ./foo/bar
      rollupOptions: {
        plugins: [
          includePaths({
            paths: ["app/javascript"],
            extensions: [".js"],
          }),
        ],
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
