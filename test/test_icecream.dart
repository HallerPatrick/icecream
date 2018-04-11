import 'package:icecream/src/content_parser.dart';
import 'package:test/test.dart';

void main() {
  group("Check variable and datastructure extractor", () {
    test("Check for simple, single decleration", () {
      var line = "x";
      var parser = new ContentParser(line);
      List<String> tokens = parser.parse();
      expect(tokens, equals(["x"]));
    });
    test("Check for multipy variable declerations", () {
      var line = "x, y, z";
      var parser = new ContentParser(line);
      List<String> tokens = parser.parse();
      expect(tokens, equals(["x", "y", "z"]));
    });
  });

  group("Testing core datatypes passed", () {
    test("Check for string datatype singlequoted", () {
      var line = "'some string', 'second string'";
      var parser = new ContentParser(line);
      List<String> tokens = parser.parse();
      expect(tokens, equals(["'some string'", "'second string'"]));
    });
    test("Check for string datatype doublequoted", () {
      var line = '"some string", "second string"';
      var parser = new ContentParser(line);
      List<String> tokens = parser.parse();
      expect(tokens, equals(['"some string"', '"second string"']));
    });
    test("Check for integer", () {
      var line = "1, 2, 3";
      var parser = new ContentParser(line);
      List<String> tokens = parser.parse();
      expect(tokens, equals(["1", "2", "3"]));
    });
  });
}
