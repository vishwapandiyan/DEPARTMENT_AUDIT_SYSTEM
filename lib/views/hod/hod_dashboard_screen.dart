import 'package:flutter/material.dart';
import '../menubar.dart';

class HODDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenuView(userRole: 'HOD'),
          Expanded(
            child: Container(
              color: const Color(0xFFF8F9FA),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // Summary Cards Row
                    _buildSummaryCards(),
                    const SizedBox(height: 32),

                    // Main Content Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column - Activities Table
                        Expanded(
                          flex: 2,
                          child: _buildActivitiesTable(),
                        ),
                        const SizedBox(width: 24),

                        // Right Column - Recent Submissions & Notifications
                        Expanded(
                          child: Column(
                            children: [
                              _buildRecentSubmissions(),
                              const SizedBox(height: 24),
                              _buildNotifications(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Audit Period Display
                    _buildAuditPeriod(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HOD Dashboard',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ARTIFICIAL INTELLIGENCE AND DATA SCIENCE',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome back, Mr. Madhusudanan!',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Staff',
            value: '28',
            icon: Icons.people_outline,
            color: const Color(0xFF5D7590),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Activities',
            value: '41',
            icon: Icons.assignment_outlined,
            color: const Color(0xFF7B8FA3),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            title: 'Completed Submissions',
            value: '156',
            icon: Icons.check_circle_outline,
            color: const Color(0xFF6B8E3F),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            title: 'Pending Submissions',
            value: '12',
            icon: Icons.pending_actions,
            color: const Color(0xFFB8860B),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Activities Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const Spacer(),
                Text(
                  '41 Activities',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildActivityRow('Teaching Activities', 28, 25, 3, ActivityStatus.inProgress),
                  _buildActivityRow('Research Publications', 28, 28, 0, ActivityStatus.completed),
                  _buildActivityRow('Conference Presentations', 28, 12, 16, ActivityStatus.pending),
                  _buildActivityRow('Student Mentoring', 28, 26, 2, ActivityStatus.inProgress),
                  _buildActivityRow('Administrative Tasks', 28, 24, 4, ActivityStatus.inProgress),
                  _buildActivityRow('Course Development', 28, 8, 20, ActivityStatus.pending),
                  _buildActivityRow('Industry Collaboration', 28, 15, 13, ActivityStatus.inProgress),
                  _buildActivityRow('Workshop Attendance', 28, 22, 6, ActivityStatus.inProgress),
                  _buildActivityRow('Curriculum Review', 28, 28, 0, ActivityStatus.completed),
                  _buildActivityRow('Grant Applications', 28, 5, 23, ActivityStatus.pending),
                  _buildActivityRow('Peer Reviews', 28, 18, 10, ActivityStatus.inProgress),
                  _buildActivityRow('Lab Management', 28, 20, 8, ActivityStatus.inProgress),
                  _buildActivityRow('Student Assessments', 28, 27, 1, ActivityStatus.completed),
                  _buildActivityRow('Faculty Meetings', 28, 26, 2, ActivityStatus.inProgress),
                  _buildActivityRow('External Examinations', 28, 14, 14, ActivityStatus.inProgress),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String name, int total, int submitted, int pending, ActivityStatus status) {
    Color statusColor;
    switch (status) {
      case ActivityStatus.completed:
        statusColor = const Color(0xFF6B8E3F);
        break;
      case ActivityStatus.inProgress:
        statusColor = const Color(0xFFB8860B);
        break;
      case ActivityStatus.pending:
        statusColor = const Color(0xFFB85450);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[100]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$total',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '$submitted',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B8E3F),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '$pending',
              style: TextStyle(
                fontSize: 13,
                color: pending > 0 ? const Color(0xFFB85450) : Colors.grey[600],
                fontWeight: pending > 0 ? FontWeight.w500 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSubmissions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Recent Submissions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          SizedBox(
            height: 180,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSubmissionItem('Dr. Sarah Johnson', 'Research Publications', '2 hours ago'),
                _buildSubmissionItem('Prof. Michael Chen', 'Teaching Activities', '4 hours ago'),
                _buildSubmissionItem('Dr. Emily Davis', 'Workshop Attendance', '6 hours ago'),
                _buildSubmissionItem('Dr. Robert Wilson', 'Student Mentoring', '8 hours ago'),
                _buildSubmissionItem('Prof. Lisa Anderson', 'Administrative Tasks', '1 day ago'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionItem(String name, String activity, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF5D7590).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              size: 16,
              color: Color(0xFF5D7590),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifications() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationItem(
                  'Low Submission Activities',
                  'Grant Applications (5/28)',
                  Icons.warning_amber_outlined,
                  const Color(0xFFB85450),
                ),
                _buildNotificationItem(
                  'Pending Review',
                  'Course Development (8/28)',
                  Icons.info_outline,
                  const Color(0xFFB8860B),
                ),
                _buildNotificationItem(
                  'Not Started',
                  'External Examinations (14/28)',
                  Icons.error_outline,
                  const Color(0xFFB85450),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditPeriod() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF5D7590).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.schedule_outlined,
              color: Color(0xFF5D7590),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Audit Period',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'July 1, 2024 - July 15, 2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6B8E3F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Active',
              style: TextStyle(
                color: Color(0xFF6B8E3F),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ActivityStatus { completed, inProgress, pending }