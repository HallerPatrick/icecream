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
  var stack = new DartStack();
  var line =  stack.getFrame(4).lineNumber;  
  var filename_dir = stack.getFrame(4).source;
  var filename = filename_dir.split("/").last;
  return "$filename:$line";
}

String icWithArguments(arguments) {
  String output = "";
  for (final arg in arguments) {
    final type = reflect(arg).type.reflectedType.toString();
    final name = reflect(arg).type.qualifiedName.toString();
    output += type + ": " + arg.toString() + ", ";
  }
  return output;
}

class IcCreamDebugger {

  static const prefix = DEFAULT_PREFIX;

  final call = new VarargsFunction((arguments) {
    var output;
    if (arguments.length == 0) {
      output = icWithoutArguments();
    } else {
      output = icWithArguments(arguments);
    }
    
    outputFunction("$prefix $output ");
  });

}

final IcCreamDebugger ic = new IcCreamDebugger();