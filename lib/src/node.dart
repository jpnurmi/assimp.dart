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

import 'package:vector_math/vector_math.dart';

import 'bindings.dart';
import 'meta_data.dart';
import 'extensions.dart';
import 'type.dart';

class Node extends AssimpType<aiNode> {
  aiNode get _node => ptr.ref;

  Node._(Pointer<aiNode> ptr) : super(ptr);
  factory Node.fromNative(Pointer<aiNode> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Node._(ptr);
  }

  String get name => AssimpString.fromNative(_node.mName);

  Matrix4 get transformation => AssimpMatrix4.fromNative(_node.mTransformation);

  Node get parent => AssimpPointer.isNotNull(_node.mParent)
      ? Node.fromNative(_node.mParent)
      : null;

  Iterable<Node> get children {
    return Iterable.generate(
      _node.mNumChildren,
      (i) => Node.fromNative(_node.mChildren[i]),
    );
  }

  Iterable<int> get meshes {
    return Iterable.generate(
      _node.mNumMeshes,
      (i) => _node.mMeshes[i],
    );
  }

  MetaData get metaData => AssimpPointer.isNotNull(_node.mMetaData)
      ? MetaData.fromNative(_node.mMetaData)
      : null;
}
