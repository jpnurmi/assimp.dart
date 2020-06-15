// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'bindings/quaternion.dart' as bindings;

class Quaternion {
  Pointer<bindings.aiQuaternion> _ptr;

  Quaternion.fromNative(this._ptr);

  double get w => _ptr.ref.w;
  double get x => _ptr.ref.x;
  double get y => _ptr.ref.y;
  double get z => _ptr.ref.z;
}
