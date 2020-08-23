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

// ignore_for_file: unused_field

typedef aiGetLegalString_t = Pointer<Utf8> Function();
typedef aiGetLegalString_f = Pointer<Utf8> Function();

typedef aiGetVersionMinor_t = Uint32 Function();
typedef aiGetVersionMinor_f = int Function();

typedef aiGetVersionMajor_t = Uint32 Function();
typedef aiGetVersionMajor_f = int Function();

typedef aiGetVersionRevision_t = Uint32 Function();
typedef aiGetVersionRevision_f = int Function();

typedef aiGetBranchName_t = Pointer<Utf8> Function();
typedef aiGetBranchName_f = Pointer<Utf8> Function();

typedef aiGetCompileFlags_t = Uint32 Function();
typedef aiGetCompileFlags_f = int Function();

typedef aiGetErrorString_t = Pointer<Utf8> Function();
typedef aiGetErrorString_f = Pointer<Utf8> Function();

typedef aiIsExtensionSupported_t = Int32 Function(Pointer<Utf8> extension);
typedef aiIsExtensionSupported_f = int Function(Pointer<Utf8> extension);

typedef aiGetExtensionList_t = Void Function(Pointer<aiString> out);
typedef aiGetExtensionList_f = void Function(Pointer<aiString> out);
