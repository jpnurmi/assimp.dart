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

/** 
  * @file   anim.h
  * @brief  Defines the data structures in which the imported animations
  *         are returned.
  */

import 'types.dart';
import 'quaternion.dart';

// ---------------------------------------------------------------------------
/** A time-value pair specifying a certain 3D vector for the given time. */
class aiVectorKey extends Struct {
  /** The time of this key */
  @Double()
  double mTime;

  /** The value of this key */
  Pointer<aiVector3D> mValue;
}

// ---------------------------------------------------------------------------
/** A time-value pair specifying a rotation for the given time.
 *  Rotations are expressed with quaternions. */
class aiQuatKey extends Struct {
  /** The time of this key */
  @Double()
  double mTime;

  /** The value of this key */
  Pointer<aiQuaternion> mValue;
}

// ---------------------------------------------------------------------------
/** Binds a anim-mesh to a specific point in time. */
class aiMeshKey extends Struct {
  /** The time of this key */
  @Double()
  double mTime;

  /** Index into the aiMesh::mAnimMeshes array of the
     *  mesh corresponding to the #aiMeshAnim hosting this
     *  key frame. The referenced anim mesh is evaluated
     *  according to the rules defined in the docs for #aiAnimMesh.*/
  @Uint32()
  int mValue;
}

// ---------------------------------------------------------------------------
/** Binds a morph anim mesh to a specific point in time. */
class aiMeshMorphKey extends Struct {
  /** The time of this key */
  @Double()
  double mTime;

  /** The values and weights at the time of this key */
  Pointer<Uint32> mValues;
  Pointer<Double> mWeights;

  /** The number of values and weights */
  @Uint32()
  int mNumValuesAndWeights;
}

// ---------------------------------------------------------------------------
/** Defines how an animation channel behaves outside the defined time
 *  range. This corresponds to aiNodeAnim::mPreState and
 *  aiNodeAnim::mPostState.*/
class aiAnimBehaviour {
  /** The value from the default node transformation is taken*/
  static const int DEFAULT = 0x0;

  /** The nearest key value is used without interpolation */
  static const int CONSTANT = 0x1;

  /** The value of the nearest two keys is linearly
     *  extrapolated for the current time value.*/
  static const int LINEAR = 0x2;

  /** The animation is repeated.
     *
     *  If the animation key go from n to m and the current
     *  time is t, use the value at (t-n) % (|m-n|).*/
  static const int REPEAT = 0x3;
}

// ---------------------------------------------------------------------------
/** Describes the animation of a single node. The name specifies the
 *  bone/node which is affected by this animation channel. The keyframes
 *  are given in three separate series of values, one each for position,
 *  rotation and scaling. The transformation matrix computed from these
 *  values replaces the node's original transformation matrix at a
 *  specific time.
 *  This means all keys are absolute and not relative to the bone default pose.
 *  The order in which the transformations are applied is
 *  - as usual - scaling, rotation, translation.
 *
 *  @note All keys are returned in their correct, chronological order.
 *  Duplicate keys don't pass the validation step. Most likely there
 *  will be no negative time values, but they are not forbidden also ( so
 *  implementations need to cope with them! ) */
class aiNodeAnim extends Struct {
  /** The name of the node affected by this animation. The node
     *  must exist and it must be unique.*/
  Pointer<aiString> mNodeName;

  /** The number of position keys */
  @Uint32()
  int mNumPositionKeys;

  /** The position keys of this animation channel. Positions are
     * specified as 3D vector. The array is mNumPositionKeys in size.
     *
     * If there are position keys, there will also be at least one
     * scaling and one rotation key.*/
  Pointer<aiVectorKey> mPositionKeys;

  /** The number of rotation keys */
  @Uint32()
  int mNumRotationKeys;

  /** The rotation keys of this animation channel. Rotations are
     *  given as quaternions,  which are 4D vectors. The array is
     *  mNumRotationKeys in size.
     *
     * If there are rotation keys, there will also be at least one
     * scaling and one position key. */
  Pointer<aiQuatKey> mRotationKeys;

