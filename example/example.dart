import 'dart:mirrors';

import 'package:icecream/icecream.dart';
import 'package:icecream/src/content_parser.dart';
import 'package:inspect/inspect.dart';



class Hello {}
void hello() {}

void main()  {
  var x = 3;
  Hello dummy = new Hello();
  

  var listString = "[2, 3, [x]], 'rofl'";
  var line = "x, y, 'Hello', 'hey'";
  var line1 = ",y";

  var y = '["hello", 1]';
  var parser = new ContentParser(line);
  List<String> tokens = parser.parse();
  print(tokens);
}
