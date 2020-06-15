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

/** @file types.h
 *  Basic data types and primitives, such as vectors or colors.
 */

import 'vector3.dart';

export 'aabb.dart';
export 'vector3.dart';
export 'vector2.dart';
export 'color4.dart';
export 'matrix3x3.dart';
export 'matrix4x4.dart';
export 'quaternion.dart';

/** Maximum dimension for strings, ASSIMP strings are zero terminated. */
const int MAXLEN = 1024;

// ----------------------------------------------------------------------------------
/** Represents a plane in a three-dimensional, euclidean space
*/
class aiPlane extends Struct {
  //! Plane equation
  @Float() // ai_real
  double a, b, c, d;
} // !struct aiPlane

// ----------------------------------------------------------------------------------
/** Represents a ray
*/
class aiRay extends Struct {
  //! Position and direction of the ray
  Pointer<aiVector3D> pos, dir;
} // !struct aiRay

// ----------------------------------------------------------------------------------
/** Represents a color in Red-Green-Blue space.
*/
class aiColor3D extends Struct {
  //! Red, green and blue color values
  @Float() // ai_real
  double r, g, b;
} // !struct aiColor3D

// ----------------------------------------------------------------------------------
/** Represents an UTF-8 string, zero byte terminated.
 *
 *  The character set of an aiString is explicitly defined to be UTF-8. This Unicode
 *  transformation was chosen in the belief that most strings in 3d files are limited
 *  to ASCII, thus the character set needed to be strictly ASCII compatible.
 *
 *  Most text file loaders provide proper Unicode input file handling, special unicode
 *  characters are correctly transcoded to UTF8 and are kept throughout the libraries'
 *  import pipeline.
 *
 *  For most applications, it will be absolutely sufficient to interpret the
 *  aiString as ASCII data and work with it as one would work with a plain char*.
 *  Windows users in need of proper support for i.e asian characters can use the
 *  MultiByteToWideChar(), WideCharToMultiByte() WinAPI functionality to convert the
 *  UTF-8 strings to their working character set (i.e. MBCS, WideChar).
 *
 *  We use this representation instead of std::string to be C-compatible. The
 *  (binary) length of such a string is limited to MAXLEN characters (including the
 *  the terminating zero).
*/
class aiString extends Struct {
  /** Binary length of the string excluding the terminal 0. This is NOT the
   *  logical length of strings containing UTF-8 multi-byte sequences! It's
   *  the number of bytes from the beginning of the string to its end.*/
  @Uint32() // ai_uint32
  int length;

  /** String buffer. Size limit is MAXLEN */
  Pointer<Int8> data; // MAXLEN
} // !struct aiString

// ----------------------------------------------------------------------------------
/** Standard return type for some library functions.
 * Rarely used, and if, mostly in the C API.
 */
class aiReturn {
  /** Indicates that a function was successful */
  static const int SUCCESS = 0x0;

  /** Indicates that a function failed */
  static const int FAILURE = -0x1;

  /** Indicates that not enough memory was available
     * to perform the requested operation
     */
  static const int OUTOFMEMORY = -0x3;
} // !enum aiReturn

// ----------------------------------------------------------------------------------
/** Seek origins (for the virtual file system API).
 *  Much cooler than using SEEK_SET, SEEK_CUR or SEEK_END.
 */
class aiOrigin {
  /** Beginning of the file */
  static const int SET = 0x0;

  /** Current position of the file pointer */
  static const int CUR = 0x1;

  /** End of the file, offsets must be negative */
  static const int END = 0x2;
} // !enum aiOrigin

// ----------------------------------------------------------------------------------
/** @brief Enumerates predefined log streaming destinations.
 *  Logging to these streams can be enabled with a single call to
 *   #LogStream::createDefaultStream.
 */
class aiDefaultLogStream {
  /** Stream the log to a file */
  static const int FILE = 0x1;

  /** Stream the log to std::cout */
  static const int STDOUT = 0x2;

  /** Stream the log to std::cerr */
  static const int STDERR = 0x4;

  /** MSVC only: Stream the log the the debugger
     * (this relies on OutputDebugString from the Win32 SDK)
     */
  static const int DEBUGGER = 0x8;
} // !enum aiDefaultLogStream

// ----------------------------------------------------------------------------------
/** Stores the memory requirements for different components (e.g. meshes, materials,
 *  animations) of an import. All sizes are in bytes.
 *  @see Importer::GetMemoryRequirements()
*/
class aiMemoryInfo extends Struct {
  /** Storage allocated for texture data */
  @Uint32()
  int textures;

  /** Storage allocated for material data  */
  @Uint32()
  int materials;

  /** Storage allocated for mesh data */
  @Uint32()
  int meshes;

  /** Storage allocated for node data */
  @Uint32()
  int nodes;

  /** Storage allocated for animation data */
  @Uint32()
  int animations;

  /** Storage allocated for camera data */
  @Uint32()
  int cameras;

  /** Storage allocated for light data */
  @Uint32()
  int lights;

  /** Total storage allocated for the full import. */
  @Uint32()
  int total;
} // !struct aiMemoryInfo
