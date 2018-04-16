import 'package:icecream/icecream.dart' show ic;

num bar(num x, num y) {
  return x + y;
}

main() async {
  await ic();
  await ic.disable();
  await ic();
  await ic.enable();
  await ic();

  await simpleExample();
  await diaableIc();
  await changePrefix();
}

changePrefix() async {
  await ic.setPrefix("ic |");
  await ic(3);
}

simpleExample() async {
  await ic(3);
  await ic(bar(1, 2));
}

diaableIc() async {
  await ic();
  await ic.disable();
  await ic();
  await ic.enable();
  await ic();
}

