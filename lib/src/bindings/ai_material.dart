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
import 'ai_color.dart';
import 'ai_string.dart';
import 'ai_material_property.dart';
import 'ai_uv_transform.dart';

// pahole libassimpd.so -M -C aiMaterial
class aiMaterial extends Struct {
  // class aiMaterialProperty * * mProperties;        /*     0     8 */
  Pointer<Pointer<aiMaterialProperty>> mProperties;

  // unsigned int               mNumProperties;       /*     8     4 */
  @Uint32()
  int mNumProperties;

  // unsigned int               mNumAllocated;        /*    12     4 */
  @Uint32()
  int mNumAllocated;

  /* size: 16, members: 3 */
}

typedef aiGetMaterialProperty_t = Uint32 Function(
  Pointer<aiMaterial> mat,
  Pointer<Utf8> key,
  Uint32 type,
  Uint32 index,
  Pointer<Pointer<aiMaterialProperty>> propOut,
);
typedef aiGetMaterialProperty_f = int Function(
  Pointer<aiMaterial> mat,
  Pointer<Utf8> key,
  int type,
  int index,
  Pointer<Pointer<aiMaterialProperty>> propOut,
);

aiGetMaterialProperty_f _aiGetMaterialProperty;
get aiGetMaterialProperty => _aiGetMaterialProperty ??=
    libassimp.lookupFunction<aiGetMaterialProperty_t, aiGetMaterialProperty_f>(
        'aiGetMaterialProperty');

typedef aiGetMaterialFloatArray_t = Uint32 Function(
    Pointer<aiMaterial> mat,
    Pointer<Utf8> key,
    Uint32 type,
    Uint32 index,
    Pointer<Float> out, // ai_real*
    Pointer<Uint32> max);
typedef aiGetMaterialFloatArray_f = int Function(
    Pointer<aiMaterial> mat,
    Pointer<Utf8> key,
    int type,
    int index,
    Pointer<Float> out, // ai_real*
    Pointer<Uint32> max);

aiGetMaterialFloatArray_f _aiGetMaterialFloatArray;
get aiGetMaterialFloatArray => _aiGetMaterialFloatArray ??= libassimp
    .lookupFunction<aiGetMaterialFloatArray_t, aiGetMaterialFloatArray_f>(
        'aiGetMaterialFloatArray');

typedef aiGetMaterialIntegerArray_t = Uint32 Function(
    Pointer<aiMaterial> mat,
    Pointer<Utf8> key,
    Uint32 type,
    Uint32 index,
    Pointer<Int32> out,
    Pointer<Uint32> max);
typedef aiGetMaterialIntegerArray_f = int Function(
    Pointer<aiMaterial> mat,
    Pointer<Utf8> key,
    int type,
    int index,
    Pointer<Int32> out,
    Pointer<Uint32> max);

aiGetMaterialIntegerArray_f _aiGetMaterialIntegerArray;
get aiGetMaterialIntegerArray => _aiGetMaterialIntegerArray ??= libassimp
    .lookupFunction<aiGetMaterialIntegerArray_t, aiGetMaterialIntegerArray_f>(
        'aiGetMaterialIntegerArray');

typedef aiGetMaterialColor_t = Uint32 Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, Uint32 type, Uint32 index, Pointer<aiColor4D> out);
typedef aiGetMaterialColor_f = int Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, int type, int index, Pointer<aiColor4D> out);

aiGetMaterialColor_f _aiGetMaterialColor;
get aiGetMaterialColor => _aiGetMaterialColor ??=
    libassimp.lookupFunction<aiGetMaterialColor_t, aiGetMaterialColor_f>(
        'aiGetMaterialColor');

typedef aiGetMaterialUVTransform_t = Uint32 Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, Uint32 type, Uint32 index, Pointer<aiUVTransform> out);
typedef aiGetMaterialUVTransform_f = int Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, int type, int index, Pointer<aiUVTransform> out);

aiGetMaterialUVTransform_f _aiGetMaterialUVTransform;
get aiGetMaterialUVTransform => _aiGetMaterialUVTransform ??= libassimp
    .lookupFunction<aiGetMaterialUVTransform_t, aiGetMaterialUVTransform_f>(
        'aiGetMaterialUVTransform');

typedef aiGetMaterialString_t = Uint32 Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, Uint32 type, Uint32 index, Pointer<aiString> out);
typedef aiGetMaterialString_f = int Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, int type, int index, Pointer<aiString> out);

aiGetMaterialString_f _aiGetMaterialString;
get aiGetMaterialString => _aiGetMaterialString ??=
    libassimp.lookupFunction<aiGetMaterialString_t, aiGetMaterialString_f>(
        'aiGetMaterialString');

typedef aiGetMaterialTextureCount_t = Uint32 Function(
  Pointer<aiMaterial> mat,
  Uint32 type, // aiTextureType
);
typedef aiGetMaterialTextureCount_f = int Function(
  Pointer<aiMaterial> mat,
  int type, // aiTextureType
);

aiGetMaterialTextureCount_f _aiGetMaterialTextureCount;
get aiGetMaterialTextureCount => _aiGetMaterialTextureCount ??= libassimp
    .lookupFunction<aiGetMaterialTextureCount_t, aiGetMaterialTextureCount_f>(
        'aiGetMaterialTextureCount');

typedef aiGetMaterialTexture_t = Uint32 Function(
  Pointer<aiMaterial> mat,
  Uint32 type, // aiTextureType
  Uint32 index,
  Pointer<aiString> path,
  Pointer<Uint32> mapping, // aiTextureMapping*
  Pointer<Uint32> uvindex,
  Pointer<Float> blend, // ai_real*
  Pointer<Uint32> op, // aiTextureOp*
  Pointer<Uint32> mapmode, // aiTextureMapMode*
  Pointer<Uint32> flags,
);
typedef aiGetMaterialTexture_f = int Function(
  Pointer<aiMaterial> mat,
  int type, // aiTextureType
  int index,
  Pointer<aiString> path,
  Pointer<Uint32> mapping, // aiTextureMapping*
  Pointer<Uint32> uvindex,
  Pointer<Float> blend, // ai_real*
  Pointer<Uint32> op, // aiTextureOp*
  Pointer<Uint32> mapmode, // aiTextureMapMode*
  Pointer<Uint32> flags,
);

aiGetMaterialTexture_f _aiGetMaterialTexture;
get aiGetMaterialTexture => _aiGetMaterialTexture ??=
    libassimp.lookupFunction<aiGetMaterialTexture_t, aiGetMaterialTexture_f>(
        'aiGetMaterialTexture');
