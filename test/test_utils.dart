import 'package:test/test.dart';

String testFilePath(String fileName) => 'test/models/model-db/' + fileName;

const Matcher isNullPointer = _IsNullPointer();

class _IsNullPointer extends Matcher {
  const _IsNullPointer();
  @override
  bool matches(ptr, Map matchState) => ptr.isNull;
  @override
  Description describe(Description description) => description.add('nullptr');
}
