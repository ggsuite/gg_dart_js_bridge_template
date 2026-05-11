// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_dart_js_bridge_template/gg_dart_js_bridge_template.dart';
import 'package:test/test.dart';

void main() {
  group('example_function', () {
    test('add', () {
      expect(add(2, 3), 5);
    });

    test('greet', () {
      expect(greet('world'), 'Hello, world!');
    });
  });
}
