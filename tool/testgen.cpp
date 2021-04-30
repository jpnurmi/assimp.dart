﻿#include <QtCore>

#include <assimp/cexport.h>
#include <assimp/cfileio.h>
#include <assimp/cimport.h>
#include <assimp/scene.h>

static const int Dec = 9;

static QDir testFileDir() { return QDir::current(); }
static QString testFilePath(const QString &fileName) { return testFileDir().filePath(fileName); }

static QDir testModelDir() { return QDir(QDir::currentPath() + "/models/"); }
static QString testModelPath(const QString &fileName) { return testModelDir().filePath(fileName); }

static QString indexed(const QString id, int i) { return QString("%1_%2").arg(id).arg(i); }
static QString indexed(const QString id, int i, int j) { return QString("%1_%2_%3").arg(id).arg(i).arg(j); }
static QString indexed(const QString id, int i, int j, int k) { return QString("%1_%2_%3_%4").arg(id).arg(i).arg(j).arg(k); }
static QString indexed(const QString id, int i, int j, int k, int l) { return QString("%1_%2_%3_%4_%5").arg(id).arg(i).arg(j).arg(k).arg(l); }

static QString import(const QString &package) { return QString("import '%1';").arg(package); }

static QString isTrueOrFalse(bool val) { return val ? "isTrue" : "isFalse"; }
static QString isEmptyOrNot(int num) { return num ? "isNotEmpty" : "isEmpty"; }
static QString isZeroOrNot(int num) { return num ? "isNonZero" : "isZero"; }
static QString isNullOrNot(const void *ptr) { return ptr ? "isNotNull" : "isNull"; }

static QString color3ToString(const aiColor3D &c) { return QString("Vector3(%1, %2, %3)").arg(c.r, 0, 'g', Dec).arg(c.g, 0, 'g', Dec).arg(c.b, 0, 'g', Dec); }
static QString color4ToString(const aiColor4D &c) { return QString("Vector4(%1, %2, %3, %4)").arg(c.r, 0, 'g', Dec).arg(c.g, 0, 'g', Dec).arg(c.b, 0, 'g', Dec).arg(c.a, 0, 'g', Dec); }
static QString matrix4ToString(const aiMatrix4x4 &m) { return QString("Matrix4(%1, %2, %3, %4, %5, %6, %7, %8, %9, %10, %11, %12, %13, %14, %15, %16)").arg(m.a1, 0, 'g', Dec).arg(m.a2, 0, 'g', Dec).arg(m.a3, 0, 'g', Dec).arg(m.a4, 0, 'g', Dec).arg(m.b1, 0, 'g', Dec).arg(m.b2, 0, 'g', Dec).arg(m.b3, 0, 'g', Dec).arg(m.b4, 0, 'g', Dec).arg(m.c1, 0, 'g', Dec).arg(m.c2, 0, 'g', Dec).arg(m.c3, 0, 'g', Dec).arg(m.c4, 0, 'g', Dec).arg(m.d1, 0, 'g', Dec).arg(m.d2, 0, 'g', Dec).arg(m.d3, 0, 'g', Dec).arg(m.d4, 0, 'g', Dec); }
static QString quaternionToString(const aiQuaternion &q) { return QString("Quaternion(%1, %2, %3, %4)").arg(q.x, 0, 'g', Dec).arg(q.y, 0, 'g', Dec).arg(q.z, 0, 'g', Dec).arg(q.z, 0, 'g', Dec); }
static QString vector3ToString(const aiVector3D &v) { return QString("Vector3(%1, %2, %3)").arg(v.x, 0, 'g', Dec).arg(v.y, 0, 'g', Dec).arg(v.z, 0, 'g', Dec); }
static QString aabbToString(const aiAABB &a) { return QString("Aabb3.minMax(%1, %2)").arg(vector3ToString(a.mMin)).arg(vector3ToString(a.mMax)); }

static QString escaped(QString str) { return str.replace("\\", "\\\\").replace("$", "\\$"); }

