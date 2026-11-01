import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  base: "/admin/",
  plugins: [react()],
  server: {
    proxy: {
      "/api": "http://127.0.0.1:8091",
      "/sanctum": "http://127.0.0.1:8091",
    },
  },
  build: {
    sourcemap: false,
  },
});

