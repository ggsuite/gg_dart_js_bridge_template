# gg_dart_js_bridge_template

Template repository showing how to expose a Dart package as a JavaScript
**and** WebAssembly module — published to npm, consumed from Node or the
browser, with hand-typed TypeScript declarations.

It is intentionally a **single hybrid project**: one `pubspec.yaml` and one
`package.json` in the same root. `pubspec.yaml` is the source of truth for
the version; `scripts/sync_version.dart` copies it into `package.json`
before each build.

## Layout

```
.
├── pubspec.yaml            # Dart package (publish_to: none)
├── package.json            # npm package
├── build.dart              # compiles lib/src/main.dart → JS + Wasm
├── lib/                    # Dart sources
│   ├── gg_dart_js_bridge_template.dart
│   └── src/
│       ├── main.dart           # @JSExport bridge to JS
│       ├── example_function.dart
│       ├── example_class.dart
│       ├── example_json.dart
│       └── example_callback.dart
├── test/                   # Dart unit tests
├── typescript/             # TypeScript wrapper
│   ├── index.ts                # public typed API
│   ├── runtime.ts              # Wasm / JS loader
│   ├── examples/               # one .ts per illustrated pattern
│   ├── test/                   # Vitest specs (node + browser)
│   └── generated/              # gitignored — populated by build.dart
├── example/
│   ├── browser/                # Vite dev-server demo
│   └── node-cli/               # Node CLI demo
└── scripts/sync_version.dart   # pubspec.yaml → package.json
```

## Prerequisites

- Dart SDK ≥ 3.11
- Node.js ≥ 22 (Wasm-GC is required)
- pnpm

## Build & test

```bash
dart pub get
pnpm install

pnpm run build      # sync version, compile Dart→JS+Wasm, emit .d.ts via tsc, bundle via Vite
pnpm test           # Dart tests, then Vitest in Node + headless Chromium
```

Useful targeted scripts:

```bash
pnpm run build:dart        # only the Dart→JS+Wasm step
pnpm run build:dart:debug  # unoptimized + source maps
pnpm run test:node         # Vitest, Node only
pnpm run test:browser      # Vitest, Playwright/Chromium only
pnpm run clean             # remove dist/ and typescript/generated/
```

## Run the examples

```bash
pnpm run example:browser   # http://localhost:5174 — exercises all four patterns
pnpm run example:node      # CLI — exercises the same patterns from Node
```

See [`example/`](example/) for the bundler integration details.

## The four illustrated patterns

| # | Pattern | Dart side | JS side |
|---|---|---|---|
| 1 | Function call | `add(int, int)` in `example_function.dart` | `dart.add(a, b)` |
| 2 | Class + async method | `Counter` in `example_class.dart` | `dart.createCounter()` → handle with `incrementAsync` returning `Promise<number>` |
| 3 | Typed object exchange | `enrichPerson` in `example_json.dart` (+ `JSObject` extension types in `main.dart`) | `dart.enrichPerson({ name, age })` — returns `{ name, age, isAdult }` |
| 4 | JS callback into Dart | `mapWithCallback` in `example_callback.dart` | `dart.mapWithCallback(items, fn)` — Dart invokes `fn` per element |

Each pattern has a Dart unit test, a TypeScript example file, and a Vitest
spec that runs in both Node and a real Chromium browser.

## Publishing

```bash
pnpm publish
```

`prepublishOnly` runs the full build and test suite first. The `files`
allow-list in `package.json` ensures only `dist/`, `README.md`, and
`LICENSE` are shipped — Dart sources, `.dart_tool/`, `node_modules/`, and
the bridge generator stay out of the tarball.

## Bundle-size note

The minimum bundle produced by `dart compile js` / `dart compile wasm` is
in the **few hundred kilobytes** range, even for trivial APIs. That is the
nature of the Dart-to-JS / Dart-to-Wasm runtime, not a property of this
template. If your goal is a tiny utility that ships in a couple of
kilobytes, hand-writing TypeScript will always be smaller. The value of
this approach is reusing substantial existing Dart code from the web.

## Source-map caveat

Source maps work for JS in debug mode (`pnpm run build:dart:debug`).
For Wasm, source-map support across browsers and Node is partial. Treat it
as a debugging aid, not a guaranteed feature.

## License

See [LICENSE](LICENSE).
