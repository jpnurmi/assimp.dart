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
import 'dart:typed_data';

import 'animesh.dart';
import 'bindings.dart';
import 'extensions.dart';
import 'type.dart';

/// A single face in a mesh, referring to multiple vertices.
///
/// If mNumIndices is 3, we call the face 'triangle', for mNumIndices > 3
/// it's called 'polygon' (hey, that's just a definition!).
/// <br>
/// aiMesh::mPrimitiveTypes can be queried to quickly examine which types of
/// primitive are actually present in a mesh. The #aiProcess_SortByPType flag
/// executes a special post-processing algorithm which splits meshes with
/// *different* primitive types mixed up (e.g. lines and triangles) in several
/// 'clean' submeshes. Furthermore there is a configuration option (
/// #AI_CONFIG_PP_SBP_REMOVE) to force #aiProcess_SortByPType to remove
/// specific kinds of primitives from the imported scene, completely and forever.
/// In many cases you'll probably want to set this setting to
/// @code
/// aiPrimitiveType_LINE|aiPrimitiveType_POINT
/// @endcode
/// Together with the #aiProcess_Triangulate flag you can then be sure that
/// #aiFace::mNumIndices is always 3.
/// @note Take a look at the @link data Data Structures page @endlink for
/// more information on the layout and winding order of a face.
class Face extends AssimpType<aiFace> {
  aiFace get _face => ptr.ref;

  Face._(Pointer<aiFace> ptr) : super(ptr);
  factory Face.fromNative(Pointer<aiFace> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Face._(ptr);
  }

  /// Pointer to the indices array. Size of the array is given in numIndices.
  Iterable<int> get indices => _face.mIndices.asTypedList(_face.mNumIndices);

  Uint32List get indexData =>
      _face.mIndices.cast<Uint32>().asTypedList(_face.mNumIndices);
}

/// A single influence of a bone on a vertex.
class VertexWeight extends AssimpType<aiVertexWeight> {
  aiVertexWeight get _vertexWeight => ptr.ref;

  VertexWeight._(Pointer<aiVertexWeight> ptr) : super(ptr);
  factory VertexWeight.fromNative(Pointer<aiVertexWeight> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return VertexWeight._(ptr);
  }

  /// Index of the vertex which is influenced by the bone.
  int get vertexId => _vertexWeight.mVertexId;

  /// The strength of the influence in the range (0...1).
  /// The influence from all bones at one vertex amounts to 1.
  double get weight => _vertexWeight.mWeight;
}

/// A single bone of a mesh.
///
/// A bone has a name by which it can be found in the frame hierarchy and by
/// which it can be addressed by animations. In addition it has a number of
/// influences on vertices, and a matrix relating the mesh position to the
/// position of the bone at the time of binding.
class Bone extends AssimpType<aiBone> {
  aiBone get _bone => ptr.ref;

  Bone._(Pointer<aiBone> ptr) : super(ptr);
  factory Bone.fromNative(Pointer<aiBone> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Bone._(ptr);
  }

  /// The name of the bone.
  String get name => AssimpString.fromNative(_bone.mName);

  /// The influence weights of this bone, by vertex index.
  Iterable<VertexWeight> get weights {
    return Iterable.generate(
      _bone.mNumWeights,
      (i) => VertexWeight.fromNative(_bone.mWeights.elementAt(i)),
    );
  }

  /// Matrix that transforms from bone space to mesh space in bind pose.
  ///
  /// This matrix describes the position of the mesh
  /// in the local space of this bone when the skeleton was bound.
  /// Thus it can be used directly to determine a desired vertex position,
  /// given the world-space transform of the bone when animated,
  /// and the position of the vertex in mesh space.
  ///
  /// It is sometimes called an inverse-bind matrix,
  /// or inverse bind pose matrix.
  Matrix4 get offset => AssimpMatrix4.fromNative(_bone.mOffsetMatrix);
}

/// The types of geometric primitives supported by Assimp.
///
/// See also:
/// - [Face] data structure
/// - [PostProcess.sortByPType] for per-primitive sorting of meshes
/// - [PostProcess.triangulate] for automatic triangulation
/// - [AI_CONFIG_PP_SBP_REMOVE] for removal of specific primitive types.
class PrimitiveType {
  /// A point primitive.
  ///
  /// This is just a single vertex in the virtual world,
  /// [Face] contains just one index for such a primitive.
  static const int point = 0x1;

  /// A line primitive.
  ///
  /// This is a line defined through a start and an end position.
  /// [Face] contains exactly two indices for such a primitive.
  static const int line = 0x2;

  /// A triangular primitive.
  ///
  /// A triangle consists of three indices.
  static const int triangle = 0x4;

