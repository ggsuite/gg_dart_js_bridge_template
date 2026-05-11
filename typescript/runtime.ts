// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import { assertWasmGcSupported } from './compat.js';


import type { DartBridge } from "./index.js";

/** Which compiled Dart target to load. */
export type Target = "wasm" | "js" | "auto";

/** Options for `loadBridge`. */
export interface RuntimeOptions {
  /**
   * Force a specific target. Default `'auto'`:
   * try Wasm first, fall back to JS.
   */
  target?: Target;
  /**
   * URL of the `.wasm` file. Required when running in the browser unless
   * a bundler resolves it for you. In Node we read it from the filesystem
   * next to the module.
   */
  wasmUrl?: string | URL;
}

declare global {
  // populated by Dart's `main()` after the module is loaded
  var dartBridge: DartBridge | undefined;
}

const isNode =
  typeof process !== "undefined" &&
  process.versions != null &&
  process.versions.node != null;

export async function loadBridge(options: RuntimeOptions): Promise<DartBridge> {
  const target = options.target ?? "auto";

  if (target === "js") {
    return await loadJs();
  }
  if (target === "wasm") {
    return await loadWasm(options.wasmUrl);
  }
  // auto
  try {
    return await loadWasm(options.wasmUrl);
  } catch (e) {
    if (isNode || typeof console !== "undefined") {
      console.warn(
        "[gg-dart-js-bridge-template] Wasm load failed, falling back to JS:",
        e,
      );
    }
    return await loadJs();
  }
}

async function loadJs(): Promise<DartBridge> {
  const mod = await import("./generated/bridge-js.js");
  // bridgeJs() runs Dart's main() which assigns globalThis.dartBridge
  (mod as { bridgeJs: () => void }).bridgeJs();
  const bridge = globalThis.dartBridge;
  if (!bridge) {
    throw new Error("Dart JS bundle did not expose globalThis.dartBridge");
  }
  return bridge;
}

interface InstantiatedApp {
  invokeMain(...args: unknown[]): void;
}

interface CompiledApp {
  instantiate(
    additionalImports?: Record<string, unknown>,
  ): Promise<InstantiatedApp>;
}

interface WasmLoader {
  compileStreaming(
    source: Response | Promise<Response>,
  ): Promise<CompiledApp>;
}

async function loadWasm(wasmUrl?: string | URL): Promise<DartBridge> {
  // Fail fast with a clear, actionable message if the runtime is missing
  // Wasm-GC or JS-string builtins, rather than letting WebAssembly.compile
  // throw something opaque from inside the loader.
  assertWasmGcSupported();

  const loader = (await import(
    "./generated/bridge-wasm.js"
  )) as unknown as WasmLoader;

  const url = await resolveWasmUrl(wasmUrl);
  const response = await fetchWasm(url);

  const compiled = await loader.compileStreaming(response);
  const instance = await compiled.instantiate({});
  instance.invokeMain();

  const bridge = globalThis.dartBridge;
  if (!bridge) {
    throw new Error("Dart Wasm module did not expose globalThis.dartBridge");
  }
  return bridge;
}

async function resolveWasmUrl(provided?: string | URL): Promise<URL> {
  if (provided) {
    return provided instanceof URL ? provided : new URL(provided);
  }
  // Bundlers (Vite, Webpack 5, Rollup) recognise this pattern and rewrite
  // it to a URL pointing at the asset they emit. In Node it resolves to a
  // file:// URL next to this module.
  return new URL("./generated/bridge-wasm.wasm", import.meta.url);
}

async function fetchWasm(url: URL): Promise<Response> {
  if (url.protocol === "file:" && isNode) {
    const { readFile } = await import("node:fs/promises");
    const buf = await readFile(url);
    return new Response(buf, {
      headers: { "content-type": "application/wasm" },
    });
  }
  return await fetch(url);
}
