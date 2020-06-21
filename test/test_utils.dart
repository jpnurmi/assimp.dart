import 'dart:io';

import 'package:path/path.dart' hide equals;

import '../lib/assimp.dart';
export 'third_party/matchers.dart';

String testModelPath(String fileName) => 'test/models/model-db/' + fileName;

void prepareTest() {
  // https://github.com/flutter/flutter/issues/20907
  if (Directory.current.path.endsWith('/test')) {
    Directory.current = Directory.current.parent;
  }
}

class TestFrom {
  static const int file = 0x1;
  static const int bytes = 0x2;
  static const int string = 0x4;
  static const int ascii = file | string;
  static const int binary = file | bytes;
  static const int content = string | bytes;
}

void testSceneFromFile(String fileName, void tester(scene)) {
  final filePath = testModelPath(fileName);
  final scene = Scene.fromFile(filePath);
  tester(scene);
  scene.dispose();
}

void testSceneFromBytes(String fileName, void tester(scene)) {
  final filePath = testModelPath(fileName);
  final bytes = File(filePath).readAsBytesSync();
  final scene = Scene.fromBytes(bytes, hint: extension(filePath));
  tester(scene);
  scene.dispose();
}

void testSceneFromString(String fileName, void tester(scene)) {
  final filePath = testModelPath(fileName);
  final str = File(filePath).readAsStringSync();
  final scene = Scene.fromString(str, hint: extension(filePath));
  tester(scene);
  scene.dispose();
}

void testScene(String fileName,
    {int from = TestFrom.file, void tester(scene)}) {
  if (from & TestFrom.file != 0) {
    testSceneFromFile(fileName, tester);
  }
  if (from & TestFrom.bytes != 0) {
    testSceneFromBytes(fileName, tester);
  }
  if (from & TestFrom.string != 0) {
    testSceneFromString(fileName, tester);
  }
}

void testAnimations(String fileName, void tester(animations)) {
  final filePath = testModelPath(fileName);
  final scene = Scene.fromFile(filePath);
  tester(scene.animations);
  scene.dispose();
}

void testCameras(String fileName, void tester(cameras)) {
  final filePath = testModelPath(fileName);
  final scene = Scene.fromFile(filePath);
  tester(scene.cameras);
  scene.dispose();
}

void testLights(String fileName, void tester(lights)) {
  final filePath = testModelPath(fileName);
  final scene = Scene.fromFile(filePath);
  tester(scene.lights);
  scene.dispose();
}

void testMaterials(String fileName, void tester(materials)) {
  final filePath = testModelPath(fileName);
  final scene = Scene.fromFile(filePath);
  tester(scene.materials);
  scene.dispose();
}

void testMeshes(String fileName, void tester(meshes)) {
  final filePath = testModelPath(fileName);
  final scene = Scene.fromFile(filePath);
  tester(scene.meshes);
  scene.dispose();
}

void testMetaData(String fileName, void tester(metaData)) {
  final filePath = testModelPath(fileName);
  final scene = Scene.fromFile(filePath);
  tester(scene.metaData);
  scene.dispose();
}

void testNodes(String fileName, void tester(nodes)) {
  final filePath = testModelPath(fileName);
  final scene = Scene.fromFile(filePath);
  tester(scene.rootNode);
  scene.dispose();
}

void testTextures(String fileName, void tester(textures)) {
  final filePath = testModelPath(fileName);
  final scene = Scene.fromFile(filePath);
  tester(scene.textures);
  scene.dispose();
}
