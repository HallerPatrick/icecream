import 'package:icecream/icecream.dart' show ic;
import 'package:icecream/src/content_parser.dart';

class Hello {}

void hello() {}

foo(int x, int y) {
  ic();
  return x + y;
}

void main() {
  var x = ["3", 3];

  Hello dummy = new Hello();

  var y = "foo(1, 2)";

  var parser = new ContentParser(y);


  // print(parser.parse());
  

  ic(
    3,
    foo(2, 3)
  );
}
