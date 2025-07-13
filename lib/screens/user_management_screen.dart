import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/user.dart';
import '../models/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/user_dialog.dart';

class UserManagementScreen extends StatefulWidget {
  final User user;

  const UserManagementScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _roleFilter = 'all';
  
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));

    _users = List.from(DummyData.users);
    _applyFilters();

    setState(() {
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<User> filtered = List.from(_users);

    // Filter by role
    if (_roleFilter != 'all') {
      filtered = filtered.where((user) => user.role == _roleFilter).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((user) => 
        user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        user.email.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    setState(() {
      _filteredUsers = filtered;
    });
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => UserDialog(
        onSave: (user) {
          setState(() {
            _users.add(user);
            _applyFilters();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User added successfully'),
              backgroundColor: AppTheme.success,
            ),
          );
        },
      ),
    );
  }

  void _showEditUserDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => UserDialog(
        user: user,
        onSave: (updatedUser) {
          setState(() {
            int index = _users.indexWhere((u) => u.id == user.id);
            if (index != -1) {
              _users[index] = updatedUser;
              _applyFilters();
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User updated successfully'),
              backgroundColor: AppTheme.success,
            ),
          );
        },
      ),
    );
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete "${user.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _users.removeWhere((u) => u.id == user.id);
                _applyFilters();
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User deleted successfully'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.user.isHoD) {
      return const Center(
        child: Text(
          'Access Denied\nThis page is only available to Head of Department',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.textLight,
            fontSize: 16,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: Column(
        children: [
          // Header
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.userGear,
                        color: AppTheme.pureWhite,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Management',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.textDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage department staff and their access',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddUserDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Add New User'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Filters
                Row(
                  children: [
                    // Search Field
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          labelText: 'Search users',
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
                    
                    const SizedBox(width: 16),
                    
                    // Role Filter
                    SizedBox(
                      width: 150,
                      child: DropdownButtonFormField<String>(
                        value: _roleFilter,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Roles')),
                          DropdownMenuItem(value: 'hod', child: Text('HoD')),
                          DropdownMenuItem(value: 'staff', child: Text('Staff')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _roleFilter = value ?? 'all';
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Clear Filters
                    if (_searchQuery.isNotEmpty || _roleFilter != 'all')
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _roleFilter = 'all';
                            _searchController.clear();
                            _applyFilters();
                          });
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Users List
          Expanded(
            child: _isLoading 
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                    ),
                  )
                : _buildUsersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    if (_filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.userSlash,
              size: 48,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            const Text(
              'No users found',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _roleFilter = 'all';
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
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.lightYellow,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.people,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Department Users',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_filteredUsers.length} users',
                    style: const TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Users DataTable
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 12,
                horizontalMargin: 12,
                headingRowHeight: 50,
                dataRowHeight: 60,
                columns: const [
                  DataColumn(
                    label: SizedBox(
                      width: 250,
                      child: Text('Name'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 250,
                      child: Text('Email'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 100,
                      child: Text('Role'),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 120,
                      child: Text('Actions'),
                    ),
                  ),
                ],
              rows: _filteredUsers.map((user) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 250,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTheme.primaryBlue,
                              radius: 18,
                              child: Text(
                                user.name.split(' ').map((n) => n[0]).join().toUpperCase(),
                                style: const TextStyle(
                                  color: AppTheme.pureWhite,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  color: AppTheme.textDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 250,
                        child: Text(
                          user.email,
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: user.isHoD ? AppTheme.primaryBlue : AppTheme.accentYellow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.role.toUpperCase(),
                            style: TextStyle(
                              color: user.isHoD ? AppTheme.pureWhite : AppTheme.textDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _showEditUserDialog(user),
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              tooltip: 'Edit user',
                            ),
                            IconButton(
                              onPressed: user.id == widget.user.id ? null : () => _deleteUser(user),
                              icon: const Icon(Icons.delete_outline, size: 18),
                              tooltip: user.id == widget.user.id ? 'Cannot delete yourself' : 'Delete user',
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
          ),
        ],
      ),
    );
  }
} 