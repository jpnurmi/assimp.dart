import 'dart:io';

import 'package:path/path.dart' hide equals;

import '../lib/assimp.dart';
export 'third_party/matchers.dart';

String testModelPath(String fileName) => 'test/models/' + fileName;

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

void testScene(String fileName, void tester(scene),
    {int from = TestFrom.file}) {
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
