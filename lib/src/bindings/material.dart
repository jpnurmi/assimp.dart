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

/** @file material.h
 *  @brief Defines the material system of the library
 */

import 'package:ffi/ffi.dart';

import 'types.dart';

// Name for default materials (2nd is used if meshes have UV coords)
const String AI_DEFAULT_MATERIAL_NAME = 'DefaultMaterial';

// ---------------------------------------------------------------------------
/** @brief Defines how the Nth texture of a specific type is combined with
 *  the result of all previous layers.
 *
 *  Example (left: key, right: value): <br>
 *  @code
 *  DiffColor0     - gray
 *  DiffTextureOp0 - aiTextureOpMultiply
 *  DiffTexture0   - tex1.png
 *  DiffTextureOp0 - aiTextureOpAdd
 *  DiffTexture1   - tex2.png
 *  @endcode
 *  Written as equation, the final diffuse term for a specific pixel would be:
 *  @code
 *  diffFinal = DiffColor0 * sampleTex(DiffTexture0,UV0) +
 *     sampleTex(DiffTexture1,UV0) * diffContrib;
 *  @endcode
 *  where 'diffContrib' is the intensity of the incoming light for that pixel.
 */
class aiTextureOp {
  /** T = T1 * T2 */
  static const int Multiply = 0x0;

  /** T = T1 + T2 */
  static const int Add = 0x1;

  /** T = T1 - T2 */
  static const int Subtract = 0x2;

  /** T = T1 / T2 */
  static const int Divide = 0x3;

  /** T = (T1 + T2) - (T1 * T2) */
  static const int SmoothAdd = 0x4;

  /** T = T1 + (T2-0.5) */
  static const int SignedAdd = 0x5;
}

// ---------------------------------------------------------------------------
/** @brief Defines how UV coordinates outside the [0...1] range are handled.
 *
 *  Commonly referred to as 'wrapping mode'.
 */
class aiTextureMapMode {
  /** A texture coordinate u|v is translated to u%1|v%1
     */
  static const int Wrap = 0x0;

  /** Texture coordinates outside [0...1]
     *  are clamped to the nearest valid value.
     */
  static const int Clamp = 0x1;

  /** If the texture coordinates for a pixel are outside [0...1]
     *  the texture is not applied to that pixel
     */
  static const int Decal = 0x3;

  /** A texture coordinate u|v becomes u%1|v%1 if (u-(u%1))%2 is zero and
     *  1-(u%1)|1-(v%1) otherwise
     */
  static const int Mirror = 0x2;
}

// ---------------------------------------------------------------------------
/** @brief Defines how the mapping coords for a texture are generated.
 *
 *  Real-time applications typically require full UV coordinates, so the use of
 *  the aiProcess_GenUVCoords step is highly recommended. It generates proper
 *  UV channels for non-UV mapped objects, as long as an accurate description
 *  how the mapping should look like (e.g spherical) is given.
 *  See the #AI_MATKEY_MAPPING property for more details.
 */
class aiTextureMapping {
  /** The mapping coordinates are taken from an UV channel.
     *
     *  The #AI_MATKEY_UVWSRC key specifies from which UV channel
     *  the texture coordinates are to be taken from (remember,
     *  meshes can have more than one UV channel).
    */
  static const int UV = 0x0;

  /** Spherical mapping */
  static const int SPHERE = 0x1;

  /** Cylindrical mapping */
  static const int CYLINDER = 0x2;

  /** Cubic mapping */
  static const int BOX = 0x3;

  /** Planar mapping */
  static const int PLANE = 0x4;

  /** Undefined mapping. Have fun. */
  static const int OTHER = 0x5;
}

// ---------------------------------------------------------------------------
/** @brief Defines the purpose of a texture
 *
 *  This is a very difficult topic. Different 3D packages support different
 *  kinds of textures. For very common texture types, such as bumpmaps, the
 *  rendering results depend on implementation details in the rendering
 *  pipelines of these applications. Assimp loads all texture references from
 *  the model file and tries to determine which of the predefined texture
 *  types below is the best choice to match the original use of the texture
 *  as closely as possible.<br>
 *
 *  In content pipelines you'll usually define how textures have to be handled,
 *  and the artists working on models have to conform to this specification,
 *  regardless which 3D tool they're using.
 */
class aiTextureType {
  /** Dummy value.
     *
     *  No texture, but the value to be used as 'texture semantic'
     *  (#aiMaterialProperty::mSemantic) for all material properties
     *  *not* related to textures.
     */
  static const int NONE = 0;

  /** LEGACY API MATERIALS
     * Legacy refers to materials which
     * Were originally implemented in the specifications around 2000.
     * These must never be removed, as most engines support them.
     */

  /** The texture is combined with the result of the diffuse
     *  lighting equation.
     */
  static const int DIFFUSE = 1;

  /** The texture is combined with the result of the specular
     *  lighting equation.
     */
  static const int SPECULAR = 2;

  /** The texture is combined with the result of the ambient
     *  lighting equation.
     */
  static const int AMBIENT = 3;

  /** The texture is added to the result of the lighting
     *  calculation. It isn't influenced by incoming light.
     */
  static const int EMISSIVE = 4;

  /** The texture is a height map.
     *
     *  By convention, higher gray-scale values stand for
     *  higher elevations from the base height.
     */
  static const int HEIGHT = 5;

  /** The texture is a (tangent space) normal-map.
     *
     *  Again, there are several conventions for tangent-space
     *  normal maps. Assimp does (intentionally) not
     *  distinguish here.
     */
  static const int NORMALS = 6;

  /** The texture defines the glossiness of the material.
     *
     *  The glossiness is in fact the exponent of the specular
     *  (phong) lighting equation. Usually there is a conversion
     *  function defined to map the linear color values in the
     *  texture to a suitable exponent. Have fun.
    */
  static const int SHININESS = 7;

