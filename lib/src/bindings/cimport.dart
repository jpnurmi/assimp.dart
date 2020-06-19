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

/** @file  cimport.h
 *  @brief Defines the C-API to the Open Asset Import Library.
 */

import 'package:ffi/ffi.dart';

import 'types.dart';
import 'importerdesc.dart';
import 'memoryinfo.dart';
import 'dylib.dart';
import 'scene.dart';
import 'cfileio.dart';

typedef aiLogStreamCallback_t = Void Function(
    Pointer<Utf8> message, Pointer<Utf8> user);

// --------------------------------------------------------------------------------
/** C-API: Represents a log stream. A log stream receives all log messages and
 *  streams them _somewhere_.
 *  @see aiGetPredefinedLogStream
 *  @see aiAttachLogStream
 *  @see aiDetachLogStream */
// --------------------------------------------------------------------------------
class aiLogStream extends Struct {
  /** callback to be called */
  Pointer<NativeFunction> callback; // aiLogStreamCallback_t

  /** user data to be passed to the callback */
  Pointer<Utf8> user;
}

// --------------------------------------------------------------------------------
/** C-API: Represents an opaque set of settings to be used during importing.
 *  @see aiCreatePropertyStore
 *  @see aiReleasePropertyStore
 *  @see aiImportFileExWithProperties
 *  @see aiSetPropertyInteger
 *  @see aiSetPropertyFloat
 *  @see aiSetPropertyString
 *  @see aiSetPropertyMatrix
 */
// --------------------------------------------------------------------------------
class aiPropertyStore extends Struct {
  @Int8()
  int sentinel;
}

const int AI_FALSE = 0;
const int AI_TRUE = 1;

// --------------------------------------------------------------------------------
/** Reads the given file and returns its content.
 *
 * If the call succeeds, the imported data is returned in an aiScene structure.
 * The data is intended to be read-only, it stays property of the ASSIMP
 * library and will be stable until aiReleaseImport() is called. After you're
 * done with it, call aiReleaseImport() to free the resources associated with
 * this file. If the import fails, NULL is returned instead. Call
 * aiGetErrorString() to retrieve a human-readable error text.
 * @param pFile Path and filename of the file to be imported,
 *   expected to be a null-terminated c-string. NULL is not a valid value.
 * @param pFlags Optional post processing steps to be executed after
 *   a successful import. Provide a bitwise combination of the
 *   #aiPostProcessSteps flags.
 * @return Pointer to the imported data or NULL if the import failed.
 */
typedef aiImportFile_t = Pointer<aiScene> Function(
    Pointer<Utf8> file, Uint32 flags);
typedef aiImportFile_f = Pointer<aiScene> Function(
    Pointer<Utf8> file, int flags);

aiImportFile_f _aiImportFile;
get aiImportFile => _aiImportFile ??=
    libassimp.lookupFunction<aiImportFile_t, aiImportFile_f>('aiImportFile');

// --------------------------------------------------------------------------------
/** Reads the given file using user-defined I/O functions and returns
 *   its content.
 *
 * If the call succeeds, the imported data is returned in an aiScene structure.
 * The data is intended to be read-only, it stays property of the ASSIMP
 * library and will be stable until aiReleaseImport() is called. After you're
 * done with it, call aiReleaseImport() to free the resources associated with
 * this file. If the import fails, NULL is returned instead. Call
 * aiGetErrorString() to retrieve a human-readable error text.
 * @param pFile Path and filename of the file to be imported,
 *   expected to be a null-terminated c-string. NULL is not a valid value.
 * @param pFlags Optional post processing steps to be executed after
 *   a successful import. Provide a bitwise combination of the
 *   #aiPostProcessSteps flags.
 * @param pFS aiFileIO structure. Will be used to open the model file itself
 *   and any other files the loader needs to open.  Pass NULL to use the default
 *   implementation.
 * @return Pointer to the imported data or NULL if the import failed.
 * @note Include <aiFileIO.h> for the definition of #aiFileIO.
 */
typedef aiImportFileEx_t = Pointer<aiScene> Function(
    Pointer<Utf8> file, Uint32 flags, Pointer<aiFileIO> fs);
typedef aiImportFileEx_f = Pointer<aiScene> Function(
    Pointer<Utf8> file, int flags, Pointer<aiFileIO> fs);

