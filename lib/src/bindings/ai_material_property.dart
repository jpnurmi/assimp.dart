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

// pahole libassimpd.so -M -C aiMaterialProperty
class aiMaterialProperty extends Struct {
  // struct aiString            mKey;                 /*     0  1028 */
  Pointer<aiString> get mKey => Pointer.fromAddress(addressOf.address + 0);

  @Uint32()
  int _mKeyLength;

  // char[MAXLEN=1024]
  Pointer _mKey0,
      _mKey1,
      _mKey2,
      _mKey3,
      _mKey4,
      _mKey5,
      _mKey6,
      _mKey7,
      _mKey8,
      _mKey9,
      _mKey10,
      _mKey11,
      _mKey12,
      _mKey13,
      _mKey14,
      _mKey15,
      _mKey16,
      _mKey17,
      _mKey18,
      _mKey19,
      _mKey20,
      _mKey21,
      _mKey22,
      _mKey23,
      _mKey24,
      _mKey25,
      _mKey26,
      _mKey27,
      _mKey28,
      _mKey29,
      _mKey30,
      _mKey31,
      _mKey32,
      _mKey33,
      _mKey34,
      _mKey35,
      _mKey36,
      _mKey37,
      _mKey38,
      _mKey39,
      _mKey40,
      _mKey41,
      _mKey42,
      _mKey43,
      _mKey44,
      _mKey45,
      _mKey46,
      _mKey47,
      _mKey48,
      _mKey49,
      _mKey50,
      _mKey51,
      _mKey52,
      _mKey53,
      _mKey54,
      _mKey55,
      _mKey56,
      _mKey57,
      _mKey58,
      _mKey59,
      _mKey60,
      _mKey61,
      _mKey62,
      _mKey63,
      _mKey64,
      _mKey65,
      _mKey66,
      _mKey67,
      _mKey68,
      _mKey69,
      _mKey70,
      _mKey71,
      _mKey72,
      _mKey73,
      _mKey74,
      _mKey75,
      _mKey76,
      _mKey77,
      _mKey78,
      _mKey79,
      _mKey80,
      _mKey81,
      _mKey82,
      _mKey83,
      _mKey84,
      _mKey85,
      _mKey86,
      _mKey87,
      _mKey88,
      _mKey89,
      _mKey90,
      _mKey91,
      _mKey92,
      _mKey93,
      _mKey94,
      _mKey95,
      _mKey96,
      _mKey97,
      _mKey98,
      _mKey99,
      _mKey100,
      _mKey101,
      _mKey102,
      _mKey103,
      _mKey104,
      _mKey105,
      _mKey106,
      _mKey107,
      _mKey108,
      _mKey109,
      _mKey110,
      _mKey111,
      _mKey112,
      _mKey113,
      _mKey114,
      _mKey115,
      _mKey116,
      _mKey117,
      _mKey118,
      _mKey119,
      _mKey120,
      _mKey121,
      _mKey122,
      _mKey123,
      _mKey124,
      _mKey125,
      _mKey126,
      _mKey127;

  // unsigned int               mSemantic;            /*  1028     4 */
  @Uint32()
  int mSemantic;

  // unsigned int               mIndex;               /*  1032     4 */
  @Uint32()
  int mIndex;

  // unsigned int               mDataLength;          /*  1036     4 */
  @Uint32()
  int mDataLength;

  // enum aiPropertyTypeInfo    mType;                /*  1040     4 */
  @Uint32()
  int mType;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding0;

  // char *                     mData;                /*  1048     8 */
  Pointer<Utf8> mData;

  /* size: 1056, members: 6 */
  /* sum members: 1052, holes: 1, sum holes: 4 */
}
