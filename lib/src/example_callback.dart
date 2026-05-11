// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

/// Calls [callback] once per element in [items] and returns the list of
/// transformed values.
///
/// In the JS bridge this maps to a JS callback function being passed to Dart
/// and invoked synchronously.
List<R> mapWithCallback<T, R>(List<T> items, R Function(T) callback) {
  return <R>[for (final item in items) callback(item)];
}
