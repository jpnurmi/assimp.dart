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

/** @file mesh.h
 *  @brief Declares the data structures in which the imported geometry is
    returned by ASSIMP: aiMesh, aiFace and aiBone data structures.
 */

import 'types.dart';

// ---------------------------------------------------------------------------
// Limits. These values are required to match the settings Assimp was
// compiled against. Therefore, do not redefine them unless you build the
// library from source using the same definitions.
// ---------------------------------------------------------------------------

/** @def AI_MAX_FACE_INDICES
 *  Maximum number of indices per face (polygon). */
const int AI_MAX_FACE_INDICES = 0x7fff;

/** @def AI_MAX_BONE_WEIGHTS
 *  Maximum number of indices per face (polygon). */
const int AI_MAX_BONE_WEIGHTS = 0x7fffffff;

/** @def AI_MAX_VERTICES
 *  Maximum number of vertices per mesh.  */
const int AI_MAX_VERTICES = 0x7fffffff;

/** @def AI_MAX_FACES
 *  Maximum number of faces per mesh. */
const int AI_MAX_FACES = 0x7fffffff;

/** @def AI_MAX_NUMBER_OF_COLOR_SETS
 *  Supported number of vertex color sets per mesh. */
const int AI_MAX_NUMBER_OF_COLOR_SETS = 0x8;

/** @def AI_MAX_NUMBER_OF_TEXTURECOORDS
 *  Supported number of texture coord sets (UV(W) channels) per mesh */
const int AI_MAX_NUMBER_OF_TEXTURECOORDS = 0x8;

// ---------------------------------------------------------------------------
/** @brief A single face in a mesh, referring to multiple vertices.
 *
 * If mNumIndices is 3, we call the face 'triangle', for mNumIndices > 3
 * it's called 'polygon' (hey, that's just a definition!).
 * <br>
 * aiMesh::mPrimitiveTypes can be queried to quickly examine which types of
 * primitive are actually present in a mesh. The #aiProcess_SortByPType flag
 * executes a special post-processing algorithm which splits meshes with
 * *different* primitive types mixed up (e.g. lines and triangles) in several
 * 'clean' submeshes. Furthermore there is a configuration option (
 * #AI_CONFIG_PP_SBP_REMOVE) to force #aiProcess_SortByPType to remove
 * specific kinds of primitives from the imported scene, completely and forever.
 * In many cases you'll probably want to set this setting to
 * @code
 * aiPrimitiveType_LINE|aiPrimitiveType_POINT
 * @endcode
 * Together with the #aiProcess_Triangulate flag you can then be sure that
 * #aiFace::mNumIndices is always 3.
 * @note Take a look at the @link data Data Structures page @endlink for
 * more information on the layout and winding order of a face.
 */
class aiFace extends Struct {
  //! Number of indices defining this face.
  //! The maximum value for this member is #AI_MAX_FACE_INDICES.
  @Uint32()
  int mNumIndices;

  //! Pointer to the indices array. Size of the array is given in numIndices.
  Pointer<Uint32> mIndices;
} // struct aiFace

// ---------------------------------------------------------------------------
/** @brief A single influence of a bone on a vertex.
 */
class aiVertexWeight extends Struct {
  //! Index of the vertex which is influenced by the bone.
  @Uint32()
  int mVertexId;

  //! The strength of the influence in the range (0...1).
  //! The influence from all bones at one vertex amounts to 1.
  @Float()
  double mWeight;
}

// ---------------------------------------------------------------------------
/** @brief A single bone of a mesh.
 *
 *  A bone has a name by which it can be found in the frame hierarchy and by
 *  which it can be addressed by animations. In addition it has a number of
 *  influences on vertices, and a matrix relating the mesh position to the
 *  position of the bone at the time of binding.
 */
class aiBone extends Struct {
  //! The name of the bone.
  Pointer<aiString> mName;

  //! The number of vertices affected by this bone.
  //! The maximum value for this member is #AI_MAX_BONE_WEIGHTS.
  @Uint32()
  int mNumWeights;

  //! The influence weights of this bone, by vertex index.
  Pointer<aiVertexWeight> mWeights;

  /** Matrix that transforms from bone space to mesh space in bind pose.
     *
     * This matrix describes the position of the mesh
     * in the local space of this bone when the skeleton was bound.
     * Thus it can be used directly to determine a desired vertex position,
     * given the world-space transform of the bone when animated,
     * and the position of the vertex in mesh space.
     *
     * It is sometimes called an inverse-bind matrix,
     * or inverse bind pose matrix.
     */
  Pointer<aiMatrix4x4> mOffsetMatrix;
}

