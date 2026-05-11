// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:convert';

/// Input model parsed from JSON.
class Person {
  /// Create a [Person].
  const Person({required this.name, required this.age});

  /// Parse from a JSON map.
  factory Person.fromJson(Map<String, dynamic> json) => Person(
    name: json['name'] as String,
    age: json['age'] as int,
  );

  /// Name of the person.
  final String name;

  /// Age in years.
  final int age;

  /// Convert to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'age': age,
  };
}

/// Takes a JSON string describing a [Person] and returns an enriched JSON
/// string describing the same person plus a derived `isAdult` flag.
///
/// String-based JSON exchange is the simplest, bundler-agnostic way to pass
/// structured data across the Dart/JS boundary.
String enrichPersonJson(String input) {
  final decoded = jsonDecode(input) as Map<String, dynamic>;
  final person = Person.fromJson(decoded);
  final result = <String, dynamic>{
    ...person.toJson(),
    'isAdult': person.age >= 18,
  };
  return jsonEncode(result);
}
