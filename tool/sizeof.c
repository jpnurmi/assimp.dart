#include <assimp/aabb.h>
#include <assimp/anim.h>
#include <assimp/camera.h>
#include <assimp/cexport.h>
#include <assimp/cfileio.h>
#include <assimp/cimport.h>
#include <assimp/color4.h>
#include <assimp/defs.h>
#include <assimp/light.h>
#include <assimp/material.h>
#include <assimp/matrix3x3.h>
#include <assimp/matrix4x4.h>
#include <assimp/mesh.h>
#include <assimp/metadata.h>
#include <assimp/postprocess.h>
#include <assimp/quaternion.h>
#include <assimp/scene.h>
#include <assimp/texture.h>
#include <assimp/types.h>
#include <assimp/vector2.h>
#include <assimp/vector3.h>

#include <stdio.h>

// padding: pahole libassimp.so -C aiXxx

static void print_primitive_types()
{
    printf("primitive:\n");
    printf("\tsizeof(int) = %zu\n", sizeof(int));
    printf("\tsizeof(long) = %zu\n", sizeof(long));
    printf("\tsizeof(short) = %zu\n", sizeof(short));
    printf("\tsizeof(char) = %zu\n", sizeof(char));
    printf("\tsizeof(float) = %zu\n", sizeof(float));
    printf("\tsizeof(double) = %zu\n", sizeof(double));
    printf("\tsizeof(void*) = %zu\n", sizeof(void*));
    printf("\n");
}

static void print_assimp_types()
{
    printf("assimp:\n");
    printf("\tsizeof(aiAABB) = %zu\n", sizeof(struct aiAABB));
    printf("\tsizeof(aiAnimation) = %zu\n", sizeof(struct aiAnimation));
    printf("\tsizeof(aiAnimMesh) = %zu\n", sizeof(struct aiAnimMesh));
    printf("\tsizeof(aiBone) = %zu\n", sizeof(struct aiBone));
    printf("\tsizeof(aiCamera) = %zu\n", sizeof(struct aiCamera));
    printf("\tsizeof(aiColor3D) = %zu\n", sizeof(struct aiColor3D));
    printf("\tsizeof(aiExportDataBlob) = %zu\n", sizeof(struct aiExportDataBlob));
    printf("\tsizeof(aiExportFormatDesc) = %zu\n", sizeof(struct aiExportFormatDesc));
    printf("\tsizeof(aiFace) = %zu\n", sizeof(struct aiFace));
    printf("\tsizeof(aiFile) = %zu\n", sizeof(struct aiFile));
    printf("\tsizeof(aiFileIO) = %zu\n", sizeof(struct aiFileIO));
    printf("\tsizeof(aiImporterDesc) = %zu\n", sizeof(struct aiImporterDesc));
    printf("\tsizeof(aiLight) = %zu\n", sizeof(struct aiLight));
    printf("\tsizeof(aiLogStream) = %zu\n", sizeof(struct aiLogStream));
    printf("\tsizeof(aiMaterial) = %zu\n", sizeof(struct aiMaterial));
    printf("\tsizeof(aiMaterialProperty) = %zu\n", sizeof(struct aiMaterialProperty));
    printf("\tsizeof(aiMatrix3x3) = %zu\n", sizeof(struct aiMatrix3x3));
    printf("\tsizeof(aiMatrix4x4) = %zu\n", sizeof(struct aiMatrix4x4));
    printf("\tsizeof(aiMemoryInfo) = %zu\n", sizeof(struct aiMemoryInfo));
    printf("\tsizeof(aiMesh) = %zu\n", sizeof(struct aiMesh));
    printf("\tsizeof(aiMeshKey) = %zu\n", sizeof(struct aiMeshKey));
    printf("\tsizeof(aiMeshMorphAnim) = %zu\n", sizeof(struct aiMeshMorphAnim));
    printf("\tsizeof(aiMeshMorphKey) = %zu\n", sizeof(struct aiMeshMorphKey));
    printf("\tsizeof(aiMetadata) = %zu\n", sizeof(struct aiMetadata));
    printf("\tsizeof(aiMetadataEntry) = %zu\n", sizeof(struct aiMetadataEntry));
    printf("\tsizeof(aiNode) = %zu\n", sizeof(struct aiNode));
    printf("\tsizeof(aiNodeAnim) = %zu\n", sizeof(struct aiNodeAnim));
    printf("\tsizeof(aiPlane) = %zu\n", sizeof(struct aiPlane));
    printf("\tsizeof(aiPropertyStore) = %zu\n", sizeof(struct aiPropertyStore));
    printf("\tsizeof(aiQuatKey) = %zu\n", sizeof(struct aiQuatKey));
    printf("\tsizeof(aiRay) = %zu\n", sizeof(struct aiRay));
    printf("\tsizeof(aiScene) = %zu\n", sizeof(struct aiScene));
    printf("\tsizeof(aiString) = %zu\n", sizeof(struct aiString));
    printf("\tsizeof(aiTexel) = %zu\n", sizeof(struct aiTexel));
    printf("\tsizeof(aiTexture) = %zu\n", sizeof(struct aiTexture));
    printf("\tsizeof(aiUVTransform) = %zu\n", sizeof(struct aiUVTransform));
    printf("\tsizeof(aiVector2D) = %zu\n", sizeof(struct aiVector2D));
    printf("\tsizeof(aiVector3D) = %zu\n", sizeof(struct aiVector3D));
    printf("\tsizeof(aiVertexWeight) = %zu\n", sizeof(struct aiVertexWeight));
    printf("\n");
}

int main()
{
    print_primitive_types();
    print_assimp_types();
}
