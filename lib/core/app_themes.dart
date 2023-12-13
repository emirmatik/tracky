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
        backgroundColor: const Color.fromRGBO(117, 157, 234, 1),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    ),
  );
}
