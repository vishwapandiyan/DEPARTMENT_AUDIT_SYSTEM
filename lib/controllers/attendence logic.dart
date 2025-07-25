// controllers/attendance_controller.dart

import 'package:flutter/material.dart';
import '../models/attendence_model.dart';

class AttendanceController extends ChangeNotifier {
  // Form controllers
  final TextEditingController dateController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  // New controllers for manual entry
  final TextEditingController totalStrengthController = TextEditingController();
  final TextEditingController presentController = TextEditingController();
  final TextEditingController absentController = TextEditingController();

  // Form data - Separate fields for year, semester, section
  String? selectedProgramme;
  String? selectedYear;
  String? selectedSemester;
  String? selectedSection;
  int studentsPresent = 0;
  int studentsAbsent = 0;
  int totalStrength = 0;
  DateTime selectedDate = DateTime.now();
  DateTime fromDate = DateTime.now().subtract(Duration(days: 30));
  DateTime toDate = DateTime.now();

  // Validation properties
  bool hasValidationError = false;
  String validationMessage = '';

  // Report filters
  String? reportFilterProgramme = 'All';
  String? reportFilterYear = 'All';
  bool hasGeneratedReport = false;
  Map<String, dynamic> reportSummary = {};
  List<Map<String, dynamic>> reportRecords = [];

  // Data storage
  List<AttendanceRecord> _attendanceRecords = [];
  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;

  // Computed property for total students
  int get totalStudents => totalStrength;

  // Computed property for attendance percentage
  String get attendancePercentage {
    if (totalStrength == 0) return '0.0';
    double percentage = (studentsPresent / totalStrength) * 100;
    return percentage.toStringAsFixed(1);
  }

  // Options for dropdowns
  final List<String> programmes = [
    'BTECH',
    'MTECH'
  ];

  final List<String> years = [
    '1 Year',
    '2 Year',
    '3 Year',
    '4 Year',
  ];

  final List<String> semesters = [
    '1 Semester',
    '2 Semester',
    '3 Semester',
    '4 Semester',
    '5 Semester',
    '6 Semester',
    '7 Semester',
    '8 Semester',
  ];

  final List<String> sections = [
    'Section A',
    'Section B',
    'Section C',
    'Section D',
  ];

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Last generated report for reference
  AttendanceReport? _lastGeneratedReport;

  AttendanceController() {
    _initializeControllers();
  }

  void _initializeControllers() {
    dateController.text = _formatDate(selectedDate);
    fromDateController.text = _formatDate(fromDate);
    toDateController.text = _formatDate(toDate);

    // Initialize manual entry controllers
    totalStrengthController.text = totalStrength.toString();
    presentController.text = studentsPresent.toString();
    absentController.text = studentsAbsent.toString();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  // Setters for form fields
  void setProgramme(String? programme) {
    selectedProgramme = programme;
    _validateInputs();
    notifyListeners();
  }

  void setYear(String? year) {
    selectedYear = year;
    _validateInputs();
    notifyListeners();
  }

  void setSemester(String? semester) {
    selectedSemester = semester;
    _validateInputs();
    notifyListeners();
  }

  void setSection(String? section) {
    selectedSection = section;
    _validateInputs();
    notifyListeners();
  }

  void setStudentsPresent(int present) {
    if (present >= 0) {
      studentsPresent = present;
      presentController.text = present.toString();
      _validateInputs();
      notifyListeners();
    }
  }

  void setStudentsAbsent(int absent) {
    if (absent >= 0) {
      studentsAbsent = absent;
      absentController.text = absent.toString();
      _validateInputs();
      notifyListeners();
    }
  }

  void setDate(DateTime date) {
    selectedDate = date;
    dateController.text = _formatDate(date);
    notifyListeners();
  }

  void setFromDate(DateTime date) {
    fromDate = date;
    fromDateController.text = _formatDate(date);
    // Ensure toDate is not before fromDate
    if (toDate.isBefore(date)) {
      setToDate(date);
    }
    notifyListeners();
  }

  void setToDate(DateTime date) {
    toDate = date;
    toDateController.text = _formatDate(date);
    notifyListeners();
  }

  // New methods for manual entry
  void updateTotalStrength(String value) {
    int? strength = int.tryParse(value);
    if (strength != null && strength >= 0) {
      totalStrength = strength;
      _validateInputs();
    } else {
      totalStrength = 0;
    }
    notifyListeners();
  }

  void updatePresent(String value) {
    int? present = int.tryParse(value);
    if (present != null && present >= 0) {
      studentsPresent = present;
      _validateInputs();
    } else {
      studentsPresent = 0;
    }
    notifyListeners();
  }

  void updateAbsent(String value) {
    int? absent = int.tryParse(value);
    if (absent != null && absent >= 0) {
      studentsAbsent = absent;
      _validateInputs();
    } else {
      studentsAbsent = 0;
    }
    notifyListeners();
  }

  // Report filter setters
  void setReportFilterProgramme(String? programme) {
    reportFilterProgramme = programme;
    notifyListeners();
  }

  void setReportFilterYear(String? year) {
    reportFilterYear = year;
    notifyListeners();
  }

  // Validation
  void _validateInputs() {
    hasValidationError = false;
    validationMessage = '';

    if (totalStrength > 0 && studentsPresent + studentsAbsent != totalStrength) {
      hasValidationError = true;
      validationMessage = 'Present + Absent should equal Total Strength (${totalStrength})';
    }

    if (studentsPresent > totalStrength) {
      hasValidationError = true;
      validationMessage = 'Students present cannot exceed total strength';
    }

    if (studentsAbsent > totalStrength) {
      hasValidationError = true;
      validationMessage = 'Students absent cannot exceed total strength';
    }
  }

  bool _validateForm() {
    if (selectedProgramme == null || selectedProgramme!.isEmpty) {
      throw Exception('Please select a programme');
    }
    if (selectedYear == null || selectedYear!.isEmpty) {
      throw Exception('Please select a year');
    }
    if (selectedSemester == null || selectedSemester!.isEmpty) {
      throw Exception('Please select a semester');
    }
    if (selectedSection == null || selectedSection!.isEmpty) {
      throw Exception('Please select a section');
    }
    if (totalStrength <= 0) {
      throw Exception('Please enter valid total strength');
    }
    if (studentsPresent + studentsAbsent != totalStrength) {
      throw Exception('Present + Absent should equal Total Strength');
    }
    return true;
  }

  bool _validateReportForm() {
    if (fromDate.isAfter(toDate)) {
      throw Exception('From date cannot be after To date');
    }
    return true;
  }

  // Add attendance record
  Future<void> addAttendanceRecord() async {
    if (!_validateForm()) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 1));