static QString equalsTo(const QString &value) { return QString("equals(%1)").arg(value); }
static QString equalsToInt(int value) { return value ? equalsTo(QString::number(value)) : "isZero"; }
static QString equalsToFloat(float value) { return qFuzzyIsNull(value) ? "isZero" : QString("moreOrLessEquals(%1)").arg(value, 0, 'g', Dec); }
static QString equalsToDouble(double value) { return qFuzzyIsNull(value) ? "isZero" : QString("moreOrLessEquals(%1)").arg(value, 0, 'g', Dec); }
static QString equalsToString(const char *str, uint len) { return len ? equalsTo(QString("'%1'").arg(escaped(QString::fromUtf8(str, len)))) : "isEmpty"; }
static QString equalsToString(const aiString &str) { return equalsToString(str.data, str.length); }
static QString equalsToAabb(const aiAABB &a) { return QString("aabb3MoreOrLessEquals(%1)").arg(aabbToString(a)); }
static QString equalsToColor3(const aiColor3D &c) { return QString("vector3MoreOrLessEquals(%1)").arg(color3ToString(c)); }
static QString equalsToColor4(const aiColor4D &c) { return QString("vector4MoreOrLessEquals(%1)").arg(color4ToString(c)); }
static QString equalsToQuaternion(const aiQuaternion &q) { return QString("quaternionMoreOrLessEquals(%1)").arg(quaternionToString(q)); }
static QString equalsToVector3(const aiVector3D &v) { return QString("vector3MoreOrLessEquals(%1)").arg(vector3ToString(v)); }
static QString equalsToMatrix4(const aiMatrix4x4 &m) { return QString("matrix4MoreOrLessEquals(%1)").arg(matrix4ToString(m)); }
static QString equalsToByteArray(const char *arr, uint len) { QStringList v; for (uint i = 0; i < len; ++i) v += QString::number(arr[i]); return equalsTo("[%1]").arg(v.join(", ")); }
static QString equalsToIntArray(const int *arr, uint len) { QStringList v; for (uint i = 0; i < len; ++i) v += QString::number(arr[i]); return equalsTo("[%1]").arg(v.join(", ")); }
static QString equalsToUintArray(const uint *arr, uint len) { return equalsToIntArray(reinterpret_cast<const int*>(arr), len); }
static QString equalsToDoubleArray(const double *arr, uint len) { QStringList v; for (uint i = 0; i < len; ++i) v += QString::number(arr[i]); return equalsTo("[%1]").arg(v.join(", ")); }
static QString equalsToStringArray(const QStringList &arr) { if (arr.isEmpty()) return equalsTo("[]"); QStringList v; for (int i = 0; i < arr.length(); ++i) v += escaped(arr[i]); return equalsTo("['%1']").arg(v.join("', '")); }

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
        << import("package:assimp/assimp.dart") << "\n"
        << import("package:assimp/src/bindings.dart") << "\n"
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

static void writeSizeTest(QTextStream &out, const QString &nativeName, size_t size)
{
    writeGroup(out, "size", [&]() {
        out << QString("    expect(sizeOf<%1>(), equals(%2));\n").arg(nativeName).arg(size);
    });
}

static void writeEqualityTest(QTextStream &out, const QString &nativeName, const QString &dartName)
{
    writeGroup(out, "equals", [&]() {
        out << QString("    final a = %1.fromNative(calloc<%2>());\n").arg(dartName).arg(nativeName)
            << QString("    final b = %1.fromNative(calloc<%2>());\n").arg(dartName).arg(nativeName)
            << QString("    expect(a, equals(a));\n")
            << QString("    expect(b, equals(b));\n")
            << QString("    expect(a, isNot(equals(b)));\n")
            << QString("    expect(b, isNot(equals(a)));\n");
    });
}

static void writeToStringTest(QTextStream &out, const QString &nativeName, const QString &dartName)
{
    writeGroup(out, "toString", [&]() {
        out << QString("    expect(%1.fromNative(calloc<%2>()).toString(), matches(r'%1\\(Pointer<%2>: address=0x[0-f]+\\)'));\n").arg(dartName).arg(nativeName);
    });
}

static void writeAnimationTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
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
}

