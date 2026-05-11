// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import { defineWorkspace } from 'vitest/config';

export default defineWorkspace([
  {
    test: {
      name: 'node',
      environment: 'node',
      include: ['typescript/test/**/*.test.ts'],
      exclude: ['typescript/test/**/*.browser.test.ts', 'node_modules/**'],
    },
  },
  {
    test: {
      name: 'browser',
      include: ['typescript/test/**/*.test.ts'],
      exclude: ['typescript/test/**/*.node.test.ts', 'node_modules/**'],
      browser: {
        enabled: true,
        provider: 'playwright',
        headless: true,
        name: 'chromium',
      },
    },
  },
]);
