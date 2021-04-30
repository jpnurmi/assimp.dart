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

import 'bindings.dart';
import 'import.dart';
import 'extensions.dart';
import 'export.dart';
import 'libassimp.dart';

/// ### TODO
class Assimp {
  Assimp._();

  /// Enable verbose logging. Verbose logging includes debug-related stuff and
  /// detailed import statistics. This can have severe impact on import performance
  /// and memory consumption. However, it might be useful to find out why a file
  /// didn't read correctly.
  /// @param d AI_TRUE or AI_FALSE, your decision.
  static void enableVerboseLogging(bool enable) =>
      libassimp.aiEnableVerboseLogging(enable ? 1 : 0);

  /// Returns the error text of the last failed import process.
  ///
  /// @return A textual description of the error that occurred at the last
  /// import process. NULL if there was no error. There can't be an error if you
  /// got a non-NULL #aiScene from #aiImportFile/#aiImportFileEx/#aiApplyPostProcessing.
  static String get errorString => libassimp.aiGetErrorString().toDartString();

  /// Returns a string with legal copyright and licensing information
  /// about Assimp. The string may include multiple lines.
  static String get legalString => libassimp.aiGetLegalString().toDartString();

  /// Returns the current major version number of Assimp.
  static int get versionMajor => libassimp.aiGetVersionMajor();

  /// eturns the current minor version number of Assimp.
  static int get versionMinor => libassimp.aiGetVersionMinor();

  /// Returns the repository revision of the Assimp runtime.
  static int get versionRevision => libassimp.aiGetVersionRevision();

  /// Returns assimp's compile flags
  static int get compileFlags => libassimp.aiGetCompileFlags();

  /// Returns the branchname of the Assimp runtime.
  static String get branchName => libassimp.aiGetBranchName().toDartString();

  /// Returns whether a given file extension is supported by ASSIMP
  ///
  /// @param szExtension Extension for which the function queries support for.
  /// Must include a leading dot '.'. Example: ".3ds", ".md3"
  /// @return AI_TRUE if the file extension is supported.
  static bool isSupported(String extension) {
    final ptr = extension.toNativeString();
    final res = libassimp.aiIsExtensionSupported(ptr);
    malloc.free(ptr);
    return res != 0;
  }

  /// Get a list of all file extensions supported by ASSIMP.
  ///
  /// If a file extension is contained in the list this does, of course, not
  /// mean that ASSIMP is able to load all files with this extension.
  /// @param szOut String to receive the extension list.
  /// Format of the list: "*.3ds;*.obj;*.dae". NULL is not a valid parameter.
  static Iterable<String> get extensions {
    final ptr = calloc<aiString>();
    libassimp.aiGetExtensionList(ptr);
    final ext = AssimpString.fromNative(ptr.ref);
    calloc.free(ptr);
    return ext.split(';');
  }

  /// Import file format descriptions
  static Iterable<ImportFormat> get importFormats {
    return Iterable.generate(
      libassimp.aiGetImportFormatCount(),
      (i) =>
          ImportFormat.fromNative(libassimp.aiGetImportFormatDescription(i))!,
    );
  }

  /// Export file format descriptions
  static Iterable<ExportFormat> get exportFormats {
    return Iterable.generate(
      libassimp.aiGetExportFormatCount(),
      (i) =>
          ExportFormat.fromNative(libassimp.aiGetExportFormatDescription(i))!,
    );
  }
}
