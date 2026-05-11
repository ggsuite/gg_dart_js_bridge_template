// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_dart_js_bridge_template/gg_dart_js_bridge_template.dart';
import 'package:test/test.dart';

void main() {
  group('enrichPerson', () {
    test('marks age >= 18 as adult', () {
      final out = enrichPerson(const Person(name: 'Alice', age: 30));
      expect(out.name, 'Alice');
      expect(out.age, 30);
      expect(out.isAdult, true);
    });

    test('marks age < 18 as not adult', () {
      final out = enrichPerson(const Person(name: 'Bob', age: 12));
      expect(out.isAdult, false);
    });
  });
}
