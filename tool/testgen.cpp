#include <QtCore>

#include <assimp/cimport.h>
#include <assimp/scene.h>

static QDir testFileDir() { return QDir::current(); }
static QString testFilePath(const QString &fileName) { return testFileDir().filePath(fileName); }

static QDir testModelDir() { return QDir(QDir::currentPath() + "/models/model-db/"); }
static QString testModelPath(const QString &fileName) { return testModelDir().filePath(fileName); }

static QString indexed(const QString id, int i) { return QString("%1_%2").arg(id).arg(i); }
static QString indexed(const QString id, int i, int j) { return QString("%1_%2_%3").arg(id).arg(i).arg(j); }
static QString indexed(const QString id, int i, int j, int k) { return QString("%1_%2_%3_%4").arg(id).arg(i).arg(j).arg(k); }

static QString import(const QString &package) { return QString("import '%1';").arg(package); }
static QString dartName(const QString &typeName) { return typeName == "aiMetadata" ? "MetaData" : typeName.mid(2); }

static QString isTrueOrFalse(bool val) { return val ? "isTrue" : "isFalse"; }
static QString isEmptyOrNot(int num) { return num ? "isNotEmpty" : "isEmpty"; }
static QString isZeroOrNot(int num) { return num ? "isNonZero" : "isZero"; }
static QString isNullOrNot(const void *ptr) { return ptr ? "isNotNull" : "isNull"; }

static QString color4ToString(const aiColor4D &c) { return QString("Color.fromARGB(%1, %2, %3, %4)").arg(std::round(c.a * 255)).arg(std::round(c.r * 255)).arg(std::round(c.g * 255)).arg(std::round(c.b * 255)); }
static QString color3ToString(const aiColor3D &c) { return color4ToString(aiColor4D(c.r, c.g, c.b, 1.0)); }
static QString matrix4ToString(const aiMatrix4x4 &m) { return QString("Matrix4(%1, %2, %3, %4, %5 ,%6, %7, %8, %9, %10, %11, %12, %13, %14, %15, %16)").arg(m.a1).arg(m.a2).arg(m.a3).arg(m.a4).arg(m.b1).arg(m.b2).arg(m.b3).arg(m.b4).arg(m.c1).arg(m.c2).arg(m.c3).arg(m.c4).arg(m.d1).arg(m.d2).arg(m.d3).arg(m.d4); }
static QString quaternionToString(const aiQuaternion &q) { return QString("Quaternion(%1, %2, %3, %4)").arg(q.x).arg(q.y).arg(q.z).arg(q.z); }
static QString vector3ToString(const aiVector3D &v) { return QString("Vector3(%1, %2, %3)").arg(v.x).arg(v.y).arg(v.z); }
static QString aabbToString(const aiAABB &a) { return QString("Aabb3.minMax(%1, %2)").arg(vector3ToString(a.mMin)).arg(vector3ToString(a.mMax)); }

static QString equalsTo(const QString &value) { return QString("equals(%1)").arg(value); }
static QString equalsToInt(int value) { return value ? equalsTo(QString::number(value)) : "isZero"; }
static QString equalsToFloat(float value) { return qFuzzyIsNull(value) ? "isZero" : QString("moreOrLessEquals(%1)").arg(value); }
static QString equalsToDouble(double value) { return qFuzzyIsNull(value) ? "isZero" : QString("moreOrLessEquals(%1)").arg(value); }
static QString equalsToString(const char *str, uint len) { return len ? equalsTo(QString("'%1'").arg(QString::fromUtf8(str, len).replace("\\", "\\\\").replace("$", "\\$"))) : "isEmpty"; }
static QString equalsToString(const aiString &str) { return equalsToString(str.data, str.length); }
static QString equalsToAabb(const aiAABB &a) { return QString("aabb3MoreOrLessEquals(%1)").arg(aabbToString(a)); }
static QString equalsToColor3(const aiColor3D &c) { return QString("isSameColorAs(%1)").arg(color3ToString(c)); }
static QString equalsToColor4(const aiColor4D &c) { return QString("isSameColorAs(%1)").arg(color4ToString(c)); }
static QString equalsToQuaternion(const aiQuaternion &q) { return QString("quaternionMoreOrLessEquals(%1)").arg(quaternionToString(q)); }
static QString equalsToVector3(const aiVector3D &v) { return QString("vector3MoreOrLessEquals(%1)").arg(vector3ToString(v)); }
static QString equalsToMatrix4(const aiMatrix4x4 &m) { return QString("matrix4MoreOrLessEquals(%1)").arg(matrix4ToString(m)); }
static QString equalsToByteArray(const char *arr, uint len) { QStringList v; for (uint i = 0; i < len; ++i) v += QString::number(arr[i]); return equalsTo("[%1]").arg(v.join(", ")); }
static QString equalsToIntArray(const int *arr, uint len) { QStringList v; for (uint i = 0; i < len; ++i) v += QString::number(arr[i]); return equalsTo("[%1]").arg(v.join(", ")); }
static QString equalsToUintArray(const uint *arr, uint len) { return equalsToIntArray(reinterpret_cast<const int*>(arr), len); }
static QString equalsToDoubleArray(const double *arr, uint len) { QStringList v; for (uint i = 0; i < len; ++i) v += QString::number(arr[i]); return equalsTo("[%1]").arg(v.join(", ")); }

