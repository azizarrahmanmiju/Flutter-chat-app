import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color lightBackgroundColor = Colors.white;
const Color darkBackgroundColor = Colors.black;
const Color lightPrimaryColor = Colors.black;
const Color darkPrimaryColor = Colors.white;

final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: lightPrimaryColor,
      brightness: Brightness.light,
      primary: lightPrimaryColor,
      // ignore: deprecated_member_use
      background: lightBackgroundColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme()
    // Add other properties for light theme if needed
    );

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: darkPrimaryColor,
  scaffoldBackgroundColor: darkBackgroundColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: darkPrimaryColor,
    brightness: Brightness.dark,
    primary: darkPrimaryColor,
    // ignore: deprecated_member_use
    background: darkBackgroundColor,
  ),
  // Add other properties for dark theme if needed
  textTheme: GoogleFonts.poppinsTextTheme(),
);
