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

import 'package:assimp/src/properties.dart';
import 'package:ffi/ffi.dart';

import 'animation.dart';
import 'bindings.dart';
import 'camera.dart';
import 'extensions.dart';
import 'libassimp.dart';
import 'light.dart';
import 'material.dart';
import 'mesh.dart';
import 'metadata.dart';
import 'node.dart';
import 'texture.dart';
import 'type.dart';

class SceneFlags {
  /// Specifies that the scene data structure that was imported is not complete.
  /// This flag bypasses some internal validations and allows the import
  /// of animation skeletons, material libraries or camera animation paths
  /// using Assimp. Most applications won't support such data.
  static const int incomplete = 0x1;

  /// This flag is set by the validation postprocess-step (aiPostProcess_ValidateDS)
  /// if the validation is successful. In a validated scene you can be sure that
  /// any cross references in the data structure (e.g. vertex indices) are valid.
  static const int validated = 0x2;

  /// This flag is set by the validation postprocess-step (aiPostProcess_ValidateDS)
  /// if the validation is successful but some issues have been found.
  /// This can for example mean that a texture that does not exist is referenced
  /// by a material or that the bone weights for a vertex don't sum to 1.0 ... .
  /// In most cases you should still be able to use the import. This flag could
  /// be useful for applications which don't capture Assimp's log output.
  static const int validationWarning = 0x4;

  /// This flag is currently only set by the aiProcess_JoinIdenticalVertices step.
  /// It indicates that the vertices of the output meshes aren't in the internal
  /// verbose format anymore. In the verbose format all vertices are unique,
  /// no vertex is ever referenced by more than one face.
  static const int nonVerboseFormat = 0x8;

  /// Denotes pure height-map terrain data. Pure terrains usually consist of quads,
  /// sometimes triangles, in a regular grid. The x,y coordinates of all vertex
  /// positions refer to the x,y coordinates on the terrain height map, the z-axis
  /// stores the elevation at a specific point.
  ///
  /// TER (Terragen) and HMP (3D Game Studio) are height map formats.
  ///
  /// **Note:** Assimp is probably not the best choice for loading **huge** terrains -
  /// fully triangulated data takes extremely much free store and should be avoided
  /// as long as possible (typically you'll do the triangulation when you actually
  /// need to render it).
  static const int terrain = 0x10;

  /// Specifies that the scene data can be shared between structures. For example:
  /// one vertex in few faces. \ref AI_SCENE_FLAGS_NON_VERBOSE_FORMAT can not be
  /// used for this because \ref AI_SCENE_FLAGS_NON_VERBOSE_FORMAT has internal
  /// meaning about postprocessing steps.
  static const int allowShared = 0x20;
}

/// The root structure of the imported data.
///
///  Everything that was imported from the given file can be accessed from here.
///  Objects of this class are generally maintained and owned by Assimp, not
///  by the caller. You shouldn't want to instance it, nor should you ever try to
///  delete a given scene on your own.
class Scene extends AssimpType<aiScene> {
  aiScene get _scene => ptr.ref;

  Scene._(Pointer<aiScene> ptr) : super(ptr);

  /// @internal
  static Scene? fromNative(Pointer<aiScene> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Scene._(ptr);
  }

  /// Reads the given file and returns its content.
  ///
  /// If the call succeeds, the imported data is returned in an aiScene structure.
  /// The data is intended to be read-only, it stays property of the ASSIMP
  /// library and will be stable until aiReleaseImport() is called. After you're
  /// done with it, call aiReleaseImport() to free the resources associated with
  /// this file. If the import fails, NULL is returned instead. Call
  /// aiGetErrorString() to retrieve a human-readable error text.
  /// @param pFile Path and filename of the file to be imported,
  ///   expected to be a null-terminated c-string. NULL is not a valid value.
  /// @param pFlags Optional post processing steps to be executed after
  ///   a successful import. Provide a bitwise combination of the
  ///   #aiPostProcessSteps flags.
  /// @return Pointer to the imported data or NULL if the import failed.
  static Scene? fromFile(String path,
      {int flags = 0, Map<String, dynamic>? properties}) {
    final cpath = path.toNativeString();
    final store = PropertyStore.fromMap(properties);
    final ptr = libassimp.aiImportFileExWithProperties(
        cpath, flags, nullptr, store?.ptr ?? nullptr);
    malloc.free(cpath);
    store?.dispose();
    return Scene.fromNative(ptr);
  }

