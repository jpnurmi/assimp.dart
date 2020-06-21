/*
---------------------------------------------------------------------------
Open Asset Import Library (assimp)
---------------------------------------------------------------------------

Copyright (c) 2006-2020, assimp team

All rights reserved.

Redistribution and use of this software in source and binary forms,
with or without modification, are permitted provided that the following
conditions are met:

* Redistributions of source code must retain the above
copyright notice, this list of conditions and the
following disclaimer.

* Redistributions in binary form must reproduce the above
copyright notice, this list of conditions and the
following disclaimer in the documentation and/or other
materials provided with the distribution.

* Neither the name of the assimp team, nor the names of its
contributors may be used to endorse or promote products
derived from this software without specific prior
written permission of the assimp team.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------
*/

import 'package:test/test.dart';
import 'package:assimp/assimp.dart';

void main() {
  test('version', () {
    expect(Assimp.versionMajor, equals(5));
    expect(Assimp.versionMinor, equals(0));
    expect(Assimp.versionRevision, equals(0));
  });

  test('legalString', () {
    expect(Assimp.legalString, isNotEmpty);
    expect(Assimp.legalString, contains('BSD'));
    expect(Assimp.legalString, contains('assimp team'));
  });

  test('errorString', () {
    final scene1 = Scene.fromFile('foobar');
    expect(Assimp.errorString, equals('Unable to open file "foobar".'));
    expect(scene1, isNull);

    Scene scene2 = Scene.fromString('foobar');
    expect(Assimp.errorString, startsWith('No suitable reader found for'));
    expect(scene2, isNull);
  });

  test('build', () {
    expect(Assimp.branchName, isEmpty);
    expect(Assimp.compileFlags, isNonZero);
  });

  test('importFormats', () {
    final formats = Assimp.importFormats;
    expect(formats, isNotEmpty);
    for (final format in Assimp.importFormats) {
      expect(format.name, isNotEmpty);
      expect(format.author, isNotNull);
      expect(format.maintainer, isNotNull);
      expect(format.comments, isNotNull);
      expect(format.flags, isNotNull);
      expect(format.extensions, isNotEmpty);
      expect(format.extensions, allOf(isNotEmpty));
    }
  });
}
