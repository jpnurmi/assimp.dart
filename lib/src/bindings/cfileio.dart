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

/** @file cfileio.h
 *  @brief Defines generic C routines to access memory-mapped files
 */

import 'package:ffi/ffi.dart';

import 'types.dart';

//struct aiFileIO;
//struct aiFile;

// aiFile callbacks
typedef aiFileWriteProc_t = Uint32 Function(
    Pointer<aiFile> file, Pointer<Utf8>, Uint32, Uint32);
typedef aiFileReadProc_t = Uint32 Function(
    Pointer<aiFile> file, Pointer<Utf8>, Uint32, Uint32);
typedef aiFileTellProc_t = Uint32 Function(Pointer<aiFile> file);
typedef aiFileFlushProc_t = Void Function(Pointer<aiFile> file);
typedef aiFileSeek_t = Uint32 Function(Pointer<aiFile> file, Uint32, Uint32);

// aiFileIO callbacks
typedef aiFileOpenProc_t = Pointer<aiFile> Function(
    Pointer<aiFileIO> file, Pointer<Utf8>, Pointer<Utf8>);
typedef aiFileCloseProc_t = Void Function(
    Pointer<aiFileIO> file, Pointer<aiFile>);

// ----------------------------------------------------------------------------------
/** @brief C-API: File system callbacks
 *
 *  Provided are functions to open and close files. Supply a custom structure to
 *  the import function. If you don't, a default implementation is used. Use custom
 *  file systems to enable reading from other sources, such as ZIPs
 *  or memory locations. */
class aiFileIO extends Struct {
  /** Function used to open a new file
     */
  Pointer<NativeFunction> OpenProc; // aiFileOpenProc_t

  /** Function used to close an existing file
     */
  Pointer<NativeFunction> CloseProc; // aiFileCloseProc_t

  /** User-defined, opaque data */
  Pointer<Void> UserData;
}

// ----------------------------------------------------------------------------------
/** @brief C-API: File callbacks
 *
 *  Actually, it's a data structure to wrap a set of fXXXX (e.g fopen)
 *  replacement functions.
 *
 *  The default implementation of the functions utilizes the fXXX functions from
 *  the CRT. However, you can supply a custom implementation to Assimp by
 *  delivering a custom aiFileIO. Use this to enable reading from other sources,
 *  such as ZIP archives or memory locations. */
class aiFile extends Struct {
  /** Callback to read from a file */
  Pointer<NativeFunction> ReadProc; // aiFileReadProc_t

  /** Callback to write to a file */
  Pointer<NativeFunction> WriteProc; // aiFileWriteProc_t

  /** Callback to retrieve the current position of
     *  the file cursor (ftell())
     */
  Pointer<NativeFunction> TellProc; // aiFileTellProc_t

  /** Callback to retrieve the size of the file,
     *  in bytes
     */
  Pointer<NativeFunction> FileSizeProc; // aiFileTellProc_t

  /** Callback to set the current position
     * of the file cursor (fseek())
     */
  Pointer<NativeFunction> SeekProc; // aiFileSeek_t

  /** Callback to flush the file contents
     */
  Pointer<NativeFunction> FlushProc; // aiFileFlushProc_t

  /** User-defined, opaque data
     */
  Pointer<Void> UserData;
}