  static Scene? _fromBuffer(Pointer<Int8> cstr, int length, flags,
      Map<String, dynamic>? properties, String hint) {
    final chint = hint.toNativeString();
    final store = PropertyStore.fromMap(properties);
    final ptr = libassimp.aiImportFileFromMemoryWithProperties(
        cstr, length, flags, chint, store?.ptr ?? nullptr);
    malloc.free(cstr);
    malloc.free(chint);
    store?.dispose();
    return Scene.fromNative(ptr);
  }

  /// Reads the given file from a given string.
  ///
  /// @{macro assimp.scene.import}
  static Scene? fromString(String str,
      {int flags = 0, Map<String, dynamic>? properties, String hint = ''}) {
    return Scene._fromBuffer(
        str.toNativeString(), str.length, flags, properties, hint);
  }

  /// Reads the given file from a given memory buffer.
  ///
  /// @{template assimp.scene.import}
  /// If the call succeeds, the contents of the file are returned as a pointer to an
  /// aiScene object. The returned data is intended to be read-only, the importer keeps
  /// ownership of the data and will destroy it upon destruction. If the import fails,
  /// NULL is returned.
  /// A human-readable error description can be retrieved by calling aiGetErrorString().
  /// @param pBuffer Pointer to the file data
  /// @param pLength Length of pBuffer, in bytes
  /// @param pFlags Optional post processing steps to be executed after
  ///   a successful import. Provide a bitwise combination of the
  ///   #aiPostProcessSteps flags. If you wish to inspect the imported
  ///   scene first in order to fine-tune your post-processing setup,
  ///   consider to use #aiApplyPostProcessing().
  /// @param pHint An additional hint to the library. If this is a non empty string,
  ///   the library looks for a loader to support the file extension specified by pHint
  ///   and passes the file to the first matching loader. If this loader is unable to
  ///   completely the request, the library continues and tries to determine the file
  ///   format on its own, a task that may or may not be successful.
  ///   Check the return value, and you'll know ...
  /// @return A pointer to the imported data, NULL if the import failed.
  ///
  /// @note This is a straightforward way to decode models from memory
  /// buffers, but it doesn't handle model formats that spread their
  /// data across multiple files or even directories. Examples include
  /// OBJ or MD3, which outsource parts of their material info into
  /// external scripts. If you need full functionality, provide
  /// a custom IOSystem to make Assimp find these files and use
  /// the regular aiImportFileEx()/aiImportFileExWithProperties() API.
  /// @{endtemplate assimp.scene.import}
  static Scene? fromBytes(Uint8List bytes,
      {int flags = 0, Map<String, dynamic>? properties, String hint = ''}) {
    // ### TODO: avoid copy...
    // https://github.com/dart-lang/ffi/issues/31
    // https://github.com/dart-lang/ffi/issues/27
    final cbuffer = malloc<Int8>(bytes.length);
    final carray = cbuffer.asTypedList(bytes.length);
    carray.setAll(0, bytes);
    return Scene._fromBuffer(cbuffer, bytes.length, flags, properties, hint);
  }

  /// Create a modifiable copy of a scene.
  /// This is useful to import files via Assimp, change their topology and
  /// export them again. Since the scene returned by the various importer functions
  /// is const, a modifiable copy is needed.
  /// @param pIn Valid scene to be copied
  /// @param pOut Receives a modifyable copy of the scene. Use aiFreeScene() to
  /// delete it again.
  Scene copy() {
    final out = malloc<Pointer<aiScene>>();
    libassimp.aiCopyScene(ptr, out);
    final scene = Scene.fromNative(out[0]);
    malloc.free(out);
    return scene!;
  }

