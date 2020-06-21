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
import 'type.dart';

class Face extends AssimpType<aiFace> {
  aiFace get _face => ptr.ref;

  Face._(Pointer<aiFace> ptr) : super(ptr);
  factory Face.fromNative(Pointer<aiFace> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Face._(ptr);
  }

  Iterable<int> get indices => _face.mIndices.asTypedList(_face.mNumIndices);
}

class VertexWeight extends AssimpType<aiVertexWeight> {
  aiVertexWeight get _vertexWeight => ptr.ref;

  VertexWeight._(Pointer<aiVertexWeight> ptr) : super(ptr);
  factory VertexWeight.fromNative(Pointer<aiVertexWeight> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return VertexWeight._(ptr);
  }

  int get vertexId => _vertexWeight.mVertexId;

  double get weight => _vertexWeight.mWeight;
}

class Bone extends AssimpType<aiBone> {
  aiBone get _bone => ptr.ref;

  Bone._(Pointer<aiBone> ptr) : super(ptr);
  factory Bone.fromNative(Pointer<aiBone> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Bone._(ptr);
  }

  String get name => AssimpString.fromNative(_bone.mName);

  Iterable<VertexWeight> get weights {
    return Iterable.generate(
      _bone.mNumWeights,
      (i) => VertexWeight.fromNative(_bone.mWeights.elementAt(i)),
    );
  }

  Matrix4 get offset => AssimpMatrix4.fromNative(_bone.mOffset);
}

class AnimMesh extends AssimpType<aiAnimMesh> {
  aiAnimMesh get _animMesh => ptr.ref;

  AnimMesh._(Pointer<aiAnimMesh> ptr) : super(ptr);
  factory AnimMesh.fromNative(Pointer<aiAnimMesh> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return AnimMesh._(ptr);
  }

  String get name => AssimpString.fromNative(_animMesh.mName);

  Iterable<Vector3> get vertices {
    return Iterable.generate(
      _animMesh.mNumVertices,
      (i) => AssimpVector3.fromNative(_animMesh.mVertices.elementAt(i)),
    );
  }

  Iterable<Vector3> get normals {
    return Iterable.generate(
      _animMesh.mNumVertices,
      (i) => AssimpVector3.fromNative(_animMesh.mNormals.elementAt(i)),
    );
  }

  Iterable<Vector3> get tangents {
    return Iterable.generate(
      _animMesh.mNumVertices,
      (i) => AssimpVector3.fromNative(_animMesh.mTangents.elementAt(i)),
    );
  }

  Iterable<Vector3> get bitangents {
    return Iterable.generate(
      _animMesh.mNumVertices,
      (i) => AssimpVector3.fromNative(_animMesh.mBitangents.elementAt(i)),
    );
  }

  Iterable<Iterable<Color>> get colors {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_COLOR_SETS &&
        AssimpPointer.isNotNull(_animMesh.mColors?.elementAt(n))) ++n;
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _animMesh.mNumVertices,
        (j) => AssimpColor4.fromNative(_animMesh.mColors[i].elementAt(j)),
      ),
    );
  }

  Iterable<Iterable<Vector3>> get textureCoords {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_TEXTURECOORDS &&
        AssimpPointer.isNotNull(_animMesh.mTextureCoords?.elementAt(n))) ++n;
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _animMesh.mNumVertices,
        (j) =>
            AssimpVector3.fromNative(_animMesh.mTextureCoords[i].elementAt(j)),
      ),
    );
  }

  double get weight => _animMesh.mWeight;
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

class Mesh extends AssimpType<aiMesh> {
  aiMesh get _mesh => ptr.ref;

  Mesh._(Pointer<aiMesh> ptr) : super(ptr);
  factory Mesh.fromNative(Pointer<aiMesh> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Mesh._(ptr);
  }

  int get primitiveTypes => _mesh.mPrimitiveTypes;

  Iterable<Vector3> get vertices {
    return Iterable.generate(
      _mesh.mNumVertices,
      (i) => AssimpVector3.fromNative(_mesh.mVertices.elementAt(i)),
    );
  }

  Iterable<Vector3> get normals {
    return Iterable.generate(
      AssimpPointer.isNotNull(_mesh.mNormals) ? _mesh.mNumVertices : 0,
      (i) => AssimpVector3.fromNative(_mesh.mNormals.elementAt(i)),
    );
  }

  Iterable<Vector3> get tangents {
    return Iterable.generate(
      AssimpPointer.isNotNull(_mesh.mTangents) ? _mesh.mNumVertices : 0,
      (i) => AssimpVector3.fromNative(_mesh.mTangents.elementAt(i)),
    );
  }

  Iterable<Vector3> get bitangents {
    return Iterable.generate(
      AssimpPointer.isNotNull(_mesh.mBitangents) ? _mesh.mNumVertices : 0,
      (i) => AssimpVector3.fromNative(_mesh.mBitangents.elementAt(i)),
    );
  }

  Iterable<Iterable<Color>> get colors {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_COLOR_SETS &&
        _mesh.mColors != null &&
        AssimpPointer.isNotNull(_mesh.mColors[n])) ++n;
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _mesh.mNumVertices,
        (j) => AssimpColor4.fromNative(_mesh.mColors[i].elementAt(j)),
      ),
    );
  }

  Iterable<Iterable<Vector3>> get textureCoords {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_TEXTURECOORDS &&
        _mesh.mTextureCoords != null &&
        AssimpPointer.isNotNull(_mesh.mTextureCoords[n])) ++n;
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _mesh.mNumVertices,
        (j) => AssimpVector3.fromNative(_mesh.mTextureCoords[i].elementAt(j)),
      ),
    );
  }

  Iterable<int> get uvComponents {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_TEXTURECOORDS &&
        _mesh.mNumUVComponents != null &&
        _mesh.mNumUVComponents.elementAt(n).value > 0) ++n;
    return n > 0 ? _mesh.mNumUVComponents.asTypedList(n) : [];
  }

  Iterable<Face> get faces {
    return Iterable.generate(
      _mesh.mNumFaces,
      (i) => Face.fromNative(_mesh.mFaces.elementAt(i)),
    );
  }

  Iterable<Bone> get bones {
    return Iterable.generate(
      _mesh.mNumBones,
      (i) => Bone.fromNative(_mesh.mBones[i]),
    );
  }

  int get materialIndex => _mesh.mMaterialIndex;

  String get name => AssimpString.fromNative(_mesh.mName);

  Iterable<AnimMesh> get animMeshes {
    return Iterable.generate(
      _mesh.mNumAnimMeshes,
      (i) => AnimMesh.fromNative(_mesh.mAnimMeshes[i]),
    );
  }

  int get morphingMethod => _mesh.mMethod;

  Aabb3 get aabb => AssimpAabb3.fromNative(_mesh.mAABB);
}