  /// A higher-level polygon with more than 3 edges.
  ///
  /// A triangle is a polygon, but polygon in this context means
  /// "all polygons that are not triangles". The "Triangulate"-Step
  /// is provided for your convenience, it splits all polygons in
  /// triangles (which are much easier to handle).
  static const int polygon = 0x8;
}

/// A mesh represents a geometry or model with a single material.
///
/// It usually consists of a number of vertices and a series of primitives/faces
/// referencing the vertices. In addition there might be a series of bones, each
/// of them addressing a number of vertices with a certain weight. Vertex data
/// is presented in channels with each channel containing a single per-vertex
/// information such as a set of texture coords or a normal vector.
/// If a data pointer is non-null, the corresponding data stream is present.
/// From C++-programs you can also use the comfort functions Has*() to
/// test for the presence of various data streams.
///
/// A Mesh uses only a single material which is referenced by a material ID.
/// **Note:** The mPositions member is usually not optional. However, vertex positions
/// *could* be missing if the [SceneFlags.incomplete] flag is set in
/// [Scene.flags].
class Mesh extends AssimpType<aiMesh> {
  aiMesh get _mesh => ptr.ref;

  Mesh._(Pointer<aiMesh> ptr) : super(ptr);
  factory Mesh.fromNative(Pointer<aiMesh> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Mesh._(ptr);
  }

  /// Bitwise combination of the members of the #aiPrimitiveType enum.
  /// This specifies which types of primitives are present in the mesh.
  /// The "SortByPrimitiveType"-Step can be used to make sure the
  /// output meshes consist of one primitive type each.
  int get primitiveTypes => _mesh.mPrimitiveTypes;

  /// Vertex positions.
  /// This array is always present in a mesh.
  Iterable<Vector3> get vertices {
    return Iterable.generate(
      _mesh.mNumVertices,
      (i) => AssimpVector3.fromNative(_mesh.mVertices.elementAt(i)),
    );
  }

  Float32List get vertexData =>
      _mesh.mVertices.cast<Float>().asTypedList(_mesh.mNumVertices * 3);

  /// Vertex normals.
  /// The array contains normalized vectors, NULL if not present.
  /// The array is mNumVertices in size. Normals are undefined for
  /// point and line primitives. A mesh consisting of points and
  /// lines only may not have normal vectors. Meshes with mixed
  /// primitive types (i.e. lines and triangles) may have normals,
  /// but the normals for vertices that are only referenced by
  /// point or line primitives are undefined and set to QNaN (WARN:
  /// qNaN compares to inequal to ///everything///, even to qNaN itself.
  /// Using code like this to check whether a field is qnan is:
  /// @code
  /// #define IS_QNAN(f) (f != f)
  /// @endcode
  /// still dangerous because even 1.f == 1.f could evaluate to false! (
  /// remember the subtleties of IEEE754 artithmetics). Use stuff like
  /// @c fpclassify instead.
  /// @note Normal vectors computed by Assimp are always unit-length.
  /// However, this needn't apply for normals that have been taken
  ///   directly from the model file.
  Iterable<Vector3> get normals {
    return Iterable.generate(
      AssimpPointer.isNotNull(_mesh.mNormals) ? _mesh.mNumVertices : 0,
      (i) => AssimpVector3.fromNative(_mesh.mNormals.elementAt(i)),
    );
  }

  Float32List get normalData => AssimpPointer.isNotNull(_mesh.mNormals)
      ? _mesh.mNormals.cast<Float>().asTypedList(_mesh.mNumVertices * 3)
      : null;

  /// Vertex tangents.
  /// The tangent of a vertex points in the direction of the positive
  /// X texture axis. The array contains normalized vectors, NULL if
  /// not present. The array is mNumVertices in size. A mesh consisting
  /// of points and lines only may not have normal vectors. Meshes with
  /// mixed primitive types (i.e. lines and triangles) may have
  /// normals, but the normals for vertices that are only referenced by
  /// point or line primitives are undefined and set to qNaN.  See
  /// the #mNormals member for a detailed discussion of qNaNs.
  /// @note If the mesh contains tangents, it automatically also
  /// contains bitangents.
  Iterable<Vector3> get tangents {
    return Iterable.generate(
      AssimpPointer.isNotNull(_mesh.mTangents) ? _mesh.mNumVertices : 0,
      (i) => AssimpVector3.fromNative(_mesh.mTangents.elementAt(i)),
    );
  }

  Float32List get tangentData => AssimpPointer.isNotNull(_mesh.mTangents)
      ? _mesh.mTangents.cast<Float>().asTypedList(_mesh.mNumVertices * 3)
      : null;

  /// Vertex bitangents.
  /// The bitangent of a vertex points in the direction of the positive
  /// Y texture axis. The array contains normalized vectors, NULL if not
  /// present. The array is mNumVertices in size.
  /// @note If the mesh contains tangents, it automatically also contains
  /// bitangents.
  Iterable<Vector3> get bitangents {
    return Iterable.generate(
      AssimpPointer.isNotNull(_mesh.mBitangents) ? _mesh.mNumVertices : 0,
      (i) => AssimpVector3.fromNative(_mesh.mBitangents.elementAt(i)),
    );
  }

