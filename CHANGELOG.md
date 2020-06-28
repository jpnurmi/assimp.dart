## [0.0.3] - 2020-06-28

* Added Face.indexData
* Added Mesh.vertexData, Mesh.normalData, Mesh.tangentData, Mesh.bitangentData
* Allowed specifying ASSIMP_LIBRARY_PATH and/or ASSIMP_LIBRARY_PATH environment
  variables
* Added a preliminary example

## [0.0.2] - 2020-06-23

* Added ImportFormat & Assimp.importFormats
* Added ExportFormat & Assimp.exportFormats
* Added Assimp.extensions & Assimp.isSupported(extension)
* Added Scene.copy()
* Added Material.textures & TextureType
* Added Scene.exportFile()
* Added ExportData & Scene.exportData()
* Renamed PostProcess to ProcessFlags
* Removed unused Ray & Plane (use vector_math)

## [0.0.1] - 2020-06-21

* Initial alpha release that supports read-only imports with Assimp 5.x
  on 64-bit desktop platforms.
