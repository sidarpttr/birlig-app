import 'package:flutter/material.dart';

const COLOR_PRIMARY = Color(0XFF183D3D);
const COLOR_SECONDARY = Color(0xFFB5C8374);
const SCAFFOLD_BACKGROUND = Color(0xFF040D12);

//const COLOR_PRIMARY = Color(0xFF183D3D);
const INPUT = Color.fromARGB(217, 147, 177, 166);
const WHITE = Color(0xDBD8E3FF);
const BLACK = Color(0xFF040D12);

ThemeData darkTheme = ThemeData(
    snackBarTheme: SnackBarThemeData(backgroundColor: COLOR_PRIMARY, contentTextStyle: TextStyle(color: WHITE)),
    brightness: Brightness.dark,
    primaryColor: COLOR_PRIMARY,
    scaffoldBackgroundColor: SCAFFOLD_BACKGROUND,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: SCAFFOLD_BACKGROUND),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        scrolledUnderElevation: BorderSide.strokeAlignCenter,
        centerTitle: true),
    cardTheme: CardTheme(
      color: const Color.fromRGBO(255, 255, 255, 0.175),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
        side: const BorderSide(color: Color(0xFF352F44)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: COLOR_PRIMARY,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0)),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      backgroundColor: MaterialStateProperty.all<Color>(COLOR_PRIMARY),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey; // Icon rengi buton pasifken
          }
          return Colors.white; // Icon rengi buton aktifken
        },
      ),
    )),
    dataTableTheme: DataTableThemeData(
      headingRowColor: MaterialStateProperty.all(COLOR_SECONDARY),
      headingRowHeight: 20,
      columnSpacing: 30,
      headingTextStyle: const TextStyle(color: SCAFFOLD_BACKGROUND, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none),
      filled: true,
      fillColor: COLOR_PRIMARY,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
    ));
