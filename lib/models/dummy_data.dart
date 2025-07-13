import 'user.dart';
import 'audit_item.dart';

class DummyData {
  // Sample users
  static List<User> users = [
    User(
      id: '1',
      name: 'Dr. Sarah Johnson',
      email: 'sarah.johnson@college.edu',
      role: 'hod',
    ),
    User(
      id: '2',
      name: 'Prof. Michael Chen',
      email: 'michael.chen@college.edu',
      role: 'staff',
    ),
    User(
      id: '3',
      name: 'Dr. Emily Rodriguez',
      email: 'emily.rodriguez@college.edu',
      role: 'staff',
    ),
    User(
      id: '4',
      name: 'Prof. David Kumar',
      email: 'david.kumar@college.edu',
      role: 'staff',
    ),
    User(
      id: '5',
      name: 'Dr. Lisa Thompson',
      email: 'lisa.thompson@college.edu',
      role: 'staff',
    ),
    User(
      id: '6',
      name: 'Prof. James Wilson',
      email: 'james.wilson@college.edu',
      role: 'staff',
    ),
    User(
      id: '7',
      name: 'Dr. Maria Garcia',
      email: 'maria.garcia@college.edu',
      role: 'staff',
    ),
    User(
      id: '8',
      name: 'Prof. Robert Brown',
      email: 'robert.brown@college.edu',
      role: 'staff',
    ),
    User(
      id: '9',
      name: 'Dr. Jennifer Davis',
      email: 'jennifer.davis@college.edu',
      role: 'staff',
    ),
    User(
      id: '10',
      name: 'Prof. Mark Anderson',
      email: 'mark.anderson@college.edu',
      role: 'staff',
    ),
  ];

  // All 41 audit criteria descriptions
  static List<String> auditCriteriaDescriptions = [
    'Student feedback collection on Day 14',
    'Daily attendance verification',
    'Student code of conduct availability',
    'Cordial treatment of students',
    'Maintenance of mentoring records',
    'Grievance redressal mechanism (incl. some staff doing NPTEL psychology course)',
    'Identify students with disruptive behaviour',
    'Review LMS usage',
    'Student certification courses (NPTEL/MOOC)',
    'Guest lectures organized',
    'Seminars conducted',
    'Workshops/hands-on training',
    'Field projects for students',
    'Student internships',
    'On-the-job training (final year)',
    'Events via professional societies',
    'Events via department clubs',
    'Department newsletters/magazines',
    'Student publications',
    'Student assignments & evaluation process',
    'Experiments conducted in labs',
    'Pedagogy methods employed',
    'Student awards in co-curricular/competitions',
    'Student awards in cultural/extension activities',
    'Remind faculty to publish research papers',
    'Faculty leave register',
    'Alternative work arrangement register',
    'Syllabus coverage as per academic schedule',
    'Faculty code of conduct',
    'Faculty certification courses (NPTEL/MOOC)',
    'Faculty industry training/internship',
    'Faculty as resource persons in workshops/seminars',
    'Teacher research projects',
    'Workshops/Seminars on IPR, Research Methodology, Entrepreneurship, Skill Development',
    'Books/chapters authored by faculty',
    'Revenue from consultancy/corporate training (INR lakhs)',
    'FDPs conducted',
    'FDPs organized',
    'Functional MoUs signed',
    'E-content developed (Lecture Capturing System)',
    'Extension & outreach activities: NSS activities, Swachh Bharat, Gender sensitization, Other outreach initiatives',
  ];

  // Generate audit items for all users
  static List<AuditItem> generateAuditItems() {
    List<AuditItem> allItems = [];
    
    for (User user in users) {
      for (int i = 0; i < auditCriteriaDescriptions.length; i++) {
        // Create varying completion rates for different users
        bool isCompleted = _getRandomCompletion(user.id, i);
        
        allItems.add(AuditItem(
          id: int.parse('${user.id}${i + 1}'.padLeft(3, '0')),
          description: auditCriteriaDescriptions[i],
          isCompleted: isCompleted,
          comments: isCompleted ? _getRandomComment(i) : '',
          attachedFiles: isCompleted ? _getRandomFiles(i) : [],
          evaluationPeriod: DateTime.now().subtract(Duration(days: i % 30)),
          userId: user.id,
        ));
      }
    }
    
    return allItems;
  }

