import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'bindings/types.dart' as bindings;

class Utils {
  static String fromUtf8(Pointer<bindings.aiString> str) {
    if (str.address == 0) {
      return null;
    }
    final len = str.ref.length;
    final data = Int8List.view(str.ref.data.asTypedList(len).buffer, 0, len);
    return utf8.decode(data);
  }
}