  /** The texture defines per-pixel opacity.
     *
     *  Usually 'white' means opaque and 'black' means
     *  'transparency'. Or quite the opposite. Have fun.
    */
  static const int OPACITY = 8;

  /** Displacement texture
     *
     *  The exact purpose and format is application-dependent.
     *  Higher color values stand for higher vertex displacements.
    */
  static const int DISPLACEMENT = 9;

  /** Lightmap texture (aka Ambient Occlusion)
     *
     *  Both 'Lightmaps' and dedicated 'ambient occlusion maps' are
     *  covered by this material property. The texture contains a
     *  scaling value for the final color value of a pixel. Its
     *  intensity is not affected by incoming light.
    */
  static const int LIGHTMAP = 10;

  /** Reflection texture
     *
     * Contains the color of a perfect mirror reflection.
     * Rarely used, almost never for real-time applications.
    */
  static const int REFLECTION = 11;

  /** PBR Materials
     * PBR definitions from maya and other modelling packages now use this standard.
     * This was originally introduced around 2012.
     * Support for this is in game engines like Godot, Unreal or Unity3D.
     * Modelling packages which use this are very common now.
     */

  static const int BASE_COLOR = 12;
  static const int NORMAL_CAMERA = 13;
  static const int EMISSION_COLOR = 14;
  static const int METALNESS = 15;
  static const int DIFFUSE_ROUGHNESS = 16;
  static const int AMBIENT_OCCLUSION = 17;

  /** Unknown texture
     *
     *  A texture reference that does not match any of the definitions
     *  above is considered to be 'unknown'. It is still imported,
     *  but is excluded from any further post-processing.
    */
  static const int UNKNOWN = 18;
}

const int AI_TEXTURE_TYPE_MAX = aiTextureType.UNKNOWN;

// ---------------------------------------------------------------------------
/** @brief Defines all shading models supported by the library
 *
 *  The list of shading modes has been taken from Blender.
 *  See Blender documentation for more information. The API does
 *  not distinguish between "specular" and "diffuse" shaders (thus the
 *  specular term for diffuse shading models like Oren-Nayar remains
 *  undefined). <br>
 *  Again, this value is just a hint. Assimp tries to select the shader whose
 *  most common implementation matches the original rendering results of the
 *  3D modeller which wrote a particular model as closely as possible.
 */
class aiShadingMode {
  /** Flat shading. Shading is done on per-face base,
     *  diffuse only. Also known as 'faceted shading'.
     */
  static const int Flat = 0x1;

  /** Simple Gouraud shading.
     */
  static const int Gouraud = 0x2;

  /** Phong-Shading -
     */
  static const int Phong = 0x3;

  /** Phong-Blinn-Shading
     */
  static const int Blinn = 0x4;

  /** Toon-Shading per pixel
     *
     *  Also known as 'comic' shader.
     */
  static const int Toon = 0x5;

  /** OrenNayar-Shading per pixel
     *
     *  Extension to standard Lambertian shading, taking the
     *  roughness of the material into account
     */
  static const int OrenNayar = 0x6;

  /** Minnaert-Shading per pixel
     *
     *  Extension to standard Lambertian shading, taking the
     *  "darkness" of the material into account
     */
  static const int Minnaert = 0x7;

  /** CookTorrance-Shading per pixel
     *
     *  Special shader for metallic surfaces.
     */
  static const int CookTorrance = 0x8;

  /** No shading at all. Constant light influence of 1.0.
    */
  static const int NoShading = 0x9;

  /** Fresnel shading
     */
  static const int Fresnel = 0xa;
}

// ---------------------------------------------------------------------------
/** @brief Defines some mixed flags for a particular texture.
 *
 *  Usually you'll instruct your cg artists how textures have to look like ...
 *  and how they will be processed in your application. However, if you use
 *  Assimp for completely generic loading purposes you might also need to
 *  process these flags in order to display as many 'unknown' 3D models as
 *  possible correctly.
 *
 *  This corresponds to the #AI_MATKEY_TEXFLAGS property.
*/
class aiTextureFlags {
  /** The texture's color values have to be inverted (component-wise 1-n)
     */
  static const int Invert = 0x1;

  /** Explicit request to the application to process the alpha channel
     *  of the texture.
     *
     *  Mutually exclusive with #aiTextureFlags_IgnoreAlpha. These
     *  flags are set if the library can say for sure that the alpha
     *  channel is used/is not used. If the model format does not
     *  define this, it is left to the application to decide whether
     *  the texture alpha channel - if any - is evaluated or not.
     */
  static const int UseAlpha = 0x2;

  /** Explicit request to the application to ignore the alpha channel
     *  of the texture.
     *
     *  Mutually exclusive with #aiTextureFlags_UseAlpha.
     */
  static const int IgnoreAlpha = 0x4;
}

// ---------------------------------------------------------------------------
/** @brief Defines alpha-blend flags.
 *
 *  If you're familiar with OpenGL or D3D, these flags aren't new to you.
 *  They define *how* the final color value of a pixel is computed, basing
 *  on the previous color at that pixel and the new color value from the
 *  material.
 *  The blend formula is:
 *  @code
 *    SourceColor * SourceBlend + DestColor * DestBlend
 *  @endcode
 *  where DestColor is the previous color in the framebuffer at this
 *  position and SourceColor is the material color before the transparency
 *  calculation.<br>
 *  This corresponds to the #AI_MATKEY_BLEND_FUNC property.
*/
class aiBlendMode {
  /**
     *  Formula:
     *  @code
     *  SourceColor*SourceAlpha + DestColor*(1-SourceAlpha)
     *  @endcode
     */
  static const int Default = 0x0;

  /** Additive blending
     *
     *  Formula:
     *  @code
     *  SourceColor*1 + DestColor*1
     *  @endcode
     */
  static const int Additive = 0x1;
}

