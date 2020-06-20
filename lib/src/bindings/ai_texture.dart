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

import 'ai_string.dart';
import 'ai_texel.dart';

// pahole libassimpd.so -M -C aiTexture
class aiTexture extends Struct {
  // unsigned int               mWidth;               /*     0     4 */
  @Uint32()
  int mWidth;

  // unsigned int               mHeight;              /*     4     4 */
  @Uint32()
  int mHeight;

  // char                       achFormatHint[9];     /*     8     9 */
  Pointer<Utf8> get mName => Pointer.fromAddress(addressOf.address + 8);
  Pointer _mPadding0;

  /* XXX 7 bytes hole, try to pack */
  Pointer _mPadding1;

  // class aiTexel *            pcData;               /*    24     8 */
  Pointer<aiTexel> pcData;

  // struct aiString            mFilename;            /*    32  1028 */
  Pointer<aiString> get mFilename =>
      Pointer<aiString>.fromAddress(addressOf.address + 32);

  @Uint32()
  int _mFilenameLength;

  // char[MAXLEN=1024]
  Pointer _mFilename0,
      _mFilename1,
      _mFilename2,
      _mFilename3,
      _mFilename4,
      _mFilename5,
      _mFilename6,
      _mFilename7,
      _mFilename8,
      _mFilename9,
      _mFilename10,
      _mFilename11,
      _mFilename12,
      _mFilename13,
      _mFilename14,
      _mFilename15,
      _mFilename16,
      _mFilename17,
      _mFilename18,
      _mFilename19,
      _mFilename20,
      _mFilename21,
      _mFilename22,
      _mFilename23,
      _mFilename24,
      _mFilename25,
      _mFilename26,
      _mFilename27,
      _mFilename28,
      _mFilename29,
      _mFilename30,
      _mFilename31,
      _mFilename32,
      _mFilename33,
      _mFilename34,
      _mFilename35,
      _mFilename36,
      _mFilename37,
      _mFilename38,
      _mFilename39,
      _mFilename40,
      _mFilename41,
      _mFilename42,
      _mFilename43,
      _mFilename44,
      _mFilename45,
      _mFilename46,
      _mFilename47,
      _mFilename48,
      _mFilename49,
      _mFilename50,
      _mFilename51,
      _mFilename52,
      _mFilename53,
      _mFilename54,
      _mFilename55,
      _mFilename56,
      _mFilename57,
      _mFilename58,
      _mFilename59,
      _mFilename60,
      _mFilename61,
      _mFilename62,
      _mFilename63,
      _mFilename64,
      _mFilename65,
      _mFilename66,
      _mFilename67,
      _mFilename68,
      _mFilename69,
      _mFilename70,
      _mFilename71,
      _mFilename72,
      _mFilename73,
      _mFilename74,
      _mFilename75,
      _mFilename76,
      _mFilename77,
      _mFilename78,
      _mFilename79,
      _mFilename80,
      _mFilename81,
      _mFilename82,
      _mFilename83,
      _mFilename84,
      _mFilename85,
      _mFilename86,
      _mFilename87,
      _mFilename88,
      _mFilename89,
      _mFilename90,
      _mFilename91,
      _mFilename92,
      _mFilename93,
      _mFilename94,
      _mFilename95,
      _mFilename96,
      _mFilename97,
      _mFilename98,
      _mFilename99,
      _mFilename100,
      _mFilename101,
      _mFilename102,
      _mFilename103,
      _mFilename104,
      _mFilename105,
      _mFilename106,
      _mFilename107,
      _mFilename108,
      _mFilename109,
      _mFilename110,
      _mFilename111,
      _mFilename112,
      _mFilename113,
      _mFilename114,
      _mFilename115,
      _mFilename116,
      _mFilename117,
      _mFilename118,
      _mFilename119,
      _mFilename120,
      _mFilename121,
      _mFilename122,
      _mFilename123,
      _mFilename124,
      _mFilename125,
      _mFilename126,
      _mFilename127;

  /* size: 1064, members: 5 */
  /* sum members: 1053, holes: 1, sum holes: 7 */
  /* padding: 4 */
  @Uint32()
  int _mPadding2;
}
