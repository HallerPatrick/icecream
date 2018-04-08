import 'dart:io';
import 'dart:mirrors';

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

String getVariableName(String filename, int line, int argumentIndex) async {
  var stack = new DartStack();
  var lineNumber = stack.getFrame(6).lineNumber;
  
  List<String> lines = await new File(filename).readAsLines();
  print(lines[lineNumber-1]);
  return "";
}

class IcCreamDebugger {

  static const prefix = DEFAULT_PREFIX;

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