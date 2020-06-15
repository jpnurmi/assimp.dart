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

/** @file  cexport.h
*  @brief Defines the C-API for the Assimp export interface
*/

import 'types.dart';
import 'dylib.dart';
import 'scene.dart';
import 'cfileio.dart';

// --------------------------------------------------------------------------------
/** Describes an file format which Assimp can export to. Use #aiGetExportFormatCount() to
* learn how many export formats the current Assimp build supports and #aiGetExportFormatDescription()
* to retrieve a description of an export format option.
*/
class aiExportFormatDesc extends Struct {
  /// a short string ID to uniquely identify the export format. Use this ID string to
  /// specify which file format you want to export to when calling #aiExportScene().
  /// Example: "dae" or "obj"
  Pointer<Utf8> id;

  /// A short description of the file format to present to users. Useful if you want
  /// to allow the user to select an export format.
  Pointer<Utf8> description;

  /// Recommended file extension for the exported file in lower case.
  Pointer<Utf8> fileExtension;
}

// --------------------------------------------------------------------------------
/** Returns the number of export file formats available in the current Assimp build.
 * Use aiGetExportFormatDescription() to retrieve infos of a specific export format.
 */
typedef aiGetExportFormatCount_t = Uint32 Function();
typedef aiGetExportFormatCount_f = int Function();

aiGetExportFormatCount_f _aiGetExportFormatCount;
get aiGetExportFormatCount => _aiGetExportFormatCount ??= libassimp
    .lookupFunction<aiGetExportFormatCount_t, aiGetExportFormatCount_f>(
        'aiGetExportFormatCount');

// --------------------------------------------------------------------------------
/** Returns a description of the nth export file format. Use #aiGetExportFormatCount()
 * to learn how many export formats are supported. The description must be released by
 * calling aiReleaseExportFormatDescription afterwards.
 * @param pIndex Index of the export format to retrieve information for. Valid range is
 *    0 to #aiGetExportFormatCount()
 * @return A description of that specific export format. NULL if pIndex is out of range.
 */
typedef aiGetExportFormatDescription_t = Pointer<aiExportFormatDesc> Function(
    Uint32 index);
typedef aiGetExportFormatDescription_f = Pointer<aiExportFormatDesc> Function(
    int index);

aiGetExportFormatDescription_f _aiGetExportFormatDescription;
get aiGetExportFormatDescription =>
    _aiGetExportFormatDescription ??= libassimp.lookupFunction<
        aiGetExportFormatDescription_t,
        aiGetExportFormatDescription_f>('aiGetExportFormatDescription');

// --------------------------------------------------------------------------------
/** Release a description of the nth export file format. Must be returned by
* aiGetExportFormatDescription
* @param desc Pointer to the description
*/
typedef aiReleaseExportFormatDescription_t = Void Function(
    Pointer<aiExportFormatDesc> desc);
typedef aiReleaseExportFormatDescription_f = void Function(
    Pointer<aiExportFormatDesc> desc);

aiReleaseExportFormatDescription_f _aiReleaseExportFormatDescription;
get aiReleaseExportFormatDescription =>
    _aiReleaseExportFormatDescription ??= libassimp.lookupFunction<
        aiReleaseExportFormatDescription_t,
        aiReleaseExportFormatDescription_f>('aiReleaseExportFormatDescription');

// --------------------------------------------------------------------------------
/** Create a modifiable copy of a scene.
 *  This is useful to import files via Assimp, change their topology and
 *  export them again. Since the scene returned by the various importer functions
 *  is const, a modifiable copy is needed.
 *  @param pIn Valid scene to be copied
 *  @param pOut Receives a modifyable copy of the scene. Use aiFreeScene() to
 *    delete it again.
 */
typedef aiCopyScene_t = Void Function(
    Pointer<aiScene> scene, Pointer<Pointer<aiScene>> out);
typedef aiCopyScene_f = void Function(
    Pointer<aiScene> scene, Pointer<Pointer<aiScene>> out);

