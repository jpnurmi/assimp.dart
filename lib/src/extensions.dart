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

import 'package:ffi/ffi.dart';
import 'package:vector_math/vector_math.dart';
export 'package:vector_math/vector_math.dart'
    show Aabb3, Matrix3, Matrix4, Quaternion, Vector2, Vector3, Vector4;

import 'bindings.dart';

extension AssimpAabb3 on Aabb3 {
  static Aabb3 fromNative(aiAABB a) {
    return Aabb3.minMax(
      AssimpVector3.fromNative(a.mMin),
      AssimpVector3.fromNative(a.mMax),
    );
  }

//  static Pointer<bindings.aiAABB> toNative(Aabb3 aabb) {
//    final Pointer<bindings.aiAABB> ptr = allocate();
//    ptr.ref.mMin = AssimpVector3.toNative(aabb.min);
//    ptr.ref.mMax = AssimpVector3.toNative(aabb.max);
//    return ptr;
//  }
}

extension AssimpColor3 on Vector3 {
  static Vector3 fromNative(aiColor3D m) {
    return Vector3(m.r, m.g, m.b);
  }

//  static Pointer<aiColor3D> toNative(Color color) {
//    final Pointer<aiColor3D> ptr = allocate();
//    ptr.ref.r = color.red / 255.0;
//    ptr.ref.g = color.green / 255.0;
//    ptr.ref.b = color.blue / 255.0;
//    return ptr;
//  }
}

extension AssimpColor4 on Vector4 {
  static Vector4 fromNative(aiColor4D c) {
    return Vector4(c.a, c.r, c.g, c.b);
  }

//  static Pointer<aiColor4D> toNative(Color color) {
//    final Pointer<aiColor4D> ptr = allocate();
//    ptr.ref.a = color.alpha / 255.0;
//    ptr.ref.r = color.red / 255.0;
//    ptr.ref.g = color.green / 255.0;
//    ptr.ref.b = color.blue / 255.0;
//    return ptr;
//  }
}

extension AssimpMatrix3 on Matrix3 {
  static Matrix3 fromNative(aiMatrix3x3 m) {
    return Matrix3(m.a1, m.a2, m.a3, m.b1, m.b2, m.b3, m.c1, m.c2, m.c3);
  }

//  static Pointer<aiMatrix3x3> toNative(Matrix3 matrix) {
//    final Pointer<aiMatrix3x3> ptr = allocate();
//    ptr.ref.a1 = matrix.row0.x;
//    ptr.ref.a2 = matrix.row0.y;
//    ptr.ref.a3 = matrix.row0.z;
//    ptr.ref.b1 = matrix.row1.x;
//    ptr.ref.b2 = matrix.row1.y;
//    ptr.ref.b3 = matrix.row1.z;
//    ptr.ref.c1 = matrix.row2.x;
//    ptr.ref.c2 = matrix.row2.y;
//    ptr.ref.c3 = matrix.row2.z;
//    return ptr;
//  }
}

extension AssimpMatrix4 on aiMatrix4x4 {
  static Matrix4 fromNative(aiMatrix4x4 m) {
    return Matrix4(
      m.a1,
      m.a2,
      m.a3,
      m.a4,
      m.b1,
      m.b2,
      m.b3,
      m.b4,
      m.c1,
      m.c2,
      m.c3,
      m.c4,
      m.d1,
      m.d2,
      m.d3,
      m.d4,
    );
  }

  void toNative(Matrix4 matrix) {
    a1 = matrix.row0.x;
    a2 = matrix.row0.y;
    a3 = matrix.row0.z;
    a4 = matrix.row0.w;
    b1 = matrix.row1.x;
    b2 = matrix.row1.y;
    b3 = matrix.row1.z;
    b4 = matrix.row1.w;
    c1 = matrix.row2.x;
    c2 = matrix.row2.y;
    c3 = matrix.row2.z;
    c4 = matrix.row2.w;
    d1 = matrix.row3.x;
    d2 = matrix.row3.y;
    d3 = matrix.row3.z;
    d4 = matrix.row3.w;
  }
}

