import 'package:flutter/material.dart';
import '../models/menubar_model.dart';

class SideMenuController with ChangeNotifier {
  bool _isExpanded = false;
  int _selectedIndex = 0;
  List<MenuItemModel> _menuItems = [];
  UserModel? _currentUser;

  bool get isExpanded => _isExpanded;
  int get selectedIndex => _selectedIndex;
  List<MenuItemModel> get menuItems => _menuItems;
  UserModel? get currentUser => _currentUser;

  void toggleMenu() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      _updateMenuItemSelection();
      notifyListeners();
    }
  }

  void initializeMenu(String userRole) {
    _currentUser = UserModel(
      name: userRole == 'HOD' ? 'Dr. John Smith' : 'Sophia Rose',
      role: userRole == 'HOD' ? 'Head of Department' : 'UX/UI Designer',
      profileImage: 'assets/images/profile.jpg',
    );

    if (userRole == 'HOD') {
      _menuItems = [
        MenuItemModel(
          title: 'Dashboard',
          icon: '🏠',
          route: '/hod-dashboard',
          action: MenuAction.navigate,
        ),
        MenuItemModel(
          title: 'Pending Activities',
          icon: '📋',
          route: '/pending-activities',
          action: MenuAction.navigate,
        ),
        MenuItemModel(
          title: 'Activities Summary',
          icon: '📊',
          route: '/activities-summary',
          action: MenuAction.navigate,
        ),
        MenuItemModel(
          title: 'Profile',
          icon: '👤',
          route: '/profile',
          action: MenuAction.navigate,
        ),
        MenuItemModel(
          title: 'Logout',
          icon: '⏻',
          route: '/logout',
          action: MenuAction.logout,
        ),
      ];
    } else {
      _menuItems = [
        MenuItemModel(
          title: 'Dashboard',
          icon: '🏠',
          route: '/staff-dashboard',
          action: MenuAction.navigate,
        ),
        MenuItemModel(
          title: 'Submissions',
          icon: '📝',
          route: '/submissions',
          action: MenuAction.navigate,
        ),
        MenuItemModel(
          title: 'Activities Upload',
          icon: '📤',
          route: '/activities-upload',
          action: MenuAction.navigate,
        ),
        MenuItemModel(
          title: 'Profile',
          icon: '👤',
          route: '/profile',
          action: MenuAction.navigate,
        ),
        MenuItemModel(
          title: 'Logout',
          icon: '⏻',
          route: '/logout',
          action: MenuAction.logout,
        ),
      ];
    }

    _updateMenuItemSelection();
    notifyListeners();
  }

  void _updateMenuItemSelection() {
    _menuItems = _menuItems.asMap().entries.map((entry) {
      int index = entry.key;
      MenuItemModel item = entry.value;
      return item.copyWith(isSelected: index == _selectedIndex);
    }).toList();
  }

  // ✅ Simplified method - only handles selection state
  void onMenuItemTap(int index) {
    setSelectedIndex(index);
  }

  // ✅ Get the current selected menu item
  MenuItemModel? get selectedMenuItem {
    if (_selectedIndex >= 0 && _selectedIndex < _menuItems.length) {
      return _menuItems[_selectedIndex];
    }
    return null;
  }
}