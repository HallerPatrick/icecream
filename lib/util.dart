bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null || 
      int.parse(s, onError: (e) => null) != null;
}