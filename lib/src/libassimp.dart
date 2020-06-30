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
import 'dart:io';

import 'bindings.dart';

String get _dlprefix => Platform.isWindows ? '' : 'lib';
String get _dlsuffix => Platform.isWindows
    ? '.dll'
    : Platform.isMacOS || Platform.isIOS ? '.dylib' : '.so';
String get _dlname => _dlprefix + 'assimp' + _dlsuffix;

DynamicLibrary _dlopen() {
  var path = Platform.environment['ASSIMP_LIBRARY_PATH'] ?? '';
  if (path.isEmpty ||
      Directory(path).statSync().type == FileSystemEntityType.directory) {
    final name = Platform.environment['ASSIMP_LIBRARY_NAME'] ?? _dlname;
    if (path.isNotEmpty && !path.endsWith('/')) path += '/';
    path += name;
  }
  return DynamicLibrary.open(path);
}

DynamicLibrary _libassimp;
DynamicLibrary get libassimp => _libassimp ?? _dlopen();

aiApplyPostProcessing_f _aiApplyPostProcessing;
aiApplyPostProcessing_f get aiApplyPostProcessing => _aiApplyPostProcessing ??=
    libassimp.lookupFunction<aiApplyPostProcessing_t, aiApplyPostProcessing_f>(
        'aiApplyPostProcessing');

aiAttachLogStream_f _aiAttachLogStream;
aiAttachLogStream_f get aiAttachLogStream => _aiAttachLogStream ??=
    libassimp.lookupFunction<aiAttachLogStream_t, aiAttachLogStream_f>(
        'aiAttachLogStream');

aiCopyScene_f _aiCopyScene;
aiCopyScene_f get aiCopyScene => _aiCopyScene ??=
    libassimp.lookupFunction<aiCopyScene_t, aiCopyScene_f>('aiCopyScene');

aiCreatePropertyStore_f _aiCreatePropertyStore;
aiCreatePropertyStore_f get aiCreatePropertyStore => _aiCreatePropertyStore ??=
    libassimp.lookupFunction<aiCreatePropertyStore_t, aiCreatePropertyStore_f>(
        'aiCreatePropertyStore');

aiDetachAllLogStreams_f _aiDetachAllLogStreams;
aiDetachAllLogStreams_f get aiDetachAllLogStreams => _aiDetachAllLogStreams ??=
    libassimp.lookupFunction<aiDetachAllLogStreams_t, aiDetachAllLogStreams_f>(
        'aiDetachAllLogStreams');

aiDetachLogStream_f _aiDetachLogStream;
aiDetachLogStream_f get aiDetachLogStream => _aiDetachLogStream ??=
    libassimp.lookupFunction<aiDetachLogStream_t, aiDetachLogStream_f>(
        'aiDetachLogStream');

aiEnableVerboseLogging_f _aiEnableVerboseLogging;
aiEnableVerboseLogging_f get aiEnableVerboseLogging =>
    _aiEnableVerboseLogging ??= libassimp.lookupFunction<
        aiEnableVerboseLogging_t,
        aiEnableVerboseLogging_f>('aiEnableVerboseLogging');

aiExportSceneEx_f _aiExportSceneEx;
aiExportSceneEx_f get aiExportSceneEx => _aiExportSceneEx ??= libassimp
    .lookupFunction<aiExportSceneEx_t, aiExportSceneEx_f>('aiExportSceneEx');

aiExportSceneToBlob_f _aiExportSceneToBlob;
aiExportSceneToBlob_f get aiExportSceneToBlob => _aiExportSceneToBlob ??=
    libassimp.lookupFunction<aiExportSceneToBlob_t, aiExportSceneToBlob_f>(
        'aiExportSceneToBlob');

aiGetBranchName_f _aiGetBranchName;
aiGetBranchName_f get aiGetBranchName => _aiGetBranchName ??= libassimp
    .lookupFunction<aiGetBranchName_t, aiGetBranchName_f>('aiGetBranchName');

aiGetCompileFlags_f _aiGetCompileFlags;
aiGetCompileFlags_f get aiGetCompileFlags => _aiGetCompileFlags ??=
    libassimp.lookupFunction<aiGetCompileFlags_t, aiGetCompileFlags_f>(
        'aiGetCompileFlags');

aiGetErrorString_f _aiGetErrorString;
aiGetErrorString_f get aiGetErrorString => _aiGetErrorString ??= libassimp
    .lookupFunction<aiGetErrorString_t, aiGetErrorString_f>('aiGetErrorString');

aiGetExportFormatCount_f _aiGetExportFormatCount;
aiGetExportFormatCount_f get aiGetExportFormatCount =>
    _aiGetExportFormatCount ??= libassimp.lookupFunction<
        aiGetExportFormatCount_t,
        aiGetExportFormatCount_f>('aiGetExportFormatCount');