// ---------------------------------------------------------------------------
/** @brief Defines how an UV channel is transformed.
 *
 *  This is just a helper structure for the #AI_MATKEY_UVTRANSFORM key.
 *  See its documentation for more details.
 *
 *  Typically you'll want to build a matrix of this information. However,
 *  we keep separate scaling/translation/rotation values to make it
 *  easier to process and optimize UV transformations internally.
 */
class aiUVTransform extends Struct {
  /** Translation on the u and v axes.
     *
     *  The default value is (0|0).
     */
  Pointer<aiVector2D> mTranslation;

  /** Scaling on the u and v axes.
     *
     *  The default value is (1|1).
     */
  Pointer<aiVector2D> mScaling;

  /** Rotation - in counter-clockwise direction.
     *
     *  The rotation angle is specified in radians. The
     *  rotation center is 0.5f|0.5f. The default value
     *  0.f.
     */
  @Float() // ai_real
  double mRotation;
}

//! @cond AI_DOX_INCLUDE_INTERNAL
// ---------------------------------------------------------------------------
/** @brief A very primitive RTTI system for the contents of material
 *  properties.
 */
class aiPropertyTypeInfo {
  /** Array of single-precision (32 Bit) floats
     *
     *  It is possible to use aiGetMaterialInteger[Array]() (or the C++-API
     *  aiMaterial::Get()) to query properties stored in floating-point format.
     *  The material system performs the type conversion automatically.
    */
  static const int Float = 0x1;

  /** Array of double-precision (64 Bit) floats
     *
     *  It is possible to use aiGetMaterialInteger[Array]() (or the C++-API
     *  aiMaterial::Get()) to query properties stored in floating-point format.
     *  The material system performs the type conversion automatically.
    */
  static const int Double = 0x2;

  /** The material property is an aiString.
     *
     *  Arrays of strings aren't possible, aiGetMaterialString() (or the
     *  C++-API aiMaterial::Get()) *must* be used to query a string property.
    */
  static const int String = 0x3;

  /** Array of (32 Bit) integers
     *
     *  It is possible to use aiGetMaterialFloat[Array]() (or the C++-API
     *  aiMaterial::Get()) to query properties stored in integer format.
     *  The material system performs the type conversion automatically.
    */
  static const int Integer = 0x4;

  /** Simple binary buffer, content undefined. Not convertible to anything.
    */
  static const int Buffer = 0x5;
}

// ---------------------------------------------------------------------------
/** @brief Data structure for a single material property
 *
 *  As an user, you'll probably never need to deal with this data structure.
 *  Just use the provided aiGetMaterialXXX() or aiMaterial::Get() family
 *  of functions to query material properties easily. Processing them
 *  manually is faster, but it is not the recommended way. It isn't worth
 *  the effort. <br>
 *  Material property names follow a simple scheme:
 *  @code
 *    $<name>
 *    ?<name>
 *       A public property, there must be corresponding AI_MATKEY_XXX define
 *       2nd: Public, but ignored by the #aiProcess_RemoveRedundantMaterials
 *       post-processing step.
 *    ~<name>
 *       A temporary property for internal use.
 *  @endcode
 *  @see aiMaterial
 */
class aiMaterialProperty extends Struct {
  /** Specifies the name of the property (key)
     *  Keys are generally case insensitive.
     */
  Pointer<aiString> mKey;

  /** Textures: Specifies their exact usage semantic.
     * For non-texture properties, this member is always 0
     * (or, better-said, #aiTextureType_NONE).
     */
  @Uint32()
  int mSemantic;

  /** Textures: Specifies the index of the texture.
     *  For non-texture properties, this member is always 0.
     */
  @Uint32()
  int mIndex;

  /** Size of the buffer mData is pointing to, in bytes.
     *  This value may not be 0.
     */
  @Uint32()
  int mDataLength;

  /** Type information for the property.
     *
     * Defines the data layout inside the data buffer. This is used
     * by the library internally to perform debug checks and to
     * utilize proper type conversions.
     * (It's probably a hacky solution, but it works.)
     */
  @Uint32()
  int mType; // aiPropertyTypeInfo

  /** Binary buffer to hold the property's value.
     * The size of the buffer is always mDataLength.
     */
  Pointer<Int8> mData;
}
//! @endcond

// ---------------------------------------------------------------------------
/** @brief Data structure for a material
*
*  Material data is stored using a key-value structure. A single key-value
*  pair is called a 'material property'. C++ users should use the provided
*  member functions of aiMaterial to process material properties, C users
*  have to stick with the aiMaterialGetXXX family of unbound functions.
*  The library defines a set of standard keys (AI_MATKEY_XXX).
*/
class aiMaterial extends Struct {
  /** List of all material properties loaded. */
  Pointer<Pointer<aiMaterialProperty>> mProperties;

  /** Number of properties in the data base */
  @Uint32()
  int mNumProperties;

  /** Storage allocated */
  @Uint32()
  int mNumAllocated;
}

// Go back to extern "C" again