  /** The number of scaling keys */
  @Uint32()
  int mNumScalingKeys;

  /** The scaling keys of this animation channel. Scalings are
     *  specified as 3D vector. The array is mNumScalingKeys in size.
     *
     * If there are scaling keys, there will also be at least one
     * position and one rotation key.*/
  Pointer<aiVectorKey> mScalingKeys;

  /** Defines how the animation behaves before the first
     *  key is encountered.
     *
     *  The default value is aiAnimBehaviour_DEFAULT (the original
     *  transformation matrix of the affected node is used).*/
  @Uint32()
  int mPreState; // aiAnimBehaviour

  /** Defines how the animation behaves after the last
     *  key was processed.
     *
     *  The default value is aiAnimBehaviour_DEFAULT (the original
     *  transformation matrix of the affected node is taken).*/
  @Uint32()
  int mPostState; // aiAnimBehaviour
}

// ---------------------------------------------------------------------------
/** Describes vertex-based animations for a single mesh or a group of
 *  meshes. Meshes carry the animation data for each frame in their
 *  aiMesh::mAnimMeshes array. The purpose of aiMeshAnim is to
 *  define keyframes linking each mesh attachment to a particular
 *  point in time. */
class aiMeshAnim extends Struct {
  /** Name of the mesh to be animated. An empty string is not allowed,
     *  animated meshes need to be named (not necessarily uniquely,
     *  the name can basically serve as wild-card to select a group
     *  of meshes with similar animation setup)*/
  Pointer<aiString> mName;

  /** Size of the #mKeys array. Must be 1, at least. */
  @Uint32()
  int mNumKeys;

  /** Key frames of the animation. May not be NULL. */
  Pointer<aiMeshKey> mKeys;
}

// ---------------------------------------------------------------------------
/** Describes a morphing animation of a given mesh. */
class aiMeshMorphAnim extends Struct {
  /** Name of the mesh to be animated. An empty string is not allowed,
     *  animated meshes need to be named (not necessarily uniquely,
     *  the name can basically serve as wildcard to select a group
     *  of meshes with similar animation setup)*/
  Pointer<aiString> mName;

  /** Size of the #mKeys array. Must be 1, at least. */
  @Uint32()
  int mNumKeys;

  /** Key frames of the animation. May not be NULL. */
  Pointer<aiMeshMorphKey> mKeys;
}

// ---------------------------------------------------------------------------
/** An animation consists of key-frame data for a number of nodes. For
 *  each node affected by the animation a separate series of data is given.*/
class aiAnimation extends Struct {
  /** The name of the animation. If the modeling package this data was
     *  exported from does support only a single animation channel, this
     *  name is usually empty (length is zero). */
  Pointer<aiString> mName;

  /** Duration of the animation in ticks.  */
  @Double()
  double mDuration;

  /** Ticks per second. 0 if not specified in the imported file */
  @Double()
  double mTicksPerSecond;

  /** The number of bone animation channels. Each channel affects
     *  a single node. */
  @Uint32()
  int mNumChannels;

  /** The node animation channels. Each channel affects a single node.
     *  The array is mNumChannels in size. */
  Pointer<Pointer<aiNodeAnim>> mChannels;

  /** The number of mesh animation channels. Each channel affects
     *  a single mesh and defines vertex-based animation. */
  @Uint32()
  int mNumMeshChannels;

  /** The mesh animation channels. Each channel affects a single mesh.
     *  The array is mNumMeshChannels in size. */
  Pointer<Pointer<aiMeshAnim>> mMeshChannels;

  /** The number of mesh animation channels. Each channel affects
     *  a single mesh and defines morphing animation. */
  @Uint32()
  int mNumMorphMeshChannels;

  /** The morph mesh animation channels. Each channel affects a single mesh.
     *  The array is mNumMorphMeshChannels in size. */
  Pointer<Pointer<aiMeshMorphAnim>> mMorphMeshChannels;
}
