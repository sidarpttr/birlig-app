import 'package:flutter/material.dart';

const COLOR_PRIMARY = Color(0XFF9B3922);
const COLOR_SECONDARY = Color(0xFFF2613F);
const SCAFFOLD_BACKGROUND = Color(0xFF0C0C0C);
const CARD_COLOR = Color(0x11FFFFFF);

//const COLOR_PRIMARY = Color(0xFF183D3D);
const INPUT = Color.fromARGB(204, 255, 255, 255);
const WHITE = Color.fromARGB(213, 255, 255, 255);
const BLACK = Color(0xFF040D12);
const GREY = Color(0x44FFFFFF);

class MyAppTheme {
  static ThemeData darkTheme = ThemeData(
      primaryColor: COLOR_PRIMARY,
      textTheme: const TextTheme(
          headlineMedium: TextStyle(color: WHITE),
          bodySmall: TextStyle(color: GREY),
          headlineLarge: TextStyle(color: WHITE)),
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: COLOR_PRIMARY,
          contentTextStyle: TextStyle(color: WHITE)),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SCAFFOLD_BACKGROUND,
      appBarTheme: const AppBarTheme(
          foregroundColor: WHITE,
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
          scrolledUnderElevation: BorderSide.strokeAlignCenter,
          centerTitle: true),
      cardTheme: CardTheme(
        color: CARD_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: const BorderSide(color: BLACK),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
        backgroundColor: MaterialStateProperty.all<Color>(COLOR_PRIMARY),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return INPUT.withAlpha(100); // Icon rengi buton pasifken
            }
            return WHITE; // Icon rengi buton aktifken
          },
        ),
      )),
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(COLOR_SECONDARY),
        headingRowHeight: 20,
        columnSpacing: 21,
        headingTextStyle: const TextStyle(
            color: SCAFFOLD_BACKGROUND, fontWeight: FontWeight.bold),
      ),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: COLOR_PRIMARY),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: SCAFFOLD_BACKGROUND,
          unselectedItemColor: WHITE,
          selectedItemColor: COLOR_PRIMARY),
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: INPUT,
          contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
          hintStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: COLOR_PRIMARY.withAlpha(100))));
}
