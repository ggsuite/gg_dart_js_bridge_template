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

// coverage:ignore-file

library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'example_bytes.dart' as ex_bytes;
import 'example_callback.dart' as ex_cb;
import 'example_class.dart' as ex_class;
import 'example_function.dart' as ex_fn;
import 'example_json.dart' as ex_json;

// .............................................................................
// Extension types describing the JS-side object shapes used by example 3.
//
// They are zero-cost wrappers around `JSObject` — no runtime conversion,
// just typed access from Dart to fields of a plain JS object.

/// JS view of a `Person` object: `{ name: string, age: number }`.
extension type _PersonJs._(JSObject _) implements JSObject {
  external _PersonJs({required String name, required int age});
  external String get name;
  external int get age;
}

/// JS view of the enriched result: `{ name, age, isAdult }`.
extension type _EnrichedPersonJs._(JSObject _) implements JSObject {
  external _EnrichedPersonJs({
    required String name,
    required int age,
    required bool isAdult,
  });
}

/// JS view of the byte-analysis result: `{ byteCount: number }`.
extension type _ByteAnalysisJs._(JSObject _) implements JSObject {
  external _ByteAnalysisJs({required int byteCount});
}

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

  // ----- example 3: typed object exchange -----

  /// Accept a JS `{ name, age }` object, return `{ name, age, isAdult }`.
  ///
  /// No JSON serialization happens at the boundary — `JSObject` extension
  /// types give us typed access to the JS object's fields directly.
  JSObject enrichPerson(JSObject input) {
    return _guard(() {
      final p = input as _PersonJs;
      final out = ex_json.enrichPerson(
        ex_json.Person(name: p.name, age: p.age),
      );
      return _EnrichedPersonJs(
        name: out.name,
        age: out.age,
        isAdult: out.isAdult,
      );
    });
  }

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
      final result = ex_cb.mapWithCallback<String, String>(dartItems, (
        String s,
      ) {
        final ret = callback.callAsFunction(null, s.toJS);
        return (ret as JSString?)?.toDart ?? '';
      });
      return result.map<JSString>((s) => s.toJS).toList().toJS;
    });
  }

  // ----- example 5: byte array exchange -----

  /// Count the bytes in a JS `Uint8Array` and return `{ byteCount }`.
  ///
  /// The JS `Uint8Array` arrives as a [JSUint8Array]; `.toDart` exposes it
  /// as a [Uint8List] view over the same bytes — no copy at the boundary.
  JSObject analyzeBytes(JSUint8Array input) {
    return _guard(() {
      final out = ex_bytes.analyzeBytes(input.toDart);
      return _ByteAnalysisJs(byteCount: out.byteCount);
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
