CONFIG += link_pkgconfig
PKGCONFIG += assimp
SOURCES += testgen.cpp
DEFINES += OUT_PWD=\\\"$$clean_path($$PWD/../test)\\\"