aiImportFileEx_f _aiImportFileEx;
get aiImportFileEx => _aiImportFileEx ??= libassimp
    .lookupFunction<aiImportFileEx_t, aiImportFileEx_f>('aiImportFileEx');

// --------------------------------------------------------------------------------
/** Same as #aiImportFileEx, but adds an extra parameter containing importer settings.
 *
 * @param pFile Path and filename of the file to be imported,
 *   expected to be a null-terminated c-string. NULL is not a valid value.
 * @param pFlags Optional post processing steps to be executed after
 *   a successful import. Provide a bitwise combination of the
 *   #aiPostProcessSteps flags.
 * @param pFS aiFileIO structure. Will be used to open the model file itself
 *   and any other files the loader needs to open.  Pass NULL to use the default
 *   implementation.
 * @param pProps #aiPropertyStore instance containing import settings.
 * @return Pointer to the imported data or NULL if the import failed.
 * @note Include <aiFileIO.h> for the definition of #aiFileIO.
 * @see aiImportFileEx
 */
typedef aiImportFileExWithProperties_t = Pointer<aiScene> Function(
    Pointer<Utf8> file,
    Uint32 flags,
    Pointer<aiFileIO> fs,
    Pointer<aiPropertyStore> props);
typedef aiImportFileExWithProperties_f = Pointer<aiScene> Function(
    Pointer<Utf8> file,
    int flags,
    Pointer<aiFileIO> fs,
    Pointer<aiPropertyStore> props);

aiImportFileExWithProperties_f _aiImportFileExWithProperties;
get aiImportFileExWithProperties =>
    _aiImportFileExWithProperties ??= libassimp.lookupFunction<
        aiImportFileExWithProperties_t,
        aiImportFileExWithProperties_f>('aiImportFileExWithProperties');

// --------------------------------------------------------------------------------
/** Reads the given file from a given memory buffer,
 *
 * If the call succeeds, the contents of the file are returned as a pointer to an
 * aiScene object. The returned data is intended to be read-only, the importer keeps
 * ownership of the data and will destroy it upon destruction. If the import fails,
 * NULL is returned.
 * A human-readable error description can be retrieved by calling aiGetErrorString().
 * @param pBuffer Pointer to the file data
 * @param pLength Length of pBuffer, in bytes
 * @param pFlags Optional post processing steps to be executed after
 *   a successful import. Provide a bitwise combination of the
 *   #aiPostProcessSteps flags. If you wish to inspect the imported
 *   scene first in order to fine-tune your post-processing setup,
 *   consider to use #aiApplyPostProcessing().
 * @param pHint An additional hint to the library. If this is a non empty string,
 *   the library looks for a loader to support the file extension specified by pHint
 *   and passes the file to the first matching loader. If this loader is unable to
 *   completely the request, the library continues and tries to determine the file
 *   format on its own, a task that may or may not be successful.
 *   Check the return value, and you'll know ...
 * @return A pointer to the imported data, NULL if the import failed.
 *
 * @note This is a straightforward way to decode models from memory
 * buffers, but it doesn't handle model formats that spread their
 * data across multiple files or even directories. Examples include
 * OBJ or MD3, which outsource parts of their material info into
 * external scripts. If you need full functionality, provide
 * a custom IOSystem to make Assimp find these files and use
 * the regular aiImportFileEx()/aiImportFileExWithProperties() API.
 */
typedef aiImportFileFromMemory_t = Pointer<aiScene> Function(
    Pointer<Utf8> buffer, Uint32 length, Uint32 flags, Pointer<Utf8> hint);
typedef aiImportFileFromMemory_f = Pointer<aiScene> Function(
    Pointer<Utf8> buffer, int length, int flags, Pointer<Utf8> hint);

aiImportFileFromMemory_f _aiImportFileFromMemory;
get aiImportFileFromMemory => _aiImportFileFromMemory ??= libassimp
    .lookupFunction<aiImportFileFromMemory_t, aiImportFileFromMemory_f>(
        'aiImportFileFromMemory');

