import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import '../lib/assimp.dart';
import '../lib/src/bindings.dart';
import 'test_utils.dart';

// DO NOT EDIT (generated by tool/testgen)

void main() {
  prepareTest();

  test('null', () {
    expect(Texture.fromNative(null), isNull);
  });

  test('size', () {
    expect(sizeOf<aiTexture>(), equals(1064));
  });

  test('size', () {
    Texture a = Texture.fromNative(allocate<aiTexture>());
    Texture b = Texture.fromNative(allocate<aiTexture>());
    Texture aa = Texture.fromNative(a.ptr);
    Texture bb = Texture.fromNative(b.ptr);
    expect(a, equals(a));
    expect(a, equals(aa));
    expect(b, equals(b));
    expect(b, equals(bb));
    expect(a, isNot(equals(b)));
    expect(a, isNot(equals(bb)));
    expect(b, isNot(equals(a)));
    expect(b, isNot(equals(aa)));
  });

  test('toString', () {
    expect(Texture.fromNative(allocate<aiTexture>()).toString(), matches(r'Texture\(Pointer<aiTexture>: address=0x[0-f]+\)'));
  });

  test('3mf', () {
    testTextures('3mf/box.3mf', (textures) {
      expect(textures.length, isZero);
    });
    testTextures('3mf/spider.3mf', (textures) {
      expect(textures.length, isZero);
    });
  });

  test('fbx', () {
    testTextures('fbx/huesitos.fbx', (textures) {
      expect(textures.length, isZero);
    });
  });

  test('obj', () {
    testTextures('Obj/Spider/spider.obj', (textures) {
      expect(textures.length, isZero);
    });
  });

}
