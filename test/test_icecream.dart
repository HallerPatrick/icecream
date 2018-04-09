import 'package:icecream/content_parser.dart';
import 'package:test/test.dart';

void main() {
  group("Check variable and datastructure extractor", () {
    var parser = new ContentParser();
    test("Check for simple, single decleration", () {
      var line = "ic(x);";
      expect(parser.getVariables(line), ["x"]);
    });
  });
}