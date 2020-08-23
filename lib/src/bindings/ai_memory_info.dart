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

import 'ai_scene.dart';

// ignore_for_file: unused_field

typedef aiGetMemoryRequirements_t = Void Function(
    Pointer<aiScene> scene, Pointer<aiMemoryInfo> mem);
typedef aiGetMemoryRequirements_f = void Function(
    Pointer<aiScene> scene, Pointer<aiMemoryInfo> mem);

// pahole libassimpd.so -M -C aiMemoryInfo
class aiMemoryInfo extends Struct {
  // unsigned int               textures;             /*     0     4 */
  @Uint32()
  int textures;

  // unsigned int               materials;            /*     4     4 */
  @Uint32()
  int materials;

  // unsigned int               meshes;               /*     8     4 */
  @Uint32()
  int meshes;

  // unsigned int               nodes;                /*    12     4 */
  @Uint32()
  int nodes;

  // unsigned int               animations;           /*    16     4 */
  @Uint32()
  int animations;

  // unsigned int               cameras;              /*    20     4 */
  @Uint32()
  int cameras;

  // unsigned int               lights;               /*    24     4 */
  @Uint32()
  int lights;

  // unsigned int               total;                /*    28     4 */
  @Uint32()
  int total;

  /* size: 32, members: 8 */
}
