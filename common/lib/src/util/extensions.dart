extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true' || this == '1';
  }
}