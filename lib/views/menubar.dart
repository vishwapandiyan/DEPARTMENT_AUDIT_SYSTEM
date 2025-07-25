import 'package:dept_audit/views/staff/activity_screen.dart';
import 'package:dept_audit/views/staff/staff_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/menubar_logic.dart';
import '../models/menubar_model.dart';
import 'login_screen.dart';

class SideMenuView extends StatelessWidget {
  final String userRole;

  const SideMenuView({Key? key, required this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SideMenuController()..initializeMenu(userRole),
      child: Consumer<SideMenuController>(
        builder: (context, controller, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: controller.isExpanded ? 280 : 80,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildHeader(controller),
                Expanded(
                  child: _buildMenuItems(context, controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(SideMenuController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: controller.toggleMenu,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: controller.isExpanded
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
                children: [
                  Icon(
                    controller.isExpanded
                        ? Icons.keyboard_arrow_left
                        : Icons.keyboard_arrow_right,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, SideMenuController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: controller.menuItems.length,
      itemBuilder: (context, index) {
        final item = controller.menuItems[index];
        return _buildMenuItem(context, controller, item, index);
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, SideMenuController controller, MenuItemModel item, int index) {
    final isSelected = item.isSelected;
    final isLogout = item.action == MenuAction.logout;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleMenuItemTap(context, controller, item, index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: Colors.blue.withOpacity(0.3))
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(
                    item.icon,
                    style: TextStyle(
                      fontSize: 18,
                      color: isLogout ? Colors.red : (isSelected ? Colors.blue : Colors.grey[600]),
                    ),
                  ),
                ),
                if (controller.isExpanded) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isLogout ? Colors.red : (isSelected ? Colors.blue : Colors.black87),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Centralized navigation handler
  void _handleMenuItemTap(BuildContext context, SideMenuController controller, MenuItemModel item, int index) {
    // Update selection state
    controller.onMenuItemTap(index);

    // Handle action based on menu item type
    switch (item.action) {
      case MenuAction.navigate:
        _navigateToScreen(context, item);
        break;
      case MenuAction.logout:
        _showLogoutDialog(context);
        break;
    }
  }

  // ✅ Centralized navigation logic
  void _navigateToScreen(BuildContext context, MenuItemModel item) {
    Widget? screen;

    switch (item.route) {
      case '/staff-dashboard':
      case '/hod-dashboard':
        screen = StaffDashboardView();
        break;
      case '/activities-upload':
        screen = ActivityView();
        break;
      case '/submissions':
      // screen = SubmissionsView();
        print('Navigation to ${item.route} not implemented yet');
        return;
      case '/pending-activities':
      // screen = PendingActivitiesView();
        print('Navigation to ${item.route} not implemented yet');
        return;
      case '/activities-summary':
        screen = ActivityView();
        break;
      case '/profile':
      // screen = ProfileView();
        print('Navigation to ${item.route} not implemented yet');
        return;
      default:
        print('Unknown route: ${item.route}');
        return;
    }

    if (screen != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen!),
      );
    }
  }

  // ✅ Logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
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
}