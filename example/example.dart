import '../lib/main.dart';
import 'package:inspect/inspect.dart';

class Hello {}
void hello() {}

void main()  {
  // ic(2);

  var x = 3;
  Hello dummy = new Hello();
  ic(x, dummy, [2, "now"]);
}