static QString equalsToAnimBehavior(int value)
{
    switch (value) {
    case aiAnimBehaviour_DEFAULT: return equalsTo("AnimBehavior.defaults");
    case aiAnimBehaviour_CONSTANT: return equalsTo("AnimBehavior.constant");
    case aiAnimBehaviour_LINEAR: return equalsTo("AnimBehavior.linear");
    case aiAnimBehaviour_REPEAT: return equalsTo("AnimBehavior.repeat");
    default: return QString();
    }
}

static QString equalsToLightSourceType(int value)
{
    switch (value) {
    case aiLightSource_UNDEFINED: return equalsTo("LightSourceType.undefined");
    case aiLightSource_DIRECTIONAL: return equalsTo("LightSourceType.directional");
    case aiLightSource_POINT: return equalsTo("LightSourceType.point");
    case aiLightSource_SPOT: return equalsTo("LightSourceType.spot");
    case aiLightSource_AMBIENT: return equalsTo("LightSourceType.ambient");
    case aiLightSource_AREA: return equalsTo("LightSourceType.area");
    default: return QString();
    }
}

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
        << import("dart:typed_data") << "\n"
        << import("package:ffi/ffi.dart") << "\n"
        << import("package:test/test.dart") << "\n"
        << import("../lib/assimp.dart") << "\n"
        << import("../lib/src/bindings.dart") << "\n"
        << import("test_utils.dart") << "\n\n"
        << "// DO NOT EDIT (generated by tool/testgen)\n\n"
        << "void main() {\n"
        << "  prepareTest();\n\n";
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

static void writeNullTest(QTextStream &out, const QString &typeName)
{
    writeGroup(out, "null", [&]() {
        out << QString("    expect(%1.fromNative(null), isNull);\n").arg(typeName);
    });
}

static void writeSizeTest(QTextStream &out, const QString &typeName, size_t size)
{
    writeGroup(out, "size", [&]() {
        out << QString("    expect(sizeOf<%1>(), equals(%2));\n").arg(typeName).arg(size);
    });
}

static void writeEqualityTest(QTextStream &out, const QString &typeName)
{
    writeGroup(out, "size", [&]() {
        out << QString("    final a = %1.fromNative(allocate<%2>());\n").arg(dartName(typeName)).arg(typeName)
            << QString("    final b = %1.fromNative(allocate<%2>());\n").arg(dartName(typeName)).arg(typeName)
            << QString("    final aa = %1.fromNative(a.ptr);\n").arg(dartName(typeName))
            << QString("    final bb = %1.fromNative(b.ptr);\n").arg(dartName(typeName))
            << QString("    expect(a, equals(a));\n")
            << QString("    expect(a, equals(aa));\n")
            << QString("    expect(b, equals(b));\n")
            << QString("    expect(b, equals(bb));\n")
            << QString("    expect(a, isNot(equals(b)));\n")
            << QString("    expect(a, isNot(equals(bb)));\n")
            << QString("    expect(b, isNot(equals(a)));\n")
            << QString("    expect(b, isNot(equals(aa)));\n");
    });
}

static void writeToStringTest(QTextStream &out, const QString &typeName)
{
    writeGroup(out, "toString", [&]() {
        out << QString("    expect(%1.fromNative(allocate<%2>()).toString(), matches(r'%1\\(Pointer<%2>: address=0x[0-f]+\\)'));\n").arg(dartName(typeName)).arg(typeName);
    });
}

