/*
---------------------------------------------------------------------------
Open Asset Import Library (assimp)
---------------------------------------------------------------------------

Copyright (c) 2006-2020, assimp team

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

import 'package:test/test.dart';
import 'package:assimp/assimp.dart';
import '../lib/src/bindings/ai_scene.dart' as bindings;
import 'test_utils.dart';

void main() {
  test('size', () {
    expect(sizeOf<bindings.aiScene>(), equals(128));
  });

  test('null', () {
    Scene scene = Scene.fromNative(null);
    expect(scene.flags, isZero);
    expect(scene.rootNode, isNullPointer);
    expect(scene.meshes, isEmpty);
    expect(scene.materials, isEmpty);
    expect(scene.animations, isEmpty);
    expect(scene.textures, isEmpty);
    expect(scene.lights, isEmpty);
    expect(scene.cameras, isEmpty);
    expect(scene.metaData, isNullPointer);
  });

  test('3mf', () {
    testScene('3mf/box.3mf', TestFrom.binary, (scene) {
      expect(scene.flags, isZero);
      expect(scene.rootNode, isNotNull);
      expect(scene.meshes.length, equals(1));
      expect(scene.materials.length, equals(1));
      expect(scene.animations.length, isZero);
      expect(scene.textures.length, isZero);
      expect(scene.lights.length, isZero);
      expect(scene.cameras.length, isZero);
      expect(scene.metaData, isNullPointer);
    });

    testScene('3mf/spider.3mf', TestFrom.binary, (scene) {
      expect(scene.flags, isZero);
      expect(scene.rootNode, isNotNull);
      expect(scene.meshes.length, equals(19));
      expect(scene.materials.length, equals(4));
      expect(scene.animations.length, isZero);
      expect(scene.textures.length, isZero);
      expect(scene.lights.length, isZero);
      expect(scene.cameras.length, isZero);
      expect(scene.metaData, isNullPointer);
    });
  });

  test('fbx', () {
    testScene('fbx/huesitos.fbx', TestFrom.binary, (scene) {
      expect(scene.flags, isZero);
      expect(scene.rootNode, isNotNull);
      expect(scene.meshes.length, equals(1));
      expect(scene.materials.length, equals(1));
      expect(scene.animations.length, equals(1));
      expect(scene.textures.length, isZero);
      expect(scene.lights.length, equals(1));
      expect(scene.cameras.length, equals(1));
      expect(scene.metaData, isNotNull);
    });
  });

  test('obj', () {
    testScene('Obj/Spider/spider.obj', TestFrom.file, (scene) {
      expect(scene.flags, isZero);
      expect(scene.rootNode, isNotNull);
      expect(scene.meshes.length, equals(19));
      expect(scene.materials.length, equals(6));
      expect(scene.animations.length, isZero);
      expect(scene.textures.length, isZero);
      expect(scene.lights.length, isZero);
      expect(scene.cameras.length, isZero);
      expect(scene.metaData, isNullPointer);
    });

    testScene('Obj/Spider/spider.obj', TestFrom.content, (scene) {
      expect(scene.flags, isZero);
      expect(scene.rootNode, isNotNull);
      expect(scene.meshes.length, equals(19));
      expect(scene.materials.length, equals(5));
      expect(scene.animations.length, isZero);
      expect(scene.textures.length, isZero);
      expect(scene.lights.length, isZero);
      expect(scene.cameras.length, isZero);
      expect(scene.metaData, isNullPointer);
    });
  });
}
