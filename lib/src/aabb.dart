// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'bindings/aabb.dart' as bindings;
import 'vector3.dart';

class AABB {
  Pointer<bindings.aiAABB> _ptr;

  AABB.fromNative(this._ptr);

  Vector3D get min => Vector3D.fromNative(_ptr.ref.mMin);
  Vector3D get max => Vector3D.fromNative(_ptr.ref.mMax);
}
