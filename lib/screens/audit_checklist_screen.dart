import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';
import '../models/user.dart';
import '../models/audit_item.dart';
import '../models/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/audit_item_dialog.dart';

class AuditChecklistScreen extends StatefulWidget {
  final User user;

  const AuditChecklistScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AuditChecklistScreen> createState() => _AuditChecklistScreenState();
}

class _AuditChecklistScreenState extends State<AuditChecklistScreen> {
  List<AuditItem> _auditItems = [];
  List<AuditItem> _filteredItems = [];
  Set<int> _modifiedItems = {};
  bool _isLoading = true;
  bool _isSaving = false;
  
  // Filter state
  String _filterStatus = 'all'; // all, completed, pending
  String _searchQuery = '';
  DateTimeRange? _dateRange;
  String _selectedUserId = '';
  
  // Controllers
  final _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadAuditItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAuditItems() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (widget.user.isHoD) {
      _auditItems = DummyData.getAllAuditItems();
      _selectedUserId = _auditItems.isNotEmpty ? _auditItems.first.userId : '';
    } else {
      _auditItems = DummyData.getAuditItemsForUser(widget.user.id);
      _selectedUserId = widget.user.id;
    }

    _applyFilters();
    setState(() {
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<AuditItem> filtered = List.from(_auditItems);

    // Filter by user (HoD only)
    if (widget.user.isHoD && _selectedUserId.isNotEmpty) {
      filtered = filtered.where((item) => item.userId == _selectedUserId).toList();
    }

    // Filter by status
    if (_filterStatus == 'completed') {
      filtered = filtered.where((item) => item.isCompleted).toList();
    } else if (_filterStatus == 'pending') {
      filtered = filtered.where((item) => !item.isCompleted).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) => 
        item.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item.comments.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Filter by date range
    if (_dateRange != null) {
      filtered = filtered.where((item) => 
        item.evaluationPeriod.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
        item.evaluationPeriod.isBefore(_dateRange!.end.add(const Duration(days: 1)))
      ).toList();
    }

    setState(() {
      _filteredItems = filtered;
    });
  }

  void _onItemChanged(AuditItem item) {
    setState(() {
      _modifiedItems.add(item.id);
    });
  }

  Future<void> _saveAllChanges() async {
    if (_modifiedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes to save'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Simulate saving delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSaving = false;
      _modifiedItems.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_modifiedItems.length} changes saved successfully'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  Future<void> _pickFile(AuditItem item) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        
        // Check file size (10MB limit)
        if (file.size > 10 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size exceeds 10MB limit'),
              backgroundColor: AppTheme.error,
            ),
          );
          return;
        }

        // Create attached file
        AttachedFile attachedFile = AttachedFile(
          name: file.name,
          path: file.path ?? '',
          size: file.size,
          type: file.extension ?? 'unknown',
          uploadedAt: DateTime.now(),
        );

