import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/code_of_conduct_logic.dart';
import '../../models/code_fo_conduct_model.dart';

class CodeOfConductScreen extends StatefulWidget {
  final String? userName; // Optional username parameter

  const CodeOfConductScreen({Key? key, this.userName}) : super(key: key);

  @override
  State<CodeOfConductScreen> createState() => _CodeOfConductScreenState();
}

class _CodeOfConductScreenState extends State<CodeOfConductScreen>
    with TickerProviderStateMixin {
  final TextEditingController _queryController = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CodeConductController(),
      child: Scaffold(
        backgroundColor: CodeConductData.softBlue,
        appBar: AppBar(
          title: const Text('Code of Conduct', style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: CodeConductData.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Consumer<CodeConductController>(
            builder: (context, controller, child) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: 16),
                    _buildFilterSection(controller),
                    const SizedBox(height: 16),
                    _buildUploadButton(controller),
                    const SizedBox(height: 16),
                    if (controller.uploadedDocuments.values.any((docs) => docs.isNotEmpty))
                      _buildUploadedDocuments(controller),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    // Get display name - use provided userName or default to "User"
    final displayName = widget.userName ?? "User";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CodeConductData.primaryBlue.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CodeConductData.primaryBlue.withOpacity(0.1),
            ),
            child: Icon(Icons.person_outline, color: CodeConductData.primaryBlue, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $displayName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: CodeConductData.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Code of Conduct Management',
                  style: TextStyle(
                    fontSize: 13,
                    color: CodeConductData.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(CodeConductController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CodeConductData.primaryBlue.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_alt_outlined, size: 18, color: CodeConductData.primaryBlue),
              const SizedBox(width: 8),
              const Text(
                'Document Filters',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CodeConductData.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCompactDropdown(
                  value: controller.selectedAcademicYear,
                  items: CodeConductData.getAcademicYears(),
                  hint: 'Academic Year',
                  onChanged: controller.setAcademicYear,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCompactDropdown(
                  value: controller.selectedSemesterType,
                  items: CodeConductData.getSemesterTypes(),
                  hint: 'Semester Type',
                  onChanged: controller.setSemesterType,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCompactDropdown(
                  value: controller.selectedSemester,
                  items: controller.getSemesterOptions(),
                  hint: 'Semester',
                  onChanged: controller.setSemester,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(CodeConductController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showUploadOptions(controller),
        icon: const Icon(Icons.upload_outlined, size: 20),
        label: const Text('Upload Documents'),
        style: ElevatedButton.styleFrom(
          backgroundColor: CodeConductData.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildUploadedDocuments(CodeConductController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CodeConductData.primaryBlue.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_outlined, size: 18, color: CodeConductData.primaryBlue),
              const SizedBox(width: 8),
              const Text(
                'Uploaded Documents',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CodeConductData.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...controller.uploadOptions.map((option) {
            final files = controller.uploadedDocuments[option.id] ?? [];
            if (files.isEmpty) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: option.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(option.icon, size: 18, color: option.color),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: CodeConductData.textDark,
                          ),
                        ),
                        Text(
                          files.take(2).join(', ') + (files.length > 2 ? '...' : ''),
                          style: const TextStyle(
                            fontSize: 12,
                            color: CodeConductData.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${files.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: option.color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }


  Widget _buildCompactDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: CodeConductData.borderColor),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: CodeConductData.textLight),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: CodeConductData.textDark),
            ),
          );
        }).toList(),
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 13, color: CodeConductData.textLight),
        ),
        onChanged: onChanged,
      ),
    );
  }

  void _showUploadOptions(CodeConductController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  Icon(Icons.upload_outlined, size: 24, color: CodeConductData.primaryBlue),
                  SizedBox(width: 12),
                  Text(
                    'Upload Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CodeConductData.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.uploadOptions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final option = controller.uploadOptions[index];
                  final uploadedCount = controller.uploadedDocuments[option.id]?.length ?? 0;

                  return Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: CodeConductData.borderColor),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.pop(context);
                        controller.handleFileUpload(option, context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: option.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(option.icon, size: 20, color: option.color),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: CodeConductData.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    option.subtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: CodeConductData.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (uploadedCount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: option.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$uploadedCount',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: option.color,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}