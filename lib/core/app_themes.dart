import 'package:flutter/material.dart';

const _displayLarge = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 28,
  fontWeight: FontWeight.w600,
  height: 1.875,
);
const _displayMedium = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 22,
  fontWeight: FontWeight.w600,
  height: 1.7333,
);
const _displaySmall = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 20,
  fontWeight: FontWeight.w600,
  height: 1.4,
);
const _bodyLarge = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  fontWeight: FontWeight.w700,
  height: 1.5, // 24
);
const _bodyMedium = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.5,
);
const _bodySmall = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.43,
);

const bluePrimary = Color.fromRGBO(117, 157, 234, 1);

const darkBackground = Color.fromRGBO(18, 18, 18, 1);
const darkTextPrimary = Color.fromRGBO(255, 255, 255, 0.87);
const darkTextSmoke = Color.fromRGBO(255, 255, 255, 0.6);

class CommonThemes {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(background: Colors.white),
    fontFamily: 'Poppins',
    useMaterial3: true,
    textTheme: const TextTheme(
      displayLarge: _displayLarge,
      displayMedium: _displayMedium,
      displaySmall: _displaySmall,
      bodyLarge: _bodyLarge,
      bodyMedium: _bodyMedium,
      bodySmall: _bodySmall,
    ).apply(fontFamily: 'Poppins'),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      hintStyle: _bodyMedium.copyWith(
        color: Colors.black.withOpacity(0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      fillColor: Colors.white,
      filled: true,
      labelStyle: _bodyMedium,
      border: const OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: _bodyMedium,
        // foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white,
        backgroundColor: bluePrimary,
        disabledBackgroundColor: const Color.fromRGBO(117, 157, 234, 0.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        side: const BorderSide(color: Colors.transparent),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: _bodyMedium,
        foregroundColor: bluePrimary,
        disabledForegroundColor: const Color.fromRGBO(117, 157, 234, 0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        fixedSize: const Size.fromHeight(40),
        side: const BorderSide(
          color: bluePrimary,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      selectedIconTheme: IconThemeData(color: Colors.black),
      unselectedIconTheme: IconThemeData(color: Colors.black),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: bluePrimary,
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.light(background: darkBackground),
    disabledColor: darkTextSmoke,
    fontFamily: 'Poppins',
    useMaterial3: true,
    textTheme: const TextTheme(
      displayLarge: _displayLarge,
      displayMedium: _displayMedium,
      displaySmall: _displaySmall,
      bodyLarge: _bodyLarge,
      bodyMedium: _bodyMedium,
      bodySmall: _bodySmall,
    ).apply(
      fontFamily: 'Poppins',
      bodyColor: darkTextPrimary,
      displayColor: darkTextPrimary,
      decorationColor: darkTextPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      hintStyle: _bodyMedium.copyWith(
        color: darkTextSmoke,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      fillColor: darkBackground,
      filled: true,
      labelStyle: _bodyMedium,
      disabledBorder: const OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: darkTextSmoke),
      ),
      enabledBorder: const OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: darkTextPrimary),
      ),
      border: const OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: darkTextPrimary),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: darkTextPrimary),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: _bodyMedium,
        // foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white,
        backgroundColor: bluePrimary,
        disabledBackgroundColor: const Color.fromRGBO(117, 157, 234, 0.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        side: const BorderSide(color: Colors.transparent),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: _bodyMedium,
        foregroundColor: bluePrimary,
        disabledForegroundColor: const Color.fromRGBO(117, 157, 234, 0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        fixedSize: const Size.fromHeight(40),
        side: const BorderSide(
          color: bluePrimary,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: darkTextPrimary,
      unselectedItemColor: darkTextPrimary,
      selectedIconTheme: IconThemeData(color: darkTextPrimary),
      unselectedIconTheme: IconThemeData(color: darkTextPrimary),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: bluePrimary,
    ),
    iconTheme: const IconThemeData(color: darkTextPrimary),
  );
}
