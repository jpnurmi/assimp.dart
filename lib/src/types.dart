/*
---------------------------------------------------------------------------
Open Asset Import Library (assimp)
---------------------------------------------------------------------------

Copyright (c) 2006-2019, assimp team



All rights reserved.

Redistribution and use of this software in source and binary forms,
with or without modification, are permitted provided that the following
conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the
  following disclaimer.

* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the
  following disclaimer in the documentation and/or other
  materials provided with the distribution.

* Neither the name of the assimp team, nor the names of its
  contributors may be used to endorse or promote products
  derived from this software without specific prior
  written permission of the assimp team.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------
*/

import 'dart:ffi';
import 'dart:ui';
export 'dart:ui' show Color;
import 'package:ffi/ffi.dart';
import 'package:vector_math/vector_math.dart';
export 'package:vector_math/vector_math.dart' show Plane, Ray;

import 'vector3.dart';
import 'bindings/types.dart' as bindings;

extension AssimpPlane on Plane {
  static Plane fromNative(Pointer<bindings.aiPlane> ptr) {
    return Plane.components(ptr.ref.a, ptr.ref.b, ptr.ref.c, ptr.ref.d);
  }

  static Pointer<bindings.aiPlane> toNative(Plane plane) {
    final Pointer<bindings.aiPlane> ptr = allocate();
    ptr.ref.a = plane.normal.x;
    ptr.ref.b = plane.normal.y;
    ptr.ref.c = plane.normal.z;
    ptr.ref.d = plane.constant;
    return ptr;
  }
}

extension AssimpRay on Ray {
  static Ray fromNative(Pointer<bindings.aiRay> ptr) {
    final pos = AssimpVector3.fromNative(ptr.ref.pos);
    final dir = AssimpVector3.fromNative(ptr.ref.dir);
    return Ray.originDirection(pos, dir);
  }

  static Pointer<bindings.aiRay> toNative(Ray ray) {
    final Pointer<bindings.aiRay> ptr = allocate();
    ptr.ref.pos = AssimpVector3.toNative(ray.origin);
    ptr.ref.dir = AssimpVector3.toNative(ray.direction);
    return ptr;
  }
}

extension AssimpColor3 on Color {
  static Color fromNative(Pointer<bindings.aiColor3D> ptr) {
    return Color.fromARGB(
      255,
      (ptr.ref.r * 255).round(),
      (ptr.ref.g * 255).round(),
      (ptr.ref.b * 255).round(),
    );
  }

  static Pointer<bindings.aiColor3D> toNative(Color color) {
    final Pointer<bindings.aiColor3D> ptr = allocate();
    ptr.ref.r = color.red / 255.0;
    ptr.ref.g = color.green / 255.0;
    ptr.ref.b = color.blue / 255.0;
    return ptr;
  }
}

class MemoryInfo {
  Pointer<bindings.aiMemoryInfo> _ptr;

  MemoryInfo._();
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
