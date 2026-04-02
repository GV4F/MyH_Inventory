import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  final String userName;
  final Widget logoWidget;

  const MainHeader({
    super.key,
    required this.userName,
    required this.logoWidget,
  });

  // - Function for formatting the date in Spanish.
  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${months[now.month - 1]} ${now.day} de ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // - Padding
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      decoration: const BoxDecoration(
        // - Gradient Background
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A2463), 
            Color(0xFF212121), 
          ],  
        ),
        // - Bottom border radius
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40.0),
        ),
      ),
      // - SafeArea protege the content of the superior state bar
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // : Left section: Welcome message and date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bienvenido, $userName',
                  style: const TextStyle(
                    color: Color (0xF5F5F5F5),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    fontFamily: 'Bree serif',
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  _getFormattedDate(),
                  style: const TextStyle(
                    color: Color (0xCECECECE), 
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Bree serif',
                  ),
                ),
              ],
            ),
            
            // - Right Section: Circular logo container
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3), 
              ),
              child: ClipOval(
                child: Center(
                  child: SizedBox(width: 38.0, height: 38.0, child: logoWidget),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}