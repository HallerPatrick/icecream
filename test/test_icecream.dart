import 'package:icecream/main.dart';
import 'package:test/test.dart';

void main() {
  group("Check variable and datastructure extractor", () {
    test("Check for simple, single decleration", () {
      var line = "ic(x)";
      expect(extractVariable(line, 0), "x");
    });
  });
}