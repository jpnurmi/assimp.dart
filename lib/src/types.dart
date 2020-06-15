// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'bindings/types.dart' as bindings;
import 'vector3.dart';

class Plane {
  Pointer<bindings.aiPlane> _ptr;

  Plane.fromNative(this._ptr);

  double get a => _ptr.ref.a;
  double get b => _ptr.ref.b;
  double get c => _ptr.ref.c;
  double get d => _ptr.ref.d;
}

class Ray {
  Pointer<bindings.aiRay> _ptr;

  Ray.fromNative(this._ptr);

  Vector3D get pos => Vector3D.fromNative(_ptr.ref.pos);
  Vector3D get dir => Vector3D.fromNative(_ptr.ref.dir);
}

class Color3D {
  Pointer<bindings.aiColor3D> _ptr;

  Color3D.fromNative(this._ptr);

  double get r => _ptr.ref.r;
  double get g => _ptr.ref.g;
  double get b => _ptr.ref.b;
}

class MemoryInfo {
  Pointer<bindings.aiMemoryInfo> _ptr;

  MemoryInfo.fromNative(this._ptr);

  int get textures => _ptr.ref.textures;
  int get materials => _ptr.ref.materials;
  int get meshes => _ptr.ref.meshes;
  int get nodes => _ptr.ref.nodes;
  int get animations => _ptr.ref.animations;
  int get cameras => _ptr.ref.cameras;
  int get lights => _ptr.ref.lights;
  int get total => _ptr.ref.total;
}