aiGetExportFormatDescription_f _aiGetExportFormatDescription;
aiGetExportFormatDescription_f get aiGetExportFormatDescription =>
    _aiGetExportFormatDescription ??= libassimp.lookupFunction<
        aiGetExportFormatDescription_t,
        aiGetExportFormatDescription_f>('aiGetExportFormatDescription');

aiGetExtensionList_f _aiGetExtensionList;
aiGetExtensionList_f get aiGetExtensionList => _aiGetExtensionList ??=
    libassimp.lookupFunction<aiGetExtensionList_t, aiGetExtensionList_f>(
        'aiGetExtensionList');

aiGetLegalString_f _aiGetLegalString;
aiGetLegalString_f get aiGetLegalString => _aiGetLegalString ??= libassimp
    .lookupFunction<aiGetLegalString_t, aiGetLegalString_f>('aiGetLegalString');

aiGetMaterialColor_f _aiGetMaterialColor;
aiGetMaterialColor_f get aiGetMaterialColor => _aiGetMaterialColor ??=
    libassimp.lookupFunction<aiGetMaterialColor_t, aiGetMaterialColor_f>(
        'aiGetMaterialColor');

aiGetMaterialFloatArray_f _aiGetMaterialFloatArray;
aiGetMaterialFloatArray_f get aiGetMaterialFloatArray =>
    _aiGetMaterialFloatArray ??= libassimp.lookupFunction<
        aiGetMaterialFloatArray_t,
        aiGetMaterialFloatArray_f>('aiGetMaterialFloatArray');

aiGetMaterialIntegerArray_f _aiGetMaterialIntegerArray;
aiGetMaterialIntegerArray_f get aiGetMaterialIntegerArray =>
    _aiGetMaterialIntegerArray ??= libassimp.lookupFunction<
        aiGetMaterialIntegerArray_t,
        aiGetMaterialIntegerArray_f>('aiGetMaterialIntegerArray');

aiGetMaterialProperty_f _aiGetMaterialProperty;
aiGetMaterialProperty_f get aiGetMaterialProperty => _aiGetMaterialProperty ??=
    libassimp.lookupFunction<aiGetMaterialProperty_t, aiGetMaterialProperty_f>(
        'aiGetMaterialProperty');

aiGetMaterialString_f _aiGetMaterialString;
aiGetMaterialString_f get aiGetMaterialString => _aiGetMaterialString ??=
    libassimp.lookupFunction<aiGetMaterialString_t, aiGetMaterialString_f>(
        'aiGetMaterialString');

aiGetMaterialTexture_f _aiGetMaterialTexture;
aiGetMaterialTexture_f get aiGetMaterialTexture => _aiGetMaterialTexture ??=
    libassimp.lookupFunction<aiGetMaterialTexture_t, aiGetMaterialTexture_f>(
        'aiGetMaterialTexture');

aiGetMaterialTextureCount_f _aiGetMaterialTextureCount;
aiGetMaterialTextureCount_f get aiGetMaterialTextureCount =>
    _aiGetMaterialTextureCount ??= libassimp.lookupFunction<
        aiGetMaterialTextureCount_t,
        aiGetMaterialTextureCount_f>('aiGetMaterialTextureCount');

aiGetMaterialUVTransform_f _aiGetMaterialUVTransform;
aiGetMaterialUVTransform_f get aiGetMaterialUVTransform =>
    _aiGetMaterialUVTransform ??= libassimp.lookupFunction<
        aiGetMaterialUVTransform_t,
        aiGetMaterialUVTransform_f>('aiGetMaterialUVTransform');

aiGetMemoryRequirements_f _aiGetMemoryRequirements;
aiGetMemoryRequirements_f get aiGetMemoryRequirements =>
    _aiGetMemoryRequirements ??= libassimp.lookupFunction<
        aiGetMemoryRequirements_t,
        aiGetMemoryRequirements_f>('aiGetMemoryRequirements');

aiGetVersionMajor_f _aiGetVersionMajor;
aiGetVersionMajor_f get aiGetVersionMajor => _aiGetVersionMajor ??=
    libassimp.lookupFunction<aiGetVersionMajor_t, aiGetVersionMajor_f>(
        'aiGetVersionMajor');

aiGetVersionMinor_f _aiGetVersionMinor;
aiGetVersionMinor_f get aiGetVersionMinor => _aiGetVersionMinor ??=
    libassimp.lookupFunction<aiGetVersionMinor_t, aiGetVersionMinor_f>(
        'aiGetVersionMinor');

