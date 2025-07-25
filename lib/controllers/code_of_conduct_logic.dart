import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/code_fo_conduct_model.dart';

class CodeConductController extends ChangeNotifier {
  String? _selectedAcademicYear;
  String? _selectedSemesterType;
  String? _selectedSemester;
  Map<String, List<String>> _uploadedDocuments = {};
  List<UploadOption> _uploadOptions = CodeConductData.getUploadOptions();

  // Getters
  String? get selectedAcademicYear => _selectedAcademicYear;
  String? get selectedSemesterType => _selectedSemesterType;
  String? get selectedSemester => _selectedSemester;
  Map<String, List<String>> get uploadedDocuments => _uploadedDocuments;
  List<UploadOption> get uploadOptions => _uploadOptions;

  // Setters
  void setAcademicYear(String? year) {
    _selectedAcademicYear = year;
    notifyListeners();
  }

  void setSemesterType(String? type) {
    _selectedSemesterType = type;
    notifyListeners();
  }

  void setSemester(String? semester) {
    _selectedSemester = semester;
    notifyListeners();
  }

  // Get semester options based on selected semester type
  List<String> getSemesterOptions() {
    if (_selectedSemesterType == null) return [];

    switch (_selectedSemesterType) {
      case 'Regular':
        return ['Semester 1', 'Semester 2', 'Semester 3', 'Semester 4'];
      case 'Supplementary':
        return ['Supplementary 1', 'Supplementary 2'];
      case 'Special':
        return ['Special Session 1', 'Special Session 2'];
      default:
        return [];
    }
  }

  // Handle file upload
  Future<void> handleFileUpload(UploadOption option, BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        List<String> fileNames = result.files.map((file) => file.name).toList();

        if (_uploadedDocuments[option.id] == null) {
          _uploadedDocuments[option.id] = [];
        }

        _uploadedDocuments[option.id]!.addAll(fileNames);
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${fileNames.length} files uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading files: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Submit query
  void submitQuery(String query, BuildContext context) {
    if (query.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a query'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Here you would typically send the query to your backend
    // For now, we'll just show a confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Query submitted: ${query.length > 30 ? query.substring(0, 30) + '...' : query}'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}