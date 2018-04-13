import 'dart:async';
import 'dart:io';

import 'package:icecream/icecream.dart' show ic;
import 'package:icecream/src/content_parser.dart';
import 'package:icecream/src/ic_debugger.dart';

class Hello {}

void hello() {}

foo(x) {
  return x;
}

Future main() async {
  var x = ["3", 3];

  Hello dummy = new Hello();

  var line = "var output = await ic(2, foo());";

  var parser = new ContentParser(line);

  // var output = parser.parse();

  var output = await ic(new Hello(), 3);
  print(output);
}
