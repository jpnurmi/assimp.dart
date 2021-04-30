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

import 'bindings.dart';
import 'extensions.dart';
import 'libassimp.dart';
import 'scene.dart';
import 'type.dart';

/// Stores the memory requirements for different components (e.g. meshes, materials,
/// animations) of an import. All sizes are in bytes.
///
/// See also:
/// - Importer::GetMemoryRequirements()
class MemoryInfo extends AssimpType<aiMemoryInfo> {
  aiMemoryInfo get _memoryInfo => ptr.ref;

  MemoryInfo._(Pointer<aiMemoryInfo> ptr) : super(ptr);
  static MemoryInfo? fromNative(Pointer<aiMemoryInfo> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MemoryInfo._(ptr);
  }

  /// Get approximated storage required by a scene
  static MemoryInfo fromScene(Scene scene) {
    final mem = malloc<aiMemoryInfo>();
    libassimp.aiGetMemoryRequirements(scene.ptr, mem);
    return MemoryInfo.fromNative(mem)!;
  }

  /// Storage allocated for texture data
  int get textures => _memoryInfo.textures;

  /// Storage allocated for material data
  int get materials => _memoryInfo.materials;

  /// Storage allocated for mesh data
  int get meshes => _memoryInfo.meshes;

  /// Storage allocated for node data
  int get nodes => _memoryInfo.nodes;

  /// Storage allocated for animation data
  int get animations => _memoryInfo.animations;

  /// Storage allocated for camera data
  int get cameras => _memoryInfo.cameras;

  /// Storage allocated for light data
  int get lights => _memoryInfo.lights;

  /// Total storage allocated for the full import.
  int get total => _memoryInfo.total;

  /// Releases all resources associated with the given memory requirements.
  ///
  /// Call this function after you're done with the memory info.
  void dispose() => malloc.free(ptr);
}
