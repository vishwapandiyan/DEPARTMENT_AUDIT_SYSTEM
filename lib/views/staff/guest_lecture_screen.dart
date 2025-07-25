import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class GuestLectureScreen extends StatefulWidget {
  const GuestLectureScreen({Key? key}) : super(key: key);

  @override
  _GuestLectureScreenState createState() => _GuestLectureScreenState();
}

class _GuestLectureScreenState extends State<GuestLectureScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _lectures = [];
  final List<String> _academicYears = ['2020-2021', '2021-2022', '2022-2023', '2023-2024'];
  final List<String> _semesters = ['Semester 1', 'Semester 2', 'Semester 3', 'Semester 4', 'Semester 5', 'Semester 6', 'Semester 7', 'Semester 8'];

  // Professional Color Palette
  static const Color primaryBlue = Color(0xFF1e40af);
  static const Color softBlue = Color(0xFFdbeafe);
  static const Color textDark = Color(0xFF1f2937);
  static const Color textLight = Color(0xFF6b7280);

  String? _selectedAcademicYear;
  String? _selectedSemester;
  DateTimeRange? _selectedDateRange;
  List<String> _selectedFilters = [];

  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _resourceController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _studentsController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  DateTime? _eventDate;
  List<String> _photoPaths = [];

  @override
  void initState() {
    super.initState();
    // Add some dummy data
    _lectures.addAll([
      {
        'sno': 1,
        'title': 'AI in Education',
        'date': DateTime(2023, 5, 15),
        'resource': 'Dr. Smith',
        'venue': 'Main Auditorium',
        'budget': '5000',
        'students': '120',
        'photos': ['photo1.jpg', 'photo2.jpg'],
        'report': 'The lecture was about applications of AI in modern education systems.',
        'academicYear': '2022-2023',
        'semester': 'Semester 2',
      },
      {
        'sno': 2,
        'title': 'Blockchain Technology',
        'date': DateTime(2023, 8, 20),
        'resource': 'Prof. Johnson',
        'venue': 'Seminar Hall',
        'budget': '7500',
        'students': '85',
        'photos': ['photo3.jpg', 'photo4.jpg'],
        'report': 'Introduction to blockchain and its real-world applications.',
        'academicYear': '2022-2023',
        'semester': 'Semester 3',
      },
    ]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _resourceController.dispose();
    _venueController.dispose();
    _budgetController.dispose();
    _studentsController.dispose();
    _reportController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textDark,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textDark,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _selectedFilters = [];
      if (_selectedAcademicYear != null) {
        _selectedFilters.add(_selectedAcademicYear!);
      }
      if (_selectedSemester != null) {
        _selectedFilters.add(_selectedSemester!);
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedAcademicYear = null;
      _selectedSemester = null;
      _selectedDateRange = null;
      _selectedFilters = [];
    });
  }

  void _addLecture() {
    if (_formKey.currentState!.validate() && _photoPaths.length >= 2) {
      final newLecture = {
        'sno': _lectures.length + 1,
        'title': _titleController.text,
        'date': _eventDate!,
        'resource': _resourceController.text,
        'venue': _venueController.text,
        'budget': _budgetController.text,
        'students': _studentsController.text,
        'photos': _photoPaths,
        'report': _reportController.text,
        'academicYear': _selectedAcademicYear ?? 'Not specified',
        'semester': _selectedSemester ?? 'Not specified',
      };

      setState(() {
        _lectures.add(newLecture);
        _resetForm();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Guest lecture added successfully!'),
          backgroundColor: primaryBlue,
        ),
      );
    }
  }

  void _resetForm() {
    _titleController.clear();
    _resourceController.clear();
    _venueController.clear();
    _budgetController.clear();
    _studentsController.clear();
    _reportController.clear();
    _eventDate = null;
    _photoPaths = [];
    _formKey.currentState?.reset();
  }

  void _pickPhotos() async {
    setState(() {
      _photoPaths.add('photo_${_photoPaths.length + 1}.jpg');
      if (_photoPaths.length < 2) {
        _photoPaths.add('photo_${_photoPaths.length + 1}.jpg');
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredLectures() {
    return _lectures.where((lecture) {
      bool matches = true;

      if (_selectedAcademicYear != null) {
        matches = matches && (lecture['academicYear'] == _selectedAcademicYear);
      }

      if (_selectedSemester != null) {
        matches = matches && (lecture['semester'] == _selectedSemester);
      }

      if (_selectedDateRange != null) {
        final date = lecture['date'] as DateTime;
        matches = matches &&
            (date.isAfter(_selectedDateRange!.start) || date.isAtSameMomentAs(_selectedDateRange!.start)) &&
            (date.isBefore(_selectedDateRange!.end) || date.isAtSameMomentAs(_selectedDateRange!.end));
      }

      return matches;
    }).toList();
  }

  Future<void> _downloadReport(Map<String, dynamic> lecture) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading report for ${lecture['title']}...'),
        backgroundColor: primaryBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredLectures = _getFilteredLectures();

    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Lectures Organized'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              if (filteredLectures.isNotEmpty) {
                _downloadReport(filteredLectures.first);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Lectures',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterDropdown(
                            value: _selectedAcademicYear,
                            hint: 'Academic Year',
                            items: _academicYears,
                            onChanged: (value) {
                              setState(() {
                                _selectedAcademicYear = value;
                                _applyFilters();
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildFilterDropdown(
                            value: _selectedSemester,
                            hint: 'Semester',
                            items: _semesters,
                            onChanged: (value) {
                              setState(() {
                                _selectedSemester = value;
                                _applyFilters();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _selectDateRange(context),
                            child: Text(
                              _selectedDateRange == null
                                  ? 'Select Date Range'
                                  : '${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}',
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _resetFilters,
                          child: Text('Reset'),
                        ),
                      ],
                    ),
                    if (_selectedFilters.isNotEmpty) ...[
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _selectedFilters.map((filter) {
                          return Chip(
                            label: Text(filter),
                            backgroundColor: softBlue,
                            onDeleted: () {
                              setState(() {
                                if (filter == _selectedAcademicYear) {
                                  _selectedAcademicYear = null;
                                } else if (filter == _selectedSemester) {
                                  _selectedSemester = null;
                                }
                                _selectedFilters.remove(filter);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Add New Lecture Form
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Guest Lecture',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: _buildInputDecoration('Title of Lecture'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _resourceController,
                              decoration: _buildInputDecoration('Name of Resource Person'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter resource person name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: _buildInputDecoration(
                                    'Date of Event',
                                    suffixIcon: Icon(Icons.calendar_today, size: 20),
                                  ),
                                  controller: TextEditingController(
                                    text: _eventDate == null ? '' : DateFormat('dd/MM/yyyy').format(_eventDate!),
                                  ),
                                  validator: (value) {
                                    if (_eventDate == null) {
                                      return 'Please select a date';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _venueController,
                              decoration: _buildInputDecoration('Venue'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter venue';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _budgetController,
                              decoration: _buildInputDecoration('Budget (₹)'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter budget';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _studentsController,
                        decoration: _buildInputDecoration('Student Strength'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter student strength';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Photos (Minimum 2 required)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          ..._photoPaths.map((path) => Chip(
                            label: Text(path, style: TextStyle(fontSize: 12)),
                            backgroundColor: softBlue,
                            onDeleted: () {
                              setState(() {
                                _photoPaths.remove(path);
                              });
                            },
                          )),
                          ElevatedButton.icon(
                            onPressed: _pickPhotos,
                            icon: Icon(Icons.add_a_photo, size: 16),
                            label: Text('Add Photos'),
                          ),
                        ],
                      ),
                      if (_photoPaths.length < 2)
                        Text(
                          'Please add at least 2 photos',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _reportController,
                        decoration: _buildInputDecoration('Report'),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a report';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _addLecture,
                          child: Text('Submit Lecture Details'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Lectures List
            Text(
              'Guest Lectures (${filteredLectures.length})',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            if (filteredLectures.isEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: softBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('No lectures found for selected filters'),
                ),
              ),
            if (filteredLectures.isNotEmpty)
              ...filteredLectures.map((lecture) {
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('S.No: ${lecture['sno']}'),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: softBlue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                DateFormat('dd MMM yyyy').format(lecture['date']),
                                style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          lecture['title'],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        _buildDetailRow(Icons.person_outline, 'Resource Person: ${lecture['resource']}'),
                        _buildDetailRow(Icons.location_on_outlined, 'Venue: ${lecture['venue']}'),
                        _buildDetailRow(Icons.attach_money_outlined, 'Budget: ₹${lecture['budget']}'),
                        _buildDetailRow(Icons.people_outline, 'Students: ${lecture['students']}'),
                        _buildDetailRow(Icons.calendar_today_outlined, 'Academic Year: ${lecture['academicYear']}'),
                        _buildDetailRow(Icons.school_outlined, 'Semester: ${lecture['semester']}'),
                        SizedBox(height: 16),
                        if (lecture['photos'] != null && (lecture['photos'] as List).isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Photos:', style: TextStyle(fontWeight: FontWeight.w500)),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: (lecture['photos'] as List).map((photo) {
                                  return Chip(
                                    label: Text(photo, style: TextStyle(fontSize: 12)),
                                    backgroundColor: softBlue,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        SizedBox(height: 16),
                        Text('Report:', style: TextStyle(fontWeight: FontWeight.w500)),
                        SizedBox(height: 4),
                        Text(lecture['report']),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => _downloadReport(lecture),
                            icon: Icon(Icons.download, size: 16),
                            label: Text('Download Report'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintText: hint,
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  InputDecoration _buildInputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textLight),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}