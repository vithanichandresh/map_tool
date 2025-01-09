import 'package:flutter/material.dart';

class AppTheme {
  final primary = const Color(0xFFD0BCFF);
  final containerColor = const Color(0xFF999999);

  ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: Color(0xFFECEFF9),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        centerTitle: false,
      ),
    );
  }

  ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: Color(0xFF121b3b),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        centerTitle: false,
      ),
    );
  }
}

extension TextTheme on BuildContext {
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge?.copyWith(color: textColor);

  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge?.copyWith(color: textColor);

  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium?.copyWith(color: textColor);

  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall?.copyWith(color: textColor);

  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium?.copyWith(color: textColor);

  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall?.copyWith(color: textColor);

  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge?.copyWith(color: textColor);

  TextStyle? get labelMedium => Theme.of(this).textTheme.labelSmall?.copyWith(color: textColor);

  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall?.copyWith(color: textColor);

  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge?.copyWith(color: textColor);

  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium?.copyWith(color: textColor);

  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall?.copyWith(color: textColor);

  TextStyle? get subTitle1 => Theme.of(this).textTheme.titleMedium?.copyWith(color: textColor);

  TextStyle? get subTitle2 => Theme.of(this).textTheme.titleSmall?.copyWith(color: textColor);
}

extension ThemeColor on BuildContext {
  Color? get primaryColor => Theme.of(this).colorScheme.primary;

  Color? get cardColor => Theme.of(this).cardColor;

  Color? get dividerColor => Theme.of(this).dividerColor;

  Color? get disableColor => Theme.of(this).disabledColor;

  Color? get shadowColor => Theme.of(this).brightness == Brightness.dark ? Colors.white54 : Colors.black54;

  Color get errorColor =>
      Theme.of(this).brightness == Brightness.dark ? Colors.redAccent.shade200 : Theme.of(this).colorScheme.error;

  Color? get iconColor =>
      Theme.of(this).brightness == Brightness.dark ? Colors.grey.shade300 : Theme.of(this).iconTheme.color;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get hintColor => Theme.of(this).hintColor;

  Color? get textColor => Theme.of(this).brightness == Brightness.dark ? Colors.white : Colors.black;
}