extension DartMatrix4 on Matrix4 {
  Pointer<aiMatrix4x4> toNative() {
    final ptr = malloc<aiMatrix4x4>();
    ptr.ref.a1 = row0.x;
    ptr.ref.a2 = row0.y;
    ptr.ref.a3 = row0.z;
    ptr.ref.a4 = row0.w;
    ptr.ref.b1 = row1.x;
    ptr.ref.b2 = row1.y;
    ptr.ref.b3 = row1.z;
    ptr.ref.b4 = row1.w;
    ptr.ref.c1 = row2.x;
    ptr.ref.c2 = row2.y;
    ptr.ref.c3 = row2.z;
    ptr.ref.c4 = row2.w;
    ptr.ref.d1 = row3.x;
    ptr.ref.d2 = row3.y;
    ptr.ref.d3 = row3.z;
    ptr.ref.d4 = row3.w;
    return ptr;
  }
}

extension AssimpPointer on Pointer {
  static bool isNull(Pointer ptr) => ptr == nullptr;
  static bool isNotNull(Pointer ptr) => ptr != nullptr;
}

extension AssimpQuaternion on Quaternion {
  static Quaternion fromNative(aiQuaternion q) {
    return Quaternion(q.x, q.y, q.z, q.z);
  }

//  static Pointer<aiQuaternion> toNative(Quaternion quaternion) {
//    final Pointer<aiQuaternion> ptr = allocate();
//    ptr.ref.x = quaternion.x;
//    ptr.ref.y = quaternion.y;
//    ptr.ref.z = quaternion.z;
//    ptr.ref.w = quaternion.w;
//    return ptr;
//  }
}

extension AssimpSize on Vector2 {
  double get width => x;
  double get height => y;
}

extension AssimpArrayString on String {
  Pointer<Int8> toNativeString() {
    return toNativeUtf8().cast<Int8>();
  }
}

extension AssimpStringArray on Pointer<Int8> {
  String toDartString({int? length}) {
    return cast<Utf8>().toDartString(length: length);
  }
}

extension AssimpString on String {
  static String fromNative(aiString ai) {
    return utf8.decode(List<int>.generate(ai.length, (i) => ai.data[i]));
  }

  Pointer<aiString> toNative() {
    final ptr = calloc<aiString>();
    final units = utf8.encode(this);
    ptr.ref.length = units.length;
    for (var i = 0; i < units.length; ++i) {
      ptr.ref.data[i] = units[i];
    }
    ptr.ref.data[units.length] = 0;
    return ptr;
  }

//  static String fromUtf8(Pointer<Utf8> ptr, int len) {
//    if (AssimpPointer.isNull(ptr)) return null;
//    if (len <= 0) return '';
//    final str =
//        Uint8List.view(ptr.cast<Uint8>().asTypedList(len).buffer, 0, len);
//    return utf8.decode(str);
//  }
}

extension AssimpVector2 on Vector2 {
  static Vector2 fromNative(aiVector2D v) {
    return Vector2(v.x, v.y);
  }

//  static Pointer<aiVector2D> toNative(Vector2 vec) {
//    final Pointer<aiVector2D> ptr = allocate();
//    ptr.ref.x = vec.x;
//    ptr.ref.y = vec.y;
//    return ptr;
//  }
}

extension AssimpVector3 on Vector3 {
  static Vector3 fromNative(aiVector3D v) {
    return Vector3(v.x, v.y, v.z);
  }

//  static Pointer<aiVector3D> toNative(Vector3 vec) {
//    final Pointer<aiVector3D> ptr = allocate();
//    ptr.ref.x = vec.x;
//    ptr.ref.y = vec.y;
//    ptr.ref.z = vec.z;
//    return ptr;
//  }
}
