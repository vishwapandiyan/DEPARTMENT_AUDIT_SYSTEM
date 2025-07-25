import 'package:flutter/material.dart';

class AppTheme {
  // Color constants
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color accentYellow = Color(0xFFFFD54F);
  static const Color lightYellow = Color(0xFFFFF8E1);
  static const Color darkYellow = Color(0xFFFFA000);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF757575);
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color primaryColor = primaryBlue;
  static const Color scaffoldBackground = lightGrey;


  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      secondary: accentYellow,
      surface: pureWhite,
      onSurface: textDark,
      onPrimary: pureWhite,
      onSecondary: textDark,
    ),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: pureWhite,
      elevation: 2,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: pureWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Drawer Theme
    drawerTheme: const DrawerThemeData(
      backgroundColor: pureWhite,
      elevation: 4,
    ),

    // Card Theme
    cardTheme: CardTheme(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: pureWhite,
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: pureWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: const BorderSide(color: primaryBlue),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightGrey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: textLight),
    ),

    // Data Table Theme
    dataTableTheme: DataTableThemeData(
      columnSpacing: 24,
      horizontalMargin: 16,
      dividerThickness: 1,
      headingRowColor: MaterialStateProperty.all(lightYellow),
      headingTextStyle: const TextStyle(
        color: textDark,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      dataTextStyle: const TextStyle(
        color: textDark,
        fontSize: 13,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: lightYellow,
      selectedColor: accentYellow,
      labelStyle: const TextStyle(color: textDark),
      side: const BorderSide(color: accentYellow),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return accentYellow;
          }
          return lightGrey;
        },
      ),
      trackColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return accentYellow.withOpacity(0.5);
          }
          return lightGrey.withOpacity(0.5);
        },
      ),
    ),

    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      titleTextStyle: const TextStyle(
        color: textDark,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        color: textDark,
        fontSize: 14,
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: pureWhite,
      selectedItemColor: primaryBlue,
      unselectedItemColor: textLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textDark,
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: TextStyle(
        color: textDark,
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        color: textDark,
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: TextStyle(
        color: textDark,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: textDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: textDark,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: textDark,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: textDark,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: textDark,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: textDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: textDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: textLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: textDark,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: textDark,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: textLight,
        fontSize: 10,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Scaffold Background Color
    scaffoldBackgroundColor: lightGrey,

    // Icon Theme
    iconTheme: const IconThemeData(
      color: textDark,
      size: 24,
    ),

    // Primary Icon Theme
    primaryIconTheme: const IconThemeData(
      color: pureWhite,
      size: 24,
    ),
  );
}

// Custom card styles
class AppCardStyles {
  static BoxDecoration summaryCard = BoxDecoration(
    color: AppTheme.pureWhite,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration accentCard = BoxDecoration(
    color: AppTheme.lightYellow,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration primaryCard = BoxDecoration(
    color: AppTheme.primaryBlue,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

// Custom text styles
class AppTextStyles {
  static const TextStyle cardTitle = TextStyle(
    color: AppTheme.textDark,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle cardSubtitle = TextStyle(
    color: AppTheme.textLight,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle cardNumber = TextStyle(
    color: AppTheme.primaryBlue,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle whiteCardNumber = TextStyle(
    color: AppTheme.pureWhite,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle drawerItem = TextStyle(
    color: AppTheme.textDark,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle drawerHeader = TextStyle(
    color: AppTheme.pureWhite,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}