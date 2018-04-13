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

  RegExp regExp = new RegExp("ic\(.*\)");

  var matches = regExp.allMatches(line);
  if(regExp.hasMatch(line)) {
    print(regExp.firstMatch(line).group(1));
  }
}
