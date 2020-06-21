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

import 'bindings.dart';
import 'extensions.dart';

class Face {
  Pointer<aiFace> _ptr;

  Face._(this._ptr) : assert(AssimpPointer.isNotNull(_ptr));
  factory Face.fromNative(Pointer<aiFace> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Face._(ptr);
  }

  Iterable<int> get indices {
    return Iterable.generate(
      _ptr.ref.mNumIndices,
      (i) => _ptr.ref.mIndices[i],
    );
  }
}

class VertexWeight {
  Pointer<aiVertexWeight> _ptr;

  VertexWeight._(this._ptr) : assert(AssimpPointer.isNotNull(_ptr));
  factory VertexWeight.fromNative(Pointer<aiVertexWeight> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return VertexWeight._(ptr);
  }

  int get vertexId => _ptr.ref.mVertexId;

  double get weight => _ptr.ref.mWeight;
}

class Bone {
  Pointer<aiBone> _ptr;

  Bone._(this._ptr) : assert(AssimpPointer.isNotNull(_ptr));
  factory Bone.fromNative(Pointer<aiBone> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Bone._(ptr);
  }

  String get name => AssimpString.fromNative(_ptr.ref.mName);

  Iterable<VertexWeight> get weights {
    return Iterable.generate(
      _ptr.ref.mNumWeights,
      (i) => VertexWeight.fromNative(_ptr.ref.mWeights.elementAt(i)),
    );
  }

  Matrix4 get offset => AssimpMatrix4.fromNative(_ptr.ref.mOffset);
}

class AnimMesh {
  Pointer<aiAnimMesh> _ptr;

  AnimMesh._(this._ptr) : assert(AssimpPointer.isNotNull(_ptr));
  factory AnimMesh.fromNative(Pointer<aiAnimMesh> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return AnimMesh._(ptr);
  }

  String get name => AssimpString.fromNative(_ptr.ref.mName);

  Iterable<Vector3> get vertices {
    return Iterable.generate(
      _ptr.ref.mNumVertices,
      (i) => AssimpVector3.fromNative(_ptr.ref.mVertices.elementAt(i)),
    );
  }

  Iterable<Vector3> get normals {
    return Iterable.generate(
      _ptr.ref.mNumVertices,
      (i) => AssimpVector3.fromNative(_ptr.ref.mNormals.elementAt(i)),
    );
  }

  Iterable<Vector3> get tangents {
    return Iterable.generate(
      _ptr.ref.mNumVertices,
      (i) => AssimpVector3.fromNative(_ptr.ref.mTangents.elementAt(i)),
    );
  }

  Iterable<Vector3> get bitangents {
    return Iterable.generate(
      _ptr.ref.mNumVertices,
      (i) => AssimpVector3.fromNative(_ptr.ref.mBitangents.elementAt(i)),
    );
  }

  Iterable<Iterable<Color>> get colors {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_COLOR_SETS &&
        AssimpPointer.isNotNull(_ptr.ref.mColors?.elementAt(n))) ++n;
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _ptr.ref.mNumVertices,
        (j) => AssimpColor4.fromNative(_ptr.ref.mColors[i].elementAt(j)),
      ),
    );
  }

  Iterable<Iterable<Vector3>> get textureCoords {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_TEXTURECOORDS &&
        AssimpPointer.isNotNull(_ptr.ref.mTextureCoords?.elementAt(n))) ++n;
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _ptr.ref.mNumVertices,
        (j) =>
            AssimpVector3.fromNative(_ptr.ref.mTextureCoords[i].elementAt(j)),
      ),
    );
  }

  double get weight => _ptr.ref.mWeight;
}

class MorphingMethod {
  static const int vertexBlend = 0x1;
  static const int morphNormalized = 0x2;
  static const int morphRelative = 0x3;
}

class PrimitiveType {
  static const int Point = 0x1;
  static const int Line = 0x2;
  static const int Triangle = 0x4;
  static const int Polygon = 0x8;
}

class Mesh {
  Pointer<aiMesh> _ptr;

  Mesh._(this._ptr) : assert(AssimpPointer.isNotNull(_ptr));
  factory Mesh.fromNative(Pointer<aiMesh> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Mesh._(ptr);
  }

  int get primitiveTypes => _ptr.ref.mPrimitiveTypes;

  Iterable<Vector3> get vertices {
    return Iterable.generate(
      _ptr.ref.mNumVertices,
      (i) => AssimpVector3.fromNative(_ptr.ref.mVertices.elementAt(i)),
    );
  }

  Iterable<Vector3> get normals {
    return Iterable.generate(
      _ptr.ref.mNumVertices,
      (i) => AssimpVector3.fromNative(_ptr.ref.mNormals.elementAt(i)),
    );
  }

  Iterable<Vector3> get tangents {
    return Iterable.generate(
      _ptr.ref.mNumVertices,
      (i) => AssimpVector3.fromNative(_ptr.ref.mTangents.elementAt(i)),
    );
  }

  Iterable<Vector3> get bitangents {
    return Iterable.generate(
      _ptr.ref.mNumVertices,
      (i) => AssimpVector3.fromNative(_ptr.ref.mBitangents.elementAt(i)),
    );
  }

  Iterable<Iterable<Color>> get colors {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_COLOR_SETS &&
        _ptr.ref.mColors != null &&
        AssimpPointer.isNotNull(_ptr.ref.mColors[n])) ++n;
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _ptr.ref.mNumVertices,
        (j) => AssimpColor4.fromNative(_ptr.ref.mColors[i].elementAt(j)),
      ),
    );
  }

  Iterable<Iterable<Vector3>> get textureCoords {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_TEXTURECOORDS &&
        _ptr.ref.mTextureCoords != null &&
        AssimpPointer.isNotNull(_ptr.ref.mTextureCoords[n])) ++n;
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _ptr.ref.mNumVertices,
        (j) =>
            AssimpVector3.fromNative(_ptr.ref.mTextureCoords[i].elementAt(j)),
      ),
    );
  }

  Iterable<int> get uvComponents {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_TEXTURECOORDS &&
        _ptr.ref.mNumUVComponents != null &&
        _ptr.ref.mNumUVComponents.elementAt(n).value > 0) ++n;
    return n > 0 ? _ptr.ref.mNumUVComponents.asTypedList(n) : [];
  }

  Iterable<Face> get faces {
    return Iterable.generate(
      _ptr.ref.mNumFaces,
      (i) => Face.fromNative(_ptr.ref.mFaces.elementAt(i)),
    );
  }

  Iterable<Bone> get bones {
    return Iterable.generate(
      _ptr.ref.mNumBones,
      (i) => Bone.fromNative(_ptr.ref.mBones[i]),
    );
  }

  int get materialIndex => _ptr.ref.mMaterialIndex;

  String get name => AssimpString.fromNative(_ptr.ref.mName);

  Iterable<AnimMesh> get animMeshes {
    return Iterable.generate(
      _ptr.ref.mNumAnimMeshes,
      (i) => AnimMesh.fromNative(_ptr.ref.mAnimMeshes[i]),
    );
  }

  int get morphingMethod => _ptr.ref.mMethod;

  Aabb3 get aabb => AssimpAabb3.fromNative(null); // _ptr.ref.mAABB);
}
