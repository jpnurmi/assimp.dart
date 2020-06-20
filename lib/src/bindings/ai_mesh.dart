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

import 'ai_anim_mesh.dart';
import 'ai_bone.dart';
import 'ai_color.dart';
import 'ai_face.dart';
import 'ai_string.dart';
import 'ai_vector.dart';

const int AI_MAX_FACE_INDICES = 0x7fff;
const int AI_MAX_BONE_WEIGHTS = 0x7fffffff;
const int AI_MAX_VERTICES = 0x7fffffff;
const int AI_MAX_FACES = 0x7fffffff;
const int AI_MAX_NUMBER_OF_COLOR_SETS = 0x8;
const int AI_MAX_NUMBER_OF_TEXTURECOORDS = 0x8;

// pahole libassimpd.so -M -C aiMesh
class aiMesh extends Struct {
  // unsigned int               mPrimitiveTypes;      /*     0     4 */
  @Uint32()
  int mPrimitiveTypes;

  // unsigned int               mNumVertices;         /*     4     4 */
  @Uint32()
  int mNumVertices;

  // unsigned int               mNumFaces;            /*     8     4 */
  @Uint32()
  int mNumFaces;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding0;

  // aiVector3D *               mVertices;            /*    16     8 */
  Pointer<aiVector3D> mVertices;

  // aiVector3D *               mNormals;             /*    24     8 */
  Pointer<aiVector3D> mNormals;

  // aiVector3D *               mTangents;            /*    32     8 */
  Pointer<aiVector3D> mTangents;

  // aiVector3D *               mBitangents;          /*    40     8 */
  Pointer<aiVector3D> mBitangents;

  // aiColor4D *                mColors[8];           /*    48    64 */
  Pointer<Pointer<aiColor4D>> get mColors =>
      Pointer<Pointer<aiColor4D>>.fromAddress(addressOf.address + 48);

  Pointer _mColors0,
      _mColors1,
      _mColors2,
      _mColors3,
      _mColors4,
      _mColors5,
      _mColors6,
      _mColors7;

  // aiVector3D *               mTextureCoords[8];    /*   112    64 */
  Pointer<Pointer<aiVector3D>> get mTextureCoords =>
      Pointer<Pointer<aiVector3D>>.fromAddress(addressOf.address + 112);

  Pointer _mTextureCoords0,
      _mTextureCoords1,
      _mTextureCoords2,
      _mTextureCoords3,
      _mTextureCoords4,
      _mTextureCoords5,
      _mTextureCoords6,
      _mTextureCoords7;

  // unsigned int               mNumUVComponents[8];  /*   176    32 */
  Pointer<Uint32> get mNumUVComponents =>
      Pointer<Uint32>.fromAddress(addressOf.address + 176);

  Pointer _mNumUVComponents0,
      _mNumUVComponents1,
      _mNumUVComponents2,
      _mNumUVComponents3;

  // class aiFace *             mFaces;               /*   208     8 */
  Pointer<aiFace> mFaces;

  // unsigned int               mNumBones;            /*   216     4 */
  @Uint32()
  int mNumBones;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding1;

  // class aiBone * *           mBones;               /*   224     8 */
  Pointer<Pointer<aiBone>> mBones;

  // unsigned int               mMaterialIndex;       /*   232     4 */
  @Uint32()
  int mMaterialIndex;

  // struct aiString            mName;                /*   236  1028 */
  Pointer<aiString> get mName => Pointer.fromAddress(addressOf.address + 236);

  @Uint32()
  int _mNameLength;

  // char[MAXLEN=1024]
  Pointer _mName0,
      _mName1,
      _mName2,
      _mName3,
      _mName4,
      _mName5,
      _mName6,
      _mName7,
      _mName8,
      _mName9,
      _mName10,
      _mName11,
      _mName12,
      _mName13,
      _mName14,
      _mName15,
      _mName16,
      _mName17,
      _mName18,
      _mName19,
      _mName20,
      _mName21,
      _mName22,
      _mName23,
      _mName24,
      _mName25,
      _mName26,
      _mName27,
      _mName28,
      _mName29,
      _mName30,
      _mName31,
      _mName32,
      _mName33,
      _mName34,
      _mName35,
      _mName36,
      _mName37,
      _mName38,
      _mName39,
      _mName40,
      _mName41,
      _mName42,
      _mName43,
      _mName44,
      _mName45,
      _mName46,
      _mName47,
      _mName48,
      _mName49,
      _mName50,
      _mName51,
      _mName52,
      _mName53,
      _mName54,
      _mName55,
      _mName56,
      _mName57,
      _mName58,
      _mName59,
      _mName60,
      _mName61,
      _mName62,
      _mName63,
      _mName64,
      _mName65,
      _mName66,
      _mName67,
      _mName68,
      _mName69,
      _mName70,
      _mName71,
      _mName72,
      _mName73,
      _mName74,
      _mName75,
      _mName76,
      _mName77,
      _mName78,
      _mName79,
      _mName80,
      _mName81,
      _mName82,
      _mName83,
      _mName84,
      _mName85,
      _mName86,
      _mName87,
      _mName88,
      _mName89,
      _mName90,
      _mName91,
      _mName92,
      _mName93,
      _mName94,
      _mName95,
      _mName96,
      _mName97,
      _mName98,
      _mName99,
      _mName100,
      _mName101,
      _mName102,
      _mName103,
      _mName104,
      _mName105,
      _mName106,
      _mName107,
      _mName108,
      _mName109,
      _mName110,
      _mName111,
      _mName112,
      _mName113,
      _mName114,
      _mName115,
      _mName116,
      _mName117,
      _mName118,
      _mName119,
      _mName120,
      _mName121,
      _mName122,
      _mName123,
      _mName124,
      _mName125,
      _mName126,
      _mName127;

  // unsigned int               mNumAnimMeshes;       /*  1264     4 */
  @Uint32()
  int mNumAnimMeshes;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding2;

  // class aiAnimMesh * *       mAnimMeshes;          /*  1272     8 */
  Pointer<Pointer<aiAnimMesh>> mAnimMeshes;

  // unsigned int               mMethod;              /*  1280     4 */
  @Uint32()
  int mMethod;

  // struct aiAABB              mAABB;                /*  1284    24 */
  @Float()
  double mMinX;
  @Float()
  double mMinY;
  @Float()
  double mMinZ;
  @Float()
  double mMaxX;
  @Float()
  double mMaxY;
  @Float()
  double mMaxZ;

  /* size: 1312, members: 19 */
  /* sum members: 1296, holes: 3, sum holes: 12 */
  /* padding: 4 */
  @Uint32()
  int _mPadding3;
}
