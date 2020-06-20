#include <QtCore>

#include <assimp/cimport.h>
#include <assimp/scene.h>

static QDir testFileDir() { return QDir::current(); }
static QString testFilePath(const QString &fileName) { return testFileDir().filePath(fileName); }

static QDir testModelDir() { return QDir(QDir::currentPath() + "/models/model-db/"); }
static QString testModelPath(const QString &fileName) { return testModelDir().filePath(fileName); }

static QString import(const QString &package) { return QString("import '%1';").arg(package); }

static QString isZeroOrNot(int num) { return num ? "isNonZero" : "isZero"; }
static QString isNullOrNot(void *ptr) { return ptr ? "isNotNull" : "isNull"; }
static QString isNullPointerOrNot(void *ptr) { return !ptr ? "isNullPointer" : "isNotNull"; }
static QString equalsToInt(int count) { return count ? QString("equals(%1)").arg(count) : "isZero"; }
static QString equalsToString(const aiString str) { return str.length ? QString("equals('%1')").arg(QString::fromLatin1(str.data, str.length)) : "isNull"; }

template <typename T>
static int arraySize(T *array)
{
    int c = 0;
    while (array[c] != 0)
        ++c;
    return c;
}

static void writeHeader(QTextStream &out, const QString &fileName)
{
    Q_UNUSED(fileName);
    out << import("dart:ffi") << "\n"
        << import("package:ffi/ffi.dart") << "\n"
        << import("package:test/test.dart") << "\n"
        << import("package:assimp/assimp.dart") << "\n"
        << import("../lib/src/bindings.dart") << "\n"
        << import("test_utils.dart") << "\n\n"
        << "// DO NOT EDIT (generated by tool/testgen)\n\n"
        << "void main() {\n";
}

static void writeFooter(QTextStream &out, const QString &fileName)
{
    Q_UNUSED(fileName);
    out << "}\n";
}

static void writeGroup(QTextStream &out, const QString &name, std::function<void()> writer)
{
    out << QString("  test('%1', () {\n").arg(name);
    writer();
    out << "  });\n\n";
}

static void writeSizeTest(QTextStream &out, const QString &name, size_t size)
{
    writeGroup(out, "size", [&]() {
        out << QString("    expect(sizeOf<%1>(), equals(%2));\n").arg(name).arg(size);
    });
}

static void writeSceneTester(QTextStream &out, const QString &fileName = QString())
{
    if (fileName.isNull()) {
        out << "    testScene(null, tester: (scene) {\n"
            << "      expect(scene.flags, isZero);\n"
            << "      expect(scene.rootNode, isNullPointer);\n"
            << "      expect(scene.meshes, isEmpty);\n"
            << "      expect(scene.materials, isEmpty);\n"
            << "      expect(scene.animations, isEmpty);\n"
            << "      expect(scene.textures, isEmpty);\n"
            << "      expect(scene.lights, isEmpty);\n"
            << "      expect(scene.cameras, isEmpty);\n"
            << "      expect(scene.metaData, isNullPointer);\n"
            << "    });\n";
    } else {
        const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
        out << "    testScene('" << fileName << "', tester: (scene) {\n"
            << "      expect(scene.flags, " << isZeroOrNot(scene->mFlags) << ");\n"
            << "      expect(scene.rootNode, " << isNullPointerOrNot(scene->mRootNode) << ");\n"
            << "      expect(scene.meshes.length, " << equalsToInt(scene->mNumMeshes) << ");\n"
            << "      expect(scene.materials.length, " << equalsToInt(scene->mNumMaterials) << ");\n"
            << "      expect(scene.animations.length, " << equalsToInt(scene->mNumAnimations) << ");\n"
            << "      expect(scene.textures.length, " << equalsToInt(scene->mNumTextures) << ");\n"
            << "      expect(scene.lights.length, " << equalsToInt(scene->mNumLights) << ");\n"
            << "      expect(scene.cameras.length, " << equalsToInt(scene->mNumCameras) << ");\n"
            << "      expect(scene.metaData, " << isNullPointerOrNot(scene->mMetaData) << ");\n"
            << "    });\n";
        aiReleaseImport(scene);
    }
}

