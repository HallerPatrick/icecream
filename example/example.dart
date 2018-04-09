
import 'package:inspect/inspect.dart';

import '../lib/content_parser.dart';
import '../lib/main.dart';


class Hello {}
void hello() {}

void main()  {
  // ic(2);

  var x = 3;
  Hello dummy = new Hello();
  // ic(x, dummy, [2, "now"]);

  var line = "ic(x);";
  var parser = new ContentParser();
  parser.getVariables(line);
}