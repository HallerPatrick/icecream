import 'dart:async';
import 'dart:io';
import 'dart:mirrors';
import 'package:icecream/src/content_parser.dart';
import 'package:inspect/inspect.dart' show DartStack;

const String DEFAULT_PREFIX_UTF = "🍦 ";
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

bool _isOneLiner(String line) {
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

  return "$filename:$lineNumber in ${stack.methodName}()";
}

Future<String> icWithArguments(arguments) async {
  String output = "";

  var stack = new DartStack();

  stack = stack.getFrame(6);

  var lineNumber = stack.lineNumber;

  var filename = stack.source.split("/").last;

  for (var i = 0; i < arguments.length; i++) {
    final String name = await getVariableName(filename, lineNumber, i);
    var arg = arguments[i];
    final type = reflect(arg).type.typeVariables;
    final name1 = reflect(arg).type.qualifiedName.toString();
    print("arg: $arg");

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

  var lineNumber = stack.getFrame(8).lineNumber;
  // for(int i=0; i<stack.frameCount; i++) print(" $i -> ${stack.getFrame(i).source}");

  List<String> lines = await new File(filename).readAsLines();

  var line =
      lines[lineNumber - 1].replaceFirst('ic(', '').replaceFirst(');', '');

  if (!_isOneLiner(line)) {
    var currentLineNumber = lineNumber;
    while (!lines[currentLineNumber].contains(");")) {
      line += lines[currentLineNumber].trim();
      currentLineNumber++;
    }
  }

  var variable = extractVariable(line, argumentIndex);
  return variable;
}

String extractVariable(String line, int index) =>
    new ContentParser(line).parse()[index];

class IcCreamDebugger {
  static const prefix = DEFAULT_PREFIX_UTF;

  final call = new VarargsFunction((arguments) async {
    String output;
    // If no arguments are given, output filename and called line
    if (arguments.length == 0) {
      output = icWithoutArguments();
    } else {
      output = await icWithArguments(arguments);
    }

    outputFunction("$prefix $output ");
  });
}

VarargsFunction ic_debugger = new VarargsFunction((arguments) async {
  String _prefix = DEFAULT_PREFIX_UTF;

  String output;

  // If no arguments are given, output filename and called line
  if (arguments.length == 0) {
    output = icWithoutArguments();
  } else {
    output = await icWithArguments(arguments);
  }

  outputFunction("$_prefix $output ");
});