static void writeAnimMeshTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final meshes = scene.meshes;\n";
    for (uint i = 0; i < scene->mNumMeshes; ++i) {
        const aiMesh *meshhh = scene->mMeshes[i];
        out << "      final "  << indexed("mesh", i) << " = meshes.elementAt(" << i << ");\n"
            << "      expect(" << indexed("mesh", i) << ".animMeshes.length, " << equalsToInt(meshhh->mNumAnimMeshes) << ");\n";
        for (uint j = 0; j < meshhh->mNumAnimMeshes; ++j) {
            const aiAnimMesh *animMesh = meshhh->mAnimMeshes[j];
            out << "      final "  << indexed("animMesh", i, j) << " = "  << indexed("mesh", i) << ".animMeshes.elementAt(" << j << ");\n"
                << "      expect(" << indexed("animMesh", i, j) << ".name, " << equalsToString(animMesh->mName) << ");\n"
                << "      expect(" << indexed("animMesh", i, j) << ".weight, " << equalsToFloat(animMesh->mWeight) << ");\n";

            const uint numVertices = animMesh->mNumVertices;
            out << "      expect(" << indexed("animMesh", i, j) << ".vertices.length, " << equalsToInt(animMesh->mNumVertices) << ");\n";
            for (uint k = 0; k < numVertices; ++k) {
                out << "      final "  << indexed("vertex", i, j, k) << " = "  << indexed("animMesh", i, j) << ".vertices.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("vertex", i, j, k) << ", " << equalsToVector3(animMesh->mVertices[k]) << ");\n";
            }

            const uint numNormals = animMesh->mNormals ? animMesh->mNumVertices : 0;
            out << "      expect(" << indexed("animMesh", i, j) << ".normals.length, " << equalsToInt(numNormals) << ");\n";
            for (uint k = 0; k <  numNormals; ++k) {
                out << "      final "  << indexed("normal", i, j, k) << " = "  << indexed("animMesh", i, j) << ".normals.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("normal", i, j, k) << ", " << equalsToVector3(animMesh->mNormals[k]) << ");\n";
            }

            const uint numTangents = animMesh->mTangents ? animMesh->mNumVertices : 0;
            out << "      expect(" << indexed("animMesh", i, j) << ".tangents.length, " << equalsToInt(numTangents) << ");\n";
            for (uint k = 0; k < numTangents; ++k) {
                out << "      final "  << indexed("tangent", i, j, k) << " = "  << indexed("animMesh", i, j) << ".tangents.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("tangent", i, j, k) << ", " << equalsToVector3(animMesh->mTangents[k]) << ");\n";
            }

            const uint numBitangents = animMesh->mBitangents ? animMesh->mNumVertices : 0;
            out << "      expect(" << indexed("animMesh", i, j) << ".bitangents.length, " << equalsToInt(numBitangents) << ");\n";
            for (uint k = 0; k < numBitangents; ++k) {
                out << "      final "  << indexed("bitangent", i, j, k) << " = "  << indexed("animMesh", i, j) << ".bitangents.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("bitangent", i, j, k) << ", " << equalsToVector3(animMesh->mBitangents[k]) << ");\n";
            }

            const uint numColorChannels = arraySize(animMesh->mColors);
            out << "      expect(" << indexed("animMesh", i, j) << ".colors.length, " << equalsToInt(numColorChannels) << ");\n";
            for (uint k = 0; k < numColorChannels; ++k) {
                out << "      final "  << indexed("colors", i, j, k) << " = "  << indexed("animMesh", i, j) << ".colors.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("colors", i, j, k) << ".length, " << equalsToInt(numVertices) << ");\n";
                for (uint l = 0; l < numVertices; ++l) {
                    out << "      final "  << indexed("color", i, j, k, l) << " = "  << indexed("colors", i, j, k) << ".elementAt(" << l << ");\n"
                        << "      expect(" << indexed("color", i, j, k, l) << ", " << equalsToColor4(animMesh->mColors[k][l]) << ");\n";
                }
            }

            const uint numTextureCoords = arraySize(animMesh->mTextureCoords);
            out << "      expect(" << indexed("animMesh", i, j) << ".textureCoords.length, " << equalsToInt(numTextureCoords) << ");\n";
            for (uint k = 0; k < numTextureCoords; ++k) {
                out << "      final "  << indexed("textureCoords", i, j, k) << " = "  << indexed("animMesh", i, j) << ".textureCoords.elementAt(" << k << ");\n"
                    << "      expect(" << indexed("textureCoords", i, j, k) << ".length, " << equalsToInt(numVertices) << ");\n";
                for (uint l = 0; l < numVertices; ++l) {
                    out << "      final "  << indexed("textureCoord", i, j, k, l) << " = " << indexed("textureCoords", i, j, k) << ".elementAt(" << l << ");\n"
                        << "      expect(" << indexed("textureCoord", i, j, k, l) << ", " << equalsToVector3(animMesh->mTextureCoords[k][l]) << ");\n";
                }
            }
        }
    }
    out << "    });\n";
}

