/*
---------------------------------------------------------------------------
Open Asset Import Library (assimp)
---------------------------------------------------------------------------

Copyright (c) 2006-2011, assimp team

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

import 'ai_export_data_blob.dart';
import 'ai_file_io.dart';
import 'ai_scene.dart';

typedef aiCopyScene_t = Void Function(
    Pointer<aiScene> scene, Pointer<Pointer<aiScene>> out);
typedef aiCopyScene_f = void Function(
    Pointer<aiScene> scene, Pointer<Pointer<aiScene>> out);

typedef aiFreeScene_t = Void Function(Pointer<aiScene> scene);
typedef aiFreeScene_f = void Function(Pointer<aiScene> scene);

typedef aiExportScene_t = Uint32 Function(Pointer<aiScene> scene,
    Pointer<Utf8> formatId, Pointer<Utf8> fileName, Uint32 preprocessing);
typedef aiExportScene_f = int Function(Pointer<aiScene> scene,
    Pointer<Utf8> formatId, Pointer<Utf8> fileName, int preprocessing);

typedef aiExportSceneEx_t = Uint32 Function(
    Pointer<aiScene> scene,
    Pointer<Utf8> formatId,
    Pointer<Utf8> fileName,
    Pointer<aiFileIO> io,
    Uint32 preprocessing);
typedef aiExportSceneEx_f = int Function(
    Pointer<aiScene> scene,
    Pointer<Utf8> formatId,
    Pointer<Utf8> fileName,
    Pointer<aiFileIO> io,
    int preprocessing);

typedef aiExportSceneToBlob_t = Pointer<aiExportDataBlob> Function(
    Pointer<aiScene> scene, Pointer<Utf8> formatId, Uint32 preprocessing);
typedef aiExportSceneToBlob_f = Pointer<aiExportDataBlob> Function(
    Pointer<aiScene> scene, Pointer<Utf8> formatId, int preprocessing);

typedef aiReleaseExportBlob_t = Void Function(Pointer<aiExportDataBlob> data);
typedef aiReleaseExportBlob_f = void Function(Pointer<aiExportDataBlob> data);
