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
import 'ai_string.dart';

typedef aiGetLegalString_t = Pointer<Utf8> Function();
typedef aiGetLegalString_f = Pointer<Utf8> Function();

aiGetLegalString_f _aiGetLegalString;
get aiGetLegalString => _aiGetLegalString ??= libassimp
    .lookupFunction<aiGetLegalString_t, aiGetLegalString_f>('aiGetLegalString');

typedef aiGetVersionMinor_t = Uint32 Function();
typedef aiGetVersionMinor_f = int Function();

aiGetVersionMinor_f _aiGetVersionMinor;
get aiGetVersionMinor => _aiGetVersionMinor ??=
    libassimp.lookupFunction<aiGetVersionMinor_t, aiGetVersionMinor_f>(
        'aiGetVersionMinor');

typedef aiGetVersionMajor_t = Uint32 Function();
typedef aiGetVersionMajor_f = int Function();

aiGetVersionMajor_f _aiGetVersionMajor;
get aiGetVersionMajor => _aiGetVersionMajor ??=
    libassimp.lookupFunction<aiGetVersionMajor_t, aiGetVersionMajor_f>(
        'aiGetVersionMajor');

typedef aiGetVersionRevision_t = Uint32 Function();
typedef aiGetVersionRevision_f = int Function();

aiGetVersionRevision_f _aiGetVersionRevision;
get aiGetVersionRevision => _aiGetVersionRevision ??=
    libassimp.lookupFunction<aiGetVersionRevision_t, aiGetVersionRevision_f>(
        'aiGetVersionRevision');

typedef aiGetBranchName_t = Pointer<Utf8> Function();
typedef aiGetBranchName_f = Pointer<Utf8> Function();

aiGetBranchName_f _aiGetBranchName;
get aiGetBranchName => _aiGetBranchName ??= libassimp
    .lookupFunction<aiGetBranchName_t, aiGetBranchName_f>('aiGetBranchName');

typedef aiGetCompileFlags_t = Uint32 Function();
typedef aiGetCompileFlags_f = int Function();

aiGetCompileFlags_f _aiGetCompileFlags;
get aiGetCompileFlags => _aiGetCompileFlags ??=
    libassimp.lookupFunction<aiGetCompileFlags_t, aiGetCompileFlags_f>(
        'aiGetCompileFlags');

typedef aiGetErrorString_t = Pointer<Utf8> Function();
typedef aiGetErrorString_f = Pointer<Utf8> Function();

aiGetErrorString_f _aiGetErrorString;
get aiGetErrorString => _aiGetErrorString ??= libassimp
    .lookupFunction<aiGetErrorString_t, aiGetErrorString_f>('aiGetErrorString');

typedef aiIsExtensionSupported_t = Int32 Function(Pointer<Utf8> extension);
typedef aiIsExtensionSupported_f = int Function(Pointer<Utf8> extension);

aiIsExtensionSupported_f _aiIsExtensionSupported;
get aiIsExtensionSupported => _aiIsExtensionSupported ??= libassimp
    .lookupFunction<aiIsExtensionSupported_t, aiIsExtensionSupported_f>(
        'aiIsExtensionSupported');

typedef aiGetExtensionList_t = Void Function(Pointer<aiString> out);
typedef aiGetExtensionList_f = void Function(Pointer<aiString> out);

aiGetExtensionList_f _aiGetExtensionList;
get aiGetExtensionList => _aiGetExtensionList ??=
    libassimp.lookupFunction<aiGetExtensionList_t, aiGetExtensionList_f>(
        'aiGetExtensionList');
