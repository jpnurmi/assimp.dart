// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// VMOptions=--optimization-counter-threshold=5

import 'package:test/test.dart';

import '../lib/assimp.dart';

void main() {
  test('errorString', () {
    final scene1 = Scene.fromFile('foobar');
    expect(Assimp.errorString(), equals('Unable to open file "foobar".'));
    expect(scene1, isNull);

    Scene scene2 = Scene.fromBuffer('foobar');
    expect(Assimp.errorString(), startsWith('No suitable reader found for'));
    expect(scene2, isNull);
  });

  test('fromFile', () {
    Scene s = Scene.fromFile('test/Spider_ascii.stl');
    print('meshes: ${s.meshes}');
    print('materials: ${s.materials}');
    print('animations: ${s.animations}');
    print('textures: ${s.textures}');
    print('lights: ${s.lights}');
    print('cameras: ${s.cameras}');
    s.dispose();
  });
}