// --------------------------------------------------------------------------------
/** Same as #aiImportFileFromMemory, but adds an extra parameter containing importer settings.
 *
 * @param pBuffer Pointer to the file data
 * @param pLength Length of pBuffer, in bytes
 * @param pFlags Optional post processing steps to be executed after
 *   a successful import. Provide a bitwise combination of the
 *   #aiPostProcessSteps flags. If you wish to inspect the imported
 *   scene first in order to fine-tune your post-processing setup,
 *   consider to use #aiApplyPostProcessing().
 * @param pHint An additional hint to the library. If this is a non empty string,
 *   the library looks for a loader to support the file extension specified by pHint
 *   and passes the file to the first matching loader. If this loader is unable to
 *   completely the request, the library continues and tries to determine the file
 *   format on its own, a task that may or may not be successful.
 *   Check the return value, and you'll know ...
 * @param pProps #aiPropertyStore instance containing import settings.
 * @return A pointer to the imported data, NULL if the import failed.
 *
 * @note This is a straightforward way to decode models from memory
 * buffers, but it doesn't handle model formats that spread their
 * data across multiple files or even directories. Examples include
 * OBJ or MD3, which outsource parts of their material info into
 * external scripts. If you need full functionality, provide
 * a custom IOSystem to make Assimp find these files and use
 * the regular aiImportFileEx()/aiImportFileExWithProperties() API.
 * @see aiImportFileFromMemory
 */
typedef aiImportFileFromMemoryWithProperties_t = Pointer<aiScene> Function(
    Pointer<Utf8> buffer,
    Uint32 length,
    Uint32 flags,
    Pointer<Utf8> hint,
    Pointer<aiPropertyStore> props);
typedef aiImportFileFromMemoryWithProperties_f = Pointer<aiScene> Function(
    Pointer<Utf8> buffer,
    int length,
    int flags,
    Pointer<Utf8> hint,
    Pointer<aiPropertyStore> props);

aiImportFileFromMemoryWithProperties_f _aiImportFileFromMemoryWithProperties;
get aiImportFileFromMemoryWithProperties =>
    _aiImportFileFromMemoryWithProperties ??= libassimp.lookupFunction<
            aiImportFileFromMemoryWithProperties_t,
            aiImportFileFromMemoryWithProperties_f>(
        'aiImportFileFromMemoryWithProperties');

// --------------------------------------------------------------------------------
/** Apply post-processing to an already-imported scene.
 *
 * This is strictly equivalent to calling #aiImportFile()/#aiImportFileEx with the
 * same flags. However, you can use this separate function to inspect the imported
 * scene first to fine-tune your post-processing setup.
 * @param pScene Scene to work on.
 * @param pFlags Provide a bitwise combination of the #aiPostProcessSteps flags.
 * @return A pointer to the post-processed data. Post processing is done in-place,
 *   meaning this is still the same #aiScene which you passed for pScene. However,
 *   _if_ post-processing failed, the scene could now be NULL. That's quite a rare
 *   case, post processing steps are not really designed to 'fail'. To be exact,
 *   the #aiProcess_ValidateDataStructure flag is currently the only post processing step
 *   which can actually cause the scene to be reset to NULL.
 */
typedef aiApplyPostProcessing_t = Pointer<aiScene> Function(
    Pointer<aiScene> scene, Uint32 flags);
typedef aiApplyPostProcessing_f = Pointer<aiScene> Function(
    Pointer<aiScene> scene, int flags);

aiApplyPostProcessing_f _aiApplyPostProcessing;
get aiApplyPostProcessing => _aiApplyPostProcessing ??=
    libassimp.lookupFunction<aiApplyPostProcessing_t, aiApplyPostProcessing_f>(
        'aiApplyPostProcessing');

// --------------------------------------------------------------------------------
/** Get one of the predefine log streams. This is the quick'n'easy solution to
 *  access Assimp's log system. Attaching a log stream can slightly reduce Assimp's
 *  overall import performance.
 *
 *  Usage is rather simple (this will stream the log to a file, named log.txt, and
 *  the stdout stream of the process:
 *  @code
 *    struct aiLogStream c;
 *    c = aiGetPredefinedLogStream(aiDefaultLogStream_FILE,"log.txt");
 *    aiAttachLogStream(&c);
 *    c = aiGetPredefinedLogStream(aiDefaultLogStream_STDOUT,NULL);
 *    aiAttachLogStream(&c);
 *  @endcode
 *
 *  @param pStreams One of the #aiDefaultLogStream enumerated values.
 *  @param file Solely for the #aiDefaultLogStream_FILE flag: specifies the file to write to.
 *    Pass NULL for all other flags.
 *  @return The log stream. callback is set to NULL if something went wrong.
 */
