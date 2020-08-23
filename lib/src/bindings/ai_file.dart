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

// ignore_for_file: unused_field

typedef aiFileWriteProc_t = Uint32 Function(
    Pointer<aiFile> file, Pointer<Utf8>, Uint32, Uint32);
typedef aiFileReadProc_t = Uint32 Function(
    Pointer<aiFile> file, Pointer<Utf8>, Uint32, Uint32);
typedef aiFileTellProc_t = Uint32 Function(Pointer<aiFile> file);
typedef aiFileFlushProc_t = Void Function(Pointer<aiFile> file);
typedef aiFileSeek_t = Uint32 Function(Pointer<aiFile> file, Uint32, Uint32);

// pahole libassimpd.so -M -C aiFile
class aiFile extends Struct {
  // aiFileReadProc             ReadProc;             /*     0     8 */
  Pointer<NativeFunction> ReadProc;

  //aiFileWriteProc            WriteProc;            /*     8     8 */
  Pointer<NativeFunction> WriteProc;

  // aiFileTellProc             TellProc;             /*    16     8 */
  Pointer<NativeFunction> TellProc; // aiFileTellProc_t

  // aiFileTellProc             FileSizeProc;         /*    24     8 */
  Pointer<NativeFunction> FileSizeProc;

  // aiFileSeek                 SeekProc;             /*    32     8 */
  Pointer<NativeFunction> SeekProc;

  // aiFileFlushProc            FlushProc;            /*    40     8 */
  Pointer<NativeFunction> FlushProc;

  // aiUserData                 UserData;             /*    48     8 */
  Pointer<Void> UserData;

  /* size: 56, members: 7 */
}
