// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'bindings/color4.dart' as bindings;

class Color4D {
  Pointer<bindings.aiColor4D> _ptr;

  Color4D.fromNative(this._ptr);

  double get r => _ptr.ref.r;
  double get g => _ptr.ref.g;
  double get b => _ptr.ref.b;
  double get a => _ptr.ref.a;
}
