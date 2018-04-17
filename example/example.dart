import 'dart:async';
import 'package:icecream/icecream.dart' show ic;

num bar(num x, num y) {
  return x + y;
}

Future main() async {
  await ic();
  await ic.disable();
  await ic();
  await ic.enable();
  await ic();

  await simpleExample();
  await diaableIc();
  await changePrefix();
}

Future changePrefix() async {
  await ic.setPrefix("ic |");
  await ic(3);
}

Future simpleExample() async {
  await ic(3);
  await ic(bar(1, 2));
}

Future diaableIc() async {
  await ic();
  await ic.disable();
  await ic();
  await ic.enable();
  await ic();
}

