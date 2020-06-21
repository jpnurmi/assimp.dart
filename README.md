# Dart bindings for Assimp

[![pub](https://img.shields.io/pub/v/dart_assimp.svg)](https://pub.dev/packages/dart_assimp)
[![license: BSD](https://img.shields.io/badge/license-BSD-yellow.svg)](https://opensource.org/licenses/BSD-3-Clause)
![build](https://github.com/jpnurmi/dart_assimp/workflows/Build/badge.svg)
[![codecov](https://codecov.io/gh/jpnurmi/dart_assimp/branch/master/graph/badge.svg)](https://codecov.io/gh/jpnurmi/dart_assimp)

This library provides [FFI](https://dart.dev/guides/libraries/c-interop) bindings to
[Open Asset Import Library](http://assimp.org/) aka. Assimp, which is a portable library to import
and export various well-known [3D model formats](https://github.com/assimp/assimp/blob/master/Readme.md#supported-file-formats)
in a uniform manner.

## Usage

```dart
import 'package:assimp/assimp.dart';

final scene = Scene.fromFile('path/to/3d-model.obj');
for (final mesh in scene.meshes) {
  // ...
}
```

To use this package, add `assimp` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Status

This package is currently in **alpha stage** and supports **read-only imports with Assimp 5.x**,
and has so far been developed and tested on **64-bit desktop platforms** only. The documentation
is still more or less direct copy-paste from the original library, and is therefore full of broken
references.

Notice also that [dart:ffi](https://dart.dev/guides/libraries/c-interop) is still in
[beta](https://github.com/dart-lang/sdk/issues/34452), and many fundamentally important features
are still in research and development:
- [Nested structs](https://github.com/dart-lang/sdk/issues/37271)
- [Inline arrays in Structs](https://github.com/dart-lang/sdk/issues/35763)
- [GC finalizers](https://github.com/dart-lang/sdk/issues/35770)
- [generate Dart bindings from C headers](https://github.com/dart-lang/sdk/issues/35843)
- ...