// ---------------------------------------------------------------------------
const String AI_MATKEY_NAME = '?mat.name';
const String AI_MATKEY_TWOSIDED = '\$mat.twosided';
const String AI_MATKEY_SHADING_MODEL = '\$mat.shadingm';
const String AI_MATKEY_ENABLE_WIREFRAME = '\$mat.wireframe';
const String AI_MATKEY_BLEND_FUNC = '\$mat.blend';
const String AI_MATKEY_OPACITY = '\$mat.opacity';
const String AI_MATKEY_TRANSPARENCYFACTOR = '\$mat.transparencyfactor';
const String AI_MATKEY_BUMPSCALING = '\$mat.bumpscaling';
const String AI_MATKEY_SHININESS = '\$mat.shininess';
const String AI_MATKEY_REFLECTIVITY = '\$mat.reflectivity';
const String AI_MATKEY_SHININESS_STRENGTH = '\$mat.shinpercent';
const String AI_MATKEY_REFRACTI = '\$mat.refracti';
const String AI_MATKEY_COLOR_DIFFUSE = '\$clr.diffuse';
const String AI_MATKEY_COLOR_AMBIENT = '\$clr.ambient';
const String AI_MATKEY_COLOR_SPECULAR = '\$clr.specular';
const String AI_MATKEY_COLOR_EMISSIVE = '\$clr.emissive';
const String AI_MATKEY_COLOR_TRANSPARENT = '\$clr.transparent';
const String AI_MATKEY_COLOR_REFLECTIVE = '\$clr.reflective';
const String AI_MATKEY_GLOBAL_BACKGROUND_IMAGE = '?bg.global';
const String AI_MATKEY_GLOBAL_SHADERLANG = '?sh.lang';
const String AI_MATKEY_SHADER_VERTEX = '?sh.vs';
const String AI_MATKEY_SHADER_FRAGMENT = '?sh.fs';
const String AI_MATKEY_SHADER_GEO = '?sh.gs';
const String AI_MATKEY_SHADER_TESSELATION = '?sh.ts';
const String AI_MATKEY_SHADER_PRIMITIVE = '?sh.ps';
const String AI_MATKEY_SHADER_COMPUTE = '?sh.cs';

// ---------------------------------------------------------------------------
// Pure key names for all texture-related properties
//! @cond MATS_DOC_FULL
const String _AI_MATKEY_TEXTURE_BASE = '\$tex.file';
const String _AI_MATKEY_UVWSRC_BASE = '\$tex.uvwsrc';
const String _AI_MATKEY_TEXOP_BASE = '\$tex.op';
const String _AI_MATKEY_MAPPING_BASE = '\$tex.mapping';
const String _AI_MATKEY_TEXBLEND_BASE = '\$tex.blend';
const String _AI_MATKEY_MAPPINGMODE_U_BASE = '\$tex.mapmodeu';
const String _AI_MATKEY_MAPPINGMODE_V_BASE = '\$tex.mapmodev';
const String _AI_MATKEY_TEXMAP_AXIS_BASE = '\$tex.mapaxis';
const String _AI_MATKEY_UVTRANSFORM_BASE = '\$tex.uvtrafo';
const String _AI_MATKEY_TEXFLAGS_BASE = '\$tex.flags';
//! @endcond