        setState(() {
          item.attachedFiles.add(attachedFile);
          _modifiedItems.add(item.id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File "${file.name}" uploaded successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading file: ${e.toString()}'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  void _removeFile(AuditItem item, AttachedFile file) {
    setState(() {
      item.attachedFiles.remove(file);
      _modifiedItems.add(item.id);
    });
  }

  void _showItemDetails(AuditItem item) {
    showDialog(
      context: context,
      builder: (context) => AuditItemDialog(
        item: item,
        onSave: (updatedItem) {
          setState(() {
            // Update the item in the list
            int index = _auditItems.indexWhere((i) => i.id == item.id);
            if (index != -1) {
              _auditItems[index] = updatedItem;
            }
            _modifiedItems.add(item.id);
            _applyFilters();
          });
        },
        onPickFile: () => _pickFile(item),
        onRemoveFile: (file) => _removeFile(item, file),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: Column(
        children: [
          // Header and Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.pureWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Audit Checklist',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.textDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.user.isHoD 
                                ? 'Manage all staff audit items'
                                : 'Complete your 41 audit criteria',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_modifiedItems.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentYellow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_modifiedItems.length} unsaved changes',
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveAllChanges,
                      icon: _isSaving 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.pureWhite),
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isSaving ? 'Saving...' : 'Save All Changes'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Filters
                _buildFilters(),
              ],
            ),
          ),
          
          // Data Table
          Expanded(
            child: _isLoading 
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                    ),
                  )
                : _buildDataTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        // User Selection (HoD only)
        if (widget.user.isHoD) ...[
          SizedBox(
            width: 200,
            child: DropdownButtonFormField<String>(
              value: _selectedUserId,
              decoration: const InputDecoration(
                labelText: 'Select Staff',
                prefixIcon: Icon(Icons.person),
                isDense: true,
              ),
              items: DummyData.users.where((u) => u.isStaff).map((user) {
                return DropdownMenuItem<String>(
                  value: user.id,
                  child: Text(user.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUserId = value ?? '';
                  _applyFilters();
                });
              },
            ),
          ),
        ],
        
        // Status Filter
        SizedBox(
          width: 150,
          child: DropdownButtonFormField<String>(
            value: _filterStatus,
            decoration: const InputDecoration(
              labelText: 'Status',
              prefixIcon: Icon(Icons.filter_list),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All')),
              DropdownMenuItem(value: 'completed', child: Text('Completed')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
            ],
            onChanged: (value) {
              setState(() {
                _filterStatus = value ?? 'all';
                _applyFilters();
              });
            },
          ),
        ),
        
        // Search Field
        SizedBox(
          width: 250,
          child: TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search criteria',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _applyFilters();
              });
            },
          ),
        ),
        
        // Date Range
        OutlinedButton.icon(
          onPressed: () async {
            DateTimeRange? range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              initialDateRange: _dateRange,
            );
            
            if (range != null) {
              setState(() {
                _dateRange = range;
                _applyFilters();
              });
            }
          },
          icon: const Icon(Icons.date_range),
          label: Text(
            _dateRange == null 
                ? 'Date Range'
                : '${_dateRange!.start.day}/${_dateRange!.start.month} - ${_dateRange!.end.day}/${_dateRange!.end.month}',
          ),
        ),
        
        // Clear Filters
        if (_filterStatus != 'all' || _searchQuery.isNotEmpty || _dateRange != null)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _filterStatus = 'all';
                _searchQuery = '';
                _dateRange = null;
                _searchController.clear();
                _applyFilters();
              });
            },
            icon: const Icon(Icons.clear),
            label: const Text('Clear Filters'),
          ),
      ],
    );
  }

  Widget _buildDataTable() {
    if (_filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 48,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            const Text(
              'No audit items found',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _filterStatus = 'all';
                  _searchQuery = '';
                  _dateRange = null;
                  _searchController.clear();
                  _applyFilters();
                });
              },
              child: const Text('Clear filters'),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 12,
          horizontalMargin: 12,
          headingRowHeight: 56,
          dataRowHeight: 64,
          headingRowColor: MaterialStateProperty.all(AppTheme.lightYellow),
          columns: const [
            DataColumn(
              label: SizedBox(
                width: 60,
                child: Text('S.No'),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 300,
                child: Text('Criteria Description'),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 80,
                child: Text('Status'),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 200,
                child: Text('Comments'),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 100,
                child: Text('Files'),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 100,
                child: Text('Actions'),
              ),
            ),
          ],
        rows: _filteredItems.map((item) {
          int index = _filteredItems.indexOf(item);
          bool isModified = _modifiedItems.contains(item.id);
          
          return DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (isModified) {
                  return AppTheme.accentYellow.withOpacity(0.1);
                }
                return null;
              },
            ),
            cells: [
              DataCell(
                Text(
                  '${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 300,
                  child: Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: Switch(
                    value: item.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        item.isCompleted = value;
                        _onItemChanged(item);
                      });
                    },
                    activeColor: AppTheme.accentYellow,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    initialValue: item.comments,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter comments...',
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 12),
                    onChanged: (value) {
                      item.comments = value;
                      _onItemChanged(item);
                    },
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.attachedFiles.length} files',
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (item.attachedFiles.isNotEmpty)
                        TextButton(
                          onPressed: () => _showItemDetails(item),
                          child: const Text('View', style: TextStyle(fontSize: 10)),
                        ),
                    ],
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _pickFile(item),
                        icon: const Icon(Icons.attach_file, size: 18),
                        tooltip: 'Upload file',
                      ),
                      IconButton(
                        onPressed: () => _showItemDetails(item),
                        icon: const Icon(Icons.info_outline, size: 18),
                        tooltip: 'View details',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
        ),
      ),
    );
  }
} 