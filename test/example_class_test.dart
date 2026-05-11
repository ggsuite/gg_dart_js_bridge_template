// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_dart_js_bridge_template/gg_dart_js_bridge_template.dart';
import 'package:test/test.dart';

void main() {
  group('Counter', () {
    test('starts at 0 by default', () {
      expect(Counter().value, 0);
    });

    test('increment returns new value', () {
      final c = Counter(10);
      expect(c.increment(), 11);
      expect(c.increment(5), 16);
      expect(c.value, 16);
    });

    test('incrementAsync resolves after delay', () async {
      final c = Counter();
      final v = await c.incrementAsync(5, 3);
      expect(v, 3);
    });
  });
}
