import 'dart:async';
import 'package:icecream/src/ic_debugger.dart';
import 'package:icecream/icecream.dart' show ic;
import 'package:test/test.dart';

/// ic_debugger.dart unit and integration tests
Future main() async {

  group("Utils: ", () {
    test("Check if ic call is a one liner", () {
      var line = "ic(foo());";
      expect(true, isOneLiner(line));
    });
    test("Complex input one liner", () {
      var line = "ic(3,foo(2, 3));";
      expect(true, isOneLiner(line));
    });
    test("Not a one liner", () {
      var line = "ic(";
      expect(isOneLiner(line), false);
    });
  });

  group("Test for actual ouput of ic", () {
    var prefix = "🍦 ";
    test("Ouput if no arguments are passed to ic", () async {
      var output = await ic();
      expect(output, "$prefix test_ic_debugger.dart:27 in main()");
    });

    test("Output if simple arguments are passed to ic", () async {
      var output = await ic(2, "Pepe");
      expect(output, '$prefix 2: 2, "Pepe": Pepe');
    });
  });
}