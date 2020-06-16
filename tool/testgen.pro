CONFIG += link_pkgconfig
PKGCONFIG += assimp
SOURCES += testgen.cpp
DEFINES += MODELDB=\\\"$$clean_path($$PWD/../test/models/model-db)\\\"
