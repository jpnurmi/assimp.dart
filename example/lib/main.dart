import 'dart:typed_data';
import 'dart:ui';

import 'package:assimp/assimp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  ExamplePage({Key key}) : super(key: key);

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  Scene scene;
  String current;
  Offset offset = Offset.zero;
  List<Uint16List> indices = [];

  @override
  void initState() {
    super.initState();
    loadScene('box.obj');
  }

  Future<void> loadScene(String key) async {
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    final data = await rootBundle.load('models/$key');
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final newScene = Scene.fromBytes(bytes,
        hint: extension(key),
        flags: ProcessFlags.triangulate | ProcessFlags.generateNormals);
    setState(() {
      current = key;
      scene = newScene;
      indices = newScene.meshes.map((mesh) => mesh.createIndexData()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assimp for Dart'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) =>
                ['box.3mf', 'box.obj', 'mug.obj', 'spider.3mf']
                    .map(
                      (model) => CheckedPopupMenuItem<String>(
                        value: model,
                        checked: model == current,
                        child: Text(model),
                      ),
                    )
                    .toList(),
            onSelected: (value) => loadScene(value),
          ),
        ],
      ),
      body: GestureDetector(
        child: CustomPaint(
          painter: ScenePainter(scene, indices, offset),
          size: MediaQuery.of(context).size,
        ),
        onDoubleTap: () => setState(() => offset = Offset.zero),
        onPanUpdate: (details) => setState(() => offset += details.delta),
      ),
    );
  }
}

class ScenePainter extends CustomPainter {
  final Scene scene;
  final Offset offset;
  final List<Uint16List> indices;

  ScenePainter(this.scene, this.indices, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    if (scene == null) return;

    final color = Colors.white;
    final light = Vector3(0.0, 0.0, 1.0);
    final transformation = scene.rootNode.transformation;

    final matrix = transformation
      ..translate(size.width / 2, size.height / 2, 0)
      ..scale(100.0)
      ..rotateX(0.01 * offset.dy)
      ..rotateY(-0.01 * offset.dx);

    var m = 0;
    for (final mesh in scene.meshes) {
      final normals = mesh.normalData;
      final vertices = mesh.vertexData;

      final count = vertices.length ~/ 3;

      final colors = Int32List(count);
      final positions = Float32List(count * 2);
      for (var i = 0; i < vertices.length; i += 3) {
        final j = i ~/ 3;
        final v = matrix.transformed3(
            Vector3(vertices[i], vertices[i + 1], vertices[i + 2]));
        positions[j * 2] = v.x;
        positions[j * 2 + 1] = v.y;

        final p =
            light.dot(Vector3(normals[i], normals[i + 1], normals[i + 2]));
        colors[j] = Color.fromARGB(
          255,
          (color.red.toDouble() * p).round(),
          (color.green.toDouble() * p).round(),
          (color.blue.toDouble() * p).round(),
        ).value;
      }

      final raw = Vertices.raw(
        VertexMode.triangleFan,
        positions,
        colors: colors,
        indices: indices[m++],
      );
      canvas.drawVertices(raw, BlendMode.clear, Paint());
    }
  }

  @override
  bool shouldRepaint(ScenePainter old) =>
      scene != old.scene || offset != old.offset;
}
