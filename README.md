# <center>IceCreamDart</center>
<h1 align="center">
  <img src="icon.png" width="600px" alt="icecream">
</h1>

[![Build Status](https://travis-ci.org/HallerPatrick/icecream.svg?branch=master)](https://travis-ci.org/HallerPatrick/icecream)

### iceream for Dart is a flavor of a good tasting debugger

It is a library inspired by the python [icecream](https://github.com/gruns/icecream) library

The purpose is to to make debugging over the console easy again.

Instead of `print()` or `window.console.log()`, `ic` helps to make developing much sweeter.


### icecream without Arguments

Ic comes in handy to determine which part of code is being executed and where. So if no arguments are passed to ic, it prints out the filem, line and the parent function it is being executed in.

`ic()` without arguments is synchronous 

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

Be aware due to some IO, `ic()` with arguments is async and therefore should be awaited to ensure the right printing order

```dart

import 'package:icecream/icecream.dart' show ic;

num bar(num x, num y) {
  return x + y;
}

void main() async {
  await ic(bar(1, 2));
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
```

#### Disable ic

```dart

import 'package:icecream/icecream.dart' show ic;

void main() async {
  await ic();
  await ic.disable();
  await ic();
  await ic.enable();
  await ic();
}

```

Output:

```
🍦  example.dart:4 in main()
🍦  example.dart:8 in main()
```

### Custom prefix

```dart
import 'package:icecream/icecream.dart' show ic;

void main() async {
  await ic.setPrefix("ic| ");
  await ic(3);
}
```

Output:

```
ic | 3: 3
```

## Installation

Insert in your pubspec.yaml:

```yaml
dependencies:
  icecream: '0.1.3'
```

In command line:
```
pub get
```

Or let your IDE/Editor do the work

### Warning:

This library depends on the dart:mirror core library and is therefore only usable in a standalone VM of Dart.
 

 ### TODO:

 1. Extensive testing
 2. Proper documentation
 3. Provide all icecream flavors with a juicy icon
 4. Provide own configuration for flexible use of ic