  /// Any combination of the AI_SCENE_FLAGS_XXX flags. By default
  /// this value is 0, no flags are set. Most applications will
  /// want to reject all scenes with the AI_SCENE_FLAGS_INCOMPLETE
  /// bit set.
  int get flags => _scene.mFlags;

  /// The root node of the hierarchy.
  ///
  /// There will always be at least the root node if the import
  /// was successful (and no special flags have been set).
  /// Presence of further nodes depends on the format and content
  /// of the imported file.
  Node get rootNode => Node.fromNative(_scene.mRootNode)!;

  /// The array of meshes.
  ///
  /// Use the indices given in the [Node] structure to access this array.
  /// If the [SceneFlags.incomplete] flag is not set there will always be
  /// at least ONE material.
  Iterable<Mesh> get meshes {
    return Iterable.generate(
      _scene.mNumMeshes,
      (i) => Mesh.fromNative(_scene.mMeshes[i])!,
    );
  }

  /// The array of materials.
  ///
  /// Use the index given in each [Mesh] structure to access this array.
  /// If the [SceneFlags.incomplete] flag is not set there will always be
  /// at least ONE material.
  Iterable<Material> get materials {
    return Iterable.generate(
      _scene.mNumMaterials,
      (i) => Material.fromNative(_scene.mMaterials[i])!,
    );
  }

  /// The array of animations.
  ///
  /// All animations imported from the given file are listed here.
  Iterable<Animation> get animations {
    return Iterable.generate(
      _scene.mNumAnimations,
      (i) => Animation.fromNative(_scene.mAnimations[i])!,
    );
  }

  /// The array of embedded textures.
  ///
  /// Not many file formats embed their textures into the file.
  /// An example is Quake's MDL format (which is also used by
  /// some GameStudio versions)
  Iterable<Texture> get textures {
    return Iterable.generate(
      _scene.mNumTextures,
      (i) => Texture.fromNative(_scene.mTextures[i])!,
    );
  }

  /// The array of light sources.
  ///
  /// All light sources imported from the given file are listed here.
  Iterable<Light> get lights {
    return Iterable.generate(
      _scene.mNumLights,
      (i) => Light.fromNative(_scene.mLights[i])!,
    );
  }

  /// The array of cameras.
  ///
  /// All cameras imported from the given file are listed here.
  /// The array is mNumCameras in size. The first camera in the
  /// array (if existing) is the default camera view into
  /// the scene.
  Iterable<Camera> get cameras {
    return Iterable.generate(
      _scene.mNumCameras,
      (i) => Camera.fromNative(_scene.mCameras[i])!,
    );
  }

  /// The global metadata assigned to the scene itself.
  ///
  /// This data contains global metadata which belongs to the scene like
  /// unit-conversions, versions, vendors or other model-specific data. This
  /// can be used to store format-specific metadata as well.
  MetaData? get metaData => MetaData.fromNative(_scene.mMetaData);

  /// Post-process a scene.
  ///
  /// This is strictly equivalent to calling #aiImportFile()/#aiImportFileEx with the
  /// same flags. However, you can use this separate function to inspect the imported
  /// scene first to fine-tune your post-processing setup.
  /// @param pScene Scene to work on.
  /// @param pFlags Provide a bitwise combination of the #aiPostProcessSteps flags.
  /// @return A pointer to the post-processed data. Post processing is done in-place,
  ///   meaning this is still the same #aiScene which you passed for pScene. However,
  ///   _if_ post-processing failed, the scene could now be NULL. That's quite a rare
  ///   case, post processing steps are not really designed to 'fail'. To be exact,
  ///   the #aiProcess_ValidateDataStructure flag is currently the only post processing step
  ///   which can actually cause the scene to be reset to NULL.
  void postProcess(int flags) => libassimp.aiApplyPostProcessing(ptr, flags);

  /// Releases all resources associated with the given import process.
  ///
  /// Call this function after you're done with the imported data.
  /// @param pScene The imported data to release. NULL is a valid value.
  void dispose() => libassimp.aiReleaseImport(ptr);
}