// ---------------------------------------------------------------------------
/** @brief Enumerates the types of geometric primitives supported by Assimp.
 *
 *  @see aiFace Face data structure
 *  @see aiProcess_SortByPType Per-primitive sorting of meshes
 *  @see aiProcess_Triangulate Automatic triangulation
 *  @see AI_CONFIG_PP_SBP_REMOVE Removal of specific primitive types.
 */
class aiPrimitiveType {
  /** A point primitive.
     *
     * This is just a single vertex in the virtual world,
     * #aiFace contains just one index for such a primitive.
     */
  static const int POINT = 0x1;

  /** A line primitive.
     *
     * This is a line defined through a start and an end position.
     * #aiFace contains exactly two indices for such a primitive.
     */
  static const int LINE = 0x2;

  /** A triangular primitive.
     *
     * A triangle consists of three indices.
     */
  static const int TRIANGLE = 0x4;

  /** A higher-level polygon with more than 3 edges.
     *
     * A triangle is a polygon, but polygon in this context means
     * "all polygons that are not triangles". The "Triangulate"-Step
     * is provided for your convenience, it splits all polygons in
     * triangles (which are much easier to handle).
     */
  static const int POLYGON = 0x8;
} //! enum aiPrimitiveType

// Get the #aiPrimitiveType flag for a specific number of face indices
int AI_PRIMITIVE_TYPE_FOR_N_INDICES(int n) =>
    ((n) > 3 ? aiPrimitiveType.POLYGON : (1 << ((n) - 1)));

// ---------------------------------------------------------------------------
/** @brief An AnimMesh is an attachment to an #aiMesh stores per-vertex
 *  animations for a particular frame.
 *
 *  You may think of an #aiAnimMesh as a `patch` for the host mesh, which
 *  replaces only certain vertex data streams at a particular time.
 *  Each mesh stores n attached attached meshes (#aiMesh::mAnimMeshes).
 *  The actual relationship between the time line and anim meshes is
 *  established by #aiMeshAnim, which references singular mesh attachments
 *  by their ID and binds them to a time offset.
*/
class aiAnimMesh extends Struct {
  /**Anim Mesh name */
  Pointer<aiString> mName;

  /** Replacement for aiMesh::mVertices. If this array is non-NULL,
     *  it *must* contain mNumVertices entries. The corresponding
     *  array in the host mesh must be non-NULL as well - animation
     *  meshes may neither add or nor remove vertex components (if
     *  a replacement array is NULL and the corresponding source
     *  array is not, the source data is taken instead)*/
  Pointer<aiVector3D> mVertices;

  /** Replacement for aiMesh::mNormals.  */
  Pointer<aiVector3D> mNormals;

  /** Replacement for aiMesh::mTangents. */
  Pointer<aiVector3D> mTangents;

  /** Replacement for aiMesh::mBitangents. */
  Pointer<aiVector3D> mBitangents;

  /** Replacement for aiMesh::mColors */
  Pointer<Pointer<aiColor4D>> mColors; // AI_MAX_NUMBER_OF_COLOR_SETS

  /** Replacement for aiMesh::mTextureCoords */
  Pointer<Pointer<aiVector3D>> mTextureCoords; // AI_MAX_NUMBER_OF_TEXTURECOORDS

  /** The number of vertices in the aiAnimMesh, and thus the length of all
     * the member arrays.
     *
     * This has always the same value as the mNumVertices property in the
     * corresponding aiMesh. It is duplicated here merely to make the length
     * of the member arrays accessible even if the aiMesh is not known, e.g.
     * from language bindings.
     */
  @Uint32()
  int mNumVertices;

  /**
     * Weight of the AnimMesh.
     */
  @Float()
  double mWeight;
}

// ---------------------------------------------------------------------------
/** @brief Enumerates the methods of mesh morphing supported by Assimp.
 */
class aiMorphingMethod {
  /** Interpolation between morph targets */
  static const int VERTEX_BLEND = 0x1;

  /** Normalized morphing between morph targets  */
  static const int MORPH_NORMALIZED = 0x2;

  /** Relative morphing between morph targets  */
  static const int MORPH_RELATIVE = 0x3;
} //! enum aiMorphingMethod

