// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_dart_js_bridge_template/gg_dart_js_bridge_template.dart';
import 'package:test/test.dart';

void main() {
  test('mapWithCallback applies callback to each item', () {
    final result = mapWithCallback<int, int>([1, 2, 3], (n) => n * 10);
    expect(result, [10, 20, 30]);
  });
}