static void writeBoneTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
    out << "    testScene('" << fileName << "', (scene) {\n";
    for (uint i = 0; i < scene->mNumMeshes; ++i) {
        const aiMesh *mesh = scene->mMeshes[i];
        if (mesh->mNumBones > 0) {
            out << "      final "  << indexed("mesh", i) << " = scene.meshes.elementAt(" << i << ");\n";
            for (uint j = 0; j < mesh->mNumBones; ++j) {
                const aiBone *bone = mesh->mBones[j];
                out << "      final "  << indexed("bone", i, j) << " = "  << indexed("mesh", i) << ".bones.elementAt(" << j << ");\n"
                    << "      expect(" << indexed("bone", i, j) << ".name, " << equalsToString(bone->mName) << ");\n"
                    << "      expect(" << indexed("bone", i, j) << ".offset, " << equalsToMatrix4(bone->mOffsetMatrix) << ");\n";
                for (uint k = 0; k < bone->mNumWeights; ++k) {
                    out << "      final "  << indexed("weight", i, j, k) << " = "  << indexed("bone", i, j) << ".weights.elementAt(" << k << ");\n"
                        << "      expect(" << indexed("weight", i, j, k) << ".vertexId, " << equalsToInt(bone->mWeights[k].mVertexId) << ");\n"
                        << "      expect(" << indexed("weight", i, j, k) << ".weight, " << equalsToFloat(bone->mWeights[k].mWeight) << ");\n";
                }
            }
        }
    }
    out << "    });\n";
}

static void writeCameraTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
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
}

static void writeFaceTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
    out << "    testScene('" << fileName << "', (scene) {\n";
    for (uint i = 0; i < scene->mNumMeshes; ++i) {
        const aiMesh *mesh = scene->mMeshes[i];
        if (mesh->mNumFaces > 0) {
            out << "      final "  << indexed("mesh", i) << " = scene.meshes.elementAt(" << i << ");\n";
            for (uint j = 0; j < mesh->mNumFaces; ++j) {
                out << "      final "  << indexed("face", i, j) << " = "  << indexed("mesh", i) << ".faces.elementAt(" << j << ");\n"
                    << "      expect(" << indexed("face", i, j) << ".indices, " << equalsToUintArray(mesh->mFaces[j].mIndices, mesh->mFaces[j].mNumIndices) << ");\n";
            }
        }
    }
    out << "    });\n";
}

static void writeLightTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
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
            << "      expect(" << indexed("light", i) << ".size.x, " << equalsToFloat(light->mSize.x) << ");\n" // ### TODO: width
            << "      expect(" << indexed("light", i) << ".size.y, " << equalsToFloat(light->mSize.y) << ");\n" // ### TODO: height
            << (i < scene->mNumLights - 1 ? "\n" : "");
    }
    out << "    });\n";
}

static QStringList materialTextures(const aiMaterial *material, aiTextureType type)
{
    QStringList textures;
    uint count = aiGetMaterialTextureCount(material, type);
    for  (uint i = 0; i < count; ++i) {
        aiString path;
        aiGetMaterialTexture(material, type, i, &path);
        textures += QString::fromUtf8(path.data, path.length);
    }
    return textures;
}