// ---------------------------------------------------------------------------
/** @brief A mesh represents a geometry or model with a single material.
*
* It usually consists of a number of vertices and a series of primitives/faces
* referencing the vertices. In addition there might be a series of bones, each
* of them addressing a number of vertices with a certain weight. Vertex data
* is presented in channels with each channel containing a single per-vertex
* information such as a set of texture coords or a normal vector.
* If a data pointer is non-null, the corresponding data stream is present.
* From C++-programs you can also use the comfort functions Has*() to
* test for the presence of various data streams.
*
* A Mesh uses only a single material which is referenced by a material ID.
* @note The mPositions member is usually not optional. However, vertex positions
* *could* be missing if the #AI_SCENE_FLAGS_INCOMPLETE flag is set in
* @code
* aiScene::mFlags
* @endcode
*/
class aiMesh extends Struct {
  /** Bitwise combination of the members of the #aiPrimitiveType enum.
     * This specifies which types of primitives are present in the mesh.
     * The "SortByPrimitiveType"-Step can be used to make sure the
     * output meshes consist of one primitive type each.
     */
  @Uint32()
  int mPrimitiveTypes;

  /** The number of vertices in this mesh.
    * This is also the size of all of the per-vertex data arrays.
    * The maximum value for this member is #AI_MAX_VERTICES.
    */
  @Uint32()
  int mNumVertices;

  /** The number of primitives (triangles, polygons, lines) in this  mesh.
    * This is also the size of the mFaces array.
    * The maximum value for this member is #AI_MAX_FACES.
    */
  @Uint32()
  int mNumFaces;

  @Uint32()
  int _mPadding0;

  /** Vertex positions.
    * This array is always present in a mesh. The array is
    * mNumVertices in size.
    */
  Pointer<aiVector3D> mVertices;

  /** Vertex normals.
    * The array contains normalized vectors, NULL if not present.
    * The array is mNumVertices in size. Normals are undefined for
    * point and line primitives. A mesh consisting of points and
    * lines only may not have normal vectors. Meshes with mixed
    * primitive types (i.e. lines and triangles) may have normals,
    * but the normals for vertices that are only referenced by
    * point or line primitives are undefined and set to QNaN (WARN:
    * qNaN compares to inequal to *everything*, even to qNaN itself.
    * Using code like this to check whether a field is qnan is:
    * @code
    * #define IS_QNAN(f) (f != f)
    * @endcode
    * still dangerous because even 1.f == 1.f could evaluate to false! (
    * remember the subtleties of IEEE754 artithmetics). Use stuff like
    * @c fpclassify instead.
    * @note Normal vectors computed by Assimp are always unit-length.
    * However, this needn't apply for normals that have been taken
    *   directly from the model file.
    */
  Pointer<aiVector3D> mNormals;

  /** Vertex tangents.
    * The tangent of a vertex points in the direction of the positive
    * X texture axis. The array contains normalized vectors, NULL if
    * not present. The array is mNumVertices in size. A mesh consisting
    * of points and lines only may not have normal vectors. Meshes with
    * mixed primitive types (i.e. lines and triangles) may have
    * normals, but the normals for vertices that are only referenced by
    * point or line primitives are undefined and set to qNaN.  See
    * the #mNormals member for a detailed discussion of qNaNs.
    * @note If the mesh contains tangents, it automatically also
    * contains bitangents.
    */
  Pointer<aiVector3D> mTangents;

  /** Vertex bitangents.
    * The bitangent of a vertex points in the direction of the positive
    * Y texture axis. The array contains normalized vectors, NULL if not
    * present. The array is mNumVertices in size.
    * @note If the mesh contains tangents, it automatically also contains
    * bitangents.
    */
  Pointer<aiVector3D> mBitangents;

  /** Vertex color sets.
    * A mesh may contain 0 to #AI_MAX_NUMBER_OF_COLOR_SETS vertex
    * colors per vertex. NULL if not present. Each array is
    * mNumVertices in size if present.
    */
  Pointer<Pointer<aiColor4D>> get mColors =>
      Pointer<Pointer<aiColor4D>>.fromAddress(addressOf.address + 48);
  Pointer<Void> _mColors0;
  Pointer<Void> _mColors1;
  Pointer<Void> _mColors2;
  Pointer<Void> _mColors3;
  Pointer<Void> _mColors4;
  Pointer<Void> _mColors5;
  Pointer<Void> _mColors6;
  Pointer<Void> _mColors7;