// ---------------------------------------------------------------------------
//#define AI_MATKEY_TEXTURE(type, N) _AI_MATKEY_TEXTURE_BASE,type,N
//
//// For backward compatibility and simplicity
////! @cond MATS_DOC_FULL
//#define AI_MATKEY_TEXTURE_DIFFUSE(N)    \
//    AI_MATKEY_TEXTURE(aiTextureType_DIFFUSE,N)
//
//#define AI_MATKEY_TEXTURE_SPECULAR(N)   \
//    AI_MATKEY_TEXTURE(aiTextureType_SPECULAR,N)
//
//#define AI_MATKEY_TEXTURE_AMBIENT(N)    \
//    AI_MATKEY_TEXTURE(aiTextureType_AMBIENT,N)
//
//#define AI_MATKEY_TEXTURE_EMISSIVE(N)   \
//    AI_MATKEY_TEXTURE(aiTextureType_EMISSIVE,N)
//
//#define AI_MATKEY_TEXTURE_NORMALS(N)    \
//    AI_MATKEY_TEXTURE(aiTextureType_NORMALS,N)
//
//#define AI_MATKEY_TEXTURE_HEIGHT(N) \
//    AI_MATKEY_TEXTURE(aiTextureType_HEIGHT,N)
//
//#define AI_MATKEY_TEXTURE_SHININESS(N)  \
//    AI_MATKEY_TEXTURE(aiTextureType_SHININESS,N)
//
//#define AI_MATKEY_TEXTURE_OPACITY(N)    \
//    AI_MATKEY_TEXTURE(aiTextureType_OPACITY,N)
//
//#define AI_MATKEY_TEXTURE_DISPLACEMENT(N)   \
//    AI_MATKEY_TEXTURE(aiTextureType_DISPLACEMENT,N)
//
//#define AI_MATKEY_TEXTURE_LIGHTMAP(N)   \
//    AI_MATKEY_TEXTURE(aiTextureType_LIGHTMAP,N)
//
//#define AI_MATKEY_TEXTURE_REFLECTION(N) \
//    AI_MATKEY_TEXTURE(aiTextureType_REFLECTION,N)
//
////! @endcond
//
//// ---------------------------------------------------------------------------
//#define AI_MATKEY_UVWSRC(type, N) _AI_MATKEY_UVWSRC_BASE,type,N
//
//// For backward compatibility and simplicity
////! @cond MATS_DOC_FULL
//#define AI_MATKEY_UVWSRC_DIFFUSE(N) \
//    AI_MATKEY_UVWSRC(aiTextureType_DIFFUSE,N)
//
//#define AI_MATKEY_UVWSRC_SPECULAR(N)    \
//    AI_MATKEY_UVWSRC(aiTextureType_SPECULAR,N)
//
//#define AI_MATKEY_UVWSRC_AMBIENT(N) \
//    AI_MATKEY_UVWSRC(aiTextureType_AMBIENT,N)
//
//#define AI_MATKEY_UVWSRC_EMISSIVE(N)    \
//    AI_MATKEY_UVWSRC(aiTextureType_EMISSIVE,N)
//
//#define AI_MATKEY_UVWSRC_NORMALS(N) \
//    AI_MATKEY_UVWSRC(aiTextureType_NORMALS,N)
//
//#define AI_MATKEY_UVWSRC_HEIGHT(N)  \
//    AI_MATKEY_UVWSRC(aiTextureType_HEIGHT,N)
//
//#define AI_MATKEY_UVWSRC_SHININESS(N)   \
//    AI_MATKEY_UVWSRC(aiTextureType_SHININESS,N)
//
//#define AI_MATKEY_UVWSRC_OPACITY(N) \
//    AI_MATKEY_UVWSRC(aiTextureType_OPACITY,N)
//
//#define AI_MATKEY_UVWSRC_DISPLACEMENT(N)    \
//    AI_MATKEY_UVWSRC(aiTextureType_DISPLACEMENT,N)
//
//#define AI_MATKEY_UVWSRC_LIGHTMAP(N)    \
//    AI_MATKEY_UVWSRC(aiTextureType_LIGHTMAP,N)
//
//#define AI_MATKEY_UVWSRC_REFLECTION(N)  \
//    AI_MATKEY_UVWSRC(aiTextureType_REFLECTION,N)
//
////! @endcond
//// ---------------------------------------------------------------------------
//#define AI_MATKEY_TEXOP(type, N) _AI_MATKEY_TEXOP_BASE,type,N
//
//// For backward compatibility and simplicity
////! @cond MATS_DOC_FULL
//#define AI_MATKEY_TEXOP_DIFFUSE(N)  \
//    AI_MATKEY_TEXOP(aiTextureType_DIFFUSE,N)
//
//#define AI_MATKEY_TEXOP_SPECULAR(N) \
//    AI_MATKEY_TEXOP(aiTextureType_SPECULAR,N)
//
//#define AI_MATKEY_TEXOP_AMBIENT(N)  \
//    AI_MATKEY_TEXOP(aiTextureType_AMBIENT,N)
//
//#define AI_MATKEY_TEXOP_EMISSIVE(N) \
//    AI_MATKEY_TEXOP(aiTextureType_EMISSIVE,N)
//
//#define AI_MATKEY_TEXOP_NORMALS(N)  \
//    AI_MATKEY_TEXOP(aiTextureType_NORMALS,N)
//
//#define AI_MATKEY_TEXOP_HEIGHT(N)   \
//    AI_MATKEY_TEXOP(aiTextureType_HEIGHT,N)
//
//#define AI_MATKEY_TEXOP_SHININESS(N)    \
//    AI_MATKEY_TEXOP(aiTextureType_SHININESS,N)
//
//#define AI_MATKEY_TEXOP_OPACITY(N)  \
//    AI_MATKEY_TEXOP(aiTextureType_OPACITY,N)
//
//#define AI_MATKEY_TEXOP_DISPLACEMENT(N) \
//    AI_MATKEY_TEXOP(aiTextureType_DISPLACEMENT,N)
//
//#define AI_MATKEY_TEXOP_LIGHTMAP(N) \
//    AI_MATKEY_TEXOP(aiTextureType_LIGHTMAP,N)
//
//#define AI_MATKEY_TEXOP_REFLECTION(N)   \
//    AI_MATKEY_TEXOP(aiTextureType_REFLECTION,N)
//
////! @endcond
//// ---------------------------------------------------------------------------
//#define AI_MATKEY_MAPPING(type, N) _AI_MATKEY_MAPPING_BASE,type,N
//
//// For backward compatibility and simplicity
////! @cond MATS_DOC_FULL
//#define AI_MATKEY_MAPPING_DIFFUSE(N)    \
//    AI_MATKEY_MAPPING(aiTextureType_DIFFUSE,N)
//
//#define AI_MATKEY_MAPPING_SPECULAR(N)   \
//    AI_MATKEY_MAPPING(aiTextureType_SPECULAR,N)
//
//#define AI_MATKEY_MAPPING_AMBIENT(N)    \
//    AI_MATKEY_MAPPING(aiTextureType_AMBIENT,N)
//
//#define AI_MATKEY_MAPPING_EMISSIVE(N)   \
//    AI_MATKEY_MAPPING(aiTextureType_EMISSIVE,N)
//
//#define AI_MATKEY_MAPPING_NORMALS(N)    \
//    AI_MATKEY_MAPPING(aiTextureType_NORMALS,N)
//
//#define AI_MATKEY_MAPPING_HEIGHT(N) \
//    AI_MATKEY_MAPPING(aiTextureType_HEIGHT,N)
//
//#define AI_MATKEY_MAPPING_SHININESS(N)  \
//    AI_MATKEY_MAPPING(aiTextureType_SHININESS,N)
//
//#define AI_MATKEY_MAPPING_OPACITY(N)    \
//    AI_MATKEY_MAPPING(aiTextureType_OPACITY,N)
//
//#define AI_MATKEY_MAPPING_DISPLACEMENT(N)   \
//    AI_MATKEY_MAPPING(aiTextureType_DISPLACEMENT,N)
//
//#define AI_MATKEY_MAPPING_LIGHTMAP(N)   \
//    AI_MATKEY_MAPPING(aiTextureType_LIGHTMAP,N)
//
//#define AI_MATKEY_MAPPING_REFLECTION(N) \
//    AI_MATKEY_MAPPING(aiTextureType_REFLECTION,N)
//
////! @endcond
//// ---------------------------------------------------------------------------
//#define AI_MATKEY_TEXBLEND(type, N) _AI_MATKEY_TEXBLEND_BASE,type,N
//
//// For backward compatibility and simplicity
////! @cond MATS_DOC_FULL
//#define AI_MATKEY_TEXBLEND_DIFFUSE(N)   \
//    AI_MATKEY_TEXBLEND(aiTextureType_DIFFUSE,N)
//
//#define AI_MATKEY_TEXBLEND_SPECULAR(N)  \
//    AI_MATKEY_TEXBLEND(aiTextureType_SPECULAR,N)
//
//#define AI_MATKEY_TEXBLEND_AMBIENT(N)   \
//    AI_MATKEY_TEXBLEND(aiTextureType_AMBIENT,N)
//
//#define AI_MATKEY_TEXBLEND_EMISSIVE(N)  \
//    AI_MATKEY_TEXBLEND(aiTextureType_EMISSIVE,N)
//
//#define AI_MATKEY_TEXBLEND_NORMALS(N)   \
//    AI_MATKEY_TEXBLEND(aiTextureType_NORMALS,N)
//
//#define AI_MATKEY_TEXBLEND_HEIGHT(N)    \
//    AI_MATKEY_TEXBLEND(aiTextureType_HEIGHT,N)
//
//#define AI_MATKEY_TEXBLEND_SHININESS(N) \
//    AI_MATKEY_TEXBLEND(aiTextureType_SHININESS,N)
//
//#define AI_MATKEY_TEXBLEND_OPACITY(N)   \
//    AI_MATKEY_TEXBLEND(aiTextureType_OPACITY,N)
//
//#define AI_MATKEY_TEXBLEND_DISPLACEMENT(N)  \
//    AI_MATKEY_TEXBLEND(aiTextureType_DISPLACEMENT,N)
//
//#define AI_MATKEY_TEXBLEND_LIGHTMAP(N)  \
//    AI_MATKEY_TEXBLEND(aiTextureType_LIGHTMAP,N)
//
//#define AI_MATKEY_TEXBLEND_REFLECTION(N)    \
//    AI_MATKEY_TEXBLEND(aiTextureType_REFLECTION,N)
//
////! @endcond
//// ---------------------------------------------------------------------------
//#define AI_MATKEY_MAPPINGMODE_U(type, N) _AI_MATKEY_MAPPINGMODE_U_BASE,type,N
//
//// For backward compatibility and simplicity
////! @cond MATS_DOC_FULL
//#define AI_MATKEY_MAPPINGMODE_U_DIFFUSE(N)  \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_DIFFUSE,N)
//
//#define AI_MATKEY_MAPPINGMODE_U_SPECULAR(N) \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_SPECULAR,N)
//
//#define AI_MATKEY_MAPPINGMODE_U_AMBIENT(N)  \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_AMBIENT,N)
//
//#define AI_MATKEY_MAPPINGMODE_U_EMISSIVE(N) \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_EMISSIVE,N)
//
//#define AI_MATKEY_MAPPINGMODE_U_NORMALS(N)  \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_NORMALS,N)
//
//#define AI_MATKEY_MAPPINGMODE_U_HEIGHT(N)   \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_HEIGHT,N)
//
//#define AI_MATKEY_MAPPINGMODE_U_SHININESS(N)    \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_SHININESS,N)
//
//#define AI_MATKEY_MAPPINGMODE_U_OPACITY(N)  \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_OPACITY,N)
//
//#define AI_MATKEY_MAPPINGMODE_U_DISPLACEMENT(N) \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_DISPLACEMENT,N)
//
//#define AI_MATKEY_MAPPINGMODE_U_LIGHTMAP(N) \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_LIGHTMAP,N)
//
//#define AI_MATKEY_MAPPINGMODE_U_REFLECTION(N)   \
//    AI_MATKEY_MAPPINGMODE_U(aiTextureType_REFLECTION,N)
//
////! @endcond
//// ---------------------------------------------------------------------------
//#define AI_MATKEY_MAPPINGMODE_V(type, N) _AI_MATKEY_MAPPINGMODE_V_BASE,type,N
//
//// For backward compatibility and simplicity
////! @cond MATS_DOC_FULL
//#define AI_MATKEY_MAPPINGMODE_V_DIFFUSE(N)  \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_DIFFUSE,N)
//
//#define AI_MATKEY_MAPPINGMODE_V_SPECULAR(N) \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_SPECULAR,N)
//
//#define AI_MATKEY_MAPPINGMODE_V_AMBIENT(N)  \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_AMBIENT,N)
//
//#define AI_MATKEY_MAPPINGMODE_V_EMISSIVE(N) \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_EMISSIVE,N)
//
//#define AI_MATKEY_MAPPINGMODE_V_NORMALS(N)  \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_NORMALS,N)
//
//#define AI_MATKEY_MAPPINGMODE_V_HEIGHT(N)   \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_HEIGHT,N)
//
//#define AI_MATKEY_MAPPINGMODE_V_SHININESS(N)    \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_SHININESS,N)
//
//#define AI_MATKEY_MAPPINGMODE_V_OPACITY(N)  \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_OPACITY,N)
//
//#define AI_MATKEY_MAPPINGMODE_V_DISPLACEMENT(N) \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_DISPLACEMENT,N)
//
//#define AI_MATKEY_MAPPINGMODE_V_LIGHTMAP(N) \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_LIGHTMAP,N)
//
//#define AI_MATKEY_MAPPINGMODE_V_REFLECTION(N)   \
//    AI_MATKEY_MAPPINGMODE_V(aiTextureType_REFLECTION,N)
//
////! @endcond
//// ---------------------------------------------------------------------------
//#define AI_MATKEY_TEXMAP_AXIS(type, N) _AI_MATKEY_TEXMAP_AXIS_BASE,type,N
//
//// For backward compatibility and simplicity
////! @cond MATS_DOC_FULL
//#define AI_MATKEY_TEXMAP_AXIS_DIFFUSE(N)    \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_DIFFUSE,N)
//
//#define AI_MATKEY_TEXMAP_AXIS_SPECULAR(N)   \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_SPECULAR,N)
//
//#define AI_MATKEY_TEXMAP_AXIS_AMBIENT(N)    \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_AMBIENT,N)
//
//#define AI_MATKEY_TEXMAP_AXIS_EMISSIVE(N)   \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_EMISSIVE,N)
//
//#define AI_MATKEY_TEXMAP_AXIS_NORMALS(N)    \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_NORMALS,N)
//
//#define AI_MATKEY_TEXMAP_AXIS_HEIGHT(N) \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_HEIGHT,N)
//
//#define AI_MATKEY_TEXMAP_AXIS_SHININESS(N)  \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_SHININESS,N)
//
//#define AI_MATKEY_TEXMAP_AXIS_OPACITY(N)    \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_OPACITY,N)
//
//#define AI_MATKEY_TEXMAP_AXIS_DISPLACEMENT(N)   \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_DISPLACEMENT,N)
//
//#define AI_MATKEY_TEXMAP_AXIS_LIGHTMAP(N)   \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_LIGHTMAP,N)
//
//#define AI_MATKEY_TEXMAP_AXIS_REFLECTION(N) \
//    AI_MATKEY_TEXMAP_AXIS(aiTextureType_REFLECTION,N)
//
////! @endcond
//// ---------------------------------------------------------------------------
//#define AI_MATKEY_UVTRANSFORM(type, N) _AI_MATKEY_UVTRANSFORM_BASE,type,N
//
//// For backward compatibility and simplicity
////! @cond MATS_DOC_FULL
//#define AI_MATKEY_UVTRANSFORM_DIFFUSE(N)    \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_DIFFUSE,N)
//
//#define AI_MATKEY_UVTRANSFORM_SPECULAR(N)   \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_SPECULAR,N)
//
//#define AI_MATKEY_UVTRANSFORM_AMBIENT(N)    \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_AMBIENT,N)
//
//#define AI_MATKEY_UVTRANSFORM_EMISSIVE(N)   \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_EMISSIVE,N)
//
//#define AI_MATKEY_UVTRANSFORM_NORMALS(N)    \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_NORMALS,N)
//
//#define AI_MATKEY_UVTRANSFORM_HEIGHT(N) \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_HEIGHT,N)
//
//#define AI_MATKEY_UVTRANSFORM_SHININESS(N)  \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_SHININESS,N)
//
//#define AI_MATKEY_UVTRANSFORM_OPACITY(N)    \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_OPACITY,N)
//
//#define AI_MATKEY_UVTRANSFORM_DISPLACEMENT(N)   \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_DISPLACEMENT,N)
//
//#define AI_MATKEY_UVTRANSFORM_LIGHTMAP(N)   \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_LIGHTMAP,N)
//
//#define AI_MATKEY_UVTRANSFORM_REFLECTION(N) \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_REFLECTION,N)
//
//#define AI_MATKEY_UVTRANSFORM_UNKNOWN(N)    \
//    AI_MATKEY_UVTRANSFORM(aiTextureType_UNKNOWN,N)
//
////! @endcond
//// ---------------------------------------------------------------------------
//#define AI_MATKEY_TEXFLAGS(type, N) _AI_MATKEY_TEXFLAGS_BASE,type,N
//
//// For backward compatibility and simplicity
////! @cond MATS_DOC_FULL
//#define AI_MATKEY_TEXFLAGS_DIFFUSE(N)   \
//    AI_MATKEY_TEXFLAGS(aiTextureType_DIFFUSE,N)
//
//#define AI_MATKEY_TEXFLAGS_SPECULAR(N)  \
//    AI_MATKEY_TEXFLAGS(aiTextureType_SPECULAR,N)
//
//#define AI_MATKEY_TEXFLAGS_AMBIENT(N)   \
//    AI_MATKEY_TEXFLAGS(aiTextureType_AMBIENT,N)
//
//#define AI_MATKEY_TEXFLAGS_EMISSIVE(N)  \
//    AI_MATKEY_TEXFLAGS(aiTextureType_EMISSIVE,N)
//
//#define AI_MATKEY_TEXFLAGS_NORMALS(N)   \
//    AI_MATKEY_TEXFLAGS(aiTextureType_NORMALS,N)
//
//#define AI_MATKEY_TEXFLAGS_HEIGHT(N)    \
//    AI_MATKEY_TEXFLAGS(aiTextureType_HEIGHT,N)
//
//#define AI_MATKEY_TEXFLAGS_SHININESS(N) \
//    AI_MATKEY_TEXFLAGS(aiTextureType_SHININESS,N)
//
//#define AI_MATKEY_TEXFLAGS_OPACITY(N)   \
//    AI_MATKEY_TEXFLAGS(aiTextureType_OPACITY,N)
//
//#define AI_MATKEY_TEXFLAGS_DISPLACEMENT(N)  \
//    AI_MATKEY_TEXFLAGS(aiTextureType_DISPLACEMENT,N)
//
//#define AI_MATKEY_TEXFLAGS_LIGHTMAP(N)  \
//    AI_MATKEY_TEXFLAGS(aiTextureType_LIGHTMAP,N)
//
//#define AI_MATKEY_TEXFLAGS_REFLECTION(N)    \
//    AI_MATKEY_TEXFLAGS(aiTextureType_REFLECTION,N)
//
//#define AI_MATKEY_TEXFLAGS_UNKNOWN(N)   \
//    AI_MATKEY_TEXFLAGS(aiTextureType_UNKNOWN,N)

