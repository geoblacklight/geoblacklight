import { resolve } from "path";
import { defineConfig } from "vite";
import includePaths from "rollup-plugin-includepaths";

export default defineConfig(() => {
  return {
    build: {
      outDir: "app/assets/javascripts/geoblacklight",
      emptyOutDir: true,
      manifest: true,
      minify: false,
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
            include: {},
            external: [],
          }),
        ],
      },
    },
    test: {
      environment: "jsdom",
    },
  };
});