  /** Vertex texture coords, also known as UV channels.
    * A mesh may contain 0 to AI_MAX_NUMBER_OF_TEXTURECOORDS per
    * vertex. NULL if not present. The array is mNumVertices in size.
    */
  Pointer<Pointer<aiVector3D>> get mTextureCoords =>
      Pointer<Pointer<aiVector3D>>.fromAddress(addressOf.address + 112);
  Pointer<Void> _mTextureCoords0;
  Pointer<Void> _mTextureCoords1;
  Pointer<Void> _mTextureCoords2;
  Pointer<Void> _mTextureCoords3;
  Pointer<Void> _mTextureCoords4;
  Pointer<Void> _mTextureCoords5;
  Pointer<Void> _mTextureCoords6;
  Pointer<Void> _mTextureCoords7;

  /** Specifies the number of components for a given UV channel.
    * Up to three channels are supported (UVW, for accessing volume
    * or cube maps). If the value is 2 for a given channel n, the
    * component p.z of mTextureCoords[n][p] is set to 0.0f.
    * If the value is 1 for a given channel, p.y is set to 0.0f, too.
    * @note 4D coords are not supported
    */
  Pointer<Uint32> get mNumUVComponents =>
      Pointer<Uint32>.fromAddress(addressOf.address + 176);
  Pointer<Void> _mNumUVComponents0;
  Pointer<Void> _mNumUVComponents1;
  Pointer<Void> _mNumUVComponents2;
  Pointer<Void> _mNumUVComponents3;

  /** The faces the mesh is constructed from.
    * Each face refers to a number of vertices by their indices.
    * This array is always present in a mesh, its size is given
    * in mNumFaces. If the #AI_SCENE_FLAGS_NON_VERBOSE_FORMAT
    * is NOT set each face references an unique set of vertices.
    */
  Pointer<aiFace> mFaces;

  /** The number of bones this mesh contains.
    * Can be 0, in which case the mBones array is NULL.
    */
  @Uint32()
  int mNumBones;

  @Uint32()
  int _mPadding1;

  /** The bones of this mesh.
    * A bone consists of a name by which it can be found in the
    * frame hierarchy and a set of vertex weights.
    */
  Pointer<Pointer<aiBone>> mBones;

  /** The material used by this mesh.
     * A mesh uses only a single material. If an imported model uses
     * multiple materials, the import splits up the mesh. Use this value
     * as index into the scene's material list.
     */
  @Uint32()
  int mMaterialIndex;

