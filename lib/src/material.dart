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

class MaterialProperty {
  Pointer<aiMaterialProperty> _ptr;

  MaterialProperty._(this._ptr);
  factory MaterialProperty.fromNative(Pointer<aiMaterialProperty> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MaterialProperty._(ptr);
  }

  String get key => AssimpString.fromNative(_ptr.ref.mKey);

  dynamic get value {
    switch (_ptr.ref.mType) {
      case aiPropertyTypeInfo.float:
        return _ptr.ref.mData.cast<Float>().value;
      case aiPropertyTypeInfo.double:
        return _ptr.ref.mData.cast<Double>().value;
      case aiPropertyTypeInfo.string:
        return AssimpString.fromNative(_ptr.ref.mData.cast<aiString>());
      case aiPropertyTypeInfo.integer:
        return _ptr.ref.mData.cast<Uint32>().value;
      case aiPropertyTypeInfo.buffer:
        return _ptr.ref.mData.cast<Uint8>().asTypedList(_ptr.ref.mDataLength);
      default:
        return null;
    }
  }

  int get index => _ptr.ref.mIndex;
  int get semantic => _ptr.ref.mSemantic;
}

class Material {
  Pointer<aiMaterial> _ptr;

  Material._(this._ptr);
  factory Material.fromNative(Pointer<aiMaterial> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Material._(ptr);
  }

  Iterable<MaterialProperty> get properties {
    return Iterable.generate(
      _ptr.ref.mNumProperties,
      (i) => MaterialProperty.fromNative(_ptr.ref.mProperties[i]),
    );
  }
}
