// Add this enum to define menu item actions
enum MenuAction {
  navigate,
  logout,
}

class MenuItemModel {
  final String title;
  final String icon;
  final String route;
  final bool isSelected;
  final MenuAction action;

  MenuItemModel({
    required this.title,
    required this.icon,
    required this.route,
    this.isSelected = false,
    this.action = MenuAction.navigate,
  });

  MenuItemModel copyWith({
    String? title,
    String? icon,
    String? route,
    bool? isSelected,
    MenuAction? action,
  }) {
    return MenuItemModel(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      isSelected: isSelected ?? this.isSelected,
      action: action ?? this.action,
    );
  }
}

class UserModel {
  final String name;
  final String role;
  final String profileImage;

  UserModel({
    required this.name,
    required this.role,
    required this.profileImage,
  });
}