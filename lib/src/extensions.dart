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

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';
export 'dart:ui' show Color;

import 'package:ffi/ffi.dart';
import 'package:vector_math/vector_math.dart';
export 'package:vector_math/vector_math.dart'
    show Aabb3, Matrix3, Matrix4, Plane, Quaternion, Ray, Vector2, Vector3;

import 'bindings.dart' as b;

extension AssimpAabb3 on Aabb3 {
  static Aabb3 fromNative(Pointer<b.aiAABB> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Aabb3.minMax(
      AssimpVector3.fromNative(ptr.ref.mMin),
      AssimpVector3.fromNative(ptr.ref.mMax),
    );
  }

//  static Pointer<bindings.aiAABB> toNative(Aabb3 aabb) {
//    final Pointer<bindings.aiAABB> ptr = allocate();
//    ptr.ref.mMin = AssimpVector3.toNative(aabb.min);
//    ptr.ref.mMax = AssimpVector3.toNative(aabb.max);
//    return ptr;
//  }
}

extension AssimpColor3 on Color {
  static Color fromNative(Pointer<b.aiColor3D> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Color.fromARGB(
      255,
      (ptr.ref.r * 255).round(),
      (ptr.ref.g * 255).round(),
      (ptr.ref.b * 255).round(),
    );
  }

  static Pointer<b.aiColor3D> toNative(Color color) {
    final Pointer<b.aiColor3D> ptr = allocate();
    ptr.ref.r = color.red / 255.0;
    ptr.ref.g = color.green / 255.0;
    ptr.ref.b = color.blue / 255.0;
    return ptr;
  }
}

extension AssimpColor4 on Color {
  static Color fromNative(Pointer<b.aiColor4D> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Color.fromARGB(
      (ptr.ref.a * 255).round(),
      (ptr.ref.r * 255).round(),
      (ptr.ref.g * 255).round(),
      (ptr.ref.b * 255).round(),
    );
  }

  static Pointer<b.aiColor4D> toNative(Color color) {
    final Pointer<b.aiColor4D> ptr = allocate();
    ptr.ref.a = color.alpha / 255.0;
    ptr.ref.r = color.red / 255.0;
    ptr.ref.g = color.green / 255.0;
    ptr.ref.b = color.blue / 255.0;
    return ptr;
  }
}

extension AssimpMatrix3 on Matrix3 {
  static Matrix3 fromNative(Pointer<b.aiMatrix3x3> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Matrix3(
      ptr.ref.a1,
      ptr.ref.a2,
      ptr.ref.a3,
      ptr.ref.b1,
      ptr.ref.b2,
      ptr.ref.b3,
      ptr.ref.c1,
      ptr.ref.c2,
      ptr.ref.c3,
    );
  }

  static Pointer<b.aiMatrix3x3> toNative(Matrix3 matrix) {
    final Pointer<b.aiMatrix3x3> ptr = allocate();
    ptr.ref.a1 = matrix.row0.x;
    ptr.ref.a2 = matrix.row0.y;
    ptr.ref.a3 = matrix.row0.z;
    ptr.ref.b1 = matrix.row1.x;
    ptr.ref.b2 = matrix.row1.y;
    ptr.ref.b3 = matrix.row1.z;
    ptr.ref.c1 = matrix.row2.x;
    ptr.ref.c2 = matrix.row2.y;
    ptr.ref.c3 = matrix.row2.z;
    return ptr;
  }
}

extension AssimpMatrix4 on Matrix4 {
  static Matrix4 fromNative(Pointer<b.aiMatrix4x4> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Matrix4(
      ptr.ref.a1,
      ptr.ref.a2,
      ptr.ref.a3,
      ptr.ref.a4,
      ptr.ref.b1,
      ptr.ref.b2,
      ptr.ref.b3,
      ptr.ref.b4,
      ptr.ref.c1,
      ptr.ref.c2,
      ptr.ref.c3,
      ptr.ref.c4,
      ptr.ref.d1,
      ptr.ref.d2,
      ptr.ref.d3,
      ptr.ref.d4,
    );
  }

