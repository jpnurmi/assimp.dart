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

import 'ai_quaternion.dart';
import 'ai_vector.dart';

// pahole libassimpd.so -M -C aiVectorKey
class aiVectorKey extends Struct {
  // double                     mTime;                /*     0     8 */
  @Double()
  double mTime;

  // aiVector3D                 mValue;               /*     8    12 */
  Pointer<aiVector3D> mValue;

  /* size: 24, members: 2 */
  /* padding: 4 */
  @Uint32()
  int _mPadding0;
}

// pahole libassimpd.so -M -C aiQuatKey
class aiQuatKey extends Struct {
  // double                     mTime;                /*     0     8 */
  @Double()
  double mTime;

  // aiQuaternion               mValue;               /*     8    16 */
  Pointer<aiQuaternion> mValue;

  /* size: 24, members: 2 */
}

// pahole libassimpd.so -M -C aiMeshKey
class aiMeshKey extends Struct {
  // double                     mTime;                /*     0     8 */
  @Double()
  double mTime;

  // unsigned int               mValue;               /*     8     4 */
  @Uint32()
  int mValue;

  /* size: 16, members: 2 */
  /* padding: 4 */
  @Uint32()
  int _mPadding0;
}

// pahole libassimpd.so -M -C aiMeshMorphKey
class aiMeshMorphKey extends Struct {
  // double                     mTime;                /*     0     8 */
  @Double()
  double mTime;

  // unsigned int *             mValues;              /*     8     8 */
  Pointer<Uint32> mValues;

  // double *                   mWeights;             /*    16     8 */
  Pointer<Double> mWeights;

  // unsigned int               mNumValuesAndWeights; /*    24     4 */
  @Uint32()
  int mNumValuesAndWeights;

  /* size: 32, members: 4 */
  /* padding: 4 */
  @Uint32()
  int _mPadding0;
}
