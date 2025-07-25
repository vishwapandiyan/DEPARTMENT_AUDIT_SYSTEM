import 'package:flutter/material.dart';

class UploadOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const UploadOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class CodeConductData {
  // Colors
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color softBlue = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  // Academic Years
  static List<String> getAcademicYears() {
    final currentYear = DateTime.now().year;
    return List.generate(5, (index) => '${currentYear - index}-${currentYear - index + 1}');
  }

  // Semester Types
  static List<String> getSemesterTypes() {
    return ['Regular', 'Supplementary', 'Special'];
  }

  // Upload Options
  static List<UploadOption> getUploadOptions() {
    return [
      const UploadOption(
        id: 'policy',
        title: 'Policy Documents',
        subtitle: 'Upload institutional policies',
        icon: Icons.policy_outlined,
        color: Colors.blue,
      ),
      const UploadOption(
        id: 'guidelines',
        title: 'Guidelines',
        subtitle: 'Upload conduct guidelines',
        icon: Icons.rule_outlined,
        color: Colors.green,
      ),
      const UploadOption(
        id: 'forms',
        title: 'Forms & Templates',
        subtitle: 'Upload required forms',
        icon: Icons.description_outlined,
        color: Colors.orange,
      ),
      const UploadOption(
        id: 'reports',
        title: 'Reports',
        subtitle: 'Upload compliance reports',
        icon: Icons.assessment_outlined,
        color: Colors.purple,
      ),
    ];
  }
}