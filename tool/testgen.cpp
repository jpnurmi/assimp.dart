#include <QtCore>

#include <assimp/cimport.h>
#include <assimp/scene.h>

static QString testFilePath(const QString &fileName) { return QDir::current().filePath(fileName); }

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

static void testMeshes(const QString &fileName)
{
    const aiScene *scene = aiImportFile(testFilePath(fileName).toLocal8Bit(), 0);
    QTextStream(stdout)
            << "testMeshes('" << fileName << "', (meshes) {\n"
            << "  expect(meshes.length, " << equalsToInt(scene->mNumMeshes) << ");";
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

static void testScene(const QString &fileName)
{
    const aiScene *scene = aiImportFile(testFilePath(fileName).toLocal8Bit(), 0);
    QTextStream(stdout)
            << "testScene('" << fileName << "', TestFrom.xxx, (scene) {\n"
            << "  expect(scene.flags, " << isZeroOrNot(scene->mFlags) << ");\n"
            << "  expect(scene.rootNode, " << isNullPointerOrNot(scene->mRootNode) << ");\n"
            << "  expect(scene.meshes.length, " << equalsToInt(scene->mNumMeshes) << ");\n"
            << "  expect(scene.materials.length, " << equalsToInt(scene->mNumMaterials) << ");\n"
            << "  expect(scene.animations.length, " << equalsToInt(scene->mNumAnimations) << ");\n"
            << "  expect(scene.textures.length, " << equalsToInt(scene->mNumTextures) << ");\n"
            << "  expect(scene.lights.length, " << equalsToInt(scene->mNumLights) << ");\n"
            << "  expect(scene.cameras.length, " << equalsToInt(scene->mNumCameras) << ");\n"
            << "  expect(scene.metaData, " << isNullPointerOrNot(scene->mMetaData) << ");\n"
            << "});\n\n";
    aiReleaseImport(scene);
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    QDir::setCurrent(QString::fromLocal8Bit(argc > 1 ? argv[1] : MODELDB));

    testScene("3mf/box.3mf");
    testScene("3mf/spider.3mf");
    testScene("fbx/huesitos.fbx");
    testScene("Obj/Spider/spider.obj");

    testMeshes("3mf/box.3mf");
    testMeshes("3mf/spider.3mf");
    testMeshes("fbx/huesitos.fbx");
    testMeshes("Obj/Spider/spider.obj");
}
