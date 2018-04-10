import 'dart:mirrors';

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
  // var parser = new ContentParser();
  // parser.getVariables(line);

  var listString = "[2, 3, [x]], rofl";
  print(getListToken(listString));
}


String getListToken(String input) {
  String token = "";
  int openBrackets = 1;
  print("Param: $input");
  while(openBrackets > 0) {
    print("Input: $input");
    print("Token: $token");
    if(input.substring(1, input.length)[0] == "[") {
      openBrackets++;
    }
    if(input.substring(1, input.length)[0] == "]") {
      openBrackets--;
    }
    token += input.substring(1, input.length)[0];
    input = input.substring(1, input.length);
  }
  return token;
}