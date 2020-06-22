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
import 'extensions.dart';
import 'libassimp.dart';
import 'type.dart';

/// ### TODO
class Assimp {
  Assimp._();

  /// Enable verbose logging. Verbose logging includes debug-related stuff and
  /// detailed import statistics. This can have severe impact on import performance
  /// and memory consumption. However, it might be useful to find out why a file
  /// didn't read correctly.
  /// @param d AI_TRUE or AI_FALSE, your decision.
  static void enableVerboseLogging(bool enable) =>
      aiEnableVerboseLogging(enable ? 1 : 0);

  /// Returns the error text of the last failed import process.
  ///
  /// @return A textual description of the error that occurred at the last
  /// import process. NULL if there was no error. There can't be an error if you
  /// got a non-NULL #aiScene from #aiImportFile/#aiImportFileEx/#aiApplyPostProcessing.
  static String get errorString => Utf8.fromUtf8(aiGetErrorString());

  /// Returns a string with legal copyright and licensing information
  /// about Assimp. The string may include multiple lines.
  static String get legalString => Utf8.fromUtf8(aiGetLegalString());

  /// Returns the current major version number of Assimp.
  static int get versionMajor => aiGetVersionMajor();

  /// eturns the current minor version number of Assimp.
  static int get versionMinor => aiGetVersionMinor();

  /// Returns the repository revision of the Assimp runtime.
  static int get versionRevision => aiGetVersionRevision();

  /// Returns assimp's compile flags
  static int get compileFlags => aiGetCompileFlags();

  /// Returns the branchname of the Assimp runtime.
  static String get branchName => Utf8.fromUtf8(aiGetBranchName());

  /// Returns whether a given file extension is supported by ASSIMP
  ///
  /// @param szExtension Extension for which the function queries support for.
  /// Must include a leading dot '.'. Example: ".3ds", ".md3"
  /// @return AI_TRUE if the file extension is supported.
  static bool isSupported(String extension) {
    Pointer<Utf8> ptr = Utf8.toUtf8(extension);
    int res = aiIsExtensionSupported(ptr);
    free(ptr);
    return res != 0;
  }

  /// Get a list of all file extensions supported by ASSIMP.
  ///
  /// If a file extension is contained in the list this does, of course, not
  /// mean that ASSIMP is able to load all files with this extension.
  /// @param szOut String to receive the extension list.
  /// Format of the list: "*.3ds;*.obj;*.dae". NULL is not a valid parameter.
  static Iterable<String> get extensions {
    Pointer<aiString> ptr = aiString.alloc();
    aiGetExtensionList(ptr);
    String ext = AssimpString.fromNative(ptr);
    free(ptr);
    return ext.split(';');
  }

  /// Import file format descriptions
  static Iterable<ImportFormat> get importFormats {
    return Iterable.generate(
      aiGetImportFormatCount(),
      (i) => ImportFormat.fromNative(aiGetImportFormatDescription(i)),
    );
  }

  /// Export file format descriptions
  static Iterable<ExportFormat> get exportFormats {
    return Iterable.generate(
      aiGetExportFormatCount(),
      (i) => ExportFormat.fromNative(aiGetExportFormatDescription(i)),
    );
  }
}

class CompileFlags {
  /// Assimp was compiled as a shared object (Windows: DLL)
  static const int shared = 0x1;

  /// Assimp was compiled against STLport
  static const int stlPort = 0x2;

  /// Assimp was compiled as a debug build
  static const int debug = 0x4;

  /// Assimp was compiled with ASSIMP_BUILD_BOOST_WORKAROUND defined
  static const int noBoost = 0x8;

  /// Assimp was compiled with ASSIMP_BUILD_SINGLETHREADED defined
  static const int singleThreaded = 0x10;
}

/// Mixed set of flags for #aiImporterDesc, indicating some features
/// common to many importers
class ImportFormatFlags {
  /// Indicates that there is a textual encoding of the
  /// file format; and that it is supported.
  static const int text = 0x1;

