// * FLUTER
import 'package:flutter/material.dart';
import './router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      title: 'Inventory App',
      routerConfig: appRouter,

      theme: ThemeData(
        brightness: Brightness.dark, 
        scaffoldBackgroundColor: const Color(0x12121212), 
        
        // : 3. Main Color Scheme
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFBC00E),
          secondary: Color(0xFF0A2463),
          tertiary: Color(0xFECECECE),
          surface: Color(0xFF212121),
        ),
        fontFamily: 'Montserrat',
      ),
    );
  }
}