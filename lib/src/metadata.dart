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

import 'bindings.dart';
import 'extensions.dart';
import 'type.dart';

/// Container for holding metadata.
///
/// Metadata is a key-value store using string keys and values.
class MetaData extends AssimpType<aiMetadata> {
  aiMetadata get _metaData => ptr.ref;

  MetaData._(Pointer<aiMetadata> ptr) : super(ptr);
  static MetaData? fromNative(Pointer<aiMetadata> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MetaData._(ptr);
  }

  /// Map of properties.
  Map<String, dynamic> get properties => Map.fromIterables(keys, values);

  /// Arrays of keys, may not be NULL. Entries in this array may not be NULL as well.
  Iterable<String> get keys {
    return Iterable.generate(
      _metaData.mNumProperties,
      (i) => AssimpString.fromNative(_metaData.mKeys.elementAt(i).ref),
    );
  }

  /// Array of values, may not be NULL. Entries in this array may be NULL if the
  /// corresponding property key has no assigned value.
  Iterable<dynamic> get values {
    return Iterable.generate(
      _metaData.mNumProperties,
      (i) => _toValue(_metaData.mValues.elementAt(i)),
    );
  }

  static dynamic _toValue(Pointer<aiMetadataEntry> ptr) {
    switch (ptr.ref.mType) {
      case aiMetadataType.AI_BOOL:
        return ptr.ref.mData.cast<Int8>().value;
      case aiMetadataType.AI_INT32:
        return ptr.ref.mData.cast<Int32>().value;
      case aiMetadataType.AI_UINT64:
        return ptr.ref.mData.cast<Uint64>().value;
      case aiMetadataType.AI_FLOAT:
        return ptr.ref.mData.cast<Float>().value;
      case aiMetadataType.AI_DOUBLE:
        return ptr.ref.mData.cast<Double>().value;
      case aiMetadataType.AI_AISTRING:
        return AssimpString.fromNative(ptr.ref.mData.cast<aiString>().ref);
      case aiMetadataType.AI_AIVECTOR3D:
        return AssimpVector3.fromNative(ptr.ref.mData.cast<aiVector3D>().ref);
      default:
        throw UnimplementedError(ptr.ref.mType.toString());
    }
  }
}