aiGetVersionRevision_f _aiGetVersionRevision;
aiGetVersionRevision_f get aiGetVersionRevision => _aiGetVersionRevision ??=
    libassimp.lookupFunction<aiGetVersionRevision_t, aiGetVersionRevision_f>(
        'aiGetVersionRevision');

aiGetImportFormatCount_f _aiGetImportFormatCount;
aiGetImportFormatCount_f get aiGetImportFormatCount =>
    _aiGetImportFormatCount ??= libassimp.lookupFunction<
        aiGetImportFormatCount_t,
        aiGetImportFormatCount_f>('aiGetImportFormatCount');

aiGetImportFormatDescription_f _aiGetImportFormatDescription;
aiGetImportFormatDescription_f get aiGetImportFormatDescription =>
    _aiGetImportFormatDescription ??= libassimp.lookupFunction<
        aiGetImportFormatDescription_t,
        aiGetImportFormatDescription_f>('aiGetImportFormatDescription');

aiGetPredefinedLogStream_f _aiGetPredefinedLogStream;
aiGetPredefinedLogStream_f get aiGetPredefinedLogStream =>
    _aiGetPredefinedLogStream ??= libassimp.lookupFunction<
        aiGetPredefinedLogStream_t,
        aiGetPredefinedLogStream_f>('aiGetPredefinedLogStream');

aiImportFileExWithProperties_f _aiImportFileExWithProperties;
aiImportFileExWithProperties_f get aiImportFileExWithProperties =>
    _aiImportFileExWithProperties ??= libassimp.lookupFunction<
        aiImportFileExWithProperties_t,
        aiImportFileExWithProperties_f>('aiImportFileExWithProperties');

aiImportFileFromMemoryWithProperties_f _aiImportFileFromMemoryWithProperties;
aiImportFileFromMemoryWithProperties_f
    get aiImportFileFromMemoryWithProperties =>
        _aiImportFileFromMemoryWithProperties ??= libassimp.lookupFunction<
                aiImportFileFromMemoryWithProperties_t,
                aiImportFileFromMemoryWithProperties_f>(
            'aiImportFileFromMemoryWithProperties');

aiIsExtensionSupported_f _aiIsExtensionSupported;
aiIsExtensionSupported_f get aiIsExtensionSupported =>
    _aiIsExtensionSupported ??= libassimp.lookupFunction<
        aiIsExtensionSupported_t,
        aiIsExtensionSupported_f>('aiIsExtensionSupported');

aiReleaseExportBlob_f _aiReleaseExportBlob;
aiReleaseExportBlob_f get aiReleaseExportBlob => _aiReleaseExportBlob ??=
    libassimp.lookupFunction<aiReleaseExportBlob_t, aiReleaseExportBlob_f>(
        'aiReleaseExportBlob');

aiReleaseExportFormatDescription_f _aiReleaseExportFormatDescription;
aiReleaseExportFormatDescription_f get aiReleaseExportFormatDescription =>
    _aiReleaseExportFormatDescription ??= libassimp.lookupFunction<
        aiReleaseExportFormatDescription_t,
        aiReleaseExportFormatDescription_f>('aiReleaseExportFormatDescription');

aiReleaseImport_f _aiReleaseImport;
aiReleaseImport_f get aiReleaseImport => _aiReleaseImport ??= libassimp
    .lookupFunction<aiReleaseImport_t, aiReleaseImport_f>('aiReleaseImport');

aiReleasePropertyStore_f _aiReleasePropertyStore;
aiReleasePropertyStore_f get aiReleasePropertyStore =>
    _aiReleasePropertyStore ??= libassimp.lookupFunction<
        aiReleasePropertyStore_t,
        aiReleasePropertyStore_f>('aiReleasePropertyStore');

aiSetImportPropertyFloat_f _aiSetImportPropertyFloat;
aiSetImportPropertyFloat_f get aiSetImportPropertyFloat =>
    _aiSetImportPropertyFloat ??= libassimp.lookupFunction<
        aiSetImportPropertyFloat_t,
        aiSetImportPropertyFloat_f>('aiSetImportPropertyFloat');

aiSetImportPropertyInteger_f _aiSetImportPropertyInteger;
aiSetImportPropertyInteger_f get aiSetImportPropertyInteger =>
    _aiSetImportPropertyInteger ??= libassimp.lookupFunction<
        aiSetImportPropertyInteger_t,
        aiSetImportPropertyInteger_f>('aiSetImportPropertyInteger');

aiSetImportPropertyString_f _aiSetImportPropertyString;
aiSetImportPropertyString_f get aiSetImportPropertyString =>
    _aiSetImportPropertyString ??= libassimp.lookupFunction<
        aiSetImportPropertyString_t,
        aiSetImportPropertyString_f>('aiSetImportPropertyString');
