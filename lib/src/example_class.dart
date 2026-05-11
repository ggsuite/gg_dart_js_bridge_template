// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:async';

/// A simple counter exposed to JS as a class with sync and async methods.
class Counter {
  /// Create a counter starting at [initial].
  Counter([int initial = 0]) : _value = initial;

  int _value;

  /// Current value.
  int get value => _value;

  /// Increment by [by] and return the new value.
  int increment([int by = 1]) {
    _value += by;
    return _value;
  }

  /// Async variant: waits [delayMs] before incrementing.
  Future<int> incrementAsync(int delayMs, [int by = 1]) async {
    await Future<void>.delayed(Duration(milliseconds: delayMs));
    return increment(by);
  }
}
