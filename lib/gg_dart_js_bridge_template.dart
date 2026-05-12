// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

/// Public Dart API of the bridge template.
///
/// These types are also usable from pure Dart code (and are exercised by the
/// Dart tests in `test/`). The JS/Wasm bridge in `lib/src/main.dart` wraps
/// them with `@JSExport` annotations.
library;

export 'src/example_function.dart';
export 'src/example_class.dart';
export 'src/example_json.dart';
export 'src/example_callback.dart';
export 'src/example_bytes.dart';
