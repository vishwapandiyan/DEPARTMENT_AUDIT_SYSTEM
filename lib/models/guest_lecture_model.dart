// models/guest_lecture.dart
class GuestLecture {
  final int sno;
  final String title;
  final DateTime date;
  final String resource;
  final String venue;
  final String budget;
  final String students;
  final List<String> photos;
  final String report;
  final String academicYear;
  final String semester;

  GuestLecture({
    required this.sno,
    required this.title,
    required this.date,
    required this.resource,
    required this.venue,
    required this.budget,
    required this.students,
    required this.photos,
    required this.report,
    required this.academicYear,
    required this.semester,
  });

  factory GuestLecture.fromMap(Map<String, dynamic> map) {
    return GuestLecture(
      sno: map['sno'] as int,
      title: map['title'] as String,
      date: map['date'] as DateTime,
      resource: map['resource'] as String,
      venue: map['venue'] as String,
      budget: map['budget'] as String,
      students: map['students'] as String,
      photos: List<String>.from(map['photos'] as List),
      report: map['report'] as String,
      academicYear: map['academicYear'] as String,
      semester: map['semester'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sno': sno,
      'title': title,
      'date': date,
      'resource': resource,
      'venue': venue,
      'budget': budget,
      'students': students,
      'photos': photos,
      'report': report,
      'academicYear': academicYear,
      'semester': semester,
    };
  }
}