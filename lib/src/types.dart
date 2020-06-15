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
import 'bindings/types.dart' as bindings;
import 'vector3.dart';

class Plane {
  Pointer<bindings.aiPlane> _ptr;

  Plane.fromNative(this._ptr);

  double get a => _ptr.ref.a;
  double get b => _ptr.ref.b;
  double get c => _ptr.ref.c;
  double get d => _ptr.ref.d;
}

class Ray {
  Pointer<bindings.aiRay> _ptr;

  Ray.fromNative(this._ptr);

  Vector3D get pos => Vector3D.fromNative(_ptr.ref.pos);
  Vector3D get dir => Vector3D.fromNative(_ptr.ref.dir);
}

class Color3D {
  Pointer<bindings.aiColor3D> _ptr;

  Color3D.fromNative(this._ptr);

  double get r => _ptr.ref.r;
  double get g => _ptr.ref.g;
  double get b => _ptr.ref.b;
}

class MemoryInfo {
  Pointer<bindings.aiMemoryInfo> _ptr;

  MemoryInfo.fromNative(this._ptr);

  int get textures => _ptr.ref.textures;
  int get materials => _ptr.ref.materials;
  int get meshes => _ptr.ref.meshes;
  int get nodes => _ptr.ref.nodes;
  int get animations => _ptr.ref.animations;
  int get cameras => _ptr.ref.cameras;
  int get lights => _ptr.ref.lights;
  int get total => _ptr.ref.total;
}
