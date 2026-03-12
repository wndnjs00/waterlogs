class AuthValidator {
  AuthValidator._();

  static final RegExp emailRegex =
  RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

  static final RegExp passwordRegex =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*()_+=-]).{8,}$');

  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return passwordRegex.hasMatch(password);
  }
}