      // Check if record already exists for this date and class combination
      bool recordExists = _attendanceRecords.any((record) =>
      record.programme == selectedProgramme &&
          record.year == selectedYear &&
          record.semester == selectedSemester &&
          record.section == selectedSection &&
          _isSameDate(record.date, selectedDate));

      if (recordExists) {
        throw Exception('Attendance record already exists for this date and class');
      }

      final record = AttendanceRecord(
        programme: selectedProgramme!,
        year: selectedYear!,
        semester: selectedSemester!,
        section: selectedSection!,
        studentsPresent: studentsPresent,
        studentsAbsent: studentsAbsent,
        totalStudents: totalStrength,
        date: selectedDate,
      );

      _attendanceRecords.add(record);
      _clearForm();

    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _clearForm() {
    selectedProgramme = null;
    selectedYear = null;
    selectedSemester = null;
    selectedSection = null;
    studentsPresent = 0;
    studentsAbsent = 0;
    totalStrength = 0;
    selectedDate = DateTime.now();
    dateController.text = _formatDate(selectedDate);
    totalStrengthController.text = '0';
    presentController.text = '0';
    absentController.text = '0';
    hasValidationError = false;
    validationMessage = '';
  }

  // Generate report with filtering
  Future<AttendanceReport> generateReport() async {
    if (!_validateReportForm()) {
      throw Exception('Invalid report parameters');
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));

      List<AttendanceRecord> filteredRecords = _attendanceRecords.where((record) {
        // Date range filter
        bool dateInRange = record.date.isAfter(fromDate.subtract(Duration(days: 1))) &&
            record.date.isBefore(toDate.add(Duration(days: 1)));

        // Programme filter
        bool programmeMatch = reportFilterProgramme == 'All' ||
            record.programme == reportFilterProgramme;

        // Year filter
        bool yearMatch = reportFilterYear == 'All' ||
            record.year == reportFilterYear;

        return dateInRange && programmeMatch && yearMatch;
      }).toList();

      // Sort records by date
      filteredRecords.sort((a, b) => a.date.compareTo(b.date));

      // Convert to report records format expected by view
      reportRecords = filteredRecords.map((record) {
        double percentage = record.totalStudents > 0
            ? (record.studentsPresent / record.totalStudents) * 100
            : 0.0;

        return {
          'date': _formatDate(record.date),
          'programme': record.programme,
          'year': record.year,
          'semester': record.semester,
          'section': record.section,
          'total': record.totalStudents,
          'present': record.studentsPresent,
          'absent': record.studentsAbsent,
          'percentage': percentage.toStringAsFixed(1),
        };
      }).toList();

      // Calculate report summary
      _calculateReportSummary(filteredRecords);

      _lastGeneratedReport = AttendanceReport(
        fromDate: fromDate,
        toDate: toDate,
        records: filteredRecords,
      );

      hasGeneratedReport = true;

