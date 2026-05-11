// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// Project definitions live in vitest.workspace.ts so the two runtimes
// (Node + Playwright/Chromium) can each carry their own settings. This
// file only configures things that should apply to every run, in
// particular the coverage gate.

/// <reference types="vitest" />

import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      include: ['typescript/**/*.ts'],
      exclude: [
        'typescript/index.ts',
        'typescript/index.browser.ts',
        'typescript/index.node.ts',
        'typescript/test/**',
        'typescript/generated/**',
        'typescript/examples/**',
      ],
      all: true,
      thresholds: {
        statements: 100,
        branches: 100,
        functions: 100,
        lines: 100,
      },
    },
  },
});
