abstract class RegExps {
  static final RegExp email = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static final RegExp nameNumberAndWhiteSpaceOnly = RegExp(r'[a-zA-Z0-9\s]');

  static final RegExp decimalValue = RegExp(r'^\d+\.?\d{0,1}');
}
