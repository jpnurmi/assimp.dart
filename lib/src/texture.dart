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
import 'type.dart';

class Texel extends AssimpType<aiTexel> {
  aiTexel get _texel => ptr.ref;

  Texel._(Pointer<aiTexel> ptr) : super(ptr);
  factory Texel.fromNative(Pointer<aiTexel> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Texel._(ptr);
  }

  int get b => _texel.b;
  int get g => _texel.g;
  int get r => _texel.r;
  int get a => _texel.a;
}

class Texture extends AssimpType<aiTexture> {
  aiTexture get _texture => ptr.ref;

  Texture._(Pointer<aiTexture> ptr) : super(ptr);
  factory Texture.fromNative(Pointer<aiTexture> ptr) {
    if (AssimpPointer.isNull(ptr)) return null;
    return Texture._(ptr);
  }

  int get width => _texture.mWidth;
  int get height => _texture.mHeight;

  Iterable<Texel> get data {
    return Iterable.generate(
      _texture.mWidth * _texture.mHeight,
      (i) => Texel.fromNative(_texture.pcData.elementAt(i)),
    );
  }

  String get formatHint => Utf8.fromUtf8(_texture.achFormatHint);
  String get fileName => AssimpString.fromNative(_texture.mFilename);
}
