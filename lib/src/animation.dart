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

import 'bindings.dart' as b;
import 'extensions.dart';

enum AnimBehavior { defaults, constant, linear, repeat }

class VectorKey {
  Pointer<b.aiVectorKey> _ptr;

  VectorKey._(this._ptr);
  factory VectorKey.fromNative(Pointer<b.aiVectorKey> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return VectorKey._(ptr);
  }

  double get time => _ptr.ref.mTime;
  Vector3 get value => AssimpVector3.fromNative(_ptr.ref.mValue);
}

class QuaternionKey {
  Pointer<b.aiQuatKey> _ptr;

  QuaternionKey._(this._ptr);
  factory QuaternionKey.fromNative(Pointer<b.aiQuatKey> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return QuaternionKey._(ptr);
  }

  double get time => _ptr.ref.mTime;
  Quaternion get value => AssimpQuaternion.fromNative(_ptr.ref.mValue);
}

class MeshKey {
  Pointer<b.aiMeshKey> _ptr;

  MeshKey._(this._ptr);
  factory MeshKey.fromNative(Pointer<b.aiMeshKey> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MeshKey._(ptr);
  }

  double get time => _ptr.ref.mTime;
  int get value => _ptr.ref.mValue;
}

class MeshMorphKey {
  Pointer<b.aiMeshMorphKey> _ptr;

  MeshMorphKey._(this._ptr);
  factory MeshMorphKey.fromNative(Pointer<b.aiMeshMorphKey> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MeshMorphKey._(ptr);
  }

  double get time => _ptr.ref.mTime;
  Iterable<int> get values =>
      _ptr.ref.mValues.asTypedList(_ptr.ref.mNumValuesAndWeights);
  Iterable<double> get weights =>
      _ptr.ref.mWeights.asTypedList(_ptr.ref.mNumValuesAndWeights);
}

class NodeAnim {
  Pointer<b.aiNodeAnim> _ptr;

  NodeAnim._(this._ptr);
  factory NodeAnim.fromNative(Pointer<b.aiNodeAnim> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return NodeAnim._(ptr);
  }

  String get name => AssimpString.fromNative(_ptr.ref.mNodeName);

  Iterable<VectorKey> get positionKeys {
    return Iterable.generate(
      _ptr.ref.mNumPositionKeys,
      (i) => VectorKey.fromNative(_ptr.ref.mPositionKeys.elementAt(i)),
    );
  }

  Iterable<QuaternionKey> get rotationKeys {
    return Iterable.generate(
      _ptr.ref.mNumRotationKeys,
      (i) => QuaternionKey.fromNative(_ptr.ref.mRotationKeys.elementAt(i)),
    );
  }

  Iterable<VectorKey> get scalingKeys {
    return Iterable.generate(
      _ptr.ref.mNumScalingKeys,
      (i) => VectorKey.fromNative(_ptr.ref.mScalingKeys.elementAt(i)),
    );
  }

  AnimBehavior get preState => AnimBehavior.values[_ptr.ref.mPreState];
  AnimBehavior get postState => AnimBehavior.values[_ptr.ref.mPostState];
}

class MeshAnim {
  Pointer<b.aiMeshAnim> _ptr;

  MeshAnim._(this._ptr);
  factory MeshAnim.fromNative(Pointer<b.aiMeshAnim> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MeshAnim._(ptr);
  }

  String get name => AssimpString.fromNative(_ptr.ref.mName);

  Iterable<MeshKey> get keys {
    return Iterable.generate(
      _ptr.ref.mNumKeys,
      (i) => MeshKey.fromNative(_ptr.ref.mKeys.elementAt(i)),
    );
  }
}

class MeshMorphAnim {
  Pointer<b.aiMeshMorphAnim> _ptr;

  MeshMorphAnim._(this._ptr);
  factory MeshMorphAnim.fromNative(Pointer<b.aiMeshMorphAnim> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MeshMorphAnim._(ptr);
  }

  String get name => AssimpString.fromNative(_ptr.ref.mName);

  Iterable<MeshMorphKey> get keys {
    return Iterable.generate(
      _ptr.ref.mNumKeys,
      (i) => MeshMorphKey.fromNative(_ptr.ref.mKeys.elementAt(i)),
    );
  }
}

class Animation {
  Pointer<b.aiAnimation> _ptr;

  Animation._(this._ptr);
  factory Animation.fromNative(Pointer<b.aiAnimation> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Animation._(ptr);
  }

  String get name => AssimpString.fromNative(_ptr.ref.mName);
  double get duration => _ptr.ref.mDuration;
  double get ticksPerSecond => _ptr.ref.mTicksPerSecond;

  Iterable<NodeAnim> get channels {
    return Iterable.generate(
      _ptr.ref.mNumChannels,
      (i) => NodeAnim.fromNative(_ptr.ref.mChannels[i]),
    );
  }

  Iterable<MeshAnim> get meshChannels {
    return Iterable.generate(
      _ptr.ref.mNumMeshChannels,
      (i) => MeshAnim.fromNative(_ptr.ref.mMeshChannels[i]),
    );
  }

  Iterable<MeshMorphAnim> get meshMorphChannels {
    return Iterable.generate(
      _ptr.ref.mNumMorphMeshChannels,
      (i) => MeshMorphAnim.fromNative(_ptr.ref.mMorphMeshChannels[i]),
    );
  }
}