//! @endcond
//!
// ---------------------------------------------------------------------------
/** @brief Retrieve a material property with a specific key from the material
 *
 * @param pMat Pointer to the input material. May not be NULL
 * @param pKey Key to search for. One of the AI_MATKEY_XXX constants.
 * @param type Specifies the type of the texture to be retrieved (
 *    e.g. diffuse, specular, height map ...)
 * @param index Index of the texture to be retrieved.
 * @param pPropOut Pointer to receive a pointer to a valid aiMaterialProperty
 *        structure or NULL if the key has not been found. */
// ---------------------------------------------------------------------------
typedef aiGetMaterialProperty_t = Uint32 Function(
  Pointer<aiMaterial> mat,
  Pointer<Utf8> key,
  Uint32 type,
  Uint32 index,
  Pointer<Pointer<aiMaterialProperty>> propOut,
);

// ---------------------------------------------------------------------------
/** @brief Retrieve an array of float values with a specific key
 *  from the material
 *
 * Pass one of the AI_MATKEY_XXX constants for the last three parameters (the
 * example reads the #AI_MATKEY_UVTRANSFORM property of the first diffuse texture)
 * @code
 * aiUVTransform trafo;
 * unsigned int max = sizeof(aiUVTransform);
 * if (AI_SUCCESS != aiGetMaterialFloatArray(mat, AI_MATKEY_UVTRANSFORM(aiTextureType_DIFFUSE,0),
 *    (float*)&trafo, &max) || sizeof(aiUVTransform) != max)
 * {
 *   // error handling
 * }
 * @endcode
 *
 * @param pMat Pointer to the input material. May not be NULL
 * @param pKey Key to search for. One of the AI_MATKEY_XXX constants.
 * @param pOut Pointer to a buffer to receive the result.
 * @param pMax Specifies the size of the given buffer, in float's.
 *        Receives the number of values (not bytes!) read.
 * @param type (see the code sample above)
 * @param index (see the code sample above)
 * @return Specifies whether the key has been found. If not, the output
 *   arrays remains unmodified and pMax is set to 0.*/
