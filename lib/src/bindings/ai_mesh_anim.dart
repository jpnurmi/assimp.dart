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

import 'ai_key.dart';
import 'ai_string.dart';

// pahole libassimpd.so -M -C aiMeshAnim 2>/dev/null
class aiMeshAnim extends Struct {
  // struct aiString            mName;                /*     0  1028 */
  Pointer<aiString> get mName => Pointer.fromAddress(addressOf.address + 0);

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

  // unsigned int               mNumKeys;             /*  1028     4 */
  @Uint32()
  int mNumKeys;

  // class aiMeshKey *          mKeys;                /*  1032     8 */
  Pointer<aiMeshKey> mKeys;

  /* size: 1040, members: 3 */
}