  // Generate varying completion rates for realistic data
  static bool _getRandomCompletion(String userId, int criteriaIndex) {
    // HoD (user 1) has higher completion rate
    if (userId == '1') {
      return (criteriaIndex + int.parse(userId)) % 3 != 0; // ~67% completion
    }
    
    // Other users have varying rates
    int seed = (criteriaIndex + int.parse(userId)) % 5;
    return seed > 1; // ~60% completion
  }

  // Generate sample comments
  static String _getRandomComment(int index) {
    List<String> comments = [
      'Completed successfully on schedule',
      'Documented and filed appropriately',
      'Ongoing process, regular updates maintained',
      'Excellent participation from students',
      'Resources allocated and utilized effectively',
      'Collaborative effort with department team',
      'Meeting quality standards and benchmarks',
      'Positive feedback received from participants',
      'Regular monitoring and evaluation conducted',
      'Best practices implemented and documented',
    ];
    return comments[index % comments.length];
  }

  // Generate sample files for some items
  static List<AttachedFile> _getRandomFiles(int index) {
    if (index % 4 != 0) return []; // Only some items have files
    
    List<List<AttachedFile>> sampleFiles = [
      [
        AttachedFile(
          name: 'attendance_register.pdf',
          path: '/uploads/attendance_register.pdf',
          size: 1024 * 512, // 512KB
          type: 'application/pdf',
          uploadedAt: DateTime.now().subtract(Duration(days: 1)),
        ),
      ],
      [
        AttachedFile(
          name: 'student_feedback.xlsx',
          path: '/uploads/student_feedback.xlsx',
          size: 1024 * 256, // 256KB
          type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          uploadedAt: DateTime.now().subtract(Duration(days: 2)),
        ),
      ],
      [
        AttachedFile(
          name: 'workshop_report.docx',
          path: '/uploads/workshop_report.docx',
          size: 1024 * 1024, // 1MB
          type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
          uploadedAt: DateTime.now().subtract(Duration(days: 3)),
        ),
        AttachedFile(
          name: 'workshop_photos.zip',
          path: '/uploads/workshop_photos.zip',
          size: 1024 * 1024 * 5, // 5MB
          type: 'application/zip',
          uploadedAt: DateTime.now().subtract(Duration(days: 3)),
        ),
      ],
    ];
    
    return sampleFiles[index % sampleFiles.length];
  }

  // Get current logged in user (mock authentication)
  static User? currentUser;
  
  // Mock login function
  static User? login(String email, String password) {
    // Simple mock authentication
    if (password == 'password123') {
      currentUser = users.firstWhere(
        (user) => user.email == email,
        orElse: () => users.first, // Default to first user if not found
      );
      return currentUser;
    }
    return null;
  }
  
  // Mock logout function
  static void logout() {
    currentUser = null;
  }
  
  // Get audit items for current user
  static List<AuditItem> getAuditItemsForUser(String userId) {
    return generateAuditItems().where((item) => item.userId == userId).toList();
  }
  
  // Get all audit items (for HoD)
  static List<AuditItem> getAllAuditItems() {
    return generateAuditItems();
  }
  
  // Get department statistics
  static Map<String, dynamic> getDepartmentStats() {
    List<AuditItem> allItems = getAllAuditItems();
    int totalItems = allItems.length;
    int completedItems = allItems.where((item) => item.isCompleted).length;
    
    Map<String, int> userCompletionStats = {};
    for (User user in users) {
      if (user.isStaff) {
        List<AuditItem> userItems = allItems.where((item) => item.userId == user.id).toList();
        int userCompleted = userItems.where((item) => item.isCompleted).length;
        userCompletionStats[user.name] = userCompleted;
      }
    }
    
    return {
      'totalItems': totalItems,
      'completedItems': completedItems,
      'pendingItems': totalItems - completedItems,
      'userCompletionStats': userCompletionStats,
      'completionRate': (completedItems / totalItems * 100).round(),
    };
  }
} 