static void writeMaterialTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
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

        out << "      expect(" << indexed("material", i) << ".textures(TextureType.diffuse), " << equalsToStringArray(materialTextures(material, aiTextureType_DIFFUSE)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.specular), " << equalsToStringArray(materialTextures(material, aiTextureType_SPECULAR)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.ambient), " << equalsToStringArray(materialTextures(material, aiTextureType_AMBIENT)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.emissive), " << equalsToStringArray(materialTextures(material, aiTextureType_EMISSIVE)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.height), " << equalsToStringArray(materialTextures(material, aiTextureType_HEIGHT)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.normals), " << equalsToStringArray(materialTextures(material, aiTextureType_NORMALS)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.shininess), " << equalsToStringArray(materialTextures(material, aiTextureType_SHININESS)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.opacity), " << equalsToStringArray(materialTextures(material, aiTextureType_OPACITY)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.displacement), " << equalsToStringArray(materialTextures(material, aiTextureType_DISPLACEMENT)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.lightmap), " << equalsToStringArray(materialTextures(material, aiTextureType_LIGHTMAP)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.reflection), " << equalsToStringArray(materialTextures(material, aiTextureType_REFLECTION)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.baseColor), " << equalsToStringArray(materialTextures(material, aiTextureType_BASE_COLOR)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.normalCamera), " << equalsToStringArray(materialTextures(material, aiTextureType_NORMAL_CAMERA)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.emissionColor), " << equalsToStringArray(materialTextures(material, aiTextureType_EMISSION_COLOR)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.metalness), " << equalsToStringArray(materialTextures(material, aiTextureType_METALNESS)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.diffuseRoughness), " << equalsToStringArray(materialTextures(material, aiTextureType_DIFFUSE_ROUGHNESS)) << ");\n"
            << "      expect(" << indexed("material", i) << ".textures(TextureType.ambientOcclusion), " << equalsToStringArray(materialTextures(material, aiTextureType_AMBIENT_OCCLUSION)) << ");\n";
        out << (i < scene->mNumMaterials - 1 ? "\n" : "");
    }
    out << "    });\n";
}


static void writeMemoryInfoTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
    aiMemoryInfo mem;
    aiGetMemoryRequirements(scene, &mem);
    out << "    testScene('" << fileName << "', (scene) {\n"
        << "      final mem = MemoryInfo.fromScene(scene);\n"
        << "      expect(mem, isNotNull);\n"
        << "      expect(mem.textures, " << equalsToInt(mem.textures) << ");\n"
        << "      expect(mem.materials, " << equalsToInt(mem.materials) << ");\n"
        << "      expect(mem.meshes, " << equalsToInt(mem.meshes) << ");\n"
        << "      expect(mem.nodes, " << equalsToInt(mem.nodes) << ");\n"
        << "      expect(mem.animations, " << equalsToInt(mem.animations) << ");\n"
        << "      expect(mem.cameras, " << equalsToInt(mem.cameras) << ");\n"
        << "      expect(mem.lights, " << equalsToInt(mem.lights) << ");\n"
        << "      expect(mem.total, " << equalsToInt(mem.total) << ");\n";
    out << "    });\n";
}

static void writeMeshTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
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
                out << "      final "  << indexed("color", i, j, k) << " = "  << indexed("colors", i, j) << ".elementAt(" << k << ");\n"
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
}

static void writeMetaDataTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
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
}

static void writeNodeTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
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
}

static void writeSceneTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
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
}

static void writeTextureTester(QTextStream &out, const aiScene *scene, const QString &fileName)
{
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
}

typedef std::function<void(QTextStream &out, const aiScene *scene, const QString &fileName)> TestWriter;

static void writeSceneTest(QTextStream &out, const QString &fileName, TestWriter writer)
{
    const aiScene *scene = aiImportFile(testModelPath(fileName).toLocal8Bit(), 0);
    writer(out, scene, fileName);
    aiReleaseImport(scene);
}

template <typename T>
static void generateTest(const QString &nativeName, const QString &dartName, const QString &fileName, TestWriter writer = nullptr)
{
    QFile file(testFilePath(fileName));
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate))
        qFatal("%s", qPrintable(file.errorString()));

    QTextStream out(&file);
    writeHeader(out, fileName);
    writeSizeTest(out, nativeName, sizeof(T));
    if (writer) {
        writeEqualityTest(out, nativeName, dartName);
        writeToStringTest(out, nativeName, dartName);
        writeGroup(out, "3mf", [&]() {
            writeSceneTest(out, "box.3mf", writer);
            writeSceneTest(out, "spider.3mf", writer);
        });
        writeGroup(out, "fbx", [&]() {
            writeSceneTest(out, "huesitos.fbx", writer);
        });
        writeGroup(out, "collada", [&]() {
            writeSceneTest(out, "anims.dae", writer);
            writeSceneTest(out, "lib.dae", writer);
        });
        writeGroup(out, "obj", [&]() {
            writeSceneTest(out, "spider.obj", writer);
        });
    }
    writeFooter(out, fileName);
}

