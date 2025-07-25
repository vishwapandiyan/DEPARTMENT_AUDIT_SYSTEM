// models/login_model.dart
class LoginModel {
  String _email = '';
  String _password = '';

  // Getters
  String get email => _email;
  String get password => _password;

  // Setters
  set email(String value) {
    _email = value.trim();
  }

  set password(String value) {
    _password = value;
  }

  // Email validation
  String? validateEmail() {
    if (_email.isEmpty) {
      return 'Email is required';
    }

    // Basic email regex pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(_email)) {
      return 'Please enter a valid email address';
    }

    // Check if it's a college email domain (optional)
    if (!_email.toLowerCase().contains('college.edu')) {
      return 'Please use your college email address';
    }

    return null;
  }

  // Password validation
  String? validatePassword() {
    if (_password.isEmpty) {
      return 'Password is required';
    }

    if (_password.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  // Check if all fields are valid
  bool isValid() {
    return validateEmail() == null && validatePassword() == null;
  }

  // Clear all fields
  void clear() {
    _email = '';
    _password = '';
  }

  // Convert to string for debugging
  @override
  String toString() {
    return 'LoginModel(email: $_email, password: [HIDDEN])';
  }
}