  Float32List get bitangentData => AssimpPointer.isNotNull(_mesh.mBitangents)
      ? _mesh.mBitangents.cast<Float>().asTypedList(_mesh.mNumVertices * 3)
      : null;

  /// Vertex color sets.
  /// A mesh may contain 0 to #AI_MAX_NUMBER_OF_COLOR_SETS vertex
  /// colors per vertex. NULL if not present. Each array is
  /// mNumVertices in size if present.
  Iterable<Iterable<Vector4>> get colors {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_COLOR_SETS &&
        _mesh.mColors != null &&
        AssimpPointer.isNotNull(_mesh.mColors[n])) {
      ++n;
    }
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _mesh.mNumVertices,
        (j) => AssimpColor4.fromNative(_mesh.mColors[i].elementAt(j)),
      ),
    );
  }

  /// Vertex texture coords, also known as UV channels.
  /// A mesh may contain 0 to AI_MAX_NUMBER_OF_TEXTURECOORDS per
  /// vertex. NULL if not present. The array is mNumVertices in size.
  Iterable<Iterable<Vector3>> get textureCoords {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_TEXTURECOORDS &&
        _mesh.mTextureCoords != null &&
        AssimpPointer.isNotNull(_mesh.mTextureCoords[n])) {
      ++n;
    }
    return Iterable.generate(
      n,
      (i) => Iterable.generate(
        _mesh.mNumVertices,
        (j) => AssimpVector3.fromNative(_mesh.mTextureCoords[i].elementAt(j)),
      ),
    );
  }

  /// Specifies the number of components for a given UV channel.
  /// Up to three channels are supported (UVW, for accessing volume
  /// or cube maps). If the value is 2 for a given channel n, the
  /// component p.z of mTextureCoords[n][p] is set to 0.0f.
  /// If the value is 1 for a given channel, p.y is set to 0.0f, too.
  /// @note 4D coords are not supported
  Iterable<int> get uvComponents {
    var n = 0;
    while (n < AI_MAX_NUMBER_OF_TEXTURECOORDS &&
        _mesh.mNumUVComponents != null &&
        _mesh.mNumUVComponents.elementAt(n).value > 0) {
      ++n;
    }
    return n > 0 ? _mesh.mNumUVComponents.asTypedList(n) : [];
  }

  /// The faces the mesh is constructed from.
  /// Each face refers to a number of vertices by their indices.
  /// This array is always present in a mesh, its size is given
  /// in mNumFaces. If the #AI_SCENE_FLAGS_NON_VERBOSE_FORMAT
  /// is NOT set each face references an unique set of vertices.
  Iterable<Face> get faces {
    return Iterable.generate(
      _mesh.mNumFaces,
      (i) => Face.fromNative(_mesh.mFaces.elementAt(i)),
    );
  }

  /// The bones of this mesh.
  /// A bone consists of a name by which it can be found in the
  /// frame hierarchy and a set of vertex weights.
  Iterable<Bone> get bones {
    return Iterable.generate(
      _mesh.mNumBones,
      (i) => Bone.fromNative(_mesh.mBones[i]),
    );
  }

  /// The material used by this mesh.
  /// A mesh uses only a single material. If an imported model uses
  /// multiple materials, the import splits up the mesh. Use this value
  /// as index into the scene's material list.
  int get materialIndex => _mesh.mMaterialIndex;

  /// Name of the mesh. Meshes can be named, but this is not a
  ///  requirement and leaving this field empty is totally fine.
  ///  There are mainly three uses for mesh names:
  ///   - some formats name nodes and meshes independently.
  ///   - importers tend to split meshes up to meet the
  ///      one-material-per-mesh requirement. Assigning
  ///      the same (dummy) name to each of the result meshes
  ///      aids the caller at recovering the original mesh
  ///      partitioning.
  ///   - Vertex animations refer to meshes by their names.
  String get name => AssimpString.fromNative(_mesh.mName);

  /// Attachment meshes for this mesh, for vertex-based animation.
  /// Attachment meshes carry replacement data for some of the
  /// mesh'es vertex components (usually positions, normals).
  /// Note! Currently only works with Collada loader.
  Iterable<AnimMesh> get animMeshes {
    return Iterable.generate(
      _mesh.mNumAnimMeshes,
      (i) => AnimMesh.fromNative(_mesh.mAnimMeshes[i]),
    );
  }

  /// Method of morphing when animeshes are specified.
  int get morphingMethod => _mesh.mMethod;

  /// ### TODO
  Aabb3 get aabb => AssimpAabb3.fromNative(_mesh.mAABB);
}
