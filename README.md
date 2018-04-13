# <center>IceCreamDart</center>
<h1 align="center">
  <img src="icon.png" width="600px" alt="icecream">
</h1>

### iceream for Dart is a flavor of a good tasting debugger

It is a library inspired by the python [icecream](https://github.com/gruns/icecream) library

The purpose is to to make debugging over the console easy again.

Instead of `print()` or `window.console.log()`, `ic` helps to make developing much sweeter.


### icecream without Arguments

Ic comes in handy to determine which part of code is being executed and where. So if no arguments are passed to ic, it prints out the filem, line and the parent function it is being executed in.


```dart
import 'package:icecream/icecream.dart' show ic;

void foo() {
  ic();
}

void main() {
  ic();

  foo();
}

```

Output:

```
🍦  example.dart:8 in main()
🍦  example.dart:4 in foo()
```

### icecream with arguments

ic with arguments inspects them and return its arguments with the returning value

```dart

import 'package:icecream/icecream.dart' show ic;

num bar(num x, num y) {
  return x + y;
}

void main() {
  ic(foo(1, 2));
}

```


Output: 
```
🍦  bar(1, 2): 3
```

#### Returning ic value
ic returns its value async while the output will still be printed out

```dart

import 'package:icecream/icecream.dart' show ic;

void main() async {
  var output = await ic("Hello");
}