
enum TokenType { String, Int, Variable, List, Map, Class, Whitespace, Comma }

class StringType {
  static const String SingleQuoteMark = "'";
  static const String DoubleQuoteMark = '"';
}

class ContentParser {
  String input;

  ContentParser(String input) {
    this.input = input;
  }

  bool _isOneLiner(String line) {
    if (line.contains("ic(") && line.contains(");")) {
      return true;
    } else {
      return false;
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null ||
        int.parse(s, onError: (e) => null) != null;
  }

  bool isAlpha(String s) {
    RegExp _alpha = new RegExp(r'^[a-zA-Z]+$');
    return _alpha.hasMatch(s);
  }

  TokenType _evalType(char) {
    print("EVAL CHAR: $char");
    if (char == " ") return TokenType.Whitespace;
    if (char == ",") return TokenType.Comma;
    if (isNumeric(char)) return TokenType.Int;
    if (isAlpha(char)) return TokenType.Variable;
    if ('"' == char || "'" == char) return TokenType.String;
    if ('[' == char || ']' == char) return TokenType.List;
    if ('{' == char || '}' == char) return TokenType.Map;
    return TokenType.Class;
  }

  /// Tokenizes the input string in its corresponding types
  List<String> parse() {
    List<String> tokens = [];

    while (this.input != "") {
      // Determine from first char of token, what type it is
      switch (_evalType(this.input[0])) {
        case TokenType.Whitespace:
          {
            if (this.input.length > 1) {
              this.input = this.input.substring(1, this.input.length);
            } else {
              this.input = "";
            }
            break;
          }
        case TokenType.Comma:
          {
            if (this.input.length > 1) {
              this.input = this.input.substring(1, this.input.length);
            } else {
              this.input = "";
            }
            break;
          }
        case TokenType.String:
          {
            tokens.add(getStringToken());
            break;
          }
        case TokenType.Int:
          {
            tokens.add(getIntToken());
            break;
          }

        case TokenType.List:
          {
            tokens.add(getListToken());
            break;
          }

        case TokenType.Map:
          {
            tokens.add(getMapToken());
            break;
          }

        case TokenType.Variable:
          {
            tokens.add(getVariableToken());
            break;
          }
        case TokenType.Class:
          {
            tokens.add(getClassToken());
            break;
          }
      }
    }
    return tokens;
  }

  String getStringToken() {
    StringType stringType = evalStringType();
    String token = this.input[0];
    this.input = this.input.substring(1, this.input.length);
      while (this.input.length > 1) {
        if (this.input.substring(1, this.input.length)[0] != stringType) {
          token += this.input[0];
          this.input = this.input.substring(1, this.input.length);
        } else {
          /// Remove the last two chars of token and add to string
          token += this.input[0];
          token += this.input[1];
          this.input = this.input.substring(2, this.input.length);
          return token;
        }
      
    }
    return token;
  }

  String getIntToken() {
    String token = "";
    if (this.input.length == 1) {
      token = this.input;
      this.input = "";
      return token;
    } else {
      while (this.input.length > 1) {
        if (isNumeric(this.input.substring(1, this.input.length)[0])) {
          token += this.input.substring(1, this.input.length)[0];
          this.input = this.input.substring(1, this.input.length);
        } else {
          token += this.input[0];
          this.input = this.input.substring(1, this.input.length);
          return token;
        }
      }
    }
    return token;
  }

  String getListToken() {
    String token = "";
    int openBrackets = 1;
    while (openBrackets >= 0 && this.input.length > 1) {
      print("Current token: $token");
      if (this.input.substring(1, this.input.length)[0] == "[") {
        openBrackets++;
      }
      if (this.input.substring(1, this.input.length)[0] == "]") {
        openBrackets--;
      }
      print("Current openBrackts: $openBrackets");
      print("Current input: $input");
    
      token += this.input[0];
      this.input = this.input.substring(1, this.input.length);
    }
    return token;
  }

  String getMapToken() {
    String token = "";
    int openBrackets = 1;
    while (openBrackets > 0) {
      if (this.input.substring(1, this.input.length)[0] == "{") {
        openBrackets++;
      }
      if (this.input.substring(1, this.input.length)[0] == "}") {
        openBrackets--;
      }
      token += this.input.substring(1, this.input.length)[0];
      this.input = this.input.substring(1, this.input.length);
    }
    return token;
  }

  String getVariableToken() {
    String token = "";
    if (this.input.length == 1) {
      token = this.input;
      this.input = "";
      return token;
    } else {
      while (this.input.length > 1) {
        if (isAlpha(this.input.substring(1, this.input.length)[0])) {
          token += this.input.substring(1, this.input.length)[0];
          this.input = this.input.substring(1, this.input.length);
        } else {
          token += this.input[0];
          this.input = this.input.substring(1, this.input.length);
          return token;
        }
      }
      return token;
    }
  }

  String getClassToken() {
    String token = "";
    String classKeyword = "new";
    if (this.input.contains(classKeyword)) {
      this.input.replaceFirst("new ", "");
      token += "new ";
    }
    return token;
  }

  String evalStringType() {
    if (this.input[0] == '"') {
      return StringType.DoubleQuoteMark;
    } else {
      return StringType.SingleQuoteMark;
    }
  }
}
