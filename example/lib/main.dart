import 'dart:collection';
import 'dart:math' as Math;
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
  Aabb3 bounds;
  String current;
  Offset startPoint;
  double scale = 1;
  double startScale = 1;

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
      bounds = newScene.calculateBounds();
    });
  }

  void transformScene({double scale, Offset delta}) {
    if (scene == null) return;
    scene.rootNode.transformation = scene.rootNode.transformation
      ..rotateX(-0.01 * delta.dy)
      ..rotateY(0.01 * delta.dx);
    scene.postProcess(ProcessFlags.preTransformVertices);
    setState(() => this.scale = scale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assimp for Dart'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => ['box.obj', 'ear.stl', 'spider.stl']
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
          painter: ScenePainter(scene, bounds, scale),
          size: MediaQuery.of(context).size,
        ),
        onScaleStart: (details) {
          startScale = scale;
          startPoint = details.focalPoint;
        },
        onScaleUpdate: (details) {
          final scaled = details.scale != 1.0 || details.rotation != 0.0;
          transformScene(
            delta: details.focalPoint - startPoint,
            scale: scaled ? startScale * details.scale : scale,
          );
          startPoint = details.focalPoint;
        },
      ),
    );
  }
}

extension Vector3List on Float32List {
  Vector3 vectorAt(int i) => Vector3(this[i], this[i + 1], this[i + 2]);
}

extension Vector3Bounds on Vector3 {
  Vector3 minV(Vector3 other) {
    return Vector3(
      Math.min(x, other.x),
      Math.min(y, other.y),
      Math.min(z, other.z),
    );
  }

  Vector3 maxV(Vector3 other) {
    return Vector3(
      Math.max(x, other.x),
      Math.max(y, other.y),
      Math.max(z, other.z),
    );
  }
}

extension SceneBounds on Scene {
  Aabb3 calculateBounds() {
    Aabb3 bounds;
    for (final mesh in meshes) {
      for (final vertex in mesh.vertices) {
        bounds = Aabb3.minMax(
          bounds?.min?.minV(vertex) ?? vertex,
          bounds?.max?.maxV(vertex) ?? vertex,
        );
      }
    }
    return bounds;
  }
}

class ScenePainter extends CustomPainter {
  final Scene scene;
  final Aabb3 bounds;
  final double scale;

  ScenePainter(this.scene, this.bounds, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    if (scene == null) return;

    final color = Colors.white;
    final light = Vector3(0.0, 0.0, bounds.max.z / scale);
    final extent = bounds.max.distanceTo(bounds.min);
    final transformation = scene.rootNode.transformation;

    final matrix = transformation
      ..translate(size.width / 2, size.height / 2, 0)
      ..scale(size.shortestSide / extent * scale);

    for (final mesh in scene.meshes) {
      final normals = mesh.normalData;
      final vertices = mesh.vertexData;

      double faceDepth(Uint32List indices, Float32List vertices) {
        return (vertices[indices[0] * 3 + 2] +
                vertices[indices[1] * 3 + 2] +
                vertices[indices[2] * 3 + 2]) /
            3;
      }

      final faces = SplayTreeMap<double, Face>.fromIterable(mesh.faces,
          key: (f) => faceDepth(f.indexData, vertices), value: (f) => f);

      final count = faces.length * 3;
      final colors = Int32List(count);
      final indices = Uint16List(count);
      final positions = Float32List(count * 2);

      var i = 0;
      for (final face in faces.values) {
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

      if (i != 0) {
        final raw = Vertices.raw(
          VertexMode.triangles,
          positions.sublist(0, i * 2),
          colors: colors.sublist(0, i),
          indices: indices,
        );
        canvas.drawVertices(raw, BlendMode.src, Paint());
      }
    }
  }

  @override
  bool shouldRepaint(ScenePainter old) => true;
}
