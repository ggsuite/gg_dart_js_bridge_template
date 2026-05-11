// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// Asserts which target (Wasm vs JS fallback) was actually loaded.
// Vitest captures stderr/console.warn; we record whether the fallback
// warning fired during init().

import { afterEach, beforeAll, expect, test, vi } from 'vitest';
import { _resetForTests, init } from '../index.js';

let warned = false;

beforeAll(() => {
  vi.spyOn(console, 'warn').mockImplementation((...args: unknown[]) => {
    if (String(args[0]).includes('Wasm load failed')) warned = true;
  });
});

afterEach(() => {
  _resetForTests();
});

test('init() loads Wasm (no JS fallback)', async () => {
  warned = false;
  await init();
  expect(warned).toBe(false);
});
