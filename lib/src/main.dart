// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

/// JavaScript bridge entry point.
///
/// `dart compile js` and `dart compile wasm` both run `main()` once when the
/// module is loaded. We attach a single object — `dartBridge` — to the
/// globalThis scope. The TypeScript wrapper picks it up from there.
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'example_callback.dart' as ex_cb;
import 'example_class.dart' as ex_class;
import 'example_function.dart' as ex_fn;
import 'example_json.dart' as ex_json;

// .............................................................................
// Public API exposed to JS

/// JS-facing wrapper around the Dart API. Marked with [JSExport] so
/// `createJSInteropWrapper` produces a JS object whose own methods delegate
/// to the Dart instance methods below.
@JSExport()
class DartBridge {
  /// Construct the bridge.
  DartBridge();

  // ----- example 1: simple function call -----

  /// Add two integers.
  int add(int a, int b) => _guard(() => ex_fn.add(a, b));

  /// Greet a name.
  String greet(String name) => _guard(() => ex_fn.greet(name));

  // ----- example 2: class with sync + async methods -----

  /// Create a new counter and return its JS wrapper.
  JSObject createCounter([int initial = 0]) {
    return _guard(
      () => createJSInteropWrapper(_JsCounter(ex_class.Counter(initial))),
    );
  }

  // ----- example 3: JSON exchange -----

  /// Take a JSON string, enrich it, return a JSON string.
  String enrichPersonJson(String input) =>
      _guard(() => ex_json.enrichPersonJson(input));

  // ----- example 4: JS callback passed into Dart -----

  /// Apply [callback] to each entry of [items] and return the results.
  ///
  /// [items] arrives as a JS array of strings; [callback] is a JS function.
  /// We convert both to their Dart counterparts and use the underlying
  /// `mapWithCallback` from `example_callback.dart`.
  JSArray<JSString> mapWithCallback(
    JSArray<JSString> items,
    JSFunction callback,
  ) {
    return _guard(() {
      final dartItems = items.toDart.map<String>((j) => j.toDart).toList();
      final result = ex_cb.mapWithCallback<String, String>(
        dartItems,
        (String s) {
          final ret = callback.callAsFunction(null, s.toJS);
          return (ret as JSString?)?.toDart ?? '';
        },
      );
      return result.map<JSString>((s) => s.toJS).toList().toJS;
    });
  }
}

/// JS wrapper for [ex_class.Counter].
@JSExport()
class _JsCounter {
  _JsCounter(this._inner);
  final ex_class.Counter _inner;

  int get value => _inner.value;
  int increment([int by = 1]) => _inner.increment(by);
  JSPromise<JSNumber> incrementAsync(int delayMs, [int by = 1]) {
    return _inner.incrementAsync(delayMs, by).then((v) => v.toJS).toJS;
  }
}

// .............................................................................
// Error guard: convert Dart exceptions to JS-throwable errors with a
// readable message. Without this the JS side sees opaque interop objects.

T _guard<T>(T Function() body) {
  try {
    return body();
  } catch (e, st) {
    throw '$e\n$st'.toJS;
  }
}

// .............................................................................
// Bind to globalThis. The TypeScript wrapper reads `globalThis.dartBridge`
// after the module's `main()` has run.

void main() {
  final bridge = createJSInteropWrapper(DartBridge());
  globalContext.setProperty('dartBridge'.toJS, bridge);
}
