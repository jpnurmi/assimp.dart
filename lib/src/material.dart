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
      case aiPropertyTypeInfo.aiPTI_Float:
        return _property.mData.cast<Float>().value;
      case aiPropertyTypeInfo.aiPTI_Double:
        return _property.mData.cast<Double>().value;
      case aiPropertyTypeInfo.aiPTI_String:
        return AssimpString.fromNative(_property.mData.cast<aiString>());
      case aiPropertyTypeInfo.aiPTI_Integer:
        return _property.mData.cast<Uint32>().value;
      case aiPropertyTypeInfo.aiPTI_Buffer:
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

  /// Returns a list of material textures with [type]
  Iterable<String> textures(TextureType type) {
    return Iterable.generate(
      aiGetMaterialTextureCount(ptr, type.index),
      (i) {
        final str = aiString.alloc();
        aiGetMaterialTexture(ptr, type.index, i, str, nullptr, nullptr, nullptr,
            nullptr, nullptr, nullptr);
        final path = AssimpString.fromNative(str);
        free(str);
        return path;
      },
    );
  }
}

/// Defines the purpose of a texture
///
/// This is a very difficult topic. Different 3D packages support different
/// kinds of textures. For very common texture types, such as bumpmaps, the
/// rendering results depend on implementation details in the rendering
/// pipelines of these applications. Assimp loads all texture references from
/// the model file and tries to determine which of the predefined texture
/// types below is the best choice to match the original use of the texture
/// as closely as possible.<br>
///
/// In content pipelines you'll usually define how textures have to be handled,
/// and the artists working on models have to conform to this specification,
/// regardless which 3D tool they're using.
enum TextureType {
  /// Dummy value.
  ///
  /// No texture, but the value to be used as 'texture semantic'
  /// (#aiMaterialProperty::mSemantic) for all material properties
  /// *not* related to textures.
  none,

  /// LEGACY API MATERIALS
  /// Legacy refers to materials which
  /// Were originally implemented in the specifications around 2000.
  /// These must never be removed, as most engines support them.

  /// The texture is combined with the result of the diffuse
  /// lighting equation.
  diffuse,

  /// The texture is combined with the result of the specular
  /// lighting equation.
  specular,

  /// The texture is combined with the result of the ambient
  /// lighting equation.
  ambient,

  /// The texture is added to the result of the lighting
  /// calculation. It isn't influenced by incoming light.
  emissive,

  /// The texture is a height map.
  ///
  /// By convention, higher gray-scale values stand for
  /// higher elevations from the base height.
  height,

  /// The texture is a (tangent space) normal-map.
  ///
  /// Again, there are several conventions for tangent-space
  /// normal maps. Assimp does (intentionally) not
  /// distinguish here.
  normals,

  /// The texture defines the glossiness of the material.
  ///
  /// The glossiness is in fact the exponent of the specular
  /// (phong) lighting equation. Usually there is a conversion
  /// function defined to map the linear color values in the
  /// texture to a suitable exponent. Have fun.
  shininess,

  /// The texture defines per-pixel opacity.
  ///
  /// Usually 'white' means opaque and 'black' means
  /// 'transparency'. Or quite the opposite. Have fun.
  opacity,

  /// Displacement texture
  ///
  /// The exact purpose and format is application-dependent.
  /// Higher color values stand for higher vertex displacements.
  displacement,

  /// Lightmap texture (aka Ambient Occlusion)
  ///
  /// Both 'Lightmaps' and dedicated 'ambient occlusion maps' are
  /// covered by this material property. The texture contains a
  /// scaling value for the final color value of a pixel. Its
  /// intensity is not affected by incoming light.
  lightmap,

  /// Reflection texture
  ///
  /// Contains the color of a perfect mirror reflection.
  /// Rarely used, almost never for real-time applications.
  reflection,

  /// PBR Materials
  /// PBR definitions from maya and other modelling packages now use this standard.
  /// This was originally introduced around 2012.
  /// Support for this is in game engines like Godot, Unreal or Unity3D.
  /// Modelling packages which use this are very common now.
  baseColor,
  normalCamera,
  emissionColor,
  metalness,
  diffuseRoughness,
  ambientOcclusion,

  /// Unknown texture
  ///
  /// A texture reference that does not match any of the definitions
  /// above is considered to be 'unknown'. It is still imported,
  /// but is excluded from any further post-processing.
  unknown,
}
