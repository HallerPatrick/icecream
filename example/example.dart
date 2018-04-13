import 'package:icecream/icecream.dart' show ic;

num bar(num x, num y) {
  return x + y;
}

main() async {

  ic();

  ic(bar(1, 2));
}
