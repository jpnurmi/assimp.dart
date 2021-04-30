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

import 'package:vector_math/vector_math.dart';

import 'bindings.dart';
import 'metadata.dart';
import 'extensions.dart';
import 'type.dart';

/// A node in the imported hierarchy.
///
/// Each node has name, a parent node (except for the root node),
/// a transformation relative to its parent and possibly several child nodes.
/// Simple file formats don't support hierarchical structures - for these formats
/// the imported scene does consist of only a single root node without children.
class Node extends AssimpType<aiNode> {
  aiNode get _node => ptr.ref;

  Node._(Pointer<aiNode> ptr) : super(ptr);
  static Node? fromNative(Pointer<aiNode> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Node._(ptr);
  }

  /// The name of the node.
  ///
  /// The name might be empty (length of zero) but all nodes which
  /// need to be referenced by either bones or animations are named.
  /// Multiple nodes may have the same name, except for nodes which are referenced
  /// by bones (see #aiBone and #aiMesh::mBones). Their names *must* be unique.
  ///
  /// Cameras and lights reference a specific node by name - if there
  /// are multiple nodes with this name, they are assigned to each of them.
  /// <br>
  /// There are no limitations with regard to the characters contained in
  /// the name string as it is usually taken directly from the source file.
  ///
  /// Implementations should be able to handle tokens such as whitespace, tabs,
  /// line feeds, quotation marks, ampersands etc.
  ///
  /// Sometimes assimp introduces new nodes not present in the source file
  /// into the hierarchy (usually out of necessity because sometimes the
  /// source hierarchy format is simply not compatible). Their names are
  /// surrounded by @verbatim <> @endverbatim e.g.
  /// @verbatim<DummyRootNode> @endverbatim.
  String get name => AssimpString.fromNative(_node.mName);

  /// The transformation relative to the node's parent.
  Matrix4 get transformation => AssimpMatrix4.fromNative(_node.mTransformation);
  set transformation(Matrix4 matrix) => _node.mTransformation.toNative(matrix);

  /// Parent node. NULL if this node is the root node.
  Node? get parent => Node.fromNative(_node.mParent);

  /// The child nodes of this node.
  Iterable<Node> get children {
    return Iterable.generate(
      _node.mNumChildren,
      (i) => Node.fromNative(_node.mChildren[i])!,
    );
  }

  /// The meshes of this node. Each entry is an index into the
  /// mesh list of the [Scene].
  Iterable<int> get meshes => _node.mMeshes.asTypedList(_node.mNumMeshes);

  /// Metadata associated with this node or NULL if there is no metadata.
  /// Whether any metadata is generated depends on the source file format. See the
  /// @link importer_notes @endlink page for more information on every source file
  /// format. Importers that don't document any metadata don't write any.
  MetaData? get metaData => MetaData.fromNative(_node.mMetaData);
}
