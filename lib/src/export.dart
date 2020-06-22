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