static void generateSceneTest(const QString &fileName)
{
    QFile file(testFilePath(fileName));
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate))
        qFatal(qPrintable(file.errorString()));

    QTextStream out(&file);

    writeHeader(out, fileName);

    writeSizeTest(out, "aiScene", sizeof(aiScene));

    writeGroup(out, "null", [&]() {
        writeSceneTester(out);
    });

    writeGroup(out, "3mf", [&]() {
        writeSceneTester(out, "3mf/box.3mf");
        writeSceneTester(out, "3mf/spider.3mf");
    });

    writeGroup(out, "fbx", [&]() {
        writeSceneTester(out, "fbx/huesitos.fbx");
    });

    writeGroup(out, "obj", [&]() {
        writeSceneTester(out, "Obj/Spider/spider.obj");
    });

    writeFooter(out, fileName);
}

static void testMeshes(const QString &fileName)
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    QTextStream(stdout)
            << "testMeshes('" << fileName << "', (meshes) {\n"
            << "  expect(meshes.length, " << equalsToInt(scene->mNumMeshes) << ");\n";
    for (uint i = 0; i < scene->mNumMeshes; ++i) {
        const aiMesh *mesh = scene->mMeshes[i];
        QTextStream(stdout)
                << "  expect(meshes.elementAt(" << i << ").primitiveTypes, " << equalsToInt(mesh->mPrimitiveTypes) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").vertices.length, " << equalsToInt(mesh->mNumVertices) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").normals.length, " << equalsToInt(mesh->mNumVertices) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").tangents.length, " << equalsToInt(mesh->mNumVertices) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").bitangents.length, " << equalsToInt(mesh->mNumVertices) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").colors.length, " << equalsToInt(arraySize(mesh->mColors)) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").textureCoords.length, " << equalsToInt(arraySize(mesh->mTextureCoords)) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").uvComponents.length, " << equalsToInt(arraySize(mesh->mNumUVComponents)) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").faces.length, " << equalsToInt(mesh->mNumFaces) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").bones.length, " << equalsToInt(mesh->mNumBones) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").materialIndex, " << equalsToInt(mesh->mMaterialIndex) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").name, " << equalsToString(mesh->mName) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").animMeshes.length, " << equalsToInt(mesh->mNumAnimMeshes) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").morphingMethod, " << equalsToInt(mesh->mMethod) << ");\n"
                << "  expect(meshes.elementAt(" << i << ").aabb, isNull);\n" // ### TODO
                << (i < scene->mNumMeshes - 1 ? "\n" : "");
    }
    QTextStream(stdout) << "});\n\n";
    aiReleaseImport(scene);
}

static void testNodes(const QString &fileName)
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    QTextStream(stdout)
            << "testNodes('" << fileName << "', (rootNode) {\n"
            << "  expect(rootNode.name, " << equalsToString(scene->mRootNode->mName) << ");\n"
//            << "  expect(rootNode.transformation, " << isNullOrNot(scene->mRootNode->mTransformation) << ");\n"
            << "  expect(rootNode.parent, " << isNullOrNot(scene->mRootNode->mParent) << ");\n"
            << "  expect(rootNode.children.length, " << equalsToInt(scene->mRootNode->mNumChildren) << ");\n"
            << "  expect(rootNode.meshes.length, " << equalsToInt(scene->mRootNode->mNumMeshes) << ");\n"
            << "  expect(rootNode.metaData, " << isNullOrNot(scene->mRootNode->mMetaData) << ");\n"
            << "});\n\n";
    aiReleaseImport(scene);
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    QDir::setCurrent(QString::fromLocal8Bit(argc > 1 ? argv[1] : OUT_PWD));

    generateSceneTest("scene_test.dart");

    testMeshes("3mf/box.3mf");
    testMeshes("3mf/spider.3mf");
    testMeshes("fbx/huesitos.fbx");
    testMeshes("Obj/Spider/spider.obj");

    testNodes("3mf/box.3mf");
    testNodes("3mf/spider.3mf");
    testNodes("fbx/huesitos.fbx");
    testNodes("Obj/Spider/spider.obj");
}
