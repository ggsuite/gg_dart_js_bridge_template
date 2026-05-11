// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// Example 3 — JSON exchange across the boundary.

import { init } from '../index.js';

export interface Person {
  name: string;
  age: number;
}

export interface EnrichedPerson extends Person {
  isAdult: boolean;
}

export async function runJsonExample(person: Person): Promise<EnrichedPerson> {
  const dart = await init();
  const result = dart.enrichPersonJson(JSON.stringify(person));
  return JSON.parse(result) as EnrichedPerson;
}
