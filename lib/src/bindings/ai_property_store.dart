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
import 'ai_matrix.dart';
import 'ai_string.dart';

typedef aiCreatePropertyStore_t = Pointer<aiPropertyStore> Function();
typedef aiCreatePropertyStore_f = Pointer<aiPropertyStore> Function();

aiCreatePropertyStore_f _aiCreatePropertyStore;
get aiCreatePropertyStore => _aiCreatePropertyStore ??=
    libassimp.lookupFunction<aiCreatePropertyStore_t, aiCreatePropertyStore_f>(
        'aiCreatePropertyStore');

typedef aiReleasePropertyStore_t = Void Function(
    Pointer<aiPropertyStore> store);
typedef aiReleasePropertyStore_f = void Function(
    Pointer<aiPropertyStore> store);

aiReleasePropertyStore_f _aiReleasePropertyStore;
get aiReleasePropertyStore => _aiReleasePropertyStore ??= libassimp
    .lookupFunction<aiReleasePropertyStore_t, aiReleasePropertyStore_f>(
        'aiReleasePropertyStore');

typedef aiSetImportPropertyInteger_t = Void Function(
    Pointer<aiPropertyStore> store, Pointer<Utf8> name, Int32 value);
typedef aiSetImportPropertyInteger_f = void Function(
    Pointer<aiPropertyStore> store, Pointer<Utf8> name, int value);

aiSetImportPropertyInteger_f _aiSetImportPropertyInteger;
get aiSetImportPropertyInteger => _aiSetImportPropertyInteger ??= libassimp
    .lookupFunction<aiSetImportPropertyInteger_t, aiSetImportPropertyInteger_f>(
        'aiSetImportPropertyInteger');

typedef aiSetImportPropertyFloat_t = Void Function(
    Pointer<aiPropertyStore> store, Pointer<Utf8> name, Float value);
typedef aiSetImportPropertyFloat_f = void Function(
    Pointer<aiPropertyStore> store, Pointer<Utf8> name, double value);

aiSetImportPropertyFloat_f _aiSetImportPropertyFloat;
get aiSetImportPropertyFloat => _aiSetImportPropertyFloat ??= libassimp
    .lookupFunction<aiSetImportPropertyFloat_t, aiSetImportPropertyFloat_f>(
        'aiSetImportPropertyFloat');

typedef aiSetImportPropertyString_t = Void Function(
    Pointer<aiPropertyStore> store,
    Pointer<Utf8> name,
    Pointer<aiString> value);
typedef aiSetImportPropertyString_f = void Function(
    Pointer<aiPropertyStore> store,
    Pointer<Utf8> name,
    Pointer<aiString> value);

aiSetImportPropertyString_f _aiSetImportPropertyString;
get aiSetImportPropertyString => _aiSetImportPropertyString ??= libassimp
    .lookupFunction<aiSetImportPropertyString_t, aiSetImportPropertyString_f>(
        'aiSetImportPropertyString');

typedef aiSetImportPropertyMatrix_t = Void Function(
    Pointer<aiPropertyStore> store,
    Pointer<Utf8> name,
    Pointer<aiMatrix4x4> value);
typedef aiSetImportPropertyMatrix_f = void Function(
    Pointer<aiPropertyStore> store,
    Pointer<Utf8> name,
    Pointer<aiMatrix4x4> value);

aiSetImportPropertyMatrix_f _aiSetImportPropertyMatrix;
get aiSetImportPropertyMatrix => _aiSetImportPropertyMatrix ??= libassimp
    .lookupFunction<aiSetImportPropertyMatrix_t, aiSetImportPropertyMatrix_f>(
        'aiSetImportPropertyMatrix');

// pahole libassimpd.so -M -C aiPropertyStore
class aiPropertyStore extends Struct {
  // char                       sentinel;             /*     0     1 */
  @Int8()
  int sentinel;

  /* size: 1, members: 1 */
}