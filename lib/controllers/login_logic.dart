// controllers/login_controller.dart
import 'package:flutter/material.dart';
import '../models/login_model.dart';

// User roles enum
enum UserRole { hod, staff }

// User data class
class UserData {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String department;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.department,
  });
}

class LoginController extends ChangeNotifier {
  final LoginModel _model = LoginModel();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _isPasswordVisible = false;
  UserData? _currentUser;

  // Mock user database - Replace with actual API/Database
  final List<UserData> _users = [
    UserData(
      id: '1',
      email: 'hod@aids.college.edu',
      name: 'Dr. John Smith',
      role: UserRole.hod,
      department: 'AIDS',
    ),
    UserData(
      id: '2',
      email: 'staff1@aids.college.edu',
      name: 'Prof. Sarah Johnson',
      role: UserRole.staff,
      department: 'AIDS',
    ),
    UserData(
      id: '3',
      email: 'staff2@aids.college.edu',
      name: 'Dr. Michael Brown',
      role: UserRole.staff,
      department: 'AIDS',
    ),
  ];

  // Mock password database - In real app, use hashed passwords
  final Map<String, String> _passwords = {
    'hod@aids.college.edu': 'hod123',
    'staff1@aids.college.edu': 'staff123',
    'staff2@aids.college.edu': 'staff456',
  };

  // Getters
  LoginModel get model => _model;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isPasswordVisible => _isPasswordVisible;
  UserData? get currentUser => _currentUser;

  // Update email
  void updateEmail(String email) {
    _model.email = email;
    _clearError();
    notifyListeners();
  }

  // Update password
  void updatePassword(String password) {
    _model.password = password;
    _clearError();
    notifyListeners();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Clear error message
  void _clearError() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }

  // Find user by email
  UserData? _findUserByEmail(String email) {
    try {
      return _users.firstWhere((user) => user.email.toLowerCase() == email.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  // Verify password
  bool _verifyPassword(String email, String password) {
    return _passwords[email.toLowerCase()] == password;
  }

  // Login method with role-based authentication
  Future<UserData?> login() async {
    if (!_model.isValid()) {
      return null;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Find user by email
      final user = _findUserByEmail(_model.email);

      if (user == null) {
        _errorMessage = 'User not found. Please check your email address.';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      // Verify password
      if (!_verifyPassword(_model.email, _model.password)) {
        _errorMessage = 'Invalid password. Please try again.';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      // Success - set current user
      _currentUser = user;
      _isLoading = false;
      notifyListeners();

      return user;

    } catch (e) {
      _errorMessage = 'An error occurred during login. Please try again.';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Logout method
  void logout() {
    _currentUser = null;
    _model.email = '';
    _model.password = '';
    _errorMessage = '';
    notifyListeners();
  }

  // Check if user is HOD
  bool isHOD() {
    return _currentUser?.role == UserRole.hod;
  }

  // Check if user is Staff
  bool isStaff() {
    return _currentUser?.role == UserRole.staff;
  }

  // Get user role string
  String getUserRoleString() {
    switch (_currentUser?.role) {
      case UserRole.hod:
        return 'Head of Department';
      case UserRole.staff:
        return 'Staff Member';
      default:
        return 'Unknown';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}