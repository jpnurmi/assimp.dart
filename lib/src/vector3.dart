// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'bindings/vector3.dart' as bindings;

class Vector3D {
  Pointer<bindings.aiVector3D> _ptr;

  Vector3D.fromNative(this._ptr);

  double get x => _ptr.ref.x;
  double get y => _ptr.ref.y;
  double get z => _ptr.ref.z;
}
