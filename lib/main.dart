import 'dart:io';
import 'dart:mirrors';

import 'package:icecream/content_parser.dart';
import 'package:inspect/inspect.dart';

const String DEFAULT_PREFIX = 'ic| ';
const String DEFAULT_INDENT = '  ';


typedef dynamic OnCall(List);

class VarargsFunction extends Function {
  OnCall _onCall;

  VarargsFunction(this._onCall);

  call() => _onCall([]);

  noSuchMethod(Invocation invocation) {
    final arguments = invocation.positionalArguments;
    return _onCall(arguments);
  }
}

void outputFunction(String output) {
  // stdout.write(output);
  print(output);
}

String icWithoutArguments() {
  // 4th called frame is ic-Call
  var stack = new DartStack().getFrame(4);

  // Line number of 4th frame 
  var lineNumber =  stack.lineNumber;  

  // Take script name of complete directory
  var filename = stack.source.split("/").last;

  return "$filename:$lineNumber";
}

String icWithArguments(arguments) {
  String output = "";

  var stack = new DartStack().getFrame(4);
  
  var lineNumber = stack.lineNumber;

  var filename = stack.source.split("/").last;

  for (var i=0; i < arguments.length; i++) {
    getVariableName(filename, lineNumber, i);
    var arg = arguments[i];
    final type = reflect(arg).type.reflectedType.toString();
    final name = reflect(arg).type.qualifiedName.toString();
    output += type + ": " + arg.toString() + ", ";
  }
  return output;
}

Future<String> getVariableName(String filename, int line, int argumentIndex) async {
  // For now:
  // variables and concrete datastructures possible
  // e.g.:
  // ic(x, y); , ic(2, 4);, ic(x, [2, 4], "hello")


  var stack = new DartStack();
  var lineNumber = stack.getFrame(6).lineNumber;
  
  List<String> lines = await new File(filename).readAsLines();
  var variable = extractVariable(lines[lineNumber-1], argumentIndex);
  return "";
}

String extractVariable1(String line, int index) {
  String regex = "ic(.*)";
  RegExp regexp = new RegExp(regex);
  Iterable<Match> matches = regexp.allMatches(line);
  for(final match in matches) {
    //print(match.group(2));
  }
  print(line.replaceFirst('ic(', '').replaceFirst(');', '').split(", ").length);
  return "";
}

String extractVariable(String line, int index) {
  // Check if expression is one-liner
  if(line.contains("ic(") && line.contains(");")) {
    print("true");
  }
  line.replaceFirst("ic(", "");

  return "";
}


class IcCreamDebugger {

  static const prefix = DEFAULT_PREFIX;

  ContentParser parser = new ContentParser();

  final call = new VarargsFunction((arguments) {
    var output;
    // If no arguments are given, output filename and called line
    if (arguments.length == 0) {
      output = icWithoutArguments();
    } else {
      output = icWithArguments(arguments);
    }

    outputFunction("$prefix $output ");
  });

}

final IcCreamDebugger ic = new IcCreamDebugger();