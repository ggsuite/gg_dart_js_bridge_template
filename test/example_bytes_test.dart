// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import 'package:gg_dart_js_bridge_template/gg_dart_js_bridge_template.dart';
import 'package:test/test.dart';

void main() {
  group('analyzeBytes', () {
    test('returns the number of bytes', () {
      final out = analyzeBytes(Uint8List.fromList(<int>[1, 2, 3, 4]));
      expect(out.byteCount, 4);
    });

    test('returns 0 for an empty buffer', () {
      expect(analyzeBytes(Uint8List(0)).byteCount, 0);
    });
  });
}
