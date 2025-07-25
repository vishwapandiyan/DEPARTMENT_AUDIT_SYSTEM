// views/attendance_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/attendence logic.dart';

class AttendanceReportView extends StatefulWidget {
  @override
  _AttendanceReportViewState createState() => _AttendanceReportViewState();
}

class _AttendanceReportViewState extends State<AttendanceReportView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AttendanceController(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            _currentPage == 0 ? 'Add Attendance' : 'Generate Report',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Color(0xFF2C3E50),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _currentPage == 0 ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                if (_currentPage == 0) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ],
        ),
        body: Consumer<AttendanceController>(
          builder: (context, controller, child) {
            return PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildAttendanceEntryPage(context, controller),
                _buildReportGenerationPage(context, controller),
              ],
            );
          },
        ),
        bottomNavigationBar: Consumer<AttendanceController>(
          builder: (context, controller, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentPage,
                backgroundColor: Colors.white,
                selectedItemColor: Color(0xFF2C3E50),
                unselectedItemColor: Colors.grey[400],
                elevation: 0,
                onTap: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle_outline),
                    label: 'Add Attendance',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assessment_outlined),
                    label: 'Generate Report',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAttendanceEntryPage(BuildContext context, AttendanceController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              elevation: 2,
              shadowColor: Colors.grey.withOpacity(0.1),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF2C3E50).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.edit_note, color: Color(0xFF2C3E50), size: 24),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Attendance Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Programme and Year Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Programme',
                            controller.selectedProgramme,
                            controller.programmes,
                            controller.setProgramme,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            'Year',
                            controller.selectedYear,
                            controller.years,
                            controller.setYear,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Semester and Section Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Semester',
                            controller.selectedSemester,
                            controller.semesters,
                            controller.setSemester,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            'Section',
                            controller.selectedSection,
                            controller.sections,
                            controller.setSection,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Total Strength
                    _buildTextFieldInput(
                      'Total Strength',
                      controller.totalStrengthController,
                      'Enter total students',
                      Icons.group_outlined,
                      onChanged: (value) => controller.updateTotalStrength(value),
                    ),
                    SizedBox(height: 16),

                    // Present and Absent Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldInput(
                            'Present',
                            controller.presentController,
                            'Present count',
                            Icons.check_circle_outline,
                            onChanged: (value) => controller.updatePresent(value),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFieldInput(
                            'Absent',
                            controller.absentController,
                            'Absent count',
                            Icons.cancel_outlined,
                            onChanged: (value) => controller.updateAbsent(value),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Validation Error
                    if (controller.hasValidationError)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF5F5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xFFFEB2B2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, color: Color(0xFFDC2626), size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.validationMessage,
                                style: TextStyle(color: Color(0xFFDC2626), fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Summary Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF8FAFC), Color(0xFFEBF4FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem('Total', controller.totalStudents.toString(), Color(0xFF64748B)),
                          _buildSummaryItem('Present', controller.studentsPresent.toString(), Color(0xFF059669)),
                          _buildSummaryItem('Absent', controller.studentsAbsent.toString(), Color(0xFFDC2626)),
                          _buildSummaryItem('Rate', '${controller.attendancePercentage}%', Color(0xFFD97706)),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Date Field
                    _buildDateField(
                      'Date',
                      controller.dateController,
                          () => _selectDate(context, controller),
                    ),
                    SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isLoading || controller.hasValidationError
                            ? null
                            : () => _addAttendanceRecord(context, controller),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2C3E50),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Save Attendance',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportGenerationPage(BuildContext context, AttendanceController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Column(
        children: [
          // Report Generation Card
          Container(
            width: double.infinity,

            child: Card(
              elevation: 2,
              shadowColor: Colors.grey.withOpacity(0.1),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF059669).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.assessment_outlined, color: Color(0xFF059669), size: 24),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Generate Report',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Text(
                      'Date Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                    ),
                    SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            'From Date',
                            controller.fromDateController,
                                () => _selectFromDate(context, controller),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDateField(
                            'To Date',
                            controller.toDateController,
                                () => _selectToDate(context, controller),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Filter Options
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Programme Filter',
                            controller.reportFilterProgramme,
                            ['All', ...controller.programmes],
                            controller.setReportFilterProgramme,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            'Year Filter',
                            controller.reportFilterYear,
                            ['All', ...controller.years],
                            controller.setReportFilterYear,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Generate Report Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isLoading ? null : () => _generateReport(context, controller),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF059669),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.analytics_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Generate Report',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Action Buttons Row
                    if (controller.hasGeneratedReport)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: controller.isLoading ? null : () => _downloadPDF(context, controller),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFFD97706),
                                side: BorderSide(color: Color(0xFFD97706)),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Icon(Icons.download_outlined, size: 18),
                              label: Text('PDF', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: controller.isLoading ? null : () => _shareReport(context, controller),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFF3B82F6),
                                side: BorderSide(color: Color(0xFF3B82F6)),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Icon(Icons.share_outlined, size: 18),
                              label: Text('Share', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Report Display Section
          if (controller.hasGeneratedReport) ...[
            SizedBox(height: 16),
            Card(
              elevation: 2,
              shadowColor: Colors.grey.withOpacity(0.1),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.table_chart_outlined, color: Color(0xFF059669), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Attendance Report',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Date Range: ${controller.reportSummary['dateRange']}',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                    SizedBox(height: 16),

                    // Responsive Report Table
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildCompactHeaderCell('S.No', 50),
                                  _buildCompactHeaderCell('Date', 90),
                                  _buildCompactHeaderCell('Programme', 80),
                                  _buildCompactHeaderCell('Y/S/Sec', 70),
                                  _buildCompactHeaderCell('Total', 50),
                                  _buildCompactHeaderCell('Present', 60),
                                  _buildCompactHeaderCell('Absent', 50),
                                  _buildCompactHeaderCell('%', 40),
                                ],
                              ),
                            ),
                          ),
                          // Table Rows
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: controller.reportRecords.asMap().entries.map((entry) {
                                int index = entry.key;
                                var record = entry.value;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: index % 2 == 0 ? Color(0xFFFAFAFA) : Colors.white,
                                    border: Border(
                                      bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildCompactDataCell('${index + 1}', 50),
                                      _buildCompactDataCell(record['date'] ?? '', 90),
                                      _buildCompactDataCell(record['programme'] ?? '', 80),
                                      _buildCompactDataCell('${record['year']}/${record['semester']}/${record['section']}', 70),
                                      _buildCompactDataCell('${record['total']}', 50),
                                      _buildCompactDataCell('${record['present']}', 60),
                                      _buildCompactDataCell('${record['absent']}', 50),
                                      _buildCompactDataCell('${record['percentage']}%', 40),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Report Summary
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFBBF7D0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF059669),
                            ),
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 20,
                            runSpacing: 12,
                            children: [
                              _buildSummaryColumn('Records', '${controller.reportSummary['totalRecords']}'),
                              _buildSummaryColumn('Avg. Attendance', '${controller.reportSummary['averageAttendance']}%'),
                              _buildSummaryColumn('Days', '${controller.reportSummary['totalDays']}'),
                              _buildSummaryColumn('Highest', '${controller.reportSummary['highestAttendance']}%'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextFieldInput(String label, TextEditingController controller, String hint, IconData icon, {Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
        ),
        SizedBox(height: 6),
        Container(
          height: 48,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              prefixIcon: Icon(icon, color: Color(0xFF6B7280), size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF2C3E50), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
        ),
        SizedBox(height: 6),
        Container(
          height: 48,
          child: TextFormField(
            controller: controller,
            readOnly: true,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Select date',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: Icon(Icons.calendar_today_outlined, color: Color(0xFF6B7280), size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF2C3E50), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF059669),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF059669),
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCompactDataCell(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: Color(0xFF374151)),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF374151)),
        ),
        SizedBox(height: 6),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                'Select $label',
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              ),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 20),
              style: TextStyle(color: Color(0xFF374151), fontSize: 14),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, AttendanceController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Color(0xFF2C3E50),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.setDate(picked);
    }
  }

  Future<void> _selectFromDate(BuildContext context, AttendanceController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Color(0xFF059669),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.setFromDate(picked);
    }
  }

  Future<void> _selectToDate(BuildContext context, AttendanceController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.toDate,
      firstDate: controller.fromDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Color(0xFF059669),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.setToDate(picked);
    }
  }

  Future<void> _addAttendanceRecord(BuildContext context, AttendanceController controller) async {
    try {
      await controller.addAttendanceRecord();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Attendance record saved successfully!'),
            ],
          ),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('Failed to save: $e')),
            ],
          ),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _generateReport(BuildContext context, AttendanceController controller) async {
    try {
      final report = await controller.generateReport();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.analytics, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Report generated! ${report.records.length} records found.'),
            ],
          ),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('Report generation failed: $e')),
            ],
          ),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _downloadPDF(BuildContext context, AttendanceController controller) async {
    try {
      await controller.downloadPDF();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.download_done, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('PDF downloaded successfully!'),
            ],
          ),
          backgroundColor: Color(0xFFD97706),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('PDF download failed: $e')),
            ],
          ),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _shareReport(BuildContext context, AttendanceController controller) async {
    try {
      await controller.shareReport();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.share, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Report shared successfully!'),
            ],
          ),
          backgroundColor: Color(0xFF3B82F6),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('Share failed: $e')),
            ],
          ),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }
}