class ContentParser {

  bool isOneLiner(String line) {
    if(line.contains("ic(") && line.contains(");")) {
      return true;
    } else {
      return false;
    }
  }

  List<String> getVariables(String line) {
    if(isOneLiner(line)) {
      tokenize(line.replaceFirst("ic(", "").replaceFirst(");", ""));
      return ;
    } else {
      print("No a onliner");
    }
  }
}

enum TokenType {
  String,
  Int,
  Variable,
  List,
  Map,
  Class
}

tokenize(String line) {
  Map<String, TokenType> tokens = {};

  for(final token in parse(line)) {

  }
  
}

Iterable<String> parse(String line) {
  var currentToken = "";
  var isVariable = false;
  while(line != "") {
    switch(line[0]) {
      case "" : {
        
      }
    }
    line = line.substring(1, line.length);
  }
}

eval(String char) {

}

class TokenStream {
  String input;

  TokenStream(String input) {
    this.input = input;
  }

  
}