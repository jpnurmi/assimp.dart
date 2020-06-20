const int size = 1024;
const String prefix = '_s';

String generate(String annotation, String type, int offset, int count) {
  String varname(i) => '$prefix${offset + i}';
  final vars = List.generate(count, (i) => varname(i));
  return '$annotation $type ${vars.join(',')}';
}

void main() {
  print('@Uint32() int ${prefix}len;');
  var lines = <String>[];
  for (var i = 0; i < size; i += 8) {
    lines.add(generate('@Uint8()', 'int', i, 8));
  }
  print('${lines.join(';\n')};');
}
