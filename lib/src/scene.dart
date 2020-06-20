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
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'animation.dart';
import 'bindings.dart' as b;
import 'camera.dart';
import 'libassimp.dart';
import 'light.dart';
import 'material.dart';
import 'mesh.dart';
import 'meta_data.dart';
import 'node.dart';
import 'texture.dart';
import 'extensions.dart';

class Scene {
  Pointer<b.aiScene> _ptr;

  Scene._(this._ptr);
  factory Scene.fromNative(Pointer<b.aiScene> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Scene._(ptr);
  }

  factory Scene.fromFile(String path, {int flags = 0}) {
    final cpath = Utf8.toUtf8(path);
    final ptr = aiImportFile(cpath, flags);
    free(cpath);
    return AssimpPointer.isNotNull(ptr) ? Scene.fromNative(ptr) : null;
  }

  factory Scene._fromBuffer(
      Pointer<Utf8> cstr, int length, flags, String hint) {
    final chint = Utf8.toUtf8(hint);
    final ptr = aiImportFileFromMemory(cstr, length, flags, chint);
    free(cstr);
    free(chint);
    return AssimpPointer.isNotNull(ptr) ? Scene.fromNative(ptr) : null;
  }

  factory Scene.fromString(String str, {int flags = 0, String hint = ''}) {
    return Scene._fromBuffer(Utf8.toUtf8(str), str.length, flags, hint);
  }

  factory Scene.fromBytes(Uint8List bytes, {int flags = 0, String hint = ''}) {
    // ### TODO: avoid copy...
    // https://github.com/dart-lang/ffi/issues/31
    // https://github.com/dart-lang/ffi/issues/27
    final Pointer<Uint8> cbuffer = allocate<Uint8>(count: bytes.length);
    final Uint8List carray = cbuffer.asTypedList(bytes.length);
    carray.setAll(0, bytes);
    return Scene._fromBuffer(cbuffer.cast(), bytes.length, flags, hint);
  }

  int get flags => _ptr.ref.mFlags;

  Node get rootNode => Node.fromNative(_ptr.ref.mRootNode);

  Iterable<Mesh> get meshes {
    return Iterable.generate(
      _ptr.ref.mNumMeshes,
      (i) => Mesh.fromNative(_ptr.ref.mMeshes[i]),
    );
  }

  Iterable<Material> get materials {
    return Iterable.generate(
      _ptr.ref.mNumMaterials,
      (i) => Material.fromNative(_ptr.ref.mMaterials[i]),
    );
  }

  Iterable<Animation> get animations {
    return Iterable.generate(
      _ptr.ref.mNumAnimations,
      (i) => Animation.fromNative(_ptr.ref.mAnimations[i]),
    );
  }

  Iterable<Texture> get textures {
    return Iterable.generate(
      _ptr.ref.mNumTextures,
      (i) => Texture.fromNative(_ptr.ref.mTextures[i]),
    );
  }

  Iterable<Light> get lights {
    return Iterable.generate(
      _ptr.ref.mNumLights,
      (i) => Light.fromNative(_ptr.ref.mLights[i]),
    );
  }

  Iterable<Camera> get cameras {
    return Iterable.generate(
      _ptr.ref.mNumCameras,
      (i) => Camera.fromNative(_ptr.ref.mCameras[i]),
    );
  }

  MetaData get metaData => MetaData.fromNative(_ptr.ref.mMetaData);

  void applyPostProcessing(int flags) {
    aiApplyPostProcessing(_ptr, flags);
  }

  void dispose() {
    aiReleaseImport(_ptr);
    _ptr = null;
  }
}
