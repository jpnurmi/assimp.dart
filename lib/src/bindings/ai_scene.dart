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

import 'ai_anim.dart';
import 'ai_camera.dart';
import 'ai_light.dart';
import 'ai_material.dart';
import 'ai_mesh.dart';
import 'ai_metadata.dart';
import 'ai_node.dart';
import 'ai_texture.dart';

// pahole libassimpd.so -M -C aiScene
class aiScene extends Struct {
  // unsigned int               mFlags;               /*     0     4 */
  @Uint32()
  int mFlags;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding0;

  //class aiNode *             mRootNode;            /*     8     8 */
  Pointer<aiNode> mRootNode;

  // unsigned int               mNumMeshes;           /*    16     4 */
  @Uint32()
  int mNumMeshes;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding1;

  // class aiMesh * *           mMeshes;              /*    24     8 */
  Pointer<Pointer<aiMesh>> mMeshes;

  // unsigned int               mNumMaterials;        /*    32     4 */
  @Uint32()
  int mNumMaterials;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding2;

  // class aiMaterial * *       mMaterials;           /*    40     8 */
  Pointer<Pointer<aiMaterial>> mMaterials;

  // unsigned int               mNumAnimations;       /*    48     4 */
  @Uint32()
  int mNumAnimations;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding3;

  // class aiAnimation * *      mAnimations;          /*    56     8 */
  Pointer<Pointer<aiAnimation>> mAnimations;

  // unsigned int               mNumTextures;         /*    64     4 */
  @Uint32()
  int mNumTextures;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding4;

  // class aiTexture * *        mTextures;            /*    72     8 */
  Pointer<Pointer<aiTexture>> mTextures;

  // unsigned int               mNumLights;           /*    80     4 */
  @Uint32()
  int mNumLights;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding5;

  // class aiLight * *          mLights;              /*    88     8 */
  Pointer<Pointer<aiLight>> mLights;

  // unsigned int               mNumCameras;          /*    96     4 */
  @Uint32()
  int mNumCameras;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding6;

  // class aiCamera * *         mCameras;             /*   104     8 */
  Pointer<Pointer<aiCamera>> mCameras;

  // class aiMetadata *         mMetaData;            /*   112     8 */
  Pointer<aiMetadata> mMetaData;

  // void *                     mPrivate;             /*   120     8 */
  Pointer<Void> _mPrivate;

  /* size: 128, members: 16 */
  /* sum members: 100, holes: 7, sum holes: 28 */
}
