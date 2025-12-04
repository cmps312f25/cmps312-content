import 'package:flutter/material.dart';

/// App Theme Configuration
///
/// This file contains the complete theme configuration for the AI Story Creator app.
/// It includes color schemes, typography, component themes, and custom colors
/// designed specifically for a child-friendly educational experience.

class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // ==================== Color Palette ====================

  /// Primary purple color - used for main actions and branding
  static const Color primaryPurple = Color(0xFF7C3AED); // Vibrant purple
  static const Color primaryPurpleLight = Color(0xFF9F67FF);
  static const Color primaryPurpleDark = Color(0xFF5B21B6);

  /// Secondary blue color - used for informational elements
  static const Color secondaryBlue = Color(0xFF3B82F6); // Bright blue
  static const Color secondaryBlueLight = Color(0xFF60A5FA);
  static const Color secondaryBlueDark = Color(0xFF1E40AF);

  /// Accent yellow color - used for highlights and success states
  static const Color accentYellow = Color(0xFFFBBF24); // Warm yellow
  static const Color accentYellowLight = Color(0xFFFCD34D);
  static const Color accentYellowDark = Color(0xFFD97706);

  /// Accent pink color - used for creative and playful elements
  static const Color accentPink = Color(0xFFEC4899); // Vibrant pink
  static const Color accentPinkLight = Color(0xFFF472B6);
  static const Color accentPinkDark = Color(0xFFBE185D);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Semantic colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);

  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFC);
  static const Color backgroundDark = Color(0xFF0F0F1E);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A2E);

  // ==================== Typography ====================

  /// Font family - using default system fonts
  static const String? fontFamily = null;
  static const String? displayFontFamily = null;

  /// Text Theme for Light Mode
  static TextTheme get lightTextTheme => TextTheme(
    // Display styles - large, attention-grabbing text
    displayLarge: TextStyle(
      fontFamily: displayFontFamily,
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      color: grey900,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontFamily: displayFontFamily,
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      color: grey900,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontFamily: displayFontFamily,
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: grey900,
      height: 1.22,
    ),

    // Headline styles - section headers
    headlineLarge: TextStyle(
      fontFamily: displayFontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: grey900,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: grey900,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: grey900,
      height: 1.33,
    ),

    // Title styles - card titles, dialog headers
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: grey900,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: grey900,
      height: 1.5,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: grey900,
      height: 1.43,
    ),

    // Body styles - main content text
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: grey800,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: grey800,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: grey700,
      height: 1.33,
    ),

    // Label styles - buttons, tabs, labels
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: grey900,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: grey900,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: grey800,
      height: 1.45,
    ),
  );

  /// Text Theme for Dark Mode
  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: lightTextTheme.displayLarge!.copyWith(color: white),
    displayMedium: lightTextTheme.displayMedium!.copyWith(color: white),
    displaySmall: lightTextTheme.displaySmall!.copyWith(color: white),
    headlineLarge: lightTextTheme.headlineLarge!.copyWith(color: white),
    headlineMedium: lightTextTheme.headlineMedium!.copyWith(color: white),
    headlineSmall: lightTextTheme.headlineSmall!.copyWith(color: white),
    titleLarge: lightTextTheme.titleLarge!.copyWith(color: white),
    titleMedium: lightTextTheme.titleMedium!.copyWith(color: white),
    titleSmall: lightTextTheme.titleSmall!.copyWith(color: white),
    bodyLarge: lightTextTheme.bodyLarge!.copyWith(color: grey100),
    bodyMedium: lightTextTheme.bodyMedium!.copyWith(color: grey200),
    bodySmall: lightTextTheme.bodySmall!.copyWith(color: grey300),
    labelLarge: lightTextTheme.labelLarge!.copyWith(color: white),
    labelMedium: lightTextTheme.labelMedium!.copyWith(color: white),
    labelSmall: lightTextTheme.labelSmall!.copyWith(color: grey200),
  );

  // ==================== Color Schemes ====================

  /// Light Color Scheme
  static ColorScheme get lightColorScheme => ColorScheme.light(
    primary: primaryPurple,
    onPrimary: white,
    primaryContainer: primaryPurpleLight.withValues(alpha: 0.2),
    onPrimaryContainer: primaryPurpleDark,

    secondary: secondaryBlue,
    onSecondary: white,
    secondaryContainer: secondaryBlueLight.withValues(alpha: 0.2),
    onSecondaryContainer: secondaryBlueDark,

    tertiary: accentPink,
    onTertiary: white,
    tertiaryContainer: accentPinkLight.withValues(alpha: 0.2),
    onTertiaryContainer: accentPinkDark,

    error: error,
    onError: white,
    errorContainer: errorLight.withValues(alpha: 0.2),
    onErrorContainer: error,

    surface: surfaceLight,
    onSurface: grey900,
    surfaceContainerHighest: grey100,
    onSurfaceVariant: grey700,

    outline: grey300,
    outlineVariant: grey200,

    shadow: black.withValues(alpha: 0.1),
    scrim: black.withValues(alpha: 0.5),

    inverseSurface: grey900,
    onInverseSurface: white,
    inversePrimary: primaryPurpleLight,
  );

  /// Dark Color Scheme
  static ColorScheme get darkColorScheme => ColorScheme.dark(
    primary: primaryPurpleLight,
    onPrimary: grey900,
    primaryContainer: primaryPurpleDark,
    onPrimaryContainer: primaryPurpleLight,

    secondary: secondaryBlueLight,
    onSecondary: grey900,
    secondaryContainer: secondaryBlueDark,
    onSecondaryContainer: secondaryBlueLight,

    tertiary: accentPinkLight,
    onTertiary: grey900,
    tertiaryContainer: accentPinkDark,
    onTertiaryContainer: accentPinkLight,

    error: errorLight,
    onError: grey900,
    errorContainer: error,
    onErrorContainer: errorLight,

    surface: surfaceDark,
    onSurface: white,
    surfaceContainerHighest: grey800,
    onSurfaceVariant: grey300,

    outline: grey700,
    outlineVariant: grey800,

    shadow: black.withValues(alpha: 0.3),
    scrim: black.withValues(alpha: 0.7),

    inverseSurface: grey100,
    onInverseSurface: grey900,
    inversePrimary: primaryPurple,
  );

  // ==================== Theme Data ====================

  /// Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: lightTextTheme,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: fontFamily,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: surfaceLight,
      foregroundColor: grey900,
      surfaceTintColor: primaryPurple,
      titleTextStyle: lightTextTheme.titleLarge,
      iconTheme: IconThemeData(color: grey900, size: 24),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: black.withValues(alpha: 0.08),
      surfaceTintColor: primaryPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(8),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: lightTextTheme.labelLarge,
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: primaryPurple, width: 1.5),
        textStyle: lightTextTheme.labelLarge,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: lightTextTheme.labelLarge,
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: primaryPurple,
      foregroundColor: white,
      shape: const CircleBorder(),
      sizeConstraints: const BoxConstraints.tightFor(width: 64.0, height: 64.0),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: grey50,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: grey300, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: grey300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: error, width: 2),
      ),
      labelStyle: lightTextTheme.bodyMedium,
      hintStyle: lightTextTheme.bodyMedium!.copyWith(color: grey400),
      errorStyle: lightTextTheme.bodySmall!.copyWith(color: error),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: grey100,
      selectedColor: primaryPurple.withValues(alpha: 0.2),
      deleteIconColor: grey600,
      labelStyle: lightTextTheme.labelMedium,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      elevation: 8,
      backgroundColor: surfaceLight,
      surfaceTintColor: primaryPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: lightTextTheme.headlineSmall,
      contentTextStyle: lightTextTheme.bodyMedium,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      elevation: 8,
      backgroundColor: surfaceLight,
      surfaceTintColor: primaryPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: grey800,
      contentTextStyle: lightTextTheme.bodyMedium!.copyWith(color: white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(color: grey200, thickness: 1, space: 1),

    // Icon Theme
    iconTheme: IconThemeData(color: grey700, size: 24),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryPurple,
      linearTrackColor: grey200,
      circularTrackColor: grey200,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryPurple;
        return grey400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryPurpleLight;
        return grey300;
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryPurple;
        return grey300;
      }),
      checkColor: WidgetStateProperty.all(white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryPurple;
        return grey400;
      }),
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryPurple,
      inactiveTrackColor: grey300,
      thumbColor: primaryPurple,
      overlayColor: primaryPurple.withValues(alpha: 0.2),
      valueIndicatorColor: primaryPurple,
      valueIndicatorTextStyle: lightTextTheme.labelSmall!.copyWith(
        color: white,
      ),
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: primaryPurple,
      unselectedLabelColor: grey600,
      labelStyle: lightTextTheme.labelLarge,
      unselectedLabelStyle: lightTextTheme.labelLarge,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryPurple, width: 3),
        borderRadius: BorderRadius.circular(3),
      ),
      indicatorSize: TabBarIndicatorSize.label,
    ),

    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      backgroundColor: surfaceLight,
      surfaceTintColor: primaryPurple,
      indicatorColor: primaryPurple.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.all(lightTextTheme.labelSmall),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: primaryPurple, size: 24);
        }
        return IconThemeData(color: grey600, size: 24);
      }),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      iconColor: grey700,
      textColor: grey900,
      titleTextStyle: lightTextTheme.titleMedium,
      subtitleTextStyle: lightTextTheme.bodySmall,
    ),
  );

  /// Dark Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    textTheme: darkTextTheme,
    scaffoldBackgroundColor: backgroundDark,
    fontFamily: fontFamily,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: surfaceDark,
      foregroundColor: white,
      surfaceTintColor: primaryPurpleLight,
      titleTextStyle: darkTextTheme.titleLarge,
      iconTheme: IconThemeData(color: white, size: 24),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: black.withValues(alpha: 0.3),
      surfaceTintColor: primaryPurpleLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(8),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: darkTextTheme.labelLarge,
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: primaryPurpleLight, width: 1.5),
        textStyle: darkTextTheme.labelLarge,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: darkTextTheme.labelLarge,
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: primaryPurpleLight,
      foregroundColor: grey900,
      shape: const CircleBorder(),
      sizeConstraints: const BoxConstraints.tightFor(width: 64.0, height: 64.0),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: grey800,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: grey700, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: grey700, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryPurpleLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorLight, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorLight, width: 2),
      ),
      labelStyle: darkTextTheme.bodyMedium,
      hintStyle: darkTextTheme.bodyMedium!.copyWith(color: grey600),
      errorStyle: darkTextTheme.bodySmall!.copyWith(color: errorLight),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: grey800,
      selectedColor: primaryPurpleLight.withValues(alpha: 0.3),
      deleteIconColor: grey400,
      labelStyle: darkTextTheme.labelMedium,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      elevation: 8,
      backgroundColor: surfaceDark,
      surfaceTintColor: primaryPurpleLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: darkTextTheme.headlineSmall,
      contentTextStyle: darkTextTheme.bodyMedium,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      elevation: 8,
      backgroundColor: surfaceDark,
      surfaceTintColor: primaryPurpleLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: grey200,
      contentTextStyle: darkTextTheme.bodyMedium!.copyWith(color: grey900),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(color: grey800, thickness: 1, space: 1),

    // Icon Theme
    iconTheme: IconThemeData(color: grey300, size: 24),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryPurpleLight,
      linearTrackColor: grey800,
      circularTrackColor: grey800,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryPurpleLight;
        return grey600;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryPurple;
        return grey700;
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryPurpleLight;
        return grey700;
      }),
      checkColor: WidgetStateProperty.all(grey900),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryPurpleLight;
        return grey600;
      }),
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryPurpleLight,
      inactiveTrackColor: grey700,
      thumbColor: primaryPurpleLight,
      overlayColor: primaryPurpleLight.withValues(alpha: 0.3),
      valueIndicatorColor: primaryPurpleLight,
      valueIndicatorTextStyle: darkTextTheme.labelSmall!.copyWith(
        color: grey900,
      ),
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: primaryPurpleLight,
      unselectedLabelColor: grey400,
      labelStyle: darkTextTheme.labelLarge,
      unselectedLabelStyle: darkTextTheme.labelLarge,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryPurpleLight, width: 3),
        borderRadius: BorderRadius.circular(3),
      ),
      indicatorSize: TabBarIndicatorSize.label,
    ),

    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      backgroundColor: surfaceDark,
      surfaceTintColor: primaryPurpleLight,
      indicatorColor: primaryPurpleLight.withValues(alpha: 0.3),
      labelTextStyle: WidgetStateProperty.all(darkTextTheme.labelSmall),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: primaryPurpleLight, size: 24);
        }
        return IconThemeData(color: grey400, size: 24);
      }),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      iconColor: grey300,
      textColor: white,
      titleTextStyle: darkTextTheme.titleMedium,
      subtitleTextStyle: darkTextTheme.bodySmall,
    ),
  );
}

/// Custom color extensions for specific use cases
extension AppColors on ColorScheme {
  /// Semantic colors
  Color get success => AppTheme.success;
  Color get warning => AppTheme.warning;
  Color get info => AppTheme.info;

  /// User role colors
  Color get learnerColor => AppTheme.secondaryBlue;
  Color get educatorColor => AppTheme.primaryPurple;

  /// Status colors
  Color get statusDraft => AppTheme.grey400;
  Color get statusPublished => AppTheme.success;
  Color get statusFavourite => AppTheme.accentYellow;
}