// ---------------------------------------------------------------------------
typedef aiGetMaterialFloatArray_t = Uint32 Function(
    Pointer<aiMaterial> mat,
    Pointer<Utf8> key,
    Uint32 type,
    Uint32 index,
    Pointer<Float> out, // ai_real*
    Pointer<Uint32> max);

//// Use our friend, the C preprocessor
//#define aiGetMaterialFloat (pMat, type, index, pKey, pOut) \
//    aiGetMaterialFloatArray(pMat, type, index, pKey, pOut, NULL)

// ---------------------------------------------------------------------------
/** @brief Retrieve an array of integer values with a specific key
 *  from a material
 *
 * See the sample for aiGetMaterialFloatArray for more information.*/
typedef aiGetMaterialIntegerArray_t = Uint32 Function(
    Pointer<aiMaterial> mat,
    Pointer<Utf8> key,
    Uint32 type,
    Uint32 index,
    Pointer<Int32> out,
    Pointer<Uint32> max);

//// use our friend, the C preprocessor
//#define aiGetMaterialInteger (pMat, type, index, pKey, pOut) \
//    aiGetMaterialIntegerArray(pMat, type, index, pKey, pOut, NULL)

// ---------------------------------------------------------------------------
/** @brief Retrieve a color value from the material property table
*
* See the sample for aiGetMaterialFloat for more information*/
// ---------------------------------------------------------------------------
typedef aiGetMaterialColor_t = Uint32 Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, Uint32 type, Uint32 index, Pointer<aiColor4D> out);