int main(int argc, char *argv[])
{
    QDir::setCurrent(QString::fromLocal8Bit(argc > 1 ? argv[1] : OUT_PWD));

    generateTest<aiAABB>("aiAABB", "AssimpAabb3", "aabb_test.dart");
    generateTest<aiAnimation>("aiAnimation", "Animation", "animation_test.dart", writeAnimationTester);
    generateTest<aiAnimMesh>("aiAnimMesh", "AnimMesh", "anim_mesh_test.dart", writeAnimMeshTester);
    generateTest<aiBone>("aiBone", "Bone", "bone_test.dart", writeBoneTester);
    generateTest<aiCamera>("aiCamera", "Camera", "camera_test.dart", writeCameraTester);
    generateTest<aiColor3D>("aiColor3D", "AssimpColor3", "color3_test.dart");
    generateTest<aiColor4D>("aiColor4D", "AssimpColor4", "color4_test.dart");
    generateTest<aiExportDataBlob>("aiExportDataBlob", "", "export_data_test.dart"); // ### TODO: writeExportDataTester
    generateTest<aiExportFormatDesc>("aiExportFormatDesc", "", "export_format_test.dart"); // ### TODO: writeExportFormatTester
    generateTest<aiFace>("aiFace", "Face", "face_test.dart", writeFaceTester);
    generateTest<aiFile>("aiFile", "", "file_test.dart"); // ### TODO: writeFileTester
    generateTest<aiFileIO>("aiFileIO", "", "file_io_test.dart"); // ### TODO: writeFileIOTester
    generateTest<aiLight>("aiLight", "Light", "light_test.dart", writeLightTester);
    generateTest<aiImporterDesc>("aiImporterDesc", "ImportFormat", "import_format_test.dart"); // ### TODO: writeImportFormatTester
    generateTest<aiLogStream>("aiLogStream", "", "log_stream_test.dart"); // ### TODO: writeLogStreamTester
    generateTest<aiMaterial>("aiMaterial", "Material", "material_test.dart", writeMaterialTester);
    generateTest<aiMaterialProperty>("aiMaterialProperty", "MaterialProperty", "material_property_test.dart"); // ### TODO: writeMaterialPropertyTester
    generateTest<aiMatrix3x3>("aiMatrix3x3", "AssimpMatrix3", "matrix3_test.dart");
    generateTest<aiMatrix4x4>("aiMatrix4x4", "AssimpMatrix4", "matrix4_test.dart");
    generateTest<aiMemoryInfo>("aiMemoryInfo", "MemoryInfo", "memory_info_test.dart", writeMemoryInfoTester);
    generateTest<aiMesh>("aiMesh", "Mesh", "mesh_test.dart", writeMeshTester);
    generateTest<aiMeshKey>("aiMeshKey", "MeshKey", "mesh_key_test.dart");
    generateTest<aiMeshMorphAnim>("aiMeshMorphAnim", "MeshMorphAnim", "mesh_morph_anim_test.dart"); // ### TODO: writeMeshMorpAnimTester
    generateTest<aiMeshMorphKey>("aiMeshMorphKey", "MeshMorphKey", "mesh_morph_key_test.dart");
    generateTest<aiMetadata>("aiMetadata", "MetaData", "meta_data_test.dart", writeMetaDataTester);
    generateTest<aiMetadataEntry>("aiMetadataEntry", "", "meta_data_entry_test.dart");
    generateTest<aiNode>("aiNode", "Node", "node_test.dart", writeNodeTester);
    generateTest<aiNodeAnim>("aiNodeAnim", "NodeAnim", "node_anim_test.dart"); // ### TODO: writeNodeAnimTester
    generateTest<aiPropertyStore>("aiPropertyStore", "", "property_store_test.dart");
    generateTest<aiQuatKey>("aiQuatKey", "QuaternionKey", "quaternion_key_test.dart");
    generateTest<aiScene>("aiScene", "Scene", "scene_test.dart", writeSceneTester);
    generateTest<aiString>("aiString", "AssimpString", "string_test.dart");
    generateTest<aiTexel>("aiTexel", "Texel", "texel_test.dart"); // ### TODO: writeTexelTester
    generateTest<aiTexture>("aiTexture", "Texture", "texture_test.dart", writeTextureTester);
    generateTest<aiUVTransform>("aiUVTransform", "", "uv_transform_test.dart");
    generateTest<aiVector2D>("aiVector2D", "AssimpVector2", "vector2_test.dart");
    generateTest<aiVector3D>("aiVector3D", "AssimpVector3", "vector3_test.dart");
    generateTest<aiVertexWeight>("aiVertexWeight", "VertexWeight", "vertex_weight_test.dart");
}