aiCopyScene_f _aiCopyScene;
get aiCopyScene => _aiCopyScene ??=
    libassimp.lookupFunction<aiCopyScene_t, aiCopyScene_f>('aiCopyScene');

// --------------------------------------------------------------------------------
/** Frees a scene copy created using aiCopyScene() */
typedef aiFreeScene_t = Void Function(Pointer<aiScene> scene);
typedef aiFreeScene_f = void Function(Pointer<aiScene> scene);

aiFreeScene_f _aiFreeScene;
get aiFreeScene => _aiFreeScene ??=
    libassimp.lookupFunction<aiFreeScene_t, aiFreeScene_f>('aiFreeScene');

// --------------------------------------------------------------------------------
/** Exports the given scene to a chosen file format and writes the result file(s) to disk.
* @param pScene The scene to export. Stays in possession of the caller, is not changed by the function.
*   The scene is expected to conform to Assimp's Importer output format as specified
*   in the @link data Data Structures Page @endlink. In short, this means the model data
*   should use a right-handed coordinate systems, face winding should be counter-clockwise
*   and the UV coordinate origin is assumed to be in the upper left. If your input data
*   uses different conventions, have a look at the last parameter.
* @param pFormatId ID string to specify to which format you want to export to. Use
* aiGetExportFormatCount() / aiGetExportFormatDescription() to learn which export formats are available.
* @param pFileName Output file to write
* @param pPreprocessing Accepts any choice of the #aiPostProcessSteps enumerated
*   flags, but in reality only a subset of them makes sense here. Specifying
*   'preprocessing' flags is useful if the input scene does not conform to
*   Assimp's default conventions as specified in the @link data Data Structures Page @endlink.
*   In short, this means the geometry data should use a right-handed coordinate systems, face
*   winding should be counter-clockwise and the UV coordinate origin is assumed to be in
*   the upper left. The #aiProcess_MakeLeftHanded, #aiProcess_FlipUVs and
*   #aiProcess_FlipWindingOrder flags are used in the import side to allow users
*   to have those defaults automatically adapted to their conventions. Specifying those flags
*   for exporting has the opposite effect, respectively. Some other of the
*   #aiPostProcessSteps enumerated values may be useful as well, but you'll need
*   to try out what their effect on the exported file is. Many formats impose
*   their own restrictions on the structure of the geometry stored therein,
*   so some preprocessing may have little or no effect at all, or may be
*   redundant as exporters would apply them anyhow. A good example
*   is triangulation - whilst you can enforce it by specifying
*   the #aiProcess_Triangulate flag, most export formats support only
*   triangulate data so they would run the step anyway.
*
*   If assimp detects that the input scene was directly taken from the importer side of
*   the library (i.e. not copied using aiCopyScene and potetially modified afterwards),
*   any postprocessing steps already applied to the scene will not be applied again, unless
*   they show non-idempotent behaviour (#aiProcess_MakeLeftHanded, #aiProcess_FlipUVs and
*   #aiProcess_FlipWindingOrder).
* @return a status code indicating the result of the export
* @note Use aiCopyScene() to get a modifiable copy of a previously
*   imported scene.
*/
typedef aiExportScene_t = Uint32 Function(Pointer<aiScene> scene,
    Pointer<Utf8> formatId, Pointer<Utf8> fileName, Uint32 preprocessing);
typedef aiExportScene_f = int Function(Pointer<aiScene> scene,
    Pointer<Utf8> formatId, Pointer<Utf8> fileName, int preprocessing);

aiExportScene_f _aiExportScene;
get aiExportScene => _aiExportScene ??=
    libassimp.lookupFunction<aiExportScene_t, aiExportScene_f>('aiExportScene');

