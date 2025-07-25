// models/attendance_model.dart

class AttendanceRecord {
  final String id;
  final String programme;
  final String year;
  final String semester;
  final String section;
  final int studentsPresent;
  final int studentsAbsent;
  final int totalStudents;
  final DateTime date;

  AttendanceRecord({
    String? id,
    required this.programme,
    required this.year,
    required this.semester,
    required this.section,
    required this.studentsPresent,
    required this.studentsAbsent,
    required this.totalStudents,
    required this.date,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Computed property for combined year-semester-section display
  String get yearSemSec => '$year - $semester - $section';

  // Computed property for class identifier
  String get classIdentifier => '$programme - $year - $semester - $section';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'programme': programme,
      'year': year,
      'semester': semester,
      'section': section,
      'studentsPresent': studentsPresent,
      'studentsAbsent': studentsAbsent,
      'totalStudents': totalStudents,
      'date': date.toIso8601String(),
    };
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      programme: json['programme'],
      year: json['year'],
      semester: json['semester'],
      section: json['section'],
      studentsPresent: json['studentsPresent'],
      studentsAbsent: json['studentsAbsent'],
      totalStudents: json['totalStudents'],
      date: DateTime.parse(json['date']),
    );
  }

  // Create a copy with updated values
  AttendanceRecord copyWith({
    String? id,
    String? programme,
    String? year,
    String? semester,
    String? section,
    int? studentsPresent,
    int? studentsAbsent,
    int? totalStudents,
    DateTime? date,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      programme: programme ?? this.programme,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      section: section ?? this.section,
      studentsPresent: studentsPresent ?? this.studentsPresent,
      studentsAbsent: studentsAbsent ?? this.studentsAbsent,
      totalStudents: totalStudents ?? this.totalStudents,
      date: date ?? this.date,
    );
  }

  // Calculate attendance percentage
  double get attendancePercentage {
    if (totalStudents == 0) return 0.0;
    return (studentsPresent / totalStudents) * 100;
  }

  @override
  String toString() {
    return 'AttendanceRecord{id: $id, programme: $programme, year: $year, semester: $semester, section: $section, present: $studentsPresent, absent: $studentsAbsent, total: $totalStudents, date: $date}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttendanceRecord &&
        other.id == id &&
        other.programme == programme &&
        other.year == year &&
        other.semester == semester &&
        other.section == section &&
        other.studentsPresent == studentsPresent &&
        other.studentsAbsent == studentsAbsent &&
        other.totalStudents == totalStudents &&
        other.date == date;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      programme,
      year,
      semester,
      section,
      studentsPresent,
      studentsAbsent,
      totalStudents,
      date,
    );
  }
}

class AttendanceReport {
  final DateTime fromDate;
  final DateTime toDate;
  final List<AttendanceRecord> records;
  final Map<String, dynamic>? summary;

  AttendanceReport({
    required this.fromDate,
    required this.toDate,
    required this.records,
    this.summary,
  });

  // Calculate average attendance percentage across all records
  double get averageAttendance {
    if (records.isEmpty) return 0.0;
    int totalPresent = records.fold(0, (sum, record) => sum + record.studentsPresent);
    int totalStudents = records.fold(0, (sum, record) => sum + record.totalStudents);
    return totalStudents > 0 ? (totalPresent / totalStudents) * 100 : 0.0;
  }

  // Get total present students
  int get totalPresent => records.fold(0, (sum, record) => sum + record.studentsPresent);

  // Get total absent students
  int get totalAbsent => records.fold(0, (sum, record) => sum + record.studentsAbsent);

  // Get total students across all records
  int get totalStudents => records.fold(0, (sum, record) => sum + record.totalStudents);

  // Get records grouped by programme
  Map<String, List<AttendanceRecord>> get recordsByProgramme {
    Map<String, List<AttendanceRecord>> grouped = {};
    for (var record in records) {
      if (!grouped.containsKey(record.programme)) {
        grouped[record.programme] = [];
      }
      grouped[record.programme]!.add(record);
    }
    return grouped;
  }

  // Get records grouped by year
  Map<String, List<AttendanceRecord>> get recordsByYear {
    Map<String, List<AttendanceRecord>> grouped = {};
    for (var record in records) {
      if (!grouped.containsKey(record.year)) {
        grouped[record.year] = [];
      }
      grouped[record.year]!.add(record);
    }
    return grouped;
  }

  // Get records grouped by class (programme-year-semester-section)
  Map<String, List<AttendanceRecord>> get recordsByClass {
    Map<String, List<AttendanceRecord>> grouped = {};
    for (var record in records) {
      String classKey = record.classIdentifier;
      if (!grouped.containsKey(classKey)) {
        grouped[classKey] = [];
      }
      grouped[classKey]!.add(record);
    }
    return grouped;
  }

  // Get highest attendance record
  AttendanceRecord? get highestAttendanceRecord {
    if (records.isEmpty) return null;
    return records.reduce((a, b) =>
    a.attendancePercentage > b.attendancePercentage ? a : b);
  }

  // Get lowest attendance record
  AttendanceRecord? get lowestAttendanceRecord {
    if (records.isEmpty) return null;
    return records.reduce((a, b) =>
    a.attendancePercentage < b.attendancePercentage ? a : b);
  }

  // Convert to JSON for export/sharing
  Map<String, dynamic> toJson() {
    return {
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'records': records.map((record) => record.toJson()).toList(),
      'summary': {
        'averageAttendance': averageAttendance,
        'totalPresent': totalPresent,
        'totalAbsent': totalAbsent,
        'totalStudents': totalStudents,
        'recordCount': records.length,
      },
    };
  }

  factory AttendanceReport.fromJson(Map<String, dynamic> json) {
    return AttendanceReport(
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      records: (json['records'] as List)
          .map((recordJson) => AttendanceRecord.fromJson(recordJson))
          .toList(),
      summary: json['summary'],
    );
  }

  @override
  String toString() {
    return 'AttendanceReport{fromDate: $fromDate, toDate: $toDate, recordCount: ${records.length}, averageAttendance: ${averageAttendance.toStringAsFixed(1)}%}';
  }
}

// Additional model for dashboard statistics
class AttendanceStatistics {
  final int totalRecords;
  final double averageAttendance;
  final double highestAttendance;
  final double lowestAttendance;
  final int totalClasses;
  final Map<String, int> recordsByProgramme;
  final Map<String, double> attendanceByProgramme;

  AttendanceStatistics({
    required this.totalRecords,
    required this.averageAttendance,
    required this.highestAttendance,
    required this.lowestAttendance,
    required this.totalClasses,
    required this.recordsByProgramme,
    required this.attendanceByProgramme,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalRecords': totalRecords,
      'averageAttendance': averageAttendance,
      'highestAttendance': highestAttendance,
      'lowestAttendance': lowestAttendance,
      'totalClasses': totalClasses,
      'recordsByProgramme': recordsByProgramme,
      'attendanceByProgramme': attendanceByProgramme,
    };
  }
}