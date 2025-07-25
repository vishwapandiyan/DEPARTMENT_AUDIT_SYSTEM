// controllers/publication_controller.dart

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/publication_model.dart';

class PublicationController extends ChangeNotifier {
  // Form controllers
  final titleController = TextEditingController();
  final journalController = TextEditingController();
  final conferenceController = TextEditingController();
  final identifierController = TextEditingController();
  final publicationLinkController = TextEditingController();

  // Form state
  String? selectedYear;
  String? selectedFormat;
  String? selectedIdentifierType;
  String? selectedPublicationType; // Journal or Conference
  String? proofFilePath;
  String? proofFileName;

  bool isLoading = false;
  String? errorMessage;

  List<Publication> publications = [];

  // Dropdown options
  final List<String> publicationTypes = ['Journal', 'Conference'];

  final List<String> formats = [
    'IEEE',
    'Springer',
    'ACM',
    'Elsevier',
    'Nature',
    'Science',
    'MDPI',
    'Taylor & Francis',
    'Wiley',
    'Other'
  ];

  final List<String> identifierTypes = [
    'DOI',
    'ISBN',
    'ISSN',
    'PMID',
    'arXiv',
    'Other'
  ];

  // Generate years from current year to 50 years back
  List<String> get years {
    final currentYear = DateTime.now().year;
    return List.generate(50, (index) => (currentYear - index).toString());
  }

  // Validation
  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Year of publication is required';
    }
    return null;
  }

  String? validateFormat(String? value) {
    if (value == null || value.isEmpty) {
      return 'Publication format is required';
    }
    return null;
  }

  String? validateIdentifierType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Identifier type is required';
    }
    return null;
  }

  String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Identifier is required';
    }
    return null;
  }

  String? validatePublicationType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Publication type is required';
    }
    return null;
  }

  String? validateJournalOrConference() {
    if (selectedPublicationType == 'Journal' &&
        (journalController.text.trim().isEmpty)) {
      return 'Journal name is required';
    }
    if (selectedPublicationType == 'Conference' &&
        (conferenceController.text.trim().isEmpty)) {
      return 'Conference name is required';
    }
    return null;
  }

  // File picker for proof upload
  Future<void> pickProofFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        proofFilePath = result.files.single.path;
        proofFileName = result.files.single.name;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Error picking file: $e';
      notifyListeners();
    }
  }

  // Remove selected proof file
  void removeProofFile() {
    proofFilePath = null;
    proofFileName = null;
    notifyListeners();
  }

  // Set dropdown values
  void setPublicationType(String? value) {
    selectedPublicationType = value;
    // Clear the opposite field when switching types
    if (value == 'Journal') {
      conferenceController.clear();
    } else if (value == 'Conference') {
      journalController.clear();
    }
    notifyListeners();
  }

  void setYear(String? value) {
    selectedYear = value;
    notifyListeners();
  }

  void setFormat(String? value) {
    selectedFormat = value;
    notifyListeners();
  }

  void setIdentifierType(String? value) {
    selectedIdentifierType = value;
    notifyListeners();
  }

  // Form submission
  Future<bool> submitPublication() async {
    errorMessage = null;

    // Validate all fields
    if (!_validateForm()) {
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Create publication object
      final publication = Publication(
        title: titleController.text.trim(),
        journal: selectedPublicationType == 'Journal' ? journalController.text.trim() : null,
        conference: selectedPublicationType == 'Conference' ? conferenceController.text.trim() : null,
        yearOfPublication: selectedYear!,
        format: selectedFormat!,
        identifierType: selectedIdentifierType!,
        identifier: identifierController.text.trim(),
        proofFilePath: proofFilePath,
        publicationLink: publicationLinkController.text.trim().isEmpty
            ? null
            : publicationLinkController.text.trim(),
      );

      // Add to list (in real app, save to database)
      publications.add(publication);

      // Clear form after successful submission
      clearForm();

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = 'Error submitting publication: $e';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool _validateForm() {
    if (validateTitle(titleController.text) != null) {
      errorMessage = validateTitle(titleController.text);
      return false;
    }

    if (validatePublicationType(selectedPublicationType) != null) {
      errorMessage = validatePublicationType(selectedPublicationType);
      return false;
    }

    final journalConferenceError = validateJournalOrConference();
    if (journalConferenceError != null) {
      errorMessage = journalConferenceError;
      return false;
    }

    if (validateYear(selectedYear) != null) {
      errorMessage = validateYear(selectedYear);
      return false;
    }

    if (validateFormat(selectedFormat) != null) {
      errorMessage = validateFormat(selectedFormat);
      return false;
    }

    if (validateIdentifierType(selectedIdentifierType) != null) {
      errorMessage = validateIdentifierType(selectedIdentifierType);
      return false;
    }

    if (validateIdentifier(identifierController.text) != null) {
      errorMessage = validateIdentifier(identifierController.text);
      return false;
    }

    return true;
  }

  // Clear form
  void clearForm() {
    titleController.clear();
    journalController.clear();
    conferenceController.clear();
    identifierController.clear();
    publicationLinkController.clear();

    selectedYear = null;
    selectedFormat = null;
    selectedIdentifierType = null;
    selectedPublicationType = null;
    proofFilePath = null;
    proofFileName = null;
    errorMessage = null;

    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    journalController.dispose();
    conferenceController.dispose();
    identifierController.dispose();
    publicationLinkController.dispose();
    super.dispose();
  }
}