typedef aiGetPredefinedLogStream_t = Pointer<aiLogStream> Function(
    Uint32 streams, // aiDefaultLogStream
    Pointer<Utf8> file);
typedef aiGetPredefinedLogStream_f = Pointer<aiLogStream> Function(
    int streams, // aiDefaultLogStream
    Pointer<Utf8> file);

aiGetPredefinedLogStream_f _aiGetPredefinedLogStream;
get aiGetPredefinedLogStream => _aiGetPredefinedLogStream ??= libassimp
    .lookupFunction<aiGetPredefinedLogStream_t, aiGetPredefinedLogStream_f>(
        'aiGetPredefinedLogStream');

// --------------------------------------------------------------------------------
/** Attach a custom log stream to the libraries' logging system.
 *
 *  Attaching a log stream can slightly reduce Assimp's overall import
 *  performance. Multiple log-streams can be attached.
 *  @param stream Describes the new log stream.
 *  @note To ensure proper destruction of the logging system, you need to manually
 *    call aiDetachLogStream() on every single log stream you attach.
 *    Alternatively (for the lazy folks) #aiDetachAllLogStreams is provided.
 */
typedef aiAttachLogStream_t = Void Function(Pointer<aiLogStream> stream);
typedef aiAttachLogStream_f = void Function(Pointer<aiLogStream> stream);

aiAttachLogStream_f _aiAttachLogStream;
get aiAttachLogStream => _aiAttachLogStream ??=
    libassimp.lookupFunction<aiAttachLogStream_t, aiAttachLogStream_f>(
        'aiAttachLogStream');

// --------------------------------------------------------------------------------
/** Enable verbose logging. Verbose logging includes debug-related stuff and
 *  detailed import statistics. This can have severe impact on import performance
 *  and memory consumption. However, it might be useful to find out why a file
 *  didn't read correctly.
 *  @param d AI_TRUE or AI_FALSE, your decision.
 */
typedef aiEnableVerboseLogging_t = Void Function(Int32 d);
typedef aiEnableVerboseLogging_f = void Function(int d);

aiEnableVerboseLogging_f _aiEnableVerboseLogging;
get aiEnableVerboseLogging => _aiEnableVerboseLogging ??= libassimp
    .lookupFunction<aiEnableVerboseLogging_t, aiEnableVerboseLogging_f>(
        'aiEnableVerboseLogging');

// --------------------------------------------------------------------------------
/** Detach a custom log stream from the libraries' logging system.
 *
 *  This is the counterpart of #aiAttachLogStream. If you attached a stream,
 *  don't forget to detach it again.
 *  @param stream The log stream to be detached.
 *  @return AI_SUCCESS if the log stream has been detached successfully.
 *  @see aiDetachAllLogStreams
 */
typedef aiDetachLogStream_t = Uint32 Function(Pointer<aiLogStream> stream);
typedef aiDetachLogStream_f = int Function(Pointer<aiLogStream> stream);

aiDetachLogStream_f _aiDetachLogStream;
get aiDetachLogStream => _aiDetachLogStream ??=
    libassimp.lookupFunction<aiDetachLogStream_t, aiDetachLogStream_f>(
        'aiDetachLogStream');

// --------------------------------------------------------------------------------
/** Detach all active log streams from the libraries' logging system.
 *  This ensures that the logging system is terminated properly and all
 *  resources allocated by it are actually freed. If you attached a stream,
 *  don't forget to detach it again.
 *  @see aiAttachLogStream
 *  @see aiDetachLogStream
 */
typedef aiDetachAllLogStreams_t = Void Function();
typedef aiDetachAllLogStreams_f = void Function();

aiDetachAllLogStreams_f _aiDetachAllLogStreams;
get aiDetachAllLogStreams => _aiDetachAllLogStreams ??=
    libassimp.lookupFunction<aiDetachAllLogStreams_t, aiDetachAllLogStreams_f>(
        'aiDetachAllLogStreams');

// --------------------------------------------------------------------------------
/** Releases all resources associated with the given import process.
 *
 * Call this function after you're done with the imported data.
 * @param pScene The imported data to release. NULL is a valid value.
 */
