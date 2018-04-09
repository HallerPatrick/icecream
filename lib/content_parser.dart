enum TokenType { String, Int, Variable, List, Map, Class }

enum StringType { SingleQuoteMark, DoubleQuoteMark }

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
    if (isNumeric(char)) return TokenType.Int;
    if (isAlpha(char)) return TokenType.Variable;
    if ('"' == char) return TokenType.String;
    if ('[' == char || ']' == char) return TokenType.List;
    if ('{' == char || '}' == char) return TokenType.Map;
    return TokenType.Class;
  }

  List<String> parse() {
    List<String> tokens = [];

    while (this.input != "") {
      switch (_evalType(this.input[0])) {
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
            break;
          }

        case TokenType.Map:
          {
            break;
          }

        case TokenType.Variable:
          {
            break;
          }
        case TokenType.Class:
          {
            break;
          }
      }
      // line = line.substring(1, line.length);
    }
    return tokens;
  }

  String getStringToken() {
    String token = "";
    StringType stringType = evalStringType();
    while (this.input.substring(1, this.input.length)[0] != stringType) {
      token += this.input.substring(1, this.input.length)[0];
      this.input = this.input.substring(1, this.input.length);
    }
    return token;
  }

  String getIntToken() {
    String token = "";
    while (isNumeric(this.input.substring(1, this.input.length)[0])) {
      token += this.input.substring(1, this.input.length)[0];
      this.input = this.input.substring(1, this.input.length);
    }
    return token;
  }

  String getListToken() {
    
  }

  StringType evalStringType() {
    if (this.input[0] == '"') {
      return StringType.DoubleQuoteMark;
    } else {
      return StringType.SingleQuoteMark;
    }
  }
}
