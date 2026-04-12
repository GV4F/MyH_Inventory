// * FLUTER
import 'package:flutter/material.dart';
import './router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'utils/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: EnvConfig.url,
    anonKey: EnvConfig.anonKey,
  );

  final session = Supabase.instance.client.auth.currentSession;
  if (session != null) {
    print("Sesión activa desde el arranque: ${session.user.id}");
  }

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    print("Cambio de estado detectado: ${data.event}");
  });
  
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