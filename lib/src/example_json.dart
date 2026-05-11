// @license
// Copyright (c) 2026 ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

/// A plain Dart model for a person. Used both inside Dart code and as
/// the conceptual shape exchanged with JS via the bridge.
class Person {
  /// Create a [Person].
  const Person({required this.name, required this.age});

  /// Name of the person.
  final String name;

  /// Age in years.
  final int age;
}

/// A [Person] enriched with a derived `isAdult` flag.
class EnrichedPerson extends Person {
  /// Create an [EnrichedPerson].
  const EnrichedPerson({
    required super.name,
    required super.age,
    required this.isAdult,
  });

  /// True if [Person.age] is at least 18.
  final bool isAdult;
}

/// Adds the derived `isAdult` flag to [p].
EnrichedPerson enrichPerson(Person p) =>
    EnrichedPerson(name: p.name, age: p.age, isAdult: p.age >= 18);
