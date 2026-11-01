/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_ANDROID_DOWNLOAD_URL?: string;
  readonly VITE_IOS_DOWNLOAD_URL?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
