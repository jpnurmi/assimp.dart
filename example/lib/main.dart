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

  @override
  void initState() {
    super.initState();
    loadScene('box.obj');
  }

  Future<void> loadScene(String key) async {
    final data = await rootBundle.load('models/$key');
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final newScene = Scene.fromBytes(bytes,
        hint: extension(key),
        flags: ProcessFlags.triangulate |
            ProcessFlags.optimizeMeshes |
            ProcessFlags.generateNormals |
            ProcessFlags.joinIdenticalVertices);
    setState(() {
      current = key;
      scene = newScene;
    });
  }

  void rotateScene(Offset delta) {
    scene.rootNode.transformation = scene.rootNode.transformation
      ..rotateX(0.01 * delta.dy)
      ..rotateY(-0.01 * delta.dx);
    scene.postProcess(ProcessFlags.preTransformVertices);
    setState(() {});
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
          painter: ScenePainter(scene),
          size: MediaQuery.of(context).size,
        ),
        onPanUpdate: (details) => rotateScene(details.delta),
      ),
    );
  }
}

extension Vector3List on Float32List {
  Vector3 vectorAt(int i) => Vector3(this[i], this[i + 1], this[i + 2]);
}

class ScenePainter extends CustomPainter {
  final Scene scene;

  ScenePainter(this.scene);

  @override
  void paint(Canvas canvas, Size size) {
    if (scene == null) return;

    final color = Colors.white;
    final light = Vector3(0.0, 0.0, 1.0);
    final transformation = scene.rootNode.transformation;

    final matrix = transformation
      ..translate(size.width / 2, size.height / 2, 0)
      ..scale(100.0);

    for (final mesh in scene.meshes) {
      final normals = mesh.normalData;
      final vertices = mesh.vertexData;

      final count = mesh.faces.length * 3;
      final colors = Int32List(count);
      final indices = Uint16List(count);
      final positions = Float32List(count * 2);

      var i = 0;
      for (final face in mesh.faces) {
        for (final j in face.indices) {
          final c = light.dot(matrix.transformed3(normals.vectorAt(j * 3)));
          if (c < 0 || c.isNaN) continue;

          colors[i] = Color.fromARGB(
            255,
            (color.red / 255 * c).round(),
            (color.green / 255 * c).round(),
            (color.blue / 255 * c).round(),
          ).value;

          final v = matrix.transformed3(vertices.vectorAt(j * 3));
          positions[i * 2] = v.x;
          positions[i * 2 + 1] = v.y;

          indices[i] = i++;
        }
      }

      final raw = Vertices.raw(
        VertexMode.triangles,
        positions.sublist(0, i * 2),
        colors: colors.sublist(0, i),
        indices: indices,
      );
      canvas.drawVertices(raw, BlendMode.src, Paint());
    }
  }

  @override
  bool shouldRepaint(ScenePainter old) => true;
}