// --------------------------------------------------------------------------------
/** Exports the given scene to a chosen file format using custom IO logic supplied by you.
* @param pScene The scene to export. Stays in possession of the caller, is not changed by the function.
* @param pFormatId ID string to specify to which format you want to export to. Use
* aiGetExportFormatCount() / aiGetExportFormatDescription() to learn which export formats are available.
* @param pFileName Output file to write
* @param pIO custom IO implementation to be used. Use this if you use your own storage methods.
*   If none is supplied, a default implementation using standard file IO is used. Note that
*   #aiExportSceneToBlob is provided as convenience function to export to memory buffers.
* @param pPreprocessing Please see the documentation for #aiExportScene
* @return a status code indicating the result of the export
* @note Include <aiFileIO.h> for the definition of #aiFileIO.
* @note Use aiCopyScene() to get a modifiable copy of a previously
*   imported scene.
*/
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

aiExportSceneEx_f _aiExportSceneEx;
get aiExportSceneEx => _aiExportSceneEx ??= libassimp
    .lookupFunction<aiExportSceneEx_t, aiExportSceneEx_f>('aiExportSceneEx');

// --------------------------------------------------------------------------------
/** Describes a blob of exported scene data. Use #aiExportSceneToBlob() to create a blob containing an
* exported scene. The memory referred by this structure is owned by Assimp.
* to free its resources. Don't try to free the memory on your side - it will crash for most build configurations
* due to conflicting heaps.
*
* Blobs can be nested - each blob may reference another blob, which may in turn reference another blob and so on.
* This is used when exporters write more than one output file for a given #aiScene. See the remarks for
* #aiExportDataBlob::name for more information.
*/
class aiExportDataBlob extends Struct {
  /// Size of the data in bytes
  @Uint32()
  int size;

  /// The data.
  Pointer<Void> data;

  /** Name of the blob. An empty string always
        indicates the first (and primary) blob,
        which contains the actual file data.
        Any other blobs are auxiliary files produced
        by exporters (i.e. material files). Existence
        of such files depends on the file format. Most
        formats don't split assets across multiple files.

        If used, blob names usually contain the file
        extension that should be used when writing
        the data to disc.
     */
  Pointer<aiString> name;

  /** Pointer to the next blob in the chain or NULL if there is none. */
  Pointer<aiExportDataBlob> next;
}

// --------------------------------------------------------------------------------
/** Exports the given scene to a chosen file format. Returns the exported data as a binary blob which
* you can write into a file or something. When you're done with the data, use #aiReleaseExportBlob()
* to free the resources associated with the export.
* @param pScene The scene to export. Stays in possession of the caller, is not changed by the function.
* @param pFormatId ID string to specify to which format you want to export to. Use
* #aiGetExportFormatCount() / #aiGetExportFormatDescription() to learn which export formats are available.
* @param pPreprocessing Please see the documentation for #aiExportScene
* @return the exported data or NULL in case of error
*/
typedef aiExportSceneToBlob_t = Pointer<aiExportDataBlob> Function(
    Pointer<aiScene> scene, Pointer<Utf8> formatId, Uint32 preprocessing);
typedef aiExportSceneToBlob_f = Pointer<aiExportDataBlob> Function(
    Pointer<aiScene> scene, Pointer<Utf8> formatId, int preprocessing);

aiExportSceneToBlob_f _aiExportSceneToBlob;
get aiExportSceneToBlob => _aiExportSceneToBlob ??=
    libassimp.lookupFunction<aiExportSceneToBlob_t, aiExportSceneToBlob_f>(
        'aiExportSceneToBlob');

// --------------------------------------------------------------------------------
/** Releases the memory associated with the given exported data. Use this function to free a data blob
* returned by aiExportScene().
* @param pData the data blob returned by #aiExportSceneToBlob
*/
typedef aiReleaseExportBlob_t = Void Function(Pointer<aiExportDataBlob> data);
typedef aiReleaseExportBlob_f = void Function(Pointer<aiExportDataBlob> data);

aiReleaseExportBlob_f _aiReleaseExportBlob;
get aiReleaseExportBlob => _aiReleaseExportBlob ??=
    libassimp.lookupFunction<aiReleaseExportBlob_t, aiReleaseExportBlob_f>(
        'aiReleaseExportBlob');
