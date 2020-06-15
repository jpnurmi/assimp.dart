// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'bindings/cimport.dart' as bindings;

class Assimp {
  Assimp._();

  static void enableVerboseLogging(bool enable) =>
      bindings.aiEnableVerboseLogging(enable ? 1 : 0);

  static String errorString() => Utf8.fromUtf8(bindings.aiGetErrorString());
}