typedef aiReleaseImport_t = Void Function(Pointer<aiScene> scene);
typedef aiReleaseImport_f = void Function(Pointer<aiScene> scene);

aiReleaseImport_f _aiReleaseImport;
get aiReleaseImport => _aiReleaseImport ??= libassimp
    .lookupFunction<aiReleaseImport_t, aiReleaseImport_f>('aiReleaseImport');

// --------------------------------------------------------------------------------
/** Returns the error text of the last failed import process.
 *
 * @return A textual description of the error that occurred at the last
 * import process. NULL if there was no error. There can't be an error if you
 * got a non-NULL #aiScene from #aiImportFile/#aiImportFileEx/#aiApplyPostProcessing.
 */
typedef aiGetErrorString_t = Pointer<Utf8> Function();
typedef aiGetErrorString_f = Pointer<Utf8> Function();

aiGetErrorString_f _aiGetErrorString;
get aiGetErrorString => _aiGetErrorString ??= libassimp
    .lookupFunction<aiGetErrorString_t, aiGetErrorString_f>('aiGetErrorString');

// --------------------------------------------------------------------------------
/** Returns whether a given file extension is supported by ASSIMP
 *
 * @param szExtension Extension for which the function queries support for.
 * Must include a leading dot '.'. Example: ".3ds", ".md3"
 * @return AI_TRUE if the file extension is supported.
 */
typedef aiIsExtensionSupported_t = Int32 Function(Pointer<Utf8> extension);
typedef aiIsExtensionSupported_f = int Function(Pointer<Utf8> extension);

aiIsExtensionSupported_f _aiIsExtensionSupported;
get aiIsExtensionSupported => _aiIsExtensionSupported ??= libassimp
    .lookupFunction<aiIsExtensionSupported_t, aiIsExtensionSupported_f>(
        'aiIsExtensionSupported');

// --------------------------------------------------------------------------------
/** Get a list of all file extensions supported by ASSIMP.
 *
 * If a file extension is contained in the list this does, of course, not
 * mean that ASSIMP is able to load all files with this extension.
 * @param szOut String to receive the extension list.
 * Format of the list: "*.3ds;*.obj;*.dae". NULL is not a valid parameter.
 */
typedef aiGetExtensionList_t = Void Function(Pointer<aiString> out);
typedef aiGetExtensionList_f = void Function(Pointer<aiString> out);

aiGetExtensionList_f _aiGetExtensionList;
get aiGetExtensionList => _aiGetExtensionList ??=
    libassimp.lookupFunction<aiGetExtensionList_t, aiGetExtensionList_f>(
        'aiGetExtensionList');

// --------------------------------------------------------------------------------
/** Get the approximated storage required by an imported asset
 * @param pIn Input asset.
 * @param in Data structure to be filled.
 */
typedef aiGetMemoryRequirements_t = Void Function(
    Pointer<aiScene> scene, Pointer<aiMemoryInfo> mem);
typedef aiGetMemoryRequirements_f = void Function(
    Pointer<aiScene> scene, Pointer<aiMemoryInfo> mem);

aiGetMemoryRequirements_f _aiGetMemoryRequirements;
get aiGetMemoryRequirements => _aiGetMemoryRequirements ??= libassimp
    .lookupFunction<aiGetMemoryRequirements_t, aiGetMemoryRequirements_f>(
        'aiGetMemoryRequirements');

// --------------------------------------------------------------------------------
/** Create an empty property store. Property stores are used to collect import
 *  settings.
 * @return New property store. Property stores need to be manually destroyed using
 *   the #aiReleasePropertyStore API function.
 */
typedef aiCreatePropertyStore_t = Pointer<aiPropertyStore> Function();
typedef aiCreatePropertyStore_f = Pointer<aiPropertyStore> Function();

aiCreatePropertyStore_f _aiCreatePropertyStore;
get aiCreatePropertyStore => _aiCreatePropertyStore ??=
    libassimp.lookupFunction<aiCreatePropertyStore_t, aiCreatePropertyStore_f>(
        'aiCreatePropertyStore');

// --------------------------------------------------------------------------------
/** Delete a property store.
 * @param p Property store to be deleted.
 */
typedef aiReleasePropertyStore_t = Void Function(
    Pointer<aiPropertyStore> store);
