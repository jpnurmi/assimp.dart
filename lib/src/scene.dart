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

import 'package:ffi/ffi.dart';

import 'animation.dart';
import 'bindings/scene.dart' as bindings;
import 'bindings/cimport.dart' as bindings;
import 'camera.dart';
import 'light.dart';
import 'material.dart';
import 'mesh.dart';
import 'metadata.dart';
import 'node.dart';
import 'texture.dart';
import 'utils.dart';

class Scene {
  Pointer<bindings.aiScene> _ptr;

  Scene.fromNative(this._ptr);

  factory Scene.fromFile(String path, {int flags = 0}) {
    final cpath = Utf8.toUtf8(path);
    final ptr = bindings.aiImportFile(cpath, flags);
    free(cpath);
    return Utils.isNotNull(ptr) ? Scene.fromNative(ptr) : null;
  }

  factory Scene.fromBuffer(String buffer, {int flags = 0, String hint = ''}) {
    final cbuffer = Utf8.toUtf8(buffer);
    final chint = Utf8.toUtf8(hint);
    final ptr =
        bindings.aiImportFileFromMemory(cbuffer, buffer.length, flags, chint);
    free(cbuffer);
    free(chint);
    return Utils.isNotNull(ptr) ? Scene.fromNative(ptr) : null;
  }

  bool get isNull => Utils.isNull(_ptr);

  int get flags => _ptr?.ref?.mFlags ?? 0;

  Node get rootNode => Node.fromNative(_ptr?.ref?.mRootNode);

  Iterable<Mesh> get meshes {
    return Iterable.generate(
      _ptr?.ref?.mNumMeshes ?? 0,
      (i) => Mesh.fromNative(_ptr.ref.mMeshes[i]),
    );
  }

  Iterable<Material> get materials {
    return Iterable.generate(
      _ptr?.ref?.mNumMaterials ?? 0,
      (i) => Material.fromNative(_ptr.ref.mMaterials[i]),
    );
  }

  Iterable<Animation> get animations {
    return Iterable.generate(
      _ptr?.ref?.mNumAnimations ?? 0,
      (i) => Animation.fromNative(_ptr.ref.mAnimations[i]),
    );
  }

  Iterable<Texture> get textures {
    return Iterable.generate(
      _ptr?.ref?.mNumTextures ?? 0,
      (i) => Texture.fromNative(_ptr.ref.mTextures[i]),
    );
  }

  Iterable<Light> get lights {
    return Iterable.generate(
      _ptr?.ref?.mNumLights ?? 0,
      (i) => Light.fromNative(_ptr.ref.mLights[i]),
    );
  }

  Iterable<Camera> get cameras {
    return Iterable.generate(
      _ptr?.ref?.mNumCameras ?? 0,
      (i) => Camera.fromNative(_ptr.ref.mCameras[i]),
    );
  }

  MetaData get metaData => MetaData.fromNative(_ptr?.ref?.mMetaData);

  void applyPostProcessing(int flags) {
    bindings.aiApplyPostProcessing(_ptr, flags);
  }

  void dispose() {
    bindings.aiReleaseImport(_ptr);
    _ptr = null;
  }
}
