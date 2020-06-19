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
import 'materialproperty.dart';
import 'types.dart';
import 'uvtransform.dart';

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

/** @brief Retrieve a material property with a specific key from the material
 *
 * @param pMat Pointer to the input material. May not be NULL
 * @param pKey Key to search for. One of the AI_MATKEY_XXX constants.
 * @param type Specifies the type of the texture to be retrieved (
 *    e.g. diffuse, specular, height map ...)
 * @param index Index of the texture to be retrieved.
 * @param pPropOut Pointer to receive a pointer to a valid aiMaterialProperty
 *        structure or NULL if the key has not been found. */
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
/** @brief Retrieve an array of float values with a specific key
 *  from the material
 *
 * Pass one of the AI_MATKEY_XXX constants for the last three parameters (the
 * example reads the #AI_MATKEY_UVTRANSFORM property of the first diffuse texture)
 * @code
 * aiUVTransform trafo;
 * unsigned int max = sizeof(aiUVTransform);
 * if (AI_SUCCESS != aiGetMaterialFloatArray(mat, AI_MATKEY_UVTRANSFORM(aiTextureType_DIFFUSE,0),
 *    (float*)&trafo, &max) || sizeof(aiUVTransform) != max)
 * {
 *   // error handling
 * }
 * @endcode
 *
 * @param pMat Pointer to the input material. May not be NULL
 * @param pKey Key to search for. One of the AI_MATKEY_XXX constants.
 * @param pOut Pointer to a buffer to receive the result.
 * @param pMax Specifies the size of the given buffer, in float's.
 *        Receives the number of values (not bytes!) read.
 * @param type (see the code sample above)
 * @param index (see the code sample above)
 * @return Specifies whether the key has been found. If not, the output
 *   arrays remains unmodified and pMax is set to 0.*/
// ---------------------------------------------------------------------------
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

//// Use our friend, the C preprocessor
//#define aiGetMaterialFloat (pMat, type, index, pKey, pOut) \
//    aiGetMaterialFloatArray(pMat, type, index, pKey, pOut, NULL)

// ---------------------------------------------------------------------------
/** @brief Retrieve an array of integer values with a specific key
 *  from a material
 *
 * See the sample for aiGetMaterialFloatArray for more information.*/
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

//// use our friend, the C preprocessor
//#define aiGetMaterialInteger (pMat, type, index, pKey, pOut) \
//    aiGetMaterialIntegerArray(pMat, type, index, pKey, pOut, NULL)

// ---------------------------------------------------------------------------
/** @brief Retrieve a color value from the material property table
*
* See the sample for aiGetMaterialFloat for more information*/
// ---------------------------------------------------------------------------
typedef aiGetMaterialColor_t = Uint32 Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, Uint32 type, Uint32 index, Pointer<aiColor4D> out);
typedef aiGetMaterialColor_f = int Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, int type, int index, Pointer<aiColor4D> out);

aiGetMaterialColor_f _aiGetMaterialColor;
get aiGetMaterialColor => _aiGetMaterialColor ??=
    libassimp.lookupFunction<aiGetMaterialColor_t, aiGetMaterialColor_f>(
        'aiGetMaterialColor');

// ---------------------------------------------------------------------------
/** @brief Retrieve a aiUVTransform value from the material property table
*
* See the sample for aiGetMaterialFloat for more information*/
// ---------------------------------------------------------------------------
typedef aiGetMaterialUVTransform_t = Uint32 Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, Uint32 type, Uint32 index, Pointer<aiUVTransform> out);
typedef aiGetMaterialUVTransform_f = int Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, int type, int index, Pointer<aiUVTransform> out);

aiGetMaterialUVTransform_f _aiGetMaterialUVTransform;
get aiGetMaterialUVTransform => _aiGetMaterialUVTransform ??= libassimp
    .lookupFunction<aiGetMaterialUVTransform_t, aiGetMaterialUVTransform_f>(
        'aiGetMaterialUVTransform');

// ---------------------------------------------------------------------------
/** @brief Retrieve a string from the material property table
*
* See the sample for aiGetMaterialFloat for more information.*/
// ---------------------------------------------------------------------------
typedef aiGetMaterialString_t = Uint32 Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, Uint32 type, Uint32 index, Pointer<aiString> out);
typedef aiGetMaterialString_f = int Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, int type, int index, Pointer<aiString> out);

aiGetMaterialString_f _aiGetMaterialString;
get aiGetMaterialString => _aiGetMaterialString ??=
    libassimp.lookupFunction<aiGetMaterialString_t, aiGetMaterialString_f>(
        'aiGetMaterialString');

// ---------------------------------------------------------------------------
/** Get the number of textures for a particular texture type.
 *  @param[in] pMat Pointer to the input material. May not be NULL
 *  @param type Texture type to check for
 *  @return Number of textures for this type.
 *  @note A texture can be easily queried using #aiGetMaterialTexture() */
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
/** @brief Helper function to get all values pertaining to a particular
 *  texture slot from a material structure.
 *
 *  This function is provided just for convenience. You could also read the
 *  texture by parsing all of its properties manually. This function bundles
 *  all of them in a huge function monster.
 *
 *  @param[in] mat Pointer to the input material. May not be NULL
 *  @param[in] type Specifies the texture stack to read from (e.g. diffuse,
 *     specular, height map ...).
 *  @param[in] index Index of the texture. The function fails if the
 *     requested index is not available for this texture type.
 *     #aiGetMaterialTextureCount() can be used to determine the number of
 *     textures in a particular texture stack.
 *  @param[out] path Receives the output path
 *     If the texture is embedded, receives a '*' followed by the id of
 *     the texture (for the textures stored in the corresponding scene) which
 *     can be converted to an int using a function like atoi.
 *     This parameter must be non-null.
 *  @param mapping The texture mapping mode to be used.
 *      Pass NULL if you're not interested in this information.
 *  @param[out] uvindex For UV-mapped textures: receives the index of the UV
 *      source channel. Unmodified otherwise.
 *      Pass NULL if you're not interested in this information.
 *  @param[out] blend Receives the blend factor for the texture
 *      Pass NULL if you're not interested in this information.
 *  @param[out] op Receives the texture blend operation to be perform between
 *      this texture and the previous texture.
 *      Pass NULL if you're not interested in this information.
 *  @param[out] mapmode Receives the mapping modes to be used for the texture.
 *      Pass NULL if you're not interested in this information. Otherwise,
 *      pass a pointer to an array of two aiTextureMapMode's (one for each
 *      axis, UV order).
 *  @param[out] flags Receives the the texture flags.
 *  @return AI_SUCCESS on success, otherwise something else. Have fun.*/
// ---------------------------------------------------------------------------
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