typedef aiReleasePropertyStore_f = void Function(
    Pointer<aiPropertyStore> store);

aiReleasePropertyStore_f _aiReleasePropertyStore;
get aiReleasePropertyStore => _aiReleasePropertyStore ??= libassimp
    .lookupFunction<aiReleasePropertyStore_t, aiReleasePropertyStore_f>(
        'aiReleasePropertyStore');

// --------------------------------------------------------------------------------
/** Set an integer property.
 *
 *  This is the C-version of #Assimp::Importer::SetPropertyInteger(). In the C
 *  interface, properties are always shared by all imports. It is not possible to
 *  specify them per import.
 *
 * @param store Store to modify. Use #aiCreatePropertyStore to obtain a store.
 * @param szName Name of the configuration property to be set. All supported
 *   public properties are defined in the config.h header file (AI_CONFIG_XXX).
 * @param value New value for the property
 */
typedef aiSetImportPropertyInteger_t = Void Function(
    Pointer<aiPropertyStore> store, Pointer<Utf8> name, Int32 value);
typedef aiSetImportPropertyInteger_f = void Function(
    Pointer<aiPropertyStore> store, Pointer<Utf8> name, int value);

aiSetImportPropertyInteger_f _aiSetImportPropertyInteger;
get aiSetImportPropertyInteger => _aiSetImportPropertyInteger ??= libassimp
    .lookupFunction<aiSetImportPropertyInteger_t, aiSetImportPropertyInteger_f>(
        'aiSetImportPropertyInteger');

// --------------------------------------------------------------------------------
/** Set a floating-point property.
 *
 *  This is the C-version of #Assimp::Importer::SetPropertyFloat(). In the C
 *  interface, properties are always shared by all imports. It is not possible to
 *  specify them per import.
 *
 * @param store Store to modify. Use #aiCreatePropertyStore to obtain a store.
 * @param szName Name of the configuration property to be set. All supported
 *   public properties are defined in the config.h header file (AI_CONFIG_XXX).
 * @param value New value for the property
 */
typedef aiSetImportPropertyFloat_t = Void Function(
    Pointer<aiPropertyStore> store, Pointer<Utf8> name, Float value);
typedef aiSetImportPropertyFloat_f = void Function(
    Pointer<aiPropertyStore> store, Pointer<Utf8> name, double value);

aiSetImportPropertyFloat_f _aiSetImportPropertyFloat;
get aiSetImportPropertyFloat => _aiSetImportPropertyFloat ??= libassimp
    .lookupFunction<aiSetImportPropertyFloat_t, aiSetImportPropertyFloat_f>(
        'aiSetImportPropertyFloat');

// --------------------------------------------------------------------------------
/** Set a string property.
 *
 *  This is the C-version of #Assimp::Importer::SetPropertyString(). In the C
 *  interface, properties are always shared by all imports. It is not possible to
 *  specify them per import.
 *
 * @param store Store to modify. Use #aiCreatePropertyStore to obtain a store.
 * @param szName Name of the configuration property to be set. All supported
 *   public properties are defined in the config.h header file (AI_CONFIG_XXX).
 * @param st New value for the property
 */
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

// --------------------------------------------------------------------------------
/** Set a matrix property.
 *
 *  This is the C-version of #Assimp::Importer::SetPropertyMatrix(). In the C
 *  interface, properties are always shared by all imports. It is not possible to
 *  specify them per import.
 *
 * @param store Store to modify. Use #aiCreatePropertyStore to obtain a store.
 * @param szName Name of the configuration property to be set. All supported
 *   public properties are defined in the config.h header file (AI_CONFIG_XXX).
 * @param mat New value for the property
 */
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

// --------------------------------------------------------------------------------
/** Construct a quaternion from a 3x3 rotation matrix.
 *  @param quat Receives the output quaternion.
 *  @param mat Matrix to 'quaternionize'.
 *  @see aiQuaternion(const aiMatrix3x3& pRotMatrix)
 */
typedef aiCreateQuaternionFromMatrix_t = Void Function(
    Pointer<aiQuaternion> quat, Pointer<aiMatrix3x3> mat);
typedef aiCreateQuaternionFromMatrix_f = void Function(
    Pointer<aiQuaternion> quat, Pointer<aiMatrix3x3> mat);

