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

/// Enumerates the methods of mesh morphing supported by Assimp.
class MorphingMethod {
  /// Interpolation between morph targets
  static const int vertexBlend = 0x1;

  /// Normalized morphing between morph targets
  static const int morphNormalized = 0x2;

  /// Relative morphing between morph targets
  static const int morphRelative = 0x3;
}

/// An AnimMesh is an attachment to an #aiMesh stores per-vertex
/// animations for a particular frame.
///
/// You may think of an #aiAnimMesh as a `patch` for the host mesh, which
/// replaces only certain vertex data streams at a particular time.
/// Each mesh stores n attached attached meshes (#aiMesh::mAnimMeshes).
/// The actual relationship between the time line and anim meshes is
/// established by #aiMeshAnim, which references singular mesh attachments
/// by their ID and binds them to a time offset.
class AnimMesh extends AssimpType<aiAnimMesh> {
  aiAnimMesh get _animMesh => ptr.ref;

  AnimMesh._(Pointer<aiAnimMesh> ptr) : super(ptr);
  factory AnimMesh.fromNative(Pointer<aiAnimMesh> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return AnimMesh._(ptr);
  }

  /// Anim Mesh name
  String get name => AssimpString.fromNative(_animMesh.mName);

  /// Replacement for aiMesh::mVertices. If this array is non-NULL,
  /// it *must* contain mNumVertices entries. The corresponding
  /// array in the host mesh must be non-NULL as well - animation
  /// meshes may neither add or nor remove vertex components (if
  /// a replacement array is NULL and the corresponding source
  /// array is not, the source data is taken instead)
  Iterable<Vector3> get vertices {
    return Iterable.generate(
      _animMesh.mNumVertices,
      (i) => AssimpVector3.fromNative(_animMesh.mVertices.elementAt(i)),
    );
  }

  /// Replacement for aiMesh::mNormals.
  Iterable<Vector3> get normals {
    return Iterable.generate(
      _animMesh.mNumVertices,
      (i) => AssimpVector3.fromNative(_animMesh.mNormals.elementAt(i)),
    );
  }

  /// Replacement for aiMesh::mTangents.
  Iterable<Vector3> get tangents {
    return Iterable.generate(
      _animMesh.mNumVertices,
      (i) => AssimpVector3.fromNative(_animMesh.mTangents.elementAt(i)),
    );
  }

  /// Replacement for aiMesh::mBitangents.
  Iterable<Vector3> get bitangents {
    return Iterable.generate(
      _animMesh.mNumVertices,
      (i) => AssimpVector3.fromNative(_animMesh.mBitangents.elementAt(i)),
    );
  }

  /// Replacement for aiMesh::mColors.
  Iterable<Iterable<Vector4>> get colors {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_COLOR_SETS &&
        AssimpPointer.isNotNull(_animMesh.mColors?.elementAt(n))) {
      ++n;
    }
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _animMesh.mNumVertices,
        (j) => AssimpColor4.fromNative(_animMesh.mColors[i].elementAt(j)),
      ),
    );
  }

  /// Replacement for aiMesh::mTextureCoords.
  Iterable<Iterable<Vector3>> get textureCoords {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_TEXTURECOORDS &&
        AssimpPointer.isNotNull(_animMesh.mTextureCoords?.elementAt(n))) {
      ++n;
    }
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _animMesh.mNumVertices,
        (j) =>
            AssimpVector3.fromNative(_animMesh.mTextureCoords[i].elementAt(j)),
      ),
    );
  }

  /// Weight of the AnimMesh.
  double get weight => _animMesh.mWeight;
}
