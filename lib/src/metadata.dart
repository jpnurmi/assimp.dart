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

import 'package:assimp/assimp.dart';

import 'utils.dart';
import 'bindings/metadata.dart' as bindings;

class MetaData {
  Pointer<bindings.aiMetadata> _ptr;

  MetaData.fromNative(this._ptr);

  bool get isNull => Utils.isNull(_ptr);

  Map<String, dynamic> get properties => Map.fromIterables(keys, values);

  Iterable<String> get keys {
    return Iterable.generate(
      _ptr?.ref?.mNumProperties ?? 0,
      (i) => Utils.fromString(_ptr.ref.mKeys.elementAt(i)),
    );
  }

  Iterable<dynamic> get values {
    return Iterable.generate(
      _ptr?.ref?.mNumProperties ?? 0,
      (i) => _toValue(_ptr.ref.mValues.elementAt(i)),
    );
  }

  static dynamic _toValue(Pointer<bindings.aiMetadataEntry> entry) {
    switch (entry.ref.mType) {
      case bindings.aiMetadataType.AI_BOOL:
      case bindings.aiMetadataType.AI_INT32:
      case bindings.aiMetadataType.AI_UINT64:
      case bindings.aiMetadataType.AI_FLOAT:
      case bindings.aiMetadataType.AI_DOUBLE:
        return 0; // ### TODO
      case bindings.aiMetadataType.AI_AISTRING:
        return ''; // ### TODO
      case bindings.aiMetadataType.AI_AIVECTOR3D:
        return Vector3.zero(); // ### TODO
      default:
        throw UnimplementedError(entry.ref.mType.toString());
    }
  }
}