aiCreateQuaternionFromMatrix_f _aiCreateQuaternionFromMatrix;
get aiCreateQuaternionFromMatrix =>
    _aiCreateQuaternionFromMatrix ??= libassimp.lookupFunction<
        aiCreateQuaternionFromMatrix_t,
        aiCreateQuaternionFromMatrix_f>('aiCreateQuaternionFromMatrix');

// --------------------------------------------------------------------------------
/** Decompose a transformation matrix into its rotational, translational and
 *  scaling components.
 *
 * @param mat Matrix to decompose
 * @param scaling Receives the scaling component
 * @param rotation Receives the rotational component
 * @param position Receives the translational component.
 * @see aiMatrix4x4::Decompose (aiVector3D&, aiQuaternion&, aiVector3D&) const;
 */
typedef aiDecomposeMatrix_t = Void Function(
    Pointer<aiMatrix4x4> mat,
    Pointer<aiVector3D> scaling,
    Pointer<aiQuaternion> rotation,
    Pointer<aiVector3D> position);
typedef aiDecomposeMatrix_f = void Function(
    Pointer<aiMatrix4x4> mat,
    Pointer<aiVector3D> scaling,
    Pointer<aiQuaternion> rotation,
    Pointer<aiVector3D> position);

// --------------------------------------------------------------------------------
/** Transpose a 4x4 matrix.
 *  @param mat Pointer to the matrix to be transposed
 */
typedef aiTransposeMatrix4_t = Void Function(Pointer<aiMatrix4x4> mat);
typedef aiTransposeMatrix4_f = void Function(Pointer<aiMatrix4x4> mat);

aiTransposeMatrix4_f _aiTransposeMatrix4;
get aiTransposeMatrix4 => _aiTransposeMatrix4 ??=
    libassimp.lookupFunction<aiTransposeMatrix4_t, aiTransposeMatrix4_f>(
        'aiTransposeMatrix4');

// --------------------------------------------------------------------------------
/** Transpose a 3x3 matrix.
 *  @param mat Pointer to the matrix to be transposed
 */
typedef aiTransposeMatrix3_t = Void Function(Pointer<aiMatrix3x3> mat);
typedef aiTransposeMatrix3_f = void Function(Pointer<aiMatrix3x3> mat);

aiTransposeMatrix3_f _aiTransposeMatrix3;
get aiTransposeMatrix3 => _aiTransposeMatrix3 ??=
    libassimp.lookupFunction<aiTransposeMatrix3_t, aiTransposeMatrix3_f>(
        'aiTransposeMatrix3');

// --------------------------------------------------------------------------------
/** Transform a vector by a 3x3 matrix
 *  @param vec Vector to be transformed.
 *  @param mat Matrix to transform the vector with.
 */
typedef aiTransformVecByMatrix3_t = Void Function(
    Pointer<aiVector3D> vec, Pointer<aiMatrix3x3> mat);
typedef aiTransformVecByMatrix3_f = void Function(
    Pointer<aiVector3D> vec, Pointer<aiMatrix3x3> mat);

aiTransformVecByMatrix3_f _aiTransformVecByMatrix3;
get aiTransformVecByMatrix3 => _aiTransformVecByMatrix3 ??= libassimp
    .lookupFunction<aiTransformVecByMatrix3_t, aiTransformVecByMatrix3_f>(
        'aiTransformVecByMatrix3');

// --------------------------------------------------------------------------------
/** Transform a vector by a 4x4 matrix
 *  @param vec Vector to be transformed.
 *  @param mat Matrix to transform the vector with.
 */
typedef aiTransformVecByMatrix4_t = Void Function(
    Pointer<aiVector3D> vec, Pointer<aiMatrix4x4> mat);
typedef aiTransformVecByMatrix4_f = void Function(
    Pointer<aiVector3D> vec, Pointer<aiMatrix4x4> mat);

aiTransformVecByMatrix4_f _aiTransformVecByMatrix4;
get aiTransformVecByMatrix4 => _aiTransformVecByMatrix4 ??= libassimp
    .lookupFunction<aiTransformVecByMatrix4_t, aiTransformVecByMatrix4_f>(
        'aiTransformVecByMatrix4');

