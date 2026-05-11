// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:convert';

import 'package:gg_dart_js_bridge_template/gg_dart_js_bridge_template.dart';
import 'package:test/test.dart';

void main() {
  group('enrichPersonJson', () {
    test('adds isAdult: true for age >= 18', () {
      final out = enrichPersonJson('{"name":"Alice","age":30}');
      final decoded = jsonDecode(out) as Map<String, dynamic>;
      expect(decoded, {'name': 'Alice', 'age': 30, 'isAdult': true});
    });

    test('adds isAdult: false for age < 18', () {
      final out = enrichPersonJson('{"name":"Bob","age":12}');
      final decoded = jsonDecode(out) as Map<String, dynamic>;
      expect(decoded['isAdult'], false);
    });
  });
}
