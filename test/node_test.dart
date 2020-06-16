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

import 'package:test/test.dart';
import 'package:assimp/assimp.dart';
import 'test_utils.dart';

void main() {
  test('null', () {
    Node node = Node.fromNative(null);
    expect(node.isNull, isTrue);
    expect(node.name, isNull);
    expect(node.transformation, isNull);
    expect(node.parent, isNull);
    expect(node.children, isEmpty);
    expect(node.meshes, isEmpty);
    expect(node.metaData.isNull, isTrue);
  });

  void testNodes(String fileName, void tester(rootNode)) {
    final filePath = testFilePath(fileName);
    final scene = Scene.fromFile(filePath);
    tester(scene.rootNode);
    scene.dispose();
  }

  test('3mf', () {
    testNodes('3mf/box.3mf', (rootNode) {
      expect(rootNode.name, equals('3MF'));
      expect(rootNode.parent, isNullPointer);
      expect(rootNode.children.length, equals(1));
      expect(rootNode.meshes.length, isZero);
      expect(rootNode.metaData, isNullPointer);
    });

    testNodes('3mf/spider.3mf', (rootNode) {
      expect(rootNode.name, equals('3MF'));
      expect(rootNode.parent, isNullPointer);
      expect(rootNode.children.length, equals(19));
      expect(rootNode.meshes.length, isZero);
      expect(rootNode.metaData, isNullPointer);
    });
  });

  test('fbx', () {
    testNodes('fbx/huesitos.fbx', (rootNode) {
      expect(rootNode.name, equals('RootNode'));
      expect(rootNode.parent, isNullPointer);
      expect(rootNode.children.length, equals(4));
      expect(rootNode.meshes.length, isZero);
      expect(rootNode.metaData, isNotNull);
    });
  });

  test('obj', () {
    testNodes('Obj/Spider/spider.obj', (rootNode) {
      expect(rootNode.name, equals('spider.obj'));
      expect(rootNode.parent, isNullPointer);
      expect(rootNode.children.length, equals(19));
      expect(rootNode.meshes.length, isZero);
      expect(rootNode.metaData, isNullPointer);
    });
  });
}
