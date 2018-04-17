enum TokenType { string, integer, variable, list, map, klass, whitespace, comma }

class StringType {
  static const String singleQuoteMark = "'";
  static const String doubleQuoteMark = '"';
}

class ContentParser {
  String _input;

  ContentParser(String _input) {
    this._input = _input;
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null ||
        int.parse(s, onError: (e) => null) != null;
  }

  bool _isAlpha(String s) {
    RegExp _alpha = new RegExp(r'^[a-zA-Z]+$');
    return _alpha.hasMatch(s);
  }

  TokenType _evalType(char) {
    if (char == " ") return TokenType.whitespace;
    if (char == ",") return TokenType.comma;
    if (_isNumeric(char)) return TokenType.integer;
    if (_isAlpha(char)) return TokenType.variable;
    if ('"' == char || "'" == char) return TokenType.string;
    if ('[' == char || ']' == char) return TokenType.list;
    if ('{' == char || '}' == char) return TokenType.map;
    return TokenType.klass;
  }

  /// Tokenizes the _input string in its corresponding types
  List<String> parse() {
    List<String> tokens = [];

    while (this._input != "") {
      // Determine from first char of token, what type it is
      switch (_evalType(this._input[0])) {
        case TokenType.whitespace:
          {
            if (this._input.length > 1) {
              _removeFirstCharFromInput();
            } else {
              this._input = "";
            }
            break;
          }
        case TokenType.comma:
          {
            if (this._input.length > 1) {
              _removeFirstCharFromInput();
            } else {
              this._input = "";
            }
            break;
          }
        case TokenType.string:
          {
            tokens.add(_getStringToken());
            break;
          }
        case TokenType.integer:
          {
            tokens.add(_getIntToken());
            break;
          }

        case TokenType.list:
          {
            tokens.add(_getlistToken());
            break;
          }

        case TokenType.map:
          {
            tokens.add(_getMapToken());
            break;
          }

        case TokenType.variable:
          {
            tokens.add(_getvariableToken());
            break;
          }
        case TokenType.klass:
          {
            tokens.add(_getClassToken());
            break;
          }
      }
    }
    return tokens;
  }

  String _getStringToken() {
    String stringType = _evalStringType();
    String token = _input[0];
    _removeFirstCharFromInput();
    while (_input.length >= 1) {
      if (_input[0] != stringType) {
        token += _input[0];
        _removeFirstCharFromInput();
      } else {
        /// Remove the last two chars of token and add to string
        token += this._input[0];
        _removeFirstCharFromInput();
        return token;
      }
    }
    return token;
  }

  String _getIntToken() {
    String token = "";
    if (this._input.length == 1) {
      token = this._input;
      this._input = "";
      return token;
    } else {
      while (this._input.length > 1) {
        if (_isNumeric(_input[0])) {
          token += _input[0];
          _removeFirstCharFromInput();
        } else {
          _removeFirstCharFromInput();
          return token;
        }
      }
    }
    return token;
  }

  void _removeFirstCharFromInput() {
    _input = _input.substring(1, _input.length);
  }

  String _getlistToken() {
    String token = "";
    int openBrackets = 0;
    if (_input[0] == "[") {
      openBrackets++;
      token += _input[0];
      _removeFirstCharFromInput();
    } else {
      return "";
    }
    while (this._input.length >= 1) {
      if (_input[0] == "[") {
        openBrackets++;
      }
      if (_input[0] == "]") {
        openBrackets--;
        if (openBrackets == 0) {
          token += _input[0];
          _removeFirstCharFromInput();
          return token;
        }
      }
      token += this._input[0];
      _removeFirstCharFromInput();
    }
    return token;
  }

  String _getMapToken() {
    String token = "";
    int openBrackets = 0;
    if (_input[0] == "{") {
      openBrackets++;
      token += _input[0];
      _removeFirstCharFromInput();
    } else {
      return "";
    }
    while (this._input.length >= 1) {
      if (_input[0] == "{") {
        openBrackets++;
      }
      if (_input[0] == "}") {
        openBrackets--;
        if (openBrackets == 0) {
          token += _input[0];
          _removeFirstCharFromInput();
          return token;
        }
      }
      token += this._input[0];
      _removeFirstCharFromInput();
    }
    return token;
  }

  String _getvariableToken() {
    String token = "";
    // variable type could also be function type, depending on brackets
    int openBrackets = 0;
    while (this._input.length >= 1) {
      // Check if next char is a letter
      if (_isAlpha(_input[0])) {
        token += _input[0];
        _removeFirstCharFromInput();
        // If char is opening bracket, expected variable is a function call
      } else if (_input[0] == "(") {
        openBrackets++;
        token += _input[0];
        _removeFirstCharFromInput();
      } else if (_input[0] == ")") {
        openBrackets--;
        token += _input[0];
        _removeFirstCharFromInput();
        if (openBrackets == 0) {
          return token;
        }
        // Mean that input is a function and also allows other chars than letters
      } else if (openBrackets > 0) {
        token += _input[0];
        _removeFirstCharFromInput();
      } else {
        _removeFirstCharFromInput();
        return token;
      }
    }
    return token;
  }

  String _getClassToken() {
    String token = "";
    String classKeyword = "new";
    if (this._input.contains(classKeyword)) {
      this._input.replaceFirst("new ", "");
      token += "new ";
    }
    return token;
  }

  String _evalStringType() {
    if (this._input[0] == '"') {
      return StringType.doubleQuoteMark;
    } else {
      return StringType.singleQuoteMark;
    }
  }
}
