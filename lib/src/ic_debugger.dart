import 'dart:async';
import 'dart:io';
import 'package:icecream/src/content_parser.dart';
import 'package:inspect/inspect.dart' show DartStack;

const String DEFAULT_PREFIX_UTF = "🍦 ";
const String DEFAULT_PREFIX = 'ic| ';
const String DEFAULT_INDENT = '  ';

String regex = "ic\(.*\)";
RegExp regExp = new RegExp(regex);

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

bool isOneLiner(String line) {
  if (line.contains("ic(") && line.contains(");")) {
    return true;
  } else {
    return false;
  }
}

String icWithoutArguments() {
  // 4th called frame is ic-Call
  var stack = new DartStack().getFrame(5);

  // Line number of 4th frame
  var lineNumber = stack.lineNumber;

  // Take script name of complete directory
  var filename = stack.source.split("/").last;

  return "$filename:$lineNumber in ${stack.methodName.trim()}()";
}

Future<String> icWithArguments(arguments) async {
  String output = "";

  var stack = new DartStack();

  stack = stack.getFrame(6);

  var lineNumber = stack.lineNumber;

  var filename = stack.source.replaceFirst('file://', '');

  // Formatting of variables
  for (var i = 0; i < arguments.length; i++) {
    final String name = await getVariableName(filename, lineNumber, i);
    var arg = arguments[i];
    output += name + ": " + arg.toString();
    if (i < arguments.length - 1 && arguments.length > 1) output += ", ";
  }
  return output;
}

Future<String> getVariableName(
    String filename, int line, int argumentIndex) async {
  // For now:
  // variables and concrete datastructures possible
  // e.g.:
  // ic(x, y); , ic(2, 4);, ic(x, [2, 4], "hello")

  var stack = new DartStack();

  // 8th stack is the ic call
  var lineNumber = stack.getFrame(8).lineNumber;

  // Extract line from file
  List<String> lines = await new File(filename).readAsLines();
  var line = lines[lineNumber - 1];

  // Check if ic-call is longer than line and add missing part if needed
  if (!isOneLiner(line)) {
    var currentLineNumber = lineNumber - 1;
    while (!lines[currentLineNumber].contains(");")) {
      line += lines[currentLineNumber].trim();
      currentLineNumber++;
    }
  } else {
    line = lines[lineNumber - 1];
  }

  // Extract only the arguments from ic-call
  if (regExp.hasMatch(line)) {
    line = regExp.firstMatch(line).group(1);
  }

  line = line.replaceFirst('(', '').replaceFirst(');', '');

  // Check if class init is used, and remove the "new" part for the content parser
  List<String> args = [];
  line
      .split(",")
      .forEach((arg) => args.add(arg.replaceFirst("new ", "")));

  var variable = extractVariable(args.join(","), argumentIndex);
  return variable;
}

String extractVariable(String line, int index) =>
    new ContentParser(line).parse()[index];

//class IcCreamDebugger {
//  static const prefix = DEFAULT_PREFIX_UTF;
//
//  final call = new VarargsFunction((arguments) async {
//    String output;
//    // If no arguments are given, output filename and called line
//    if (arguments.length == 0) {
//      output = icWithoutArguments();
//    } else {
//      output = await icWithArguments(arguments);
//    }
//
//    print("$prefix $output ");
//  });
//}

VarargsFunction ic_debugger = new VarargsFunction((arguments) async {
  String output;

  String _prefix = DEFAULT_PREFIX_UTF;

  // If no arguments are given, output filename and called line
  if (arguments.length == 0) {
    output = icWithoutArguments();
  } else {
    output = await icWithArguments(arguments);
  }

  print("$_prefix $output");

  // For testing purpose
  return "$_prefix $output";
});
