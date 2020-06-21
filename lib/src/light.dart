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

enum LightSourceType { undefined, directional, point, spot, ambient, area }

class Light {
  Pointer<aiLight> _ptr;

  Light._(this._ptr);
  factory Light.fromNative(Pointer<aiLight> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Light._(ptr);
  }

  String get name => AssimpString.fromNative(_ptr.ref.mName);
  LightSourceType get type => LightSourceType.values[_ptr.ref.mType];

  Vector3 get position => AssimpVector3.fromNative(_ptr.ref.mPosition);
  Vector3 get direction => AssimpVector3.fromNative(_ptr.ref.mDirection);
  Vector3 get up => AssimpVector3.fromNative(_ptr.ref.mUp);

  double get attenuationConstant => _ptr.ref.mAttenuationConstant;
  double get attenuationLinear => _ptr.ref.mAttenuationLinear;
  double get attenuationQuadratic => _ptr.ref.mAttenuationQuadratic;

  Color get colorDiffuse => AssimpColor3.fromNative(_ptr.ref.mColorDiffuse);
  Color get colorSpecular => AssimpColor3.fromNative(_ptr.ref.mColorSpecular);
  Color get colorAmbient => AssimpColor3.fromNative(_ptr.ref.mColorAmbient);

  double get angleInnerCone => _ptr.ref.mAngleInnerCone;
  double get angleOuterCone => _ptr.ref.mAngleOuterCone;

  Size get size => AssimpSize.fromNative(_ptr.ref.mSize);
}
