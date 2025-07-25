class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'staff' or 'hod'

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Factory constructor for creating User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  // Check if user is Head of Department
  bool get isHoD => role.toLowerCase() == 'hod';

  // Check if user is staff
  bool get isStaff => role.toLowerCase() == 'staff';
}