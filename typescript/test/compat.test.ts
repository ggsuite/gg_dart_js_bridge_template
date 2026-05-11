// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import { describe, expect, test } from 'vitest';
import { assertWasmGcSupported, checkWasmGcSupport } from '../compat.js';

describe('Wasm-GC compatibility probe', () => {
  test('reports support in the current runtime', () => {
    const r = checkWasmGcSupport();
    expect(r.supported).toBe(true);
    expect(r.reasons).toEqual([]);
  });

  test('assert form does not throw on a supported runtime', () => {
    expect(() => assertWasmGcSupported()).not.toThrow();
  });

  test('assert form throws a descriptive Error on unsupported runtime', () => {
    // Patch globalThis.WebAssembly to simulate an environment without it.
    const original = (globalThis as { WebAssembly?: unknown }).WebAssembly;
    (globalThis as { WebAssembly?: unknown }).WebAssembly = undefined;
    try {
      expect(() => assertWasmGcSupported()).toThrowError(
        /requires a WebAssembly runtime/,
      );
      const r = checkWasmGcSupport();
      expect(r.supported).toBe(false);
      expect(r.reasons[0]).toMatch(/WebAssembly is not available/);
    } finally {
      (globalThis as { WebAssembly?: unknown }).WebAssembly = original;
    }
  });
});
