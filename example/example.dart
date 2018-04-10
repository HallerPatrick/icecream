import 'dart:mirrors';

import 'package:inspect/inspect.dart';


import '../lib/content_parser.dart';
import '../lib/main.dart';


class Hello {}
void hello() {}

void main()  {
  var x = 3;
  Hello dummy = new Hello();
  

  var listString = "[2, 3, [x]], rofl";
  var line = "x, y, 3, 'hey'";
  var parser = new ContentParser(line);
  List<String> tokens = parser.parse();
  print(tokens);
}
