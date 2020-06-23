import 'dart:io';
import 'package:test/test.dart';
import '../lib/assimp.dart';
import 'test_utils.dart';

void main() {
  prepareTest();

  var tempDir;
  setUp(() => tempDir = Directory.systemTemp.createTempSync());
  tearDown(() => tempDir.deleteSync(recursive: true));

  test('exportFile', () {
    final importPath = testModelPath('spider.3mf');
    final importScene = Scene.fromFile(importPath);
    final exportPath = '${tempDir.path}/spider.3mf';

    expect(importScene.exportFile(exportPath, format: ''), isFalse);
    expect(importScene.exportFile(exportPath, format: '3mf'), isTrue);

    final exportFile = File(exportPath);
    expect(exportFile.existsSync(), isTrue);
    expect(exportFile.statSync().size, greaterThan(0));

    final exportScene = Scene.fromFile(exportPath);
    expect(exportScene, isNotNull);
    expect(exportScene.meshes.length, importScene.meshes.length);

    exportScene.dispose();
    importScene.dispose();
  });
}