      return _lastGeneratedReport!;

    } catch (e) {
      throw Exception('Failed to generate report: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateReportSummary(List<AttendanceRecord> records) {
    if (records.isEmpty) {
      reportSummary = {
        'totalRecords': 0,
        'dateRange': '${_formatDate(fromDate)} - ${_formatDate(toDate)}',
        'averageAttendance': '0.0',
        'totalPresent': 0,
        'totalAbsent': 0,
        'totalStudents': 0,
        'totalDays': 0,
        'highestAttendance': '0.0',
      };
      return;
    }

    int totalPresent = records.fold(0, (sum, record) => sum + record.studentsPresent);
    int totalAbsent = records.fold(0, (sum, record) => sum + record.studentsAbsent);
    int totalStudentsCount = records.fold(0, (sum, record) => sum + record.totalStudents);

    double averageAttendance = totalStudentsCount > 0
        ? (totalPresent / totalStudentsCount) * 100
        : 0.0;

    // Find highest attendance percentage
    double highestAttendance = 0.0;
    for (var record in records) {
      if (record.totalStudents > 0) {
        double percentage = (record.studentsPresent / record.totalStudents) * 100;
        if (percentage > highestAttendance) {
          highestAttendance = percentage;
        }
      }
    }

    // Calculate unique days
    Set<String> uniqueDates = records.map((record) => _formatDate(record.date)).toSet();

    reportSummary = {
      'totalRecords': records.length,
      'dateRange': '${_formatDate(fromDate)} - ${_formatDate(toDate)}',
      'averageAttendance': averageAttendance.toStringAsFixed(1),
      'totalPresent': totalPresent,
      'totalAbsent': totalAbsent,
      'totalStudents': totalStudentsCount,
      'totalDays': uniqueDates.length,
      'highestAttendance': highestAttendance.toStringAsFixed(1),
    };
  }

  // Download PDF functionality
  Future<void> downloadPDF() async {
    if (!hasGeneratedReport || _lastGeneratedReport == null) {
      throw Exception('Please generate a report first');
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate PDF generation and download
      await Future.delayed(Duration(seconds: 3));

      // In a real app, this would:
      // 1. Generate PDF using packages like pdf or printing
      // 2. Save to device storage
      // 3. Open file manager or share dialog

      // For now, we'll just simulate the process
      print('PDF generated for ${_lastGeneratedReport!.records.length} records');

    } catch (e) {
      throw Exception('Failed to download PDF: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Share report functionality
  Future<void> shareReport() async {
    if (!hasGeneratedReport || _lastGeneratedReport == null) {
      throw Exception('Please generate a report first');
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate sharing process
      await Future.delayed(Duration(seconds: 2));

      // In a real app, this would:
      // 1. Generate a shareable format (PDF, Excel, etc.)
      // 2. Use share_plus package to share
      // 3. Allow sharing via email, messaging apps, etc.

      print('Report shared successfully');

    } catch (e) {
      throw Exception('Failed to share report: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset report state
  void resetReportState() {
    hasGeneratedReport = false;
    reportSummary = {};
    reportRecords = [];
    _lastGeneratedReport = null;
    reportFilterProgramme = 'All';
    reportFilterYear = 'All';
    notifyListeners();
  }

  // Get attendance percentage for a specific record
  double getAttendancePercentage(AttendanceRecord record) {
    if (record.totalStudents == 0) return 0.0;
    return (record.studentsPresent / record.totalStudents) * 100;
  }

  // Get records for a specific programme and year
  List<AttendanceRecord> getRecordsByClass(String programme, String year, String semester, String section) {
    return _attendanceRecords.where((record) =>
    record.programme == programme &&
        record.year == year &&
        record.semester == semester &&
        record.section == section
    ).toList();
  }

  // Get all unique class combinations
  List<Map<String, String>> getAllClassCombinations() {
    Set<String> combinations = {};
    List<Map<String, String>> result = [];

    for (var record in _attendanceRecords) {
      String combination = '${record.programme}-${record.year}-${record.semester}-${record.section}';
      if (!combinations.contains(combination)) {
        combinations.add(combination);
        result.add({
          'programme': record.programme,
          'year': record.year,
          'semester': record.semester,
          'section': record.section,
        });
      }
    }

    return result;
  }

  // Get attendance statistics for dashboard
  Map<String, dynamic> getAttendanceStatistics() {
    if (_attendanceRecords.isEmpty) {
      return {
        'totalRecords': 0,
        'averageAttendance': 0.0,
        'highestAttendance': 0.0,
        'lowestAttendance': 0.0,
        'totalClasses': 0,
      };
    }

    List<double> attendancePercentages = _attendanceRecords
        .map((record) => getAttendancePercentage(record))
        .toList();

    double totalAttendance = attendancePercentages.reduce((a, b) => a + b);
    double averageAttendance = totalAttendance / attendancePercentages.length;

    return {
      'totalRecords': _attendanceRecords.length,
      'averageAttendance': averageAttendance,
      'highestAttendance': attendancePercentages.reduce((a, b) => a > b ? a : b),
      'lowestAttendance': attendancePercentages.reduce((a, b) => a < b ? a : b),
      'totalClasses': getAllClassCombinations().length,
    };
  }

  @override
  void dispose() {
    dateController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    totalStrengthController.dispose();
    presentController.dispose();
    absentController.dispose();
    super.dispose();
  }
}