// ---------------------------------------------------------------------------
/** @brief Retrieve a aiUVTransform value from the material property table
*
* See the sample for aiGetMaterialFloat for more information*/
// ---------------------------------------------------------------------------
typedef aiGetMaterialUVTransform_t = Uint32 Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, Uint32 type, Uint32 index, Pointer<aiUVTransform> out);

// ---------------------------------------------------------------------------
/** @brief Retrieve a string from the material property table
*
* See the sample for aiGetMaterialFloat for more information.*/
// ---------------------------------------------------------------------------
typedef aiGetMaterialString_t = Uint32 Function(Pointer<aiMaterial> mat,
    Pointer<Utf8> key, Uint32 type, Uint32 index, Pointer<aiString> out);

// ---------------------------------------------------------------------------
/** Get the number of textures for a particular texture type.
 *  @param[in] pMat Pointer to the input material. May not be NULL
 *  @param type Texture type to check for
 *  @return Number of textures for this type.
 *  @note A texture can be easily queried using #aiGetMaterialTexture() */
// ---------------------------------------------------------------------------
typedef aiGetMaterialTextureCount_t = Uint32 Function(
  Pointer<aiMaterial> mat,
  Uint32 type, // aiTextureType
);

// ---------------------------------------------------------------------------
/** @brief Helper function to get all values pertaining to a particular
 *  texture slot from a material structure.
 *
 *  This function is provided just for convenience. You could also read the
 *  texture by parsing all of its properties manually. This function bundles
 *  all of them in a huge function monster.
 *
 *  @param[in] mat Pointer to the input material. May not be NULL
 *  @param[in] type Specifies the texture stack to read from (e.g. diffuse,
 *     specular, height map ...).
 *  @param[in] index Index of the texture. The function fails if the
 *     requested index is not available for this texture type.
 *     #aiGetMaterialTextureCount() can be used to determine the number of
 *     textures in a particular texture stack.
 *  @param[out] path Receives the output path
 *     If the texture is embedded, receives a '*' followed by the id of
 *     the texture (for the textures stored in the corresponding scene) which
 *     can be converted to an int using a function like atoi.
 *     This parameter must be non-null.
 *  @param mapping The texture mapping mode to be used.
 *      Pass NULL if you're not interested in this information.
 *  @param[out] uvindex For UV-mapped textures: receives the index of the UV
 *      source channel. Unmodified otherwise.
 *      Pass NULL if you're not interested in this information.
 *  @param[out] blend Receives the blend factor for the texture
 *      Pass NULL if you're not interested in this information.
 *  @param[out] op Receives the texture blend operation to be perform between
 *      this texture and the previous texture.
 *      Pass NULL if you're not interested in this information.
 *  @param[out] mapmode Receives the mapping modes to be used for the texture.
 *      Pass NULL if you're not interested in this information. Otherwise,
 *      pass a pointer to an array of two aiTextureMapMode's (one for each
 *      axis, UV order).
 *  @param[out] flags Receives the the texture flags.
 *  @return AI_SUCCESS on success, otherwise something else. Have fun.*/
// ---------------------------------------------------------------------------
typedef aiGetMaterialTexture_t = Uint32 Function(
  Pointer<aiMaterial> mat,
  Uint32 type, // aiTextureType
  Uint32 index,
  Pointer<aiString> path,
  Pointer<Uint32> mapping, // aiTextureMapping*
  Pointer<Uint32> uvindex,
  Pointer<Float> blend, // ai_real*
  Pointer<Uint32> op, // aiTextureOp*
  Pointer<Uint32> mapmode, // aiTextureMapMode*
  Pointer<Uint32> flags,
);
