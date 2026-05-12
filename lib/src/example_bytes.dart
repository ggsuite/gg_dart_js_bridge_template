// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

/// Result of analyzing a byte buffer.
///
/// Conceptually the JSON `{ byteCount: <int> }` returned to JS callers.
class ByteAnalysis {
  /// Create a [ByteAnalysis].
  const ByteAnalysis({required this.byteCount});

  /// Number of bytes in the analyzed buffer.
  final int byteCount;
}

/// Returns a [ByteAnalysis] describing [bytes].
ByteAnalysis analyzeBytes(Uint8List bytes) =>
    ByteAnalysis(byteCount: bytes.length);
