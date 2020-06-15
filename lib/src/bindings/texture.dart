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

/** @file texture.h
 *  @brief Defines texture helper structures for the library
 *
 * Used for file formats which embed their textures into the model file.
 * Supported are both normal textures, which are stored as uncompressed
 * pixels, and "compressed" textures, which are stored in a file format
 * such as PNG or TGA.
 */

import 'types.dart';

// --------------------------------------------------------------------------------

/** \def AI_EMBEDDED_TEXNAME_PREFIX
 * \ref AI_MAKE_EMBEDDED_TEXNAME
 */
const String AI_EMBEDDED_TEXNAME_PREFIX = '*';

/** @def AI_MAKE_EMBEDDED_TEXNAME
 *  Used to build the reserved path name used by the material system to
 *  reference textures that are embedded into their corresponding
 *  model files. The parameter specifies the index of the texture
 *  (zero-based, in the aiScene::mTextures array)
 */
String AI_MAKE_EMBEDDED_TEXNAME(String _n_) => AI_EMBEDDED_TEXNAME_PREFIX + _n_;

// --------------------------------------------------------------------------------
/** @brief Helper structure to represent a texel in a ARGB8888 format
 *
 *  Used by aiTexture.
 */
class aiTexel extends Struct {
  @Uint8()
  int b;
  @Uint8()
  int g;
  @Uint8()
  int r;
  @Uint8()
  int a;
}

const int HINTMAXTEXTURELEN = 9;

// --------------------------------------------------------------------------------
/** Helper structure to describe an embedded texture
 *
 * Normally textures are contained in external files but some file formats embed
 * them directly in the model file. There are two types of embedded textures:
 * 1. Uncompressed textures. The color data is given in an uncompressed format.
 * 2. Compressed textures stored in a file format like png or jpg. The raw file
 * bytes are given so the application must utilize an image decoder (e.g. DevIL) to
 * get access to the actual color data.
 *
 * Embedded textures are referenced from materials using strings like "*0", "*1", etc.
 * as the texture paths (a single asterisk character followed by the
 * zero-based index of the texture in the aiScene::mTextures array).
 */
class aiTexture extends Struct {
/** Width of the texture, in pixels
 *
 * If mHeight is zero the texture is compressed in a format
 * like JPEG. In this case mWidth specifies the size of the
 * memory area pcData is pointing to, in bytes.
 */
  @Uint32()
  int mWidth;

  /** Height of the texture, in pixels
   *
   * If this value is zero, pcData points to an compressed texture
   * in any format (e.g. JPEG).
   */
  @Uint32()
  int mHeight;

  /** A hint from the loader to make it easier for applications
   *  to determine the type of embedded textures.
   *
   * If mHeight != 0 this member is show how data is packed. Hint will consist of
   * two parts: channel order and channel bitness (count of the bits for every
   * color channel). For simple parsing by the viewer it's better to not omit
   * absent color channel and just use 0 for bitness. For example:
   * 1. Image contain RGBA and 8 bit per channel, achFormatHint == "rgba8888";
   * 2. Image contain ARGB and 8 bit per channel, achFormatHint == "argb8888";
   * 3. Image contain RGB and 5 bit for R and B channels and 6 bit for G channel, achFormatHint == "rgba5650";
   * 4. One color image with B channel and 1 bit for it, achFormatHint == "rgba0010";
   * If mHeight == 0 then achFormatHint is set set to '\\0\\0\\0\\0' if the loader has no additional
   * information about the texture file format used OR the
   * file extension of the format without a trailing dot. If there
   * are multiple file extensions for a format, the shortest
   * extension is chosen (JPEG maps to 'jpg', not to 'jpeg').
   * E.g. 'dds\\0', 'pcx\\0', 'jpg\\0'.  All characters are lower-case.
   * The fourth character will always be '\\0'.
   */
  Pointer<Utf8> achFormatHint;

  /** Data of the texture.
   *
   * Points to an array of mWidth * mHeight aiTexel's.
   * The format of the texture data is always ARGB8888 to
   * make the implementation for user of the library as easy
   * as possible. If mHeight = 0 this is a pointer to a memory
   * buffer of size mWidth containing the compressed texture
   * data. Good luck, have fun!
   */
  Pointer<aiTexel> pcData;

  /** Texture original filename
   *
   * Used to get the texture reference
   */
  Pointer<aiString> mFilename;
}
