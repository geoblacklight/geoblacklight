import { defineConfig, searchForWorkspaceRoot } from "vite";
import rails from "vite-plugin-rails";

export default defineConfig(({ mode }) => {
  return {
    build: {
      minify: mode === "production",
      manifest: true,
      sourcemap: true,
    },
    server: {
      fs: {
        allow: [
          // search up for workspace root
          searchForWorkspaceRoot(process.cwd()),
          // One directory up (from .internal_test_app where we do `yarn link @geoblacklight`)
          `${process.cwd()}/..`,
        ],
      },
    },
    plugins: [rails()],
  };
});
