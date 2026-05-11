// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import wasmUrl from '../../typescript/generated/bridge-wasm.wasm?url';
import { runCallbackExample } from '../../typescript/examples/callback.js';
import { runClassExample } from '../../typescript/examples/class.js';
import { runFunctionExample } from '../../typescript/examples/function.js';
import { runJsonExample } from '../../typescript/examples/json.js';
import { init } from '../../typescript/index.js';

async function main(): Promise<void> {
  // Pre-warm the bridge with the bundler-resolved wasm URL.
  await init({ wasmUrl });

  setText('out-function', await runFunctionExample());
  setText('out-class', await runClassExample());
  setText(
    'out-json',
    JSON.stringify(await runJsonExample({ name: 'Alice', age: 30 }), null, 2),
  );
  setText('out-callback', (await runCallbackExample()).join(', '));
}

function setText(id: string, text: string): void {
  const el = document.getElementById(id);
  if (el) el.textContent = text;
}

main().catch((e) => {
  console.error(e);
  document.body.append(`Error: ${String(e)}`);
});
