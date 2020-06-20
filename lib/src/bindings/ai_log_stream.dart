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

typedef aiLogStreamCallback_t = Void Function(
    Pointer<Utf8> message, Pointer<Utf8> user);

typedef aiGetPredefinedLogStream_t = Pointer<aiLogStream> Function(
    Uint32 streams, // aiDefaultLogStream
    Pointer<Utf8> file);
typedef aiGetPredefinedLogStream_f = Pointer<aiLogStream> Function(
    int streams, // aiDefaultLogStream
    Pointer<Utf8> file);

typedef aiAttachLogStream_t = Void Function(Pointer<aiLogStream> stream);
typedef aiAttachLogStream_f = void Function(Pointer<aiLogStream> stream);

typedef aiEnableVerboseLogging_t = Void Function(Int32 d);
typedef aiEnableVerboseLogging_f = void Function(int d);

typedef aiDetachLogStream_t = Uint32 Function(Pointer<aiLogStream> stream);
typedef aiDetachLogStream_f = int Function(Pointer<aiLogStream> stream);

typedef aiDetachAllLogStreams_t = Void Function();
typedef aiDetachAllLogStreams_f = void Function();

// pahole libassimpd.so -M -C aiLogStream
class aiLogStream extends Struct {
  // aiLogStreamCallback        callback;             /*     0     8 */
  Pointer<NativeFunction> callback;

  // char *                     user;                 /*     8     8 */
  Pointer<Utf8> user;

  /* size: 16, members: 2 */
}