static void writeAnimationTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final animations = scene.animations;\n"
        << "      expect(animations, " << isEmptyOrNot(scene->mAnimations != nullptr) << ");\n"
        << "      expect(animations.length, " << equalsToInt(scene->mNumAnimations) << ");\n";
    for (uint i = 0; i < scene->mNumAnimations; ++i) {
        const aiAnimation *animation = scene->mAnimations[i];
        out << "      final "  << indexed("animation", i) << " = animations.elementAt(" << i << ");\n"
            << "      expect(" << indexed("animation", i) << ".name, " << equalsToString(animation->mName) << ");\n"
            << "      expect(" << indexed("animation", i) << ".duration, " << equalsToDouble(animation->mDuration) << ");\n"
            << "      expect(" << indexed("animation", i) << ".ticksPerSecond, " << equalsToDouble(animation->mTicksPerSecond) << ");\n"
            << "      expect(" << indexed("animation", i) << ".channels.length, " << equalsToInt(animation->mNumChannels) << ");\n";
        for (uint j = 0; j < animation->mNumChannels; ++j) {
            const aiNodeAnim *channel = animation->mChannels[j];
            out << "      final  " << indexed("channel", i, j) << " = " << indexed("animation", i) << ".channels.elementAt(" << j << ");\n"
                << "      expect(" << indexed("channel", i, j) << ".positionKeys.length, " << equalsToInt(channel->mNumPositionKeys) << ");\n";
            for (uint k = 0; k < channel->mNumPositionKeys; ++k) {
                const aiVectorKey *positionKey = channel->mPositionKeys + k;
                out << "      final "  << indexed("positionKey", i, j, k) << " = " << indexed("channel", i, j) << ".positionKeys.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("positionKey", i, j, k) << ".time, " << equalsToDouble(positionKey->mTime) << ");\n"
                    << "      expect(" << indexed("positionKey", i, j, k) << ".value, " << equalsToVector3(positionKey->mValue) << ");\n";
            }
            out << "      expect(" << indexed("channel", i, j) << ".rotationKeys.length, " << equalsToInt(channel->mNumRotationKeys) << ");\n";
            for (uint k = 0; k < channel->mNumRotationKeys; ++k) {
                const aiQuatKey *rotationKey = channel->mRotationKeys + k;
                out << "      final "  << indexed("rotationKey", i, j, k) << " = " << indexed("channel", i, j) << ".rotationKeys.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("rotationKey", i, j, k) << ".time, " << equalsToDouble(rotationKey->mTime) << ");\n"
                    << "      expect(" << indexed("rotationKey", i, j, k) << ".value, " << equalsToQuaternion(rotationKey->mValue) << ");\n";
            }
            out << "      expect(" << indexed("channel", i, j) << ".scalingKeys.length, " << equalsToInt(channel->mNumScalingKeys) << ");\n";
            for (uint k = 0; k < channel->mNumScalingKeys; ++k) {
                const aiVectorKey *scalingKey = channel->mScalingKeys + k;
                out << "      final "  << indexed("scalingKey", i, j, k) << " = " << indexed("channel", i, j) << ".scalingKeys.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("scalingKey", i, j, k) << ".time, " << equalsToDouble(scalingKey->mTime) << ");\n"
                    << "      expect(" << indexed("scalingKey", i, j, k) << ".value, " << equalsToVector3(scalingKey->mValue) << ");\n";
            }
            out << "      expect(" << indexed("channel", i, j) << ".preState, " << equalsToAnimBehavior(channel->mPreState) << ");\n"
                << "      expect(" << indexed("channel", i, j) << ".postState, " << equalsToAnimBehavior(channel->mPostState) << ");\n";
        }
        out << "      expect(" << indexed("animation", i) << ".meshChannels.length, " << equalsToInt(animation->mNumMeshChannels) << ");\n";
        for (uint j = 0; j < animation->mNumMeshChannels; ++j) {
            const aiMeshAnim *meshChannel = animation->mMeshChannels[j];
            out << "      final "  << indexed("meshChannel", i, j) << " = " << indexed("animation", i) << ".meshChannels.elementAt(" << j << ");\n"
                << "      expect(" << indexed("meshChannel", i, j) << ".keys.length, " << equalsToInt(meshChannel->mNumKeys) << ");\n";
            for (uint k = 0; k < meshChannel->mNumKeys; ++k) {
                const aiMeshKey *meshKey = meshChannel->mKeys + k;
                out << "      final "  << indexed("meshKey", i, j, k) << " = " << indexed("meshChannel", i, j) << ".keys.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("meshKey", i, j, k) << ".time, " << equalsToDouble(meshKey->mTime) << ");\n"
                    << "      expect(" << indexed("meshKey", i, j, k) << ".value, " << equalsToInt(meshKey->mValue) << ");\n";
            }
        }
        out << "      expect(" << indexed("animation", i) << ".meshMorphChannels.length, " << equalsToInt(animation->mNumMorphMeshChannels) << ");\n";
        for (uint j = 0; j < animation->mNumMorphMeshChannels; ++j) {
            const aiMeshMorphAnim *channel = animation->mMorphMeshChannels[j];
            out << "      final "  << indexed("meshMorphChannel", i, j) << " = " << indexed("animation", i) << ".meshMorphChannels.elementAt(" << j << ");\n"
                << "      expect(" << indexed("meshMorphChannel", i, j) << ".keys.length, " << equalsToInt(channel->mNumKeys) << ");\n";
            for (uint k = 0; k < channel->mNumKeys; ++k) {
                const aiMeshMorphKey *key = channel->mKeys + k;
                out << "      final "  << indexed("meshMorphKey", i, j, k) << " = " << indexed("meshMorphChannel", i, j) << ".keys.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("meshMorphKey", i, j, k) << ".time, " << equalsToDouble(key->mTime) << ");\n"
                    << "      expect(" << indexed("meshMorphKey", i, j, k) << ".values, " << equalsToUintArray(key->mValues, key->mNumValuesAndWeights) << ");\n"
                    << "      expect(" << indexed("meshMorphKey", i, j, k) << ".weights, " << equalsToDoubleArray(key->mWeights, key->mNumValuesAndWeights) << ");\n";
            }
        }
        out << (i < scene->mNumAnimations - 1 ? "\n" : "");
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void writeCameraTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final cameras = scene.cameras;\n"
        << "      expect(cameras, " << isEmptyOrNot(scene->mCameras != nullptr) << ");\n"
        << "      expect(cameras.length, " << equalsToInt(scene->mNumCameras) << ");\n";
    for (uint i = 0; i < scene->mNumCameras; ++i) {
        const aiCamera *camera = scene->mCameras[i];
        out << "      final "  << indexed("camera", i) << " = cameras.elementAt(" << i << ");\n"
            << "      expect(" << indexed("camera", i) << ".name, " << equalsToString(camera->mName) << ");\n"
            << "      expect(" << indexed("camera", i) << ".position, " << equalsToVector3(camera->mPosition) << ");\n"
            << "      expect(" << indexed("camera", i) << ".up, " << equalsToVector3(camera->mUp) << ");\n"
            << "      expect(" << indexed("camera", i) << ".lookAt, " << equalsToVector3(camera->mLookAt) << ");\n"
            << "      expect(" << indexed("camera", i) << ".horizontalFov, " << equalsToFloat(camera->mHorizontalFOV) << ");\n"
            << "      expect(" << indexed("camera", i) << ".clipPlaneNear, " << equalsToFloat(camera->mClipPlaneNear) << ");\n"
            << "      expect(" << indexed("camera", i) << ".clipPlaneFar, " << equalsToFloat(camera->mClipPlaneFar) << ");\n"
            << "      expect(" << indexed("camera", i) << ".aspect, " << equalsToFloat(camera->mAspect) << ");\n"
            << (i < scene->mNumCameras - 1 ? "\n" : "");
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void writeLightTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final lights = scene.lights;\n"
        << "      expect(lights, " << isEmptyOrNot(scene->mLights != nullptr) << ");\n"
        << "      expect(lights.length, " << equalsToInt(scene->mNumLights) << ");\n";
    for (uint i = 0; i < scene->mNumLights; ++i) {
        const aiLight *light = scene->mLights[i];
        out << "      final "  << indexed("light", i) << " = lights.elementAt(" << i << ");\n"
            << "      expect(" << indexed("light", i) << ".name, " << equalsToString(light->mName) << ");\n"
            << "      expect(" << indexed("light", i) << ".type, " << equalsToLightSourceType(light->mType) << ");\n"
            << "      expect(" << indexed("light", i) << ".position, " << equalsToVector3(light->mPosition) << ");\n"
            << "      expect(" << indexed("light", i) << ".direction, " << equalsToVector3(light->mDirection) << ");\n"
            << "      expect(" << indexed("light", i) << ".up, " << equalsToVector3(light->mUp) << ");\n"
            << "      expect(" << indexed("light", i) << ".attenuationConstant, " << equalsToFloat(light->mAttenuationConstant) << ");\n"
            << "      expect(" << indexed("light", i) << ".attenuationLinear, " << equalsToFloat(light->mAttenuationLinear) << ");\n"
            << "      expect(" << indexed("light", i) << ".attenuationQuadratic, " << equalsToFloat(light->mAttenuationQuadratic) << ");\n"
            << "      expect(" << indexed("light", i) << ".colorDiffuse, " << equalsToColor3(light->mColorDiffuse) << ");\n"
            << "      expect(" << indexed("light", i) << ".colorSpecular, " << equalsToColor3(light->mColorSpecular) << ");\n"
            << "      expect(" << indexed("light", i) << ".colorAmbient, " << equalsToColor3(light->mColorAmbient) << ");\n"
            << "      expect(" << indexed("light", i) << ".angleInnerCone, " << equalsToFloat(light->mAngleInnerCone) << ");\n"
            << "      expect(" << indexed("light", i) << ".angleOuterCone, " << equalsToFloat(light->mAngleOuterCone) << ");\n"
            << "      expect(" << indexed("light", i) << ".size.width, " << equalsToFloat(light->mSize.x) << ");\n"
            << "      expect(" << indexed("light", i) << ".size.height, " << equalsToFloat(light->mSize.y) << ");\n"
            << (i < scene->mNumLights - 1 ? "\n" : "");
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void writeMaterialTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final materials = scene.materials;\n"
        << "      expect(materials, " << isEmptyOrNot(scene->mMaterials != nullptr) << ");\n"
        << "      expect(materials.length, " << equalsToInt(scene->mNumMaterials) << ");\n";
    for (uint i = 0; i < scene->mNumMaterials; ++i) {
        const aiMaterial *material = scene->mMaterials[i];
        out << "      final "  << indexed("material", i) << " = materials.elementAt(" << i << ");\n"
            << "      expect(" << indexed("material", i) << ".properties.length, " << equalsToInt(material->mNumProperties) << ");\n";
        for (uint j = 0; j < material->mNumProperties; ++j) {
            const aiMaterialProperty *property = material->mProperties[j];
            out << "      final "  << indexed("property", i, j) << " = " << indexed("material", i) << ".properties.elementAt(" << j << ");\n"
                << "      expect(" << indexed("property", i, j) << ".key, " << equalsToString(property->mKey) << ");\n";
            switch (property->mType) {
            case aiPropertyTypeInfo::aiPTI_Float:
                out << "      expect(" << indexed("property", i, j) << ".value.runtimeType, double);\n"
                    << "      expect(" << indexed("property", i, j) << ".value, " << equalsToFloat(*reinterpret_cast<float*>(property->mData)) << ");\n";
                break;
            case aiPropertyTypeInfo::aiPTI_Double:
                out << "      expect(" << indexed("property", i, j) << ".value.runtimeType, double);\n"
                    << "      expect(" << indexed("property", i, j) << ".value, " << equalsToDouble(*reinterpret_cast<double*>(property->mData)) << ");\n";
                break;
            case aiPropertyTypeInfo::aiPTI_String:
                out << "      expect(" << indexed("property", i, j) << ".value.runtimeType, String);\n"
                    << "      expect(" << indexed("property", i, j) << ".value, " << equalsToString(*reinterpret_cast<aiString*>(property->mData)) << ");\n";
                break;
            case aiPropertyTypeInfo::aiPTI_Integer:
                out << "      expect(" << indexed("property", i, j) << ".value.runtimeType, int);\n"
                    << "      expect(" << indexed("property", i, j) << ".value, " << equalsToInt(*reinterpret_cast<int*>(property->mData)) << ");\n";
                break;
            case aiPropertyTypeInfo::aiPTI_Buffer:
                out << "      expect(" << indexed("property", i, j) << ".value.runtimeType.toString(), 'Uint8List');\n"
                    << "      expect(" << indexed("property", i, j) << ".value, " << equalsToByteArray(property->mData, property->mDataLength) << ");\n";
                break;
            default:
                break;
            }
            out << "      expect(" << indexed("property", i, j) << ".index, " << equalsToInt(property->mIndex) << ");\n"
                << "      expect(" << indexed("property", i, j) << ".semantic, " << equalsToInt(property->mSemantic) << ");\n";
        }
        out << (i < scene->mNumMaterials - 1 ? "\n" : "");
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void writeMeshTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final meshes = scene.meshes;\n"
        << "      expect(meshes, " << isEmptyOrNot(scene->mMeshes != nullptr) << ");\n"
        << "      expect(meshes.length, " << equalsToInt(scene->mNumMeshes) << ");\n";
    for (uint i = 0; i < scene->mNumMeshes; ++i) {
        const aiMesh *mesh = scene->mMeshes[i];
        out << "      final "  << indexed("mesh", i) << " = meshes.elementAt(" << i << ");\n"
            << "      expect(" << indexed("mesh", i) << ".primitiveTypes, " << equalsToInt(mesh->mPrimitiveTypes) << ");\n";

        const uint numVertices = mesh->mNumVertices;
        out << "      expect(" << indexed("mesh", i) << ".vertices.length, " << equalsToInt(mesh->mNumVertices) << ");\n";
        for (uint j = 0; j < numVertices; ++j) {
            out << "      final "  << indexed("vertex", i, j) << " = "  << indexed("mesh", i) << ".vertices.elementAt(" << j << ");\n"
                << "      expect(" << indexed("vertex", i, j) << ", " << equalsToVector3(mesh->mVertices[j]) << ");\n";
        }

        const uint numNormals = mesh->mNormals ? mesh->mNumVertices : 0;
        out << "      expect(" << indexed("mesh", i) << ".normals.length, " << equalsToInt(numNormals) << ");\n";
        for (uint j = 0; j <  numNormals; ++j) {
            out << "      final "  << indexed("normal", i, j) << " = "  << indexed("mesh", i) << ".normals.elementAt(" << j << ");\n"
                << "      expect(" << indexed("normal", i, j) << ", " << equalsToVector3(mesh->mNormals[j]) << ");\n";
        }

        const uint numTangents = mesh->mTangents ? mesh->mNumVertices : 0;
        out << "      expect(" << indexed("mesh", i) << ".tangents.length, " << equalsToInt(numTangents) << ");\n";
        for (uint j = 0; j < numTangents; ++j) {
            out << "      final "  << indexed("tangent", i, j) << " = "  << indexed("mesh", i) << ".tangents.elementAt(" << j << ");\n"
                << "      expect(" << indexed("tangent", i, j) << ", " << equalsToVector3(mesh->mTangents[j]) << ");\n";
        }

        const uint numBitangents = mesh->mBitangents ? mesh->mNumVertices : 0;
        out << "      expect(" << indexed("mesh", i) << ".bitangents.length, " << equalsToInt(numBitangents) << ");\n";
        for (uint j = 0; j < numBitangents; ++j) {
            out << "      final "  << indexed("bitangent", i, j) << " = "  << indexed("mesh", i) << ".bitangents.elementAt(" << j << ");\n"
                << "      expect(" << indexed("bitangent", i, j) << ", " << equalsToVector3(mesh->mBitangents[j]) << ");\n";
        }

        const uint numColorChannels = mesh->GetNumColorChannels();
        out << "      expect(" << indexed("mesh", i) << ".colors.length, " << equalsToInt(numColorChannels) << ");\n";
        for (uint j = 0; j < numColorChannels; ++j) {
            out << "      final "  << indexed("colors", i, j) << " = "  << indexed("mesh", i) << ".colors.elementAt(" << j << ");\n"
                << "      expect(" << indexed("colors", i, j) << ".length, " << equalsToInt(numVertices) << ");\n";
            for (uint k = 0; k < numVertices; ++k) {
                out << "      final "  << indexed("color", i, j, k) << " = .colors.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("color", i, j, k) << ", " << equalsToColor4(mesh->mColors[j][k]) << ");\n";
            }
        }

        const uint numTextureCoords = mesh->GetNumUVChannels();
        out << "      expect(" << indexed("mesh", i) << ".textureCoords.length, " << equalsToInt(numTextureCoords) << ");\n";
        for (uint j = 0; j < numTextureCoords; ++j) {
            out << "      final "  << indexed("textureCoords", i, j) << " = "  << indexed("mesh", i) << ".textureCoords.elementAt(" << j << ");\n"
                << "      expect(" << indexed("textureCoords", i, j) << ".length, " << equalsToInt(numVertices) << ");\n";
            for (uint k = 0; k < numVertices; ++k) {
                out << "      final "  << indexed("textureCoord", i, j, k) << " = " << indexed("textureCoords", i, j) << ".elementAt(" << k << ");\n"
                    << "      expect(" << indexed("textureCoord", i, j, k) << ", " << equalsToVector3(mesh->mTextureCoords[j][k]) << ");\n";
            }
        }

        out << "      expect(" << indexed("mesh", i) << ".uvComponents.length, " << equalsToInt(mesh->GetNumUVChannels()) << ");\n"
            << "      expect(" << indexed("mesh", i) << ".uvComponents, " << equalsToUintArray(mesh->mNumUVComponents, mesh->GetNumUVChannels()) << ");\n"
            << "      expect(" << indexed("mesh", i) << ".faces.length, " << equalsToInt(mesh->mNumFaces) << ");\n"
            << "      expect(" << indexed("mesh", i) << ".bones.length, " << equalsToInt(mesh->mNumBones) << ");\n"
            << "      expect(" << indexed("mesh", i) << ".materialIndex, " << equalsToInt(mesh->mMaterialIndex) << ");\n"
            << "      expect(" << indexed("mesh", i) << ".name, " << equalsToString(mesh->mName) << ");\n"
            << "      expect(" << indexed("mesh", i) << ".animMeshes.length, " << equalsToInt(mesh->mNumAnimMeshes) << ");\n"
            << "      expect(" << indexed("mesh", i) << ".morphingMethod, " << equalsToInt(mesh->mMethod) << ");\n"
            << "      expect(" << indexed("mesh", i) << ".aabb, " << equalsToAabb(mesh->mAABB) << ");\n"
            << (i < scene->mNumMeshes - 1 ? "\n" : "");
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void writeMetaDataTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final metaData = scene.metaData;\n"
        << "      expect(metaData, " << isNullOrNot(scene->mMetaData) << ");\n";
    if (scene->mMetaData) {
        out << "      expect(metaData.keys.length, " << equalsToInt(scene->mMetaData->mNumProperties) << ");\n"
            << "      expect(metaData.values.length, " << equalsToInt(scene->mMetaData->mNumProperties) << ");\n"
            << "      expect(metaData.properties.length, " << equalsToInt(scene->mMetaData->mNumProperties) << ");\n";
        for (uint i = 0; i < scene->mMetaData->mNumProperties; ++i) {
            out << "      final "  << indexed("key", i) << " = metaData.keys.elementAt(" << i << ");\n"
                << "      expect(" << indexed("key", i) << ", " << equalsToString(scene->mMetaData->mKeys[i]) << ");\n"
                << "      final "  << indexed("value", i) << " = metaData.values.elementAt(" << i << ");\n";
            const aiMetadataEntry *entry = scene->mMetaData->mValues + i;
            switch (entry->mType) {
            case aiMetadataType::AI_BOOL:
                out << "      expect(" << indexed("value", i) << ".runtimeType, bool);\n";
                out << "      expect(" << indexed("value", i) << ", " << isTrueOrFalse(*reinterpret_cast<bool*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_INT32:
                out << "      expect(" << indexed("value", i) << ".runtimeType, int);\n";
                out << "      expect(" << indexed("value", i) << ", " << equalsToInt(*reinterpret_cast<int*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_UINT64:
                out << "      expect(" << indexed("value", i) << ".runtimeType, int);\n";
                out << "      expect(" << indexed("value", i) << ", " << equalsToInt(*reinterpret_cast<qint64*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_FLOAT:
                out << "      expect(" << indexed("value", i) << ".runtimeType, double);\n";
                out << "      expect(" << indexed("value", i) << ", " << equalsToFloat(*reinterpret_cast<float*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_DOUBLE:
                out << "      expect(" << indexed("value", i) << ".runtimeType, double);\n";
                out << "      expect(" << indexed("value", i) << ", " << equalsToDouble(*reinterpret_cast<double*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_AISTRING:
                out << "      expect(" << indexed("value", i) << ".runtimeType, String);\n";
                out << "      expect(" << indexed("value", i) << ", " << equalsToString(*reinterpret_cast<aiString*>(entry->mData)) << ");\n";
                break;
            case aiMetadataType::AI_AIVECTOR3D:
                out << "      expect(" << indexed("value", i) << ".runtimeType, Vector3);\n";
                out << "      expect(" << indexed("value", i) << ", " << equalsToVector3(*reinterpret_cast<aiVector3D*>(entry->mData)) << ");\n";
                break;
            default:
                break;
            }
        }
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

static void writeNodeTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final rootNode = scene.rootNode;\n"
        << "      expect(rootNode, " << isNullOrNot(scene->mRootNode) << ");\n"
        << "      expect(rootNode.name, " << equalsToString(scene->mRootNode->mName) << ");\n"
        << "      expect(rootNode.transformation, " << equalsToMatrix4(scene->mRootNode->mTransformation) << ");\n"
        << "      expect(rootNode.parent, " << isNullOrNot(scene->mRootNode->mParent) << ");\n"
        << "      expect(rootNode.children.length, " << equalsToInt(scene->mRootNode->mNumChildren) << ");\n";
    for (uint i = 0; i < scene->mRootNode->mNumChildren; ++i) {
        const aiNode *node = scene->mRootNode->mChildren[i];
        out << "      final "  << indexed("child", i) << " = rootNode.children.elementAt(" << i << ");\n"
            << "      expect(" << indexed("child", i) << ".name, " << equalsToString(node->mName) << ");\n"
            << "      expect(" << indexed("child", i) << ".transformation, " << equalsToMatrix4(node->mTransformation) << ");\n"
            << "      expect(" << indexed("child", i) << ".parent, " << isNullOrNot(node->mParent) << ");\n"
            << "      expect(" << indexed("child", i) << ".children.length, " << equalsToInt(node->mNumChildren) << ");\n"
            << "      expect(" << indexed("child", i) << ".meshes, " << equalsToUintArray(node->mMeshes, node->mNumMeshes) << ");\n"
            << "      expect(" << indexed("child", i) << ".metaData, " << isNullOrNot(node->mMetaData) << ");\n";
    }
    out << "      expect(rootNode.meshes, " << equalsToUintArray(scene->mRootNode->mMeshes, scene->mRootNode->mNumMeshes) << ");\n"
        << "      expect(rootNode.metaData, " << isNullOrNot(scene->mRootNode->mMetaData) << ");\n"
        << "    });\n\n";
    aiReleaseImport(scene);
}

static void writeSceneTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      expect(scene, " << isNullOrNot(scene) << ");\n"
        << "      expect(scene.flags, " << isZeroOrNot(scene->mFlags) << ");\n"
        << "      expect(scene.rootNode, " << isNullOrNot(scene->mRootNode) << ");\n"
        << "      expect(scene.meshes.length, " << equalsToInt(scene->mNumMeshes) << ");\n"
        << "      expect(scene.materials.length, " << equalsToInt(scene->mNumMaterials) << ");\n"
        << "      expect(scene.animations.length, " << equalsToInt(scene->mNumAnimations) << ");\n"
        << "      expect(scene.textures.length, " << equalsToInt(scene->mNumTextures) << ");\n"
        << "      expect(scene.lights.length, " << equalsToInt(scene->mNumLights) << ");\n"
        << "      expect(scene.cameras.length, " << equalsToInt(scene->mNumCameras) << ");\n"
        << "      expect(scene.metaData, " << isNullOrNot(scene->mMetaData) << ");\n"
        << "    });\n";
    aiReleaseImport(scene);
}

static void writeTextureTester(QTextStream &out, const QString &fileName = QString())
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final textures = scene.textures;\n"
        << "      expect(textures, " << isEmptyOrNot(scene->mTextures != nullptr) << ");\n"
        << "      expect(textures.length, " << equalsToInt(scene->mNumTextures) << ");\n";
    for (uint i = 0; i < scene->mNumTextures; ++i) {
        const aiTexture *texture = scene->mTextures[i];
        out << "      expect(textures.elementAt(" << i << ").width, " << equalsToInt(texture->mWidth) << ");\n"
            << "      expect(textures.elementAt(" << i << ").height, " << equalsToInt(texture->mHeight) << ");\n"
            << "      expect(textures.elementAt(" << i << ").data.length, " << equalsToInt(texture->mWidth * texture->mHeight) << ");\n"
            << "      expect(textures.elementAt(" << i << ").formatHint, " << equalsToString(texture->achFormatHint, HINTMAXTEXTURELEN) << ");\n"
            << "      expect(textures.elementAt(" << i << ").fileName, " << equalsToString(texture->mFilename) << ");\n";
        for (uint h = 0; h < texture->mHeight; ++h) {
            for (uint w = 0; w < texture->mWidth; ++w) {
                const aiTexel *texel = texture->pcData + h * w + w;
                out << "      expect(textures.elementAt(" << i << ").b, " << equalsToInt(texel->b) << ");\n"
                    << "      expect(textures.elementAt(" << i << ").g, " << equalsToInt(texel->g) << ");\n"
                    << "      expect(textures.elementAt(" << i << ").r, " << equalsToInt(texel->r) << ");\n"
                    << "      expect(textures.elementAt(" << i << ").a, " << equalsToInt(texel->a) << ");\n";
            }
        }
    }
    out << "    });\n";
    aiReleaseImport(scene);
}

template <typename T>
static void generateTest(const QString &typeName, const QString &fileName, std::function<void(QTextStream &out, const QString &filePath)> writer)
{
    QFile file(testFilePath(fileName));
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate))
        qFatal("%s", qPrintable(file.errorString()));

    QTextStream out(&file);
    writeHeader(out, fileName);
    writeNullTest(out, dartName(typeName));
    writeSizeTest(out, typeName, sizeof(T));
    writeEqualityTest(out, typeName);
    writeToStringTest(out, typeName);
    writeGroup(out, "3mf", [&]() {
        writer(out, "3mf/box.3mf");
        writer(out, "3mf/spider.3mf");
    });
    writeGroup(out, "fbx", [&]() {
        writer(out, "fbx/huesitos.fbx");
    });
    writeGroup(out, "obj", [&]() {
        writer(out, "Obj/Spider/spider.obj");
    });
    writeFooter(out, fileName);
}

int main(int argc, char *argv[])
{
    QDir::setCurrent(QString::fromLocal8Bit(argc > 1 ? argv[1] : OUT_PWD));

    generateTest<aiAnimation>("aiAnimation", "animation_test.dart", writeAnimationTester);
    generateTest<aiCamera>("aiCamera", "camera_test.dart", writeCameraTester);
    generateTest<aiLight>("aiLight", "light_test.dart", writeLightTester);
    generateTest<aiMaterial>("aiMaterial", "material_test.dart", writeMaterialTester);
    generateTest<aiMesh>("aiMesh", "mesh_test.dart", writeMeshTester);
    generateTest<aiMetadata>("aiMetadata", "meta_data_test.dart", writeMetaDataTester);
    generateTest<aiNode>("aiNode", "node_test.dart", writeNodeTester);
    generateTest<aiScene>("aiScene", "scene_test.dart", writeSceneTester);
    generateTest<aiTexture>("aiTexture", "texture_test.dart", writeTextureTester);
}
