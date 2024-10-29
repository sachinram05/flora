import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  surface: const Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData().copyWith(
  // drawerTheme: DrawerThemeData().copyWith(backgroundColor: ),
  scaffoldBackgroundColor: colorScheme.onPrimaryContainer,
  colorScheme: colorScheme,
  
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: colorScheme.onPrimaryContainer,
    foregroundColor: colorScheme.primaryContainer
  ),
  cardTheme: const CardTheme().copyWith(
    color: const Color.fromARGB(255, 165, 149, 191),
    margin: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 0
    )
  ),
  iconTheme: const IconThemeData().copyWith(
    color: colorScheme.primaryContainer,
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primaryContainer,
      
      textStyle:  const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,),
      foregroundColor: colorScheme.onPrimaryContainer
    )
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: colorScheme.primaryContainer,
       textStyle:  const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,),
    )
    
    
  ),
  inputDecorationTheme: const InputDecorationTheme().copyWith(
  fillColor: colorScheme.primaryContainer,
    floatingLabelStyle: TextStyle(
       color: colorScheme.primaryContainer,
        fontWeight: FontWeight.bold,
        fontSize: 16,
    ),
    focusedBorder:const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)) ,
      enabledBorder:const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
          labelStyle: TextStyle( color:colorScheme.primaryContainer, fontSize: 16)
  ),
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    headlineLarge:GoogleFonts.lobster(
      fontWeight: FontWeight.bold,
      color: colorScheme.primaryContainer
    ), 
     displayLarge:GoogleFonts.lobster(
      fontWeight: FontWeight.bold,
      color: colorScheme.onPrimaryContainer
    ),
    headlineMedium: GoogleFonts.lobster(
      fontWeight: FontWeight.bold,
      color: colorScheme.onPrimaryContainer
    ), 
    headlineSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: colorScheme.primaryContainer
    ),
    labelLarge:GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: colorScheme.secondaryContainer
    ),
    labelMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: colorScheme.secondaryContainer
    ), 
    labelSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: Colors.white
    ),
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: Colors.white
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
       color: Colors.white
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
       color: Colors.white
    ),
  ),
);