  /** Name of the mesh. Meshes can be named, but this is not a
     *  requirement and leaving this field empty is totally fine.
     *  There are mainly three uses for mesh names:
     *   - some formats name nodes and meshes independently.
     *   - importers tend to split meshes up to meet the
     *      one-material-per-mesh requirement. Assigning
     *      the same (dummy) name to each of the result meshes
     *      aids the caller at recovering the original mesh
     *      partitioning.
     *   - Vertex animations refer to meshes by their names.
     **/
  @Uint32()
  int mNameLength;
  Pointer<Utf8> get mName => Pointer<Utf8>.fromAddress(addressOf.address + 240);
  Pointer<Void> _mName0;
  Pointer<Void> _mName1;
  Pointer<Void> _mName2;
  Pointer<Void> _mName3;
  Pointer<Void> _mName4;
  Pointer<Void> _mName5;
  Pointer<Void> _mName6;
  Pointer<Void> _mName7;
  Pointer<Void> _mName8;
  Pointer<Void> _mName9;
  Pointer<Void> _mName10;
  Pointer<Void> _mName11;
  Pointer<Void> _mName12;
  Pointer<Void> _mName13;
  Pointer<Void> _mName14;
  Pointer<Void> _mName15;
  Pointer<Void> _mName16;
  Pointer<Void> _mName17;
  Pointer<Void> _mName18;
  Pointer<Void> _mName19;
  Pointer<Void> _mName20;
  Pointer<Void> _mName21;
  Pointer<Void> _mName22;
  Pointer<Void> _mName23;
  Pointer<Void> _mName24;
  Pointer<Void> _mName25;
  Pointer<Void> _mName26;
  Pointer<Void> _mName27;
  Pointer<Void> _mName28;
  Pointer<Void> _mName29;
  Pointer<Void> _mName30;
  Pointer<Void> _mName31;
  Pointer<Void> _mName32;
  Pointer<Void> _mName33;
  Pointer<Void> _mName34;
  Pointer<Void> _mName35;
  Pointer<Void> _mName36;
  Pointer<Void> _mName37;
  Pointer<Void> _mName38;
  Pointer<Void> _mName39;
  Pointer<Void> _mName40;
  Pointer<Void> _mName41;
  Pointer<Void> _mName42;
  Pointer<Void> _mName43;
  Pointer<Void> _mName44;
  Pointer<Void> _mName45;
  Pointer<Void> _mName46;
  Pointer<Void> _mName47;
  Pointer<Void> _mName48;
  Pointer<Void> _mName49;
  Pointer<Void> _mName50;
  Pointer<Void> _mName51;
  Pointer<Void> _mName52;
  Pointer<Void> _mName53;
  Pointer<Void> _mName54;
  Pointer<Void> _mName55;
  Pointer<Void> _mName56;
  Pointer<Void> _mName57;
  Pointer<Void> _mName58;
  Pointer<Void> _mName59;
  Pointer<Void> _mName60;
  Pointer<Void> _mName61;
  Pointer<Void> _mName62;
  Pointer<Void> _mName63;
  Pointer<Void> _mName64;
  Pointer<Void> _mName65;
  Pointer<Void> _mName66;
  Pointer<Void> _mName67;
  Pointer<Void> _mName68;
  Pointer<Void> _mName69;
  Pointer<Void> _mName70;
  Pointer<Void> _mName71;
  Pointer<Void> _mName72;
  Pointer<Void> _mName73;
  Pointer<Void> _mName74;
  Pointer<Void> _mName75;
  Pointer<Void> _mName76;
  Pointer<Void> _mName77;
  Pointer<Void> _mName78;
  Pointer<Void> _mName79;
  Pointer<Void> _mName80;
  Pointer<Void> _mName81;
  Pointer<Void> _mName82;
  Pointer<Void> _mName83;
  Pointer<Void> _mName84;
  Pointer<Void> _mName85;
  Pointer<Void> _mName86;
  Pointer<Void> _mName87;
  Pointer<Void> _mName88;
  Pointer<Void> _mName89;
  Pointer<Void> _mName90;
  Pointer<Void> _mName91;
  Pointer<Void> _mName92;
  Pointer<Void> _mName93;
  Pointer<Void> _mName94;
  Pointer<Void> _mName95;
  Pointer<Void> _mName96;
  Pointer<Void> _mName97;
  Pointer<Void> _mName98;
  Pointer<Void> _mName99;
  Pointer<Void> _mName100;
  Pointer<Void> _mName101;
  Pointer<Void> _mName102;
  Pointer<Void> _mName103;
  Pointer<Void> _mName104;
  Pointer<Void> _mName105;
  Pointer<Void> _mName106;
  Pointer<Void> _mName107;
  Pointer<Void> _mName108;
  Pointer<Void> _mName109;
  Pointer<Void> _mName110;
  Pointer<Void> _mName111;
  Pointer<Void> _mName112;
  Pointer<Void> _mName113;
  Pointer<Void> _mName114;
  Pointer<Void> _mName115;
  Pointer<Void> _mName116;
  Pointer<Void> _mName117;
  Pointer<Void> _mName118;
  Pointer<Void> _mName119;
  Pointer<Void> _mName120;
  Pointer<Void> _mName121;
  Pointer<Void> _mName122;
  Pointer<Void> _mName123;
  Pointer<Void> _mName124;
  Pointer<Void> _mName125;
  Pointer<Void> _mName126;
  Pointer<Void> _mName127;

  /** The number of attachment meshes. Note! Currently only works with Collada loader. */
  @Uint32()
  int mNumAnimMeshes;

  @Uint32()
  int _mPadding2;

  /** Attachment meshes for this mesh, for vertex-based animation.
     *  Attachment meshes carry replacement data for some of the
     *  mesh'es vertex components (usually positions, normals).
     *  Note! Currently only works with Collada loader.*/
  Pointer<Pointer<aiAnimMesh>> mAnimMeshes;

  /**
     *  Method of morphing when animeshes are specified.
     */
  @Uint32()
  int mMethod;

  /**
     *
     */
  @Float()
  double mMinX;
  @Float()
  double mMinY;
  @Float()
  double mMinZ;
  @Float()
  double mMaxX;
  @Float()
  double mMaxY;
  @Float()
  double mMaxZ;

  @Uint32()
  int _mPadding3;
}
