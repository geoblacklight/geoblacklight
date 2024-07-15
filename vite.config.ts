import { resolve } from "path";
import { defineConfig } from "vite";
import { exec } from "child_process";

export default defineConfig(() => {
  return {
    build: {
      outDir: 'dist/javascript',
      emptyOutDir: true,
      manifest: true,
      minify: false,
      lib: {
        entry: resolve(__dirname, "app/javascript/index.js"),
        name: "@geoblacklight/frontend",
        fileName: "geoblacklight",
      },
    },
    plugins: [
      {
        name: "copy sass sources into build",
        buildEnd: async() => {
          exec("cp -R app/assets/stylesheets dist/")
        }
      },
      {
        name: "copy image assets into build",
        buildEnd: async() => {
          exec("cp -R app/assets/images dist/")
        }
      },
      {
        name: "clobber internal test app vite files and cache",
        buildEnd: async () => {
          exec("cd .internal_test_app && bundle exec vite clobber");
        },
      },
    ],
    test: {
      environment: 'jsdom',
    }
  };
});