  /// Indicates that there is a binary encoding of the
  /// file format; and that it is supported.
  static const int binary = 0x2;

  /// Indicates that there is a compressed encoding of the
  /// file format; and that it is supported.
  static const int compressed = 0x4;

  /// Indicates that the importer reads only a very particular
  /// subset of the file format. This happens commonly for
  /// declarative or procedural formats which cannot easily
  /// be mapped to #aiScene
  static const int limited = 0x8;

  /// Indicates that the importer is highly experimental and
  /// should be used with care. This only happens for trunk
  /// (i.e. Git) versions, experimental code is not included
  /// in releases.
  static const int experimental = 0x10;
}

/// Meta information about a particular importer. Importers need to fill
/// this structure, but they can freely decide how talkative they are.
/// A common use case for loader meta info is a user interface
/// in which the user can choose between various import/export file
/// formats. Building such an UI by hand means a lot of maintenance
/// as importers/exporters are added to Assimp, so it might be useful
/// to have a common mechanism to query some rough importer
/// characteristics.
class ImportFormat extends AssimpType<aiImporterDesc> {
  aiImporterDesc get _desc => ptr.ref;

  ImportFormat._(Pointer<aiImporterDesc> ptr) : super(ptr);
  factory ImportFormat.fromNative(Pointer<aiImporterDesc> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return ImportFormat._(ptr);
  }

  /// Full name of the importer (i.e. Blender3D importer)
  String get name => Utf8.fromUtf8(_desc.mName);

  /// Original author (left blank if unknown or whole assimp team)
  String get author => Utf8.fromUtf8(_desc.mAuthor);

  /// Current maintainer, left blank if the author maintains
  String get maintainer => Utf8.fromUtf8(_desc.mMaintainer);

  /// Implementation comments, i.e. unimplemented features
  String get comments => Utf8.fromUtf8(_desc.mComments);

  /// These flags indicate some characteristics common to many importers.
  int get flags => _desc.mFlags;

  /// List of file extensions this importer can handle.
  /// List entries are separated by space characters.
  /// All entries are lower case without a leading dot (i.e.
  /// "xml dae" would be a valid value. Note that multiple
  /// importers may respond to the same file extension -
  /// assimp calls all importers in the order in which they
  /// are registered and each importer gets the opportunity
  /// to load the file until one importer "claims" the file. Apart
  /// from file extension checks, importers typically use
  /// other methods to quickly reject files (i.e. magic
  /// words) so this does not mean that common or generic
  /// file extensions such as XML would be tediously slow.
  List<String> get extensions =>
      Utf8.fromUtf8(_desc.mFileExtensions).split(' ');
}

/// Describes an file format which Assimp can export to. Use #aiGetExportFormatCount() to
/// learn how many export formats the current Assimp build supports and #aiGetExportFormatDescription()
/// to retrieve a description of an export format option.
class ExportFormat extends AssimpType<aiExportFormatDesc> {
  aiExportFormatDesc get _desc => ptr.ref;

  ExportFormat._(Pointer<aiExportFormatDesc> ptr) : super(ptr);
  factory ExportFormat.fromNative(Pointer<aiExportFormatDesc> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return ExportFormat._(ptr);
  }

  /// a short string ID to uniquely identify the export format. Use this ID string to
  /// specify which file format you want to export to when calling #aiExportScene().
  /// Example: "dae" or "obj"
  String get id => Utf8.fromUtf8(_desc.id);

  /// A short description of the file format to present to users. Useful if you want
  /// to allow the user to select an export format.
  String get description => Utf8.fromUtf8(_desc.description);

  /// Recommended file extension for the exported file in lower case.
  String get extension => Utf8.fromUtf8(_desc.fileExtension);

  /// Release a description of the nth export file format. Must be returned by
  /// aiGetExportFormatDescription
  /// @param desc Pointer to the description
  void dispose() => aiReleaseExportFormatDescription(ptr);
}
