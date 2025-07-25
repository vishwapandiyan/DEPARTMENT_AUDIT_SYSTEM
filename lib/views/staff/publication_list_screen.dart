// views/publication_form_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/publication_logic.dart';

class PublicationFormPage extends StatelessWidget {
  const PublicationFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PublicationController(),
      child: const PublicationFormView(),
    );
  }
}

class PublicationFormView extends StatelessWidget {
  const PublicationFormView({Key? key}) : super(key: key);

  // Professional color scheme
  static const Color _primaryColor = Color(0xFF2563EB); // Professional blue
  static const Color _primaryLight = Color(0xFF3B82F6);
  static const Color _backgroundGrey = Color(0xFFF8FAFC);
  static const Color _cardBackground = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1E293B);
  static const Color _textSecondary = Color(0xFF64748B);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _errorColor = Color(0xFFDC2626);
  static const Color _successColor = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundGrey,
      appBar: AppBar(
        title: const Text(
          'Add Publication',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: _cardBackground,
        foregroundColor: _textPrimary,
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: _borderColor,
          ),
        ),
      ),
      body: Consumer<PublicationController>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: _cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.article_outlined,
                              color: _primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Publication Details',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: _textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Please fill out the form below to add your publication',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Form Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: _cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Error message
                      if (controller.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: _errorColor.withOpacity(0.05),
                            border: Border.all(color: _errorColor.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.error_outline,
                                  color: _errorColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  controller.errorMessage!,
                                  style: TextStyle(
                                    color: _errorColor,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Title
                      _buildTextField(
                        controller: controller.titleController,
                        label: 'Publication Title',
                        hint: 'Enter the title of your publication',
                        icon: Icons.title_outlined,
                        required: true,
                      ),
                      const SizedBox(height: 24),

                      // Publication Type
                      _buildDropdown<String>(
                        value: controller.selectedPublicationType,
                        items: controller.publicationTypes,
                        label: 'Publication Type',
                        hint: 'Select publication type',
                        icon: Icons.category_outlined,
                        onChanged: controller.setPublicationType,
                        required: true,
                      ),
                      const SizedBox(height: 24),

                      // Conditional Journal/Conference field
                      if (controller.selectedPublicationType == 'Journal')
                        Column(
                          children: [
                            _buildTextField(
                              controller: controller.journalController,
                              label: 'Journal Name',
                              hint: 'Enter journal name',
                              icon: Icons.library_books_outlined,
                              required: true,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),

                      if (controller.selectedPublicationType == 'Conference')
                        Column(
                          children: [
                            _buildTextField(
                              controller: controller.conferenceController,
                              label: 'Conference Name',
                              hint: 'Enter conference name',
                              icon: Icons.event_outlined,
                              required: true,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),

                      // Year and Format Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown<String>(
                              value: controller.selectedYear,
                              items: controller.years,
                              label: 'Year of Publication',
                              hint: 'Select year',
                              icon: Icons.calendar_today_outlined,
                              onChanged: controller.setYear,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown<String>(
                              value: controller.selectedFormat,
                              items: controller.formats,
                              label: 'Publication Format',
                              hint: 'Select format',
                              icon: Icons.format_align_left_outlined,
                              onChanged: controller.setFormat,
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Identifier Type
                      _buildDropdown<String>(
                        value: controller.selectedIdentifierType,
                        items: controller.identifierTypes,
                        label: 'Identifier Type',
                        hint: 'Select identifier type',
                        icon: Icons.fingerprint_outlined,
                        onChanged: controller.setIdentifierType,
                        required: true,
                      ),
                      const SizedBox(height: 24),

                      // Identifier
                      _buildTextField(
                        controller: controller.identifierController,
                        label: '${controller.selectedIdentifierType ?? 'Identifier'} Number/Link',
                        hint: 'Enter ${controller.selectedIdentifierType?.toLowerCase() ?? 'identifier'} number or link',
                        icon: Icons.link_outlined,
                        required: true,
                      ),
                      const SizedBox(height: 24),

                      // Publication Link
                      _buildTextField(
                        controller: controller.publicationLinkController,
                        label: 'Publication Link',
                        hint: 'Enter direct link to publication (optional)',
                        icon: Icons.open_in_new_outlined,
                      ),
                      const SizedBox(height: 24),

                      // Proof Upload
                      _buildProofUploadSection(context, controller),
                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: controller.isLoading ? null : () => _submitForm(context, controller),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: _textSecondary.withOpacity(0.3),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ),
                              child: controller.isLoading
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Submitting...',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                                  : Text(
                                'Submit Publication',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextButton(
                              onPressed: controller.isLoading ? null : controller.clearForm,
                              style: TextButton.styleFrom(
                                foregroundColor: _textSecondary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: _borderColor),
                                ),
                              ),
                              child: Text(
                                'Clear Form',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: _textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: _errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          style: TextStyle(
            fontSize: 15,
            color: _textPrimary,
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: _textSecondary.withOpacity(0.7),
              fontSize: 15,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color: _textSecondary,
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required String label,
    required String hint,
    required IconData icon,
    required Function(T?) onChanged,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: _textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: _errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                item.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: _textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 15,
            color: _textPrimary,
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: _textSecondary.withOpacity(0.7),
              fontSize: 15,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color: _textSecondary,
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _textSecondary,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildProofUploadSection(BuildContext context, PublicationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proof Document',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: _textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Upload supporting documentation (optional)',
          style: TextStyle(
            fontSize: 13,
            color: _textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: controller.proofFilePath == null
                  ? _borderColor
                  : _primaryColor.withOpacity(0.3),
              width: controller.proofFilePath == null ? 1 : 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: controller.proofFilePath == null
                ? _backgroundGrey
                : _primaryColor.withOpacity(0.03),
          ),
          child: controller.proofFilePath == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _textSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.upload_file_outlined,
                  size: 32,
                  color: _textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Drop files here or click to browse',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Supported formats: PDF, DOC, DOCX, JPG, PNG',
                style: TextStyle(
                  fontSize: 13,
                  color: _textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: controller.pickProofFile,
                icon: Icon(Icons.attach_file_outlined, size: 18),
                label: Text(
                  'Choose File',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          )
              : Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.insert_drive_file_outlined,
                  color: _primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.proofFileName ?? 'File selected',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'File uploaded successfully',
                      style: TextStyle(
                        fontSize: 13,
                        color: _successColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: controller.removeProofFile,
                icon: Icon(
                  Icons.close_rounded,
                  color: _textSecondary,
                  size: 20,
                ),
                tooltip: 'Remove file',
                style: IconButton.styleFrom(
                  backgroundColor: _textSecondary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm(BuildContext context, PublicationController controller) async {
    final success = await controller.submitPublication();

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(
                'Publication submitted successfully!',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: _successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}