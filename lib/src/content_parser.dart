enum TokenType { String, Int, Variable, List, Map, Class, Whitespace, Comma }

class StringType {
  static const String SingleQuoteMark = "'";
  static const String DoubleQuoteMark = '"';
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
    if (char == " ") return TokenType.Whitespace;
    if (char == ",") return TokenType.Comma;
    if (_isNumeric(char)) return TokenType.Int;
    if (_isAlpha(char)) return TokenType.Variable;
    if ('"' == char || "'" == char) return TokenType.String;
    if ('[' == char || ']' == char) return TokenType.List;
    if ('{' == char || '}' == char) return TokenType.Map;
    return TokenType.Class;
  }

  /// Tokenizes the _input string in its corresponding types
  List<String> parse() {
    List<String> tokens = [];

    while (this._input != "") {
      // Determine from first char of token, what type it is
      print(_input[0]);
      print(_evalType(this._input[0]));
      switch (_evalType(this._input[0])) {
        case TokenType.Whitespace:
          {
            if (this._input.length > 1) {
              _removeFirstCharFromInput();
            } else {
              this._input = "";
            }
            break;
          }
        case TokenType.Comma:
          {
            if (this._input.length > 1) {
              _removeFirstCharFromInput();
            } else {
              this._input = "";
            }
            break;
          }
        case TokenType.String:
          {
            tokens.add(_getStringToken());
            break;
          }
        case TokenType.Int:
          {
            tokens.add(_getIntToken());
            break;
          }

        case TokenType.List:
          {
            tokens.add(_getListToken());
            break;
          }

        case TokenType.Map:
          {
            tokens.add(_getMapToken());
            break;
          }

        case TokenType.Variable:
          {
            tokens.add(_getVariableToken());
            break;
          }
        case TokenType.Class:
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

  _removeFirstCharFromInput() {
    _input = _input.substring(1, _input.length);
  }

  String _getListToken() {
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

  String _getVariableToken() {
    String token = "";
    // Variable type could also be function type, depending on brackets
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
      return StringType.DoubleQuoteMark;
    } else {
      return StringType.SingleQuoteMark;
    }
  }
}
