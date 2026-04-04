// * FLUTER
import 'package:flutter/material.dart';
import './router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://mvbtupnpimptekgukzfx.supabase.co',
    anonKey: 'sb_publishable_ldJw7Iad2Lf1s3JrzzZXEQ_Yxqfu85L',
  );
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
        scaffoldBackgroundColor: const Color(0xFF121212),
        snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(color: Color(0xFFFCCC3E)),
        ),
        
        // : 3. Main Color Scheme
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFCCC3E),
          secondary: Color(0xFF0A2463),
          tertiary: Color(0xFECECECE),
          surface: Color(0xFF212121),
          onSurface: Color(0xFF121212),
        ),
        fontFamily: 'Montserrat',
      ),
    );
  }
}