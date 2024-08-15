import 'dart:io';

String readJson(String name) {
  return File('test/helpers/fixtures/$name').readAsStringSync();
}
