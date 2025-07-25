class Activity {
  final int id;
  final String description;
  bool isCompleted;
  String comments;
  DateTime? completionDate;

  Activity({
    required this.id,
    required this.description,
    this.isCompleted = false,
    this.comments = '',
    this.completionDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'isCompleted': isCompleted,
      'comments': comments,
      'completionDate': completionDate?.toIso8601String(),
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      comments: json['comments'] ?? '',
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'])
          : null,
    );
  }

  Activity copyWith({
    int? id,
    String? description,
    bool? isCompleted,
    String? comments,
    DateTime? completionDate,
  }) {
    return Activity(
      id: id ?? this.id,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      comments: comments ?? this.comments,
      completionDate: completionDate ?? this.completionDate,
    );
  }
}

class ActivityData {
  static List<Activity> getAllActivities() {
    return [
      Activity(id: 1, description: "Collection of student's feedback on 14th day, a day before meeting"),
      Activity(id: 2, description: "Verification of daily attendance"),
      Activity(id: 3, description: "Code of conduct for students is available"),
      Activity(id: 4, description: "Cordial treatment to students"),
      Activity(id: 5, description: "Maintenance of Mentoring Records includes filling up of records, minutes of meeting and other relevant details"),
      Activity(id: 6, description: "Grievance redressal Mechanism: (A few Teachers have to do psychology course through NPTEL)"),
      Activity(id: 7, description: "Identifying students of disruptive behaviour"),
      Activity(id: 8, description: "Review of the Learning Management System (LMS) Usage"),
      Activity(id: 9, description: "Details of certification courses (NPTEL/MOOC) done by students"),
      Activity(id: 10, description: "Details of Guest Lectures organized by the Department"),
      Activity(id: 11, description: "Details of seminars conducted by the department"),
      Activity(id: 12, description: "Details of workshops/hands-on experience training given to students"),
      Activity(id: 13, description: "Details of field projects given to students"),
      Activity(id: 14, description: "Details of internship undergone by students"),
      Activity(id: 15, description: "On the Job training (final year students)"),
      Activity(id: 16, description: "Details of events organized through professional societies by department"),
      Activity(id: 17, description: "Details of events organized through Department Clubs"),
      Activity(id: 18, description: "Details of Newsletter/magazines published in the department"),
      Activity(id: 19, description: "Student publications"),
      Activity(id: 20, description: "Details of assignment given to the students and process of evaluation"),
      Activity(id: 21, description: "Details of number of experiments conducted in the Laboratory"),
      Activity(id: 22, description: "Details of pedagogy methods employed during this period in various courses"),
      Activity(id: 23, description: "Awards/prizes in co-curricular/competition etc won by students"),
      Activity(id: 24, description: "Details of awards in cultural/extension activities won by students"),
      Activity(id: 25, description: "Reminder to faculty member for publication of Research papers"),
      Activity(id: 26, description: "Faculty members leave Register"),
      Activity(id: 27, description: "Availability of Alternative work arrangement register"),
      Activity(id: 28, description: "Syllabus coverage as per Academic Schedule"),
      Activity(id: 29, description: "Code of conduct for Faculty members"),
      Activity(id: 30, description: "Details of certification courses (NPTEL/MOOC) done by faculty members"),
      Activity(id: 31, description: "Faculty training/internship in Industry"),
      Activity(id: 32, description: "Faculty as a Resource person in seminars/workshops"),
      Activity(id: 33, description: "Details of research projects by teachers"),
      Activity(id: 34, description: "Details of Workshops/Seminars conducted on Intellectual Property Rights (IPR), Research Methodology, Entrepreneurship and Skill Development during the year"),
      Activity(id: 35, description: "Details of books/chapters in edited volumes/books by teacher"),
      Activity(id: 36, description: "Revenue generated from consultancy and corporate training during the year (INR in lakhs)"),
      Activity(id: 37, description: "FDPs conducted by department"),
      Activity(id: 38, description: "FDPs organized by the Department"),
      Activity(id: 39, description: "Number of functional MoUs signed"),
      Activity(id: 40, description: "Details of e-content developed (Lecture Capturing System)"),
      Activity(id: 41, description: "Extension and Outreach Activities: NSS activities, Swachh Bharat, Gender Sensitization programs, Any other outreach/extension activities"),
    ];
  }
}