// --------------------------------------------------------------------------------
/** Multiply two 4x4 matrices.
 *  @param dst First factor, receives result.
 *  @param src Matrix to be multiplied with 'dst'.
 */
typedef aiMultiplyMatrix4_t = Void Function(
    Pointer<aiMatrix4x4> dst, Pointer<aiMatrix4x4> src);
typedef aiMultiplyMatrix4_f = void Function(
    Pointer<aiMatrix4x4> dst, Pointer<aiMatrix4x4> src);

aiMultiplyMatrix4_f _aiMultiplyMatrix4;
get aiMultiplyMatrix4 => _aiMultiplyMatrix4 ??=
    libassimp.lookupFunction<aiMultiplyMatrix4_t, aiMultiplyMatrix4_f>(
        'aiMultiplyMatrix4');

// --------------------------------------------------------------------------------
/** Multiply two 3x3 matrices.
 *  @param dst First factor, receives result.
 *  @param src Matrix to be multiplied with 'dst'.
 */
typedef aiMultiplyMatrix3_t = Void Function(
    Pointer<aiMatrix3x3> dst, Pointer<aiMatrix3x3> src);
typedef aiMultiplyMatrix3_f = void Function(
    Pointer<aiMatrix3x3> dst, Pointer<aiMatrix3x3> src);

aiMultiplyMatrix3_f _aiMultiplyMatrix3;
get aiMultiplyMatrix3 => _aiMultiplyMatrix3 ??=
    libassimp.lookupFunction<aiMultiplyMatrix3_t, aiMultiplyMatrix3_f>(
        'aiMultiplyMatrix3');

// --------------------------------------------------------------------------------
/** Get a 3x3 identity matrix.
 *  @param mat Matrix to receive its personal identity
 */
typedef aiIdentityMatrix3_t = Void Function(Pointer<aiMatrix3x3> mat);
typedef aiIdentityMatrix3_f = void Function(Pointer<aiMatrix3x3> mat);

aiIdentityMatrix3_f _aiIdentityMatrix3;
get aiIdentityMatrix3 => _aiIdentityMatrix3 ??=
    libassimp.lookupFunction<aiIdentityMatrix3_t, aiIdentityMatrix3_f>(
        'aiIdentityMatrix3');

// --------------------------------------------------------------------------------
/** Get a 4x4 identity matrix.
 *  @param mat Matrix to receive its personal identity
 */
typedef aiIdentityMatrix4_t = Void Function(Pointer<aiMatrix4x4> mat);
typedef aiIdentityMatrix4_f = void Function(Pointer<aiMatrix4x4> mat);

aiIdentityMatrix4_f _aiIdentityMatrix4;
get aiIdentityMatrix4 => _aiIdentityMatrix4 ??=
    libassimp.lookupFunction<aiIdentityMatrix4_t, aiIdentityMatrix4_f>(
        'aiIdentityMatrix4');

// --------------------------------------------------------------------------------
/** Returns the number of import file formats available in the current Assimp build.
 * Use aiGetImportFormatDescription() to retrieve infos of a specific import format.
 */
typedef aiGetImportFormatCount_t = Uint32 Function();
typedef aiGetImportFormatCount_f = int Function();

aiGetImportFormatCount_f _aiGetImportFormatCount;
get aiGetImportFormatCount => _aiGetImportFormatCount ??= libassimp
    .lookupFunction<aiGetImportFormatCount_t, aiGetImportFormatCount_f>(
        'aiGetImportFormatCount');

// --------------------------------------------------------------------------------
/** Returns a description of the nth import file format. Use #aiGetImportFormatCount()
 * to learn how many import formats are supported.
 * @param pIndex Index of the import format to retrieve information for. Valid range is
 *    0 to #aiGetImportFormatCount()
 * @return A description of that specific import format. NULL if pIndex is out of range.
 */
typedef aiGetImportFormatDescription_t = Pointer<aiImporterDesc> Function(
    Uint32 index);
typedef aiGetImportFormatDescription_f = Pointer<aiImporterDesc> Function(
    int index);

aiGetImportFormatDescription_f _aiGetImportFormatDescription;
get aiGetImportFormatDescription =>
    _aiGetImportFormatDescription ??= libassimp.lookupFunction<
        aiGetImportFormatDescription_t,
        aiGetImportFormatDescription_f>('aiGetImportFormatDescription');
