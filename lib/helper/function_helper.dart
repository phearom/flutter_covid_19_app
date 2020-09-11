class FunctionHelper {
  static RegExp _regExp = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  static Function _mathFunc = (Match match) => '${match[1]},';
  static String toIntWithComma(int value) {
    return value.toString().replaceAllMapped(_regExp, _mathFunc);
  }
}
