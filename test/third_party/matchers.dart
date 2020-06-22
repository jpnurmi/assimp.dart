// based on flutter/packages/flutter_test/lib/src/matchers.dart

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';

/// The epsilon of tolerable floating point precision error.
///
/// This is used in various places in the framework to allow for floating point
/// precision loss in calculations. Differences below this threshold are safe to
/// disregard.
const double precisionErrorTolerance = 1e-6;

double relativeAabb3Error(Aabb3 calculated, Aabb3 correct) {
  return math.max(absoluteError(calculated.min, correct.min),
      absoluteError(calculated.max, correct.max));
}

Matcher aabb3MoreOrLessEquals(Aabb3 value,
    {double epsilon = precisionErrorTolerance}) {
  return _IsWithinDistance<Aabb3>(
      relativeAabb3Error, value, precisionErrorTolerance);
}

Matcher matrix3MoreOrLessEquals(Matrix3 value,
    {double epsilon = precisionErrorTolerance}) {
  return _IsWithinDistance<Matrix3>(
      relativeError, value, precisionErrorTolerance);
}

Matcher matrix4MoreOrLessEquals(Matrix4 value,
    {double epsilon = precisionErrorTolerance}) {
  return _IsWithinDistance<Matrix4>(
      relativeError, value, precisionErrorTolerance);
}

Matcher quaternionMoreOrLessEquals(Quaternion value,
    {double epsilon = precisionErrorTolerance}) {
  return _IsWithinDistance<Quaternion>(
      absoluteError, value, precisionErrorTolerance);
}

Matcher vector2MoreOrLessEquals(Vector2 value,
    {double epsilon = precisionErrorTolerance}) {
  return _IsWithinDistance<Vector2>(
      relativeError, value, precisionErrorTolerance);
}

Matcher vector3MoreOrLessEquals(Vector3 value,
    {double epsilon = precisionErrorTolerance}) {
  return _IsWithinDistance<Vector3>(
      relativeError, value, precisionErrorTolerance);
}

/// Asserts that two [double]s are equal, within some tolerated error.
///
/// {@template flutter.flutter_test.moreOrLessEquals.epsilon}
/// Two values are considered equal if the difference between them is within
/// [precisionErrorTolerance] of the larger one. This is an arbitrary value
/// which can be adjusted using the `epsilon` argument. This matcher is intended
/// to compare floating point numbers that are the result of different sequences
/// of operations, such that they may have accumulated slightly different
/// errors.
/// {@endtemplate}
///
/// See also:
///
///  * [closeTo], which is identical except that the epsilon argument is
///    required and not named.
///  * [inInclusiveRange], which matches if the argument is in a specified
///    range.
///  * [rectMoreOrLessEquals] and [offsetMoreOrLessEquals], which do something
///    similar but for [Rect]s and [Offset]s respectively.
Matcher moreOrLessEquals(double value,
    {double epsilon = precisionErrorTolerance}) {
  return _MoreOrLessEquals(value, epsilon);
}

/// Computes the distance between two values.
///
/// The distance should be a metric in a metric space (see
/// https://en.wikipedia.org/wiki/Metric_space). Specifically, if `f` is a
/// distance function then the following conditions should hold:
///
/// - f(a, b) >= 0
/// - f(a, b) == 0 if and only if a == b
/// - f(a, b) == f(b, a)
/// - f(a, c) <= f(a, b) + f(b, c), known as triangle inequality
///
/// This makes it useful for comparing numbers, [Offset]s and other
/// sets of value for which a metric space is defined.
typedef DistanceFunction<T> = num Function(T a, T b);

/// The type of a union of instances of [DistanceFunction<T>] for various types
/// T.
///
/// This type is used to describe a collection of [DistanceFunction<T>]
/// functions which have (potentially) unrelated argument types. Since the
/// argument types of the functions may be unrelated, the only thing that the
/// type system can statically assume about them is that they accept null (since
/// all types in Dart are nullable).
///
/// Calling an instance of this type must either be done dynamically, or by
/// first casting it to a [DistanceFunction<T>] for some concrete T.
typedef AnyDistanceFunction = num Function(Null a, Null b);

const Map<Type, AnyDistanceFunction> _kStandardDistanceFunctions =
    <Type, AnyDistanceFunction>{
  int: _intDistance,
  double: _doubleDistance,
};

int _intDistance(int a, int b) => (b - a).abs();
double _doubleDistance(double a, double b) => (b - a).abs();

/// Asserts that two values are within a certain distance from each other.
///
/// The distance is computed by a [DistanceFunction].
///
/// If `distanceFunction` is null, a standard distance function is used for the
/// `T` generic argument. Standard functions are defined for the following
/// types:
///
///  * [Offset], whose distance is the Euclidean distance computed using the
///    method [Offset.distance].
///  * [Rect], whose distance is the maximum component-wise delta.
///  * [Size], whose distance is the [Offset.distance] of the offset computed as
///    the difference between two sizes.
///  * [int], whose distance is the absolute difference between two integers.
///  * [double], whose distance is the absolute difference between two doubles.
///
/// See also:
///
///  * [moreOrLessEquals], which is similar to this function, but specializes in
///    [double]s and has an optional `epsilon` parameter.
///  * [rectMoreOrLessEquals], which is similar to this function, but
///    specializes in [Rect]s and has an optional `epsilon` parameter.
///  * [closeTo], which specializes in numbers only.
Matcher within<T>({
  @required num distance,
  @required T from,
  DistanceFunction<T> distanceFunction,
}) {
  distanceFunction ??= _kStandardDistanceFunctions[T] as DistanceFunction<T>;

  if (distanceFunction == null) {
    throw ArgumentError(
        'The specified distanceFunction was null, and a standard distance '
        'function was not found for type ${from.runtimeType} of the provided '
        '`from` argument.');
  }

  return _IsWithinDistance<T>(distanceFunction, from, distance);
}

class _IsWithinDistance<T> extends Matcher {
  const _IsWithinDistance(this.distanceFunction, this.value, this.epsilon);

  final DistanceFunction<T> distanceFunction;
  final T value;
  final num epsilon;

  @override
  bool matches(Object object, Map<dynamic, dynamic> matchState) {
    if (object is! T) return false;
    if (object == value) return true;
    final T test = object as T;
    final num distance = distanceFunction(test, value);
    if (distance < 0) {
      throw ArgumentError(
          'Invalid distance function was used to compare a ${value.runtimeType} '
          'to a ${object.runtimeType}. The function must return a non-negative '
          'double value, but it returned $distance.');
    }
    matchState['distance'] = distance;
    return distance <= epsilon;
  }

  @override
  Description describe(Description description) =>
      description.add('$value (±$epsilon)');

  @override
  Description describeMismatch(
    Object object,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    mismatchDescription
        .add('was ${matchState['distance']} away from the desired value.');
    return mismatchDescription;
  }
}

class _MoreOrLessEquals extends Matcher {
  const _MoreOrLessEquals(this.value, this.epsilon) : assert(epsilon >= 0);

  final double value;
  final double epsilon;

  @override
  bool matches(Object object, Map<dynamic, dynamic> matchState) {
    if (object is! double) return false;
    if (object == value) return true;
    final double test = object as double;
    return (test - value).abs() <= epsilon;
  }

  @override
  Description describe(Description description) =>
      description.add('$value (±$epsilon)');

  @override
  Description describeMismatch(Object item, Description mismatchDescription,
      Map<dynamic, dynamic> matchState, bool verbose) {
    return super
        .describeMismatch(item, mismatchDescription, matchState, verbose)
          ..add('$item is not in the range of $value (±$epsilon).');
  }
}
