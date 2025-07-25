// controllers/guest_lecture_controller.dart
import 'package:flutter/material.dart';
import '../models/guest_lecture_model.dart';

class GuestLectureController extends ChangeNotifier {
  final List<GuestLecture> _lectures = [];
  final List<String> _academicYears = ['2020-2021', '2021-2022', '2022-2023', '2023-2024'];
  final List<String> _semesters = ['Semester 1', 'Semester 2', 'Semester 3', 'Semester 4', 'Semester 5', 'Semester 6', 'Semester 7', 'Semester 8'];

  String? _selectedAcademicYear;
  String? _selectedSemester;
  DateTimeRange? _selectedDateRange;
  List<String> _selectedFilters = [];
  DateTime? _eventDate;
  List<String> _photoPaths = [];

  // Getters
  List<GuestLecture> get lectures => _lectures;
  List<String> get academicYears => _academicYears;
  List<String> get semesters => _semesters;
  String? get selectedAcademicYear => _selectedAcademicYear;
  String? get selectedSemester => _selectedSemester;
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  List<String> get selectedFilters => _selectedFilters;
  DateTime? get eventDate => _eventDate;
  List<String> get photoPaths => _photoPaths;

  GuestLectureController() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _lectures.addAll([
      GuestLecture(
        sno: 1,
        title: 'AI in Education',
        date: DateTime(2023, 5, 15),
        resource: 'Dr. Smith',
        venue: 'Main Auditorium',
        budget: '5000',
        students: '120',
        photos: ['photo1.jpg', 'photo2.jpg'],
        report: 'The lecture was about applications of AI in modern education systems.',
        academicYear: '2022-2023',
        semester: 'Semester 2',
      ),
      GuestLecture(
        sno: 2,
        title: 'Blockchain Technology',
        date: DateTime(2023, 8, 20),
        resource: 'Prof. Johnson',
        venue: 'Seminar Hall',
        budget: '7500',
        students: '85',
        photos: ['photo3.jpg', 'photo4.jpg'],
        report: 'Introduction to blockchain and its real-world applications.',
        academicYear: '2022-2023',
        semester: 'Semester 3',
      ),
    ]);
  }

  void setSelectedAcademicYear(String? year) {
    _selectedAcademicYear = year;
    _applyFilters();
    notifyListeners();
  }

  void setSelectedSemester(String? semester) {
    _selectedSemester = semester;
    _applyFilters();
    notifyListeners();
  }

  void setSelectedDateRange(DateTimeRange? dateRange) {
    _selectedDateRange = dateRange;
    _applyFilters();
    notifyListeners();
  }

  void setEventDate(DateTime? date) {
    _eventDate = date;
    notifyListeners();
  }

  void _applyFilters() {
    _selectedFilters = [];
    if (_selectedAcademicYear != null) {
      _selectedFilters.add(_selectedAcademicYear!);
    }
    if (_selectedSemester != null) {
      _selectedFilters.add(_selectedSemester!);
    }
  }

  void resetFilters() {
    _selectedAcademicYear = null;
    _selectedSemester = null;
    _selectedDateRange = null;
    _selectedFilters = [];
    notifyListeners();
  }

  void removeFilter(String filter) {
    if (filter == _selectedAcademicYear) {
      _selectedAcademicYear = null;
    } else if (filter == _selectedSemester) {
      _selectedSemester = null;
    }
    _selectedFilters.remove(filter);
    notifyListeners();
  }

  void addPhotos() {
    _photoPaths.add('photo_${_photoPaths.length + 1}.jpg');
    if (_photoPaths.length < 2) {
      _photoPaths.add('photo_${_photoPaths.length + 1}.jpg');
    }
    notifyListeners();
  }

  void removePhoto(String path) {
    _photoPaths.remove(path);
    notifyListeners();
  }

  void addLecture({
    required String title,
    required String resource,
    required String venue,
    required String budget,
    required String students,
    required String report,
  }) {
    final newLecture = GuestLecture(
      sno: _lectures.length + 1,
      title: title,
      date: _eventDate!,
      resource: resource,
      venue: venue,
      budget: budget,
      students: students,
      photos: List.from(_photoPaths),
      report: report,
      academicYear: _selectedAcademicYear ?? 'Not specified',
      semester: _selectedSemester ?? 'Not specified',
    );

    _lectures.add(newLecture);
    resetForm();
    notifyListeners();
  }

  void resetForm() {
    _eventDate = null;
    _photoPaths = [];
  }

  List<GuestLecture> getFilteredLectures() {
    return _lectures.where((lecture) {
      bool matches = true;

      if (_selectedAcademicYear != null) {
        matches = matches && (lecture.academicYear == _selectedAcademicYear);
      }

      if (_selectedSemester != null) {
        matches = matches && (lecture.semester == _selectedSemester);
      }

      if (_selectedDateRange != null) {
        final date = lecture.date;
        matches = matches &&
            (date.isAfter(_selectedDateRange!.start) || date.isAtSameMomentAs(_selectedDateRange!.start)) &&
            (date.isBefore(_selectedDateRange!.end) || date.isAtSameMomentAs(_selectedDateRange!.end));
      }

      return matches;
    }).toList();
  }

  void downloadReport(GuestLecture lecture) {
    // In a real app, this would generate and download a PDF
    // Implementation would go here
  }
}