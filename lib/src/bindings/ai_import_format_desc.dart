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

import 'dylib.dart';

typedef aiGetImporterDesc_t = Pointer<aiImporterDesc> Function(
    Pointer<Utf8> extension);

typedef aiGetImportFormatCount_t = Uint32 Function();
typedef aiGetImportFormatCount_f = int Function();

aiGetImportFormatCount_f _aiGetImportFormatCount;
get aiGetImportFormatCount => _aiGetImportFormatCount ??= libassimp
    .lookupFunction<aiGetImportFormatCount_t, aiGetImportFormatCount_f>(
        'aiGetImportFormatCount');

typedef aiGetImportFormatDescription_t = Pointer<aiImporterDesc> Function(
    Uint32 index);
typedef aiGetImportFormatDescription_f = Pointer<aiImporterDesc> Function(
    int index);

aiGetImportFormatDescription_f _aiGetImportFormatDescription;
get aiGetImportFormatDescription =>
    _aiGetImportFormatDescription ??= libassimp.lookupFunction<
        aiGetImportFormatDescription_t,
        aiGetImportFormatDescription_f>('aiGetImportFormatDescription');

// pahole libassimpd.so -M -C aiImporterDesc
class aiImporterDesc extends Struct {
  // const char  *              mName;                /*     0     8 */
  Pointer<Utf8> mName;

  // const char  *              mAuthor;              /*     8     8 */
  Pointer<Utf8> mAuthor;

  // const char  *              mMaintainer;          /*    16     8 */
  Pointer<Utf8> mMaintainer;

  // const char  *              mComments;            /*    24     8 */
  Pointer<Utf8> mComments;

  // unsigned int               mFlags;               /*    32     4 */
  @Uint32()
  int mFlags;

  // unsigned int               mMinMajor;            /*    36     4 */
  @Uint32()
  int mMinMajor;

  // unsigned int               mMinMinor;            /*    40     4 */
  @Uint32()
  int mMinMinor;

  // unsigned int               mMaxMajor;            /*    44     4 */
  @Uint32()
  int mMaxMajor;

  // unsigned int               mMaxMinor;            /*    48     4 */
  @Uint32()
  int mMaxMinor;

  /* XXX 4 bytes hole, try to pack */
  @Uint32()
  int _mPadding0;

  // const char  *              mFileExtensions;      /*    56     8 */
  Pointer<Utf8> mFileExtensions;

  /* size: 64, members: 10 */
  /* sum members: 60, holes: 1, sum holes: 4 */
}
