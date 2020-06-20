import 'dart:io';

import 'package:path/path.dart' hide equals;
import 'package:test/test.dart';
import 'package:assimp/assimp.dart';

String testModelPath(String fileName) => 'test/models/model-db/' + fileName;

const Matcher isNullPointer = _IsNullPointer();

class _IsNullPointer extends Matcher {
  const _IsNullPointer();
  @override
  bool matches(ptr, Map matchState) => ptr.isNull;
  @override
  Description describe(Description description) => description.add('nullptr');
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

void testScene(String fileName, int testFrom, void tester(scene)) {
  if (testFrom & TestFrom.file != 0) {
    testSceneFromFile(fileName, tester);
  }
  if (testFrom & TestFrom.bytes != 0) {
    testSceneFromBytes(fileName, tester);
  }
  if (testFrom & TestFrom.string != 0) {
    testSceneFromString(fileName, tester);
  }
}
