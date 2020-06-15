// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'bindings/texture.dart' as bindings;

class Texture {
  Pointer<bindings.aiTexture> _ptr;

  Texture.fromNative(this._ptr);
}
