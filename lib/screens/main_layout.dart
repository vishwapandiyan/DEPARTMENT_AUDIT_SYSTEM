import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/user.dart';
import '../models/dummy_data.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'audit_checklist_screen.dart';
import 'reports_screen.dart';
import 'user_management_screen.dart';
import 'login_screen.dart';

class MainLayout extends StatefulWidget {
  final User user;

  const MainLayout({Key? key, required this.user}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      route: '/dashboard',
    ),
    NavigationItem(
      title: 'Audit Checklist',
      icon: Icons.checklist_outlined,
      activeIcon: Icons.checklist,
      route: '/audit-checklist',
    ),
    NavigationItem(
      title: 'Reports',
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      route: '/reports',
    ),
    NavigationItem(
      title: 'User Management',
      icon: Icons.people_outline,
      activeIcon: Icons.people,
      route: '/user-management',
      hodOnly: true,
    ),
  ];

  List<NavigationItem> get _filteredNavigationItems {
    if (widget.user.isHoD) {
      return _navigationItems;
    } else {
      return _navigationItems.where((item) => !item.hodOnly).toList();
    }
  }

  Widget _getScreenForIndex(int index) {
    final filteredItems = _filteredNavigationItems;
    if (index >= filteredItems.length) {
      return DashboardScreen(user: widget.user);
    }

    switch (filteredItems[index].route) {
      case '/dashboard':
        return DashboardScreen(user: widget.user);
      case '/audit-checklist':
        return AuditChecklistScreen(user: widget.user);
      case '/reports':
        return ReportsScreen(user: widget.user);
      case '/user-management':
        return UserManagementScreen(user: widget.user);
      default:
        return DashboardScreen(user: widget.user);
    }
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isDrawerOpen = false;
    });
    Navigator.of(context).pop(); // Close drawer
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                DummyData.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: Text(
          _selectedIndex < _filteredNavigationItems.length
              ? _filteredNavigationItems[_selectedIndex].title
              : 'Department Audit System',
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.pureWhite,
        elevation: 2,
        actions: [
          // User info
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.lightBlue,
                  radius: 16,
                  child: Text(
                    widget.user.name.split(' ').map((n) => n[0]).join().toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        color: AppTheme.pureWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.user.role.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.lightBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
              setState(() {
                _isDrawerOpen = true;
              });
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppTheme.pureWhite,
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.primaryBlue,
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.clipboardCheck,
                        color: AppTheme.pureWhite,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // User Info
                    Text(
                      widget.user.name,
                      style: AppTextStyles.drawerHeader,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                        color: AppTheme.lightBlue,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentYellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.user.role.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Navigation Items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _filteredNavigationItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredNavigationItems[index];
                  final isSelected = _selectedIndex == index;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.lightYellow : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.textLight,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      onTap: () => _onNavigationItemTapped(index),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Logout Button
            Container(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: AppTheme.error,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppTheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: _logout,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: _getScreenForIndex(_selectedIndex),
      ),
    );
  }
}

class NavigationItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final bool hodOnly;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.hodOnly = false,
  });
} 