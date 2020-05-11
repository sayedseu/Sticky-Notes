class Validator {
  static String validatePassword(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }

  static String validateUsername(String value) {
    return value.isEmpty ? 'Username can\'t be empty' : null;
  }
}
