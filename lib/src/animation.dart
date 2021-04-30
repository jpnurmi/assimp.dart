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

enum AnimBehavior { defaults, constant, linear, repeat }

class VectorKey extends AssimpType<aiVectorKey> {
  aiVectorKey get _vectorKey => ptr.ref;

  VectorKey._(Pointer<aiVectorKey> ptr) : super(ptr);
  static VectorKey? fromNative(Pointer<aiVectorKey> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return VectorKey._(ptr);
  }

  double get time => _vectorKey.mTime;
  Vector3 get value => AssimpVector3.fromNative(_vectorKey.mValue);
}

class QuaternionKey extends AssimpType<aiQuatKey> {
  aiQuatKey get _quatKey => ptr.ref;

  QuaternionKey._(Pointer<aiQuatKey> ptr) : super(ptr);
  static QuaternionKey? fromNative(Pointer<aiQuatKey> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return QuaternionKey._(ptr);
  }

  double get time => _quatKey.mTime;
  Quaternion get value => AssimpQuaternion.fromNative(_quatKey.mValue);
}

class MeshKey extends AssimpType<aiMeshKey> {
  aiMeshKey get _meshKey => ptr.ref;

  MeshKey._(Pointer<aiMeshKey> ptr) : super(ptr);
  static MeshKey? fromNative(Pointer<aiMeshKey> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MeshKey._(ptr);
  }

  double get time => _meshKey.mTime;
  int get value => _meshKey.mValue;
}

class MeshMorphKey extends AssimpType<aiMeshMorphKey> {
  aiMeshMorphKey get _meshMorphKey => ptr.ref;

  MeshMorphKey._(Pointer<aiMeshMorphKey> ptr) : super(ptr);
  static MeshMorphKey? fromNative(Pointer<aiMeshMorphKey> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MeshMorphKey._(ptr);
  }

  double get time => _meshMorphKey.mTime;
  Iterable<int> get values =>
      _meshMorphKey.mValues.asTypedList(_meshMorphKey.mNumValuesAndWeights);
  Iterable<double> get weights =>
      _meshMorphKey.mWeights.asTypedList(_meshMorphKey.mNumValuesAndWeights);
}

class NodeAnim extends AssimpType<aiNodeAnim> {
  aiNodeAnim get _nodeAnim => ptr.ref;

  NodeAnim._(Pointer<aiNodeAnim> ptr) : super(ptr);
  static NodeAnim? fromNative(Pointer<aiNodeAnim> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return NodeAnim._(ptr);
  }

  String get name => AssimpString.fromNative(_nodeAnim.mNodeName);

  Iterable<VectorKey> get positionKeys {
    return Iterable.generate(
      _nodeAnim.mNumPositionKeys,
      (i) => VectorKey.fromNative(_nodeAnim.mPositionKeys.elementAt(i))!,
    );
  }

  Iterable<QuaternionKey> get rotationKeys {
    return Iterable.generate(
      _nodeAnim.mNumRotationKeys,
      (i) => QuaternionKey.fromNative(_nodeAnim.mRotationKeys.elementAt(i))!,
    );
  }

  Iterable<VectorKey> get scalingKeys {
    return Iterable.generate(
      _nodeAnim.mNumScalingKeys,
      (i) => VectorKey.fromNative(_nodeAnim.mScalingKeys.elementAt(i))!,
    );
  }

  AnimBehavior get preState => AnimBehavior.values[_nodeAnim.mPreState];
  AnimBehavior get postState => AnimBehavior.values[_nodeAnim.mPostState];
}

class MeshAnim extends AssimpType<aiMeshAnim> {
  aiMeshAnim get _meshAnim => ptr.ref;

  MeshAnim._(Pointer<aiMeshAnim> ptr) : super(ptr);
  static MeshAnim? fromNative(Pointer<aiMeshAnim> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MeshAnim._(ptr);
  }

  String get name => AssimpString.fromNative(_meshAnim.mName);

  Iterable<MeshKey> get keys {
    return Iterable.generate(
      _meshAnim.mNumKeys,
      (i) => MeshKey.fromNative(_meshAnim.mKeys.elementAt(i))!,
    );
  }
}

class MeshMorphAnim extends AssimpType<aiMeshMorphAnim> {
  aiMeshMorphAnim get _meshMorphAnim => ptr.ref;

  MeshMorphAnim._(Pointer<aiMeshMorphAnim> ptr) : super(ptr);
  static MeshMorphAnim? fromNative(Pointer<aiMeshMorphAnim> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MeshMorphAnim._(ptr);
  }

  String get name => AssimpString.fromNative(_meshMorphAnim.mName);

  Iterable<MeshMorphKey> get keys {
    return Iterable.generate(
      _meshMorphAnim.mNumKeys,
      (i) => MeshMorphKey.fromNative(_meshMorphAnim.mKeys.elementAt(i))!,
    );
  }
}

class Animation extends AssimpType<aiAnimation> {
  aiAnimation get _animation => ptr.ref;

  Animation._(Pointer<aiAnimation> ptr) : super(ptr);
  static Animation? fromNative(Pointer<aiAnimation> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Animation._(ptr);
  }

  String get name => AssimpString.fromNative(_animation.mName);
  double get duration => _animation.mDuration;
  double get ticksPerSecond => _animation.mTicksPerSecond;

  Iterable<NodeAnim> get channels {
    return Iterable.generate(
      _animation.mNumChannels,
      (i) => NodeAnim.fromNative(_animation.mChannels[i])!,
    );
  }

  Iterable<MeshAnim> get meshChannels {
    return Iterable.generate(
      _animation.mNumMeshChannels,
      (i) => MeshAnim.fromNative(_animation.mMeshChannels[i])!,
    );
  }

  Iterable<MeshMorphAnim> get meshMorphChannels {
    return Iterable.generate(
      _animation.mNumMorphMeshChannels,
      (i) => MeshMorphAnim.fromNative(_animation.mMorphMeshChannels[i])!,
    );
  }
}
