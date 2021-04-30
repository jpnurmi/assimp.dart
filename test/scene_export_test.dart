import 'dart:io';
import 'package:test/test.dart';
import 'package:assimp/assimp.dart';
import 'test_utils.dart';

void main() {
  prepareTest();

  var tempDir;
  setUp(() => tempDir = Directory.systemTemp.createTempSync());
  tearDown(() {
    tempDir.deleteSync(recursive: true);
    final blobfile = File('\$blobfile');
    if (blobfile.existsSync()) blobfile.deleteSync();
  });

  test('exportFile', () {
    final importPath = testModelPath('spider.3mf');
    final importScene = Scene.fromFile(importPath);
    final exportPath = '${tempDir.path}/spider.3mf';

    expect(importScene, isNotNull);
    expect(importScene!.exportFile(exportPath, format: ''), isFalse);
    expect(importScene!.exportFile(exportPath, format: '3mf'), isTrue);

    final exportFile = File(exportPath);
    expect(exportFile.existsSync(), isTrue);
    expect(exportFile.statSync().size, greaterThan(0));

    final exportScene = Scene.fromFile(exportPath);
    expect(exportScene, isNotNull);
    expect(exportScene!.meshes.length, importScene!.meshes.length);

    exportScene!.dispose();
    importScene!.dispose();
  });

  test('exportData', () {
    final importScene = Scene.fromFile(testModelPath('spider.3mf'));

    expect(importScene, isNotNull);
    expect(importScene!.exportData(format: ''), isNull);

    final exportData = importScene.exportData(format: 'obj');
    expect(exportData, isNotNull);
    expect(exportData!.name, isNotNull);
    expect(exportData!.data, isNotNull);
    expect(exportData!.data.length, greaterThan(0));
    expect(exportData!.next, isNotNull);

    var nextData = exportData.next;
    while (nextData != null) {
      expect(nextData!.name, isNotNull);
      expect(nextData!.data, isNotNull);
      expect(nextData!.data.length, greaterThan(0));
      nextData = nextData!.next;
    }

    final exportScene = Scene.fromBytes(exportData.data);
    expect(exportScene, isNotNull);
    expect(exportScene!.meshes.length, importScene!.meshes.length);

    exportData!.dispose();
    exportScene!.dispose();
    importScene!.dispose();
  });
}
