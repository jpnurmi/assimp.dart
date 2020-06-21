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

/// Data structure for a single material property
///
/// As an user, you'll probably never need to deal with this data structure.
/// Just use the provided aiGetMaterialXXX() or aiMaterial::Get() family
/// of functions to query material properties easily. Processing them
/// manually is faster, but it is not the recommended way. It isn't worth
/// the effort. <br>
/// Material property names follow a simple scheme:
/// @code
///   $<name>
///   ?<name>
///      A public property, there must be corresponding AI_MATKEY_XXX define
///      2nd: Public, but ignored by the #aiProcess_RemoveRedundantMaterials
///      post-processing step.
///   ~<name>
///      A temporary property for internal use.
/// @endcode
/// @see aiMaterial
class MaterialProperty extends AssimpType<aiMaterialProperty> {
  aiMaterialProperty get _property => ptr.ref;

  MaterialProperty._(Pointer<aiMaterialProperty> ptr) : super(ptr);
  factory MaterialProperty.fromNative(Pointer<aiMaterialProperty> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return MaterialProperty._(ptr);
  }

  /// Specifies the name of the property (key)
  /// Keys are generally case insensitive.
  String get key => AssimpString.fromNative(_property.mKey);

  /// The value of the property
  dynamic get value {
    switch (_property.mType) {
      case aiPropertyTypeInfo.float:
        return _property.mData.cast<Float>().value;
      case aiPropertyTypeInfo.double:
        return _property.mData.cast<Double>().value;
      case aiPropertyTypeInfo.string:
        return AssimpString.fromNative(_property.mData.cast<aiString>());
      case aiPropertyTypeInfo.integer:
        return _property.mData.cast<Uint32>().value;
      case aiPropertyTypeInfo.buffer:
        return _property.mData.cast<Uint8>().asTypedList(_property.mDataLength);
      default:
        return null;
    }
  }

  /// Textures: Specifies the index of the texture.
  /// For non-texture properties, this member is always 0.
  int get index => _property.mIndex;

  /// Textures: Specifies their exact usage semantic.
  /// For non-texture properties, this member is always 0
  /// (or, better-said, #aiTextureType_NONE).
  int get semantic => _property.mSemantic;
}

/// Data structure for a material
///
/// Material data is stored using a key-value structure. A single key-value
/// pair is called a 'material property'. C++ users should use the provided
/// member functions of aiMaterial to process material properties, C users
/// have to stick with the aiMaterialGetXXX family of unbound functions.
/// The library defines a set of standard keys (AI_MATKEY_XXX).
class Material extends AssimpType<aiMaterial> {
  aiMaterial get _material => ptr.ref;

  Material._(Pointer<aiMaterial> ptr) : super(ptr);
  factory Material.fromNative(Pointer<aiMaterial> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Material._(ptr);
  }

  /// List of all material properties loaded.
  Iterable<MaterialProperty> get properties {
    return Iterable.generate(
      _material.mNumProperties,
      (i) => MaterialProperty.fromNative(_material.mProperties[i]),
    );
  }
}