  static Pointer<b.aiMatrix4x4> toNative(Matrix4 matrix) {
    final Pointer<b.aiMatrix4x4> ptr = allocate();
    ptr.ref.a1 = matrix.row0.x;
    ptr.ref.a2 = matrix.row0.y;
    ptr.ref.a3 = matrix.row0.z;
    ptr.ref.a4 = matrix.row0.w;
    ptr.ref.b1 = matrix.row1.x;
    ptr.ref.b2 = matrix.row1.y;
    ptr.ref.b3 = matrix.row1.z;
    ptr.ref.b4 = matrix.row1.w;
    ptr.ref.c1 = matrix.row2.x;
    ptr.ref.c2 = matrix.row2.y;
    ptr.ref.c3 = matrix.row2.z;
    ptr.ref.c4 = matrix.row2.w;
    ptr.ref.d1 = matrix.row3.x;
    ptr.ref.d2 = matrix.row3.y;
    ptr.ref.d3 = matrix.row3.z;
    ptr.ref.d4 = matrix.row3.w;
    return ptr;
  }
}

extension AssimpPlane on Plane {
  static Plane fromNative(Pointer<b.aiPlane> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Plane.components(ptr.ref.a, ptr.ref.b, ptr.ref.c, ptr.ref.d);
  }

  static Pointer<b.aiPlane> toNative(Plane plane) {
    final Pointer<b.aiPlane> ptr = allocate();
    ptr.ref.a = plane.normal.x;
    ptr.ref.b = plane.normal.y;
    ptr.ref.c = plane.normal.z;
    ptr.ref.d = plane.constant;
    return ptr;
  }
}

extension AssimpPointer on Pointer {
  static bool isNull(Pointer ptr) => ptr == null || ptr.address == 0;
  static bool isNotNull(Pointer ptr) => ptr != null && ptr.address != 0;
}

extension AssimpQuaternion on Quaternion {
  static Quaternion fromNative(Pointer<b.aiQuaternion> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Quaternion(ptr.ref.x, ptr.ref.y, ptr.ref.z, ptr.ref.z);
  }

  static Pointer<b.aiQuaternion> toNative(Quaternion quaternion) {
    final Pointer<b.aiQuaternion> ptr = allocate();
    ptr.ref.x = quaternion.x;
    ptr.ref.y = quaternion.y;
    ptr.ref.z = quaternion.z;
    ptr.ref.w = quaternion.w;
    return ptr;
  }
}

extension AssimpRay on Ray {
  static Ray fromNative(Pointer<b.aiRay> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    final pos = AssimpVector3.fromNative(ptr.ref.pos);
    final dir = AssimpVector3.fromNative(ptr.ref.dir);
    return Ray.originDirection(pos, dir);
  }

//  static Pointer<bindings.aiRay> toNative(Ray ray) {
//    final Pointer<bindings.aiRay> ptr = allocate();
//    ptr.ref.pos = AssimpVector3.toNative(ray.origin);
//    ptr.ref.dir = AssimpVector3.toNative(ray.direction);
//    return ptr;
//  }
}

extension AssimpString on String {
  static String fromNative(Pointer<b.aiString> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    final len = ptr.ref.length;
    if (len <= 0) return '';
    final str = Uint8List.view(
        ptr.ref.data.cast<Uint8>().asTypedList(len).buffer, 0, len);
    return utf8.decode(str);
  }
}

extension AssimpVector2 on Vector2 {
  static Vector2 fromNative(Pointer<b.aiVector2D> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Vector2(ptr.ref.x, ptr.ref.y);
  }

  static Pointer<b.aiVector2D> toNative(Vector2 vec) {
    final Pointer<b.aiVector2D> ptr = allocate();
    ptr.ref.x = vec.x;
    ptr.ref.y = vec.y;
    return ptr;
  }
}

extension AssimpVector3 on Vector3 {
  static Vector3 fromNative(Pointer<b.aiVector3D> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Vector3(ptr.ref.x, ptr.ref.y, ptr.ref.z);
  }

  static Pointer<b.aiVector3D> toNative(Vector3 vec) {
    final Pointer<b.aiVector3D> ptr = allocate();
    ptr.ref.x = vec.x;
    ptr.ref.y = vec.y;
    ptr.ref.z = vec.z;
    return ptr;
  }
}
