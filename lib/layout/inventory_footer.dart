import 'package:flutter/material.dart';

class InventoryFooter extends StatelessWidget {
  // - Callbacks for every button tap, to be defined by the parent widget
  
  final VoidCallback onHomeTap;
  final VoidCallback onAddProjectTap;
  final VoidCallback onUserTap;

  const InventoryFooter({
    super.key,
    required this.onHomeTap,
    required this.onAddProjectTap,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Container(
  
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Color(0xFF313131),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32.0),
        ),
      ),
      child: SafeArea(
        // - SafeArea protege the content of the inferior state bar in mobile devices
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Left button: HOME ---
            _CircleIconButton(
              iconData: Icons.home,
              onTap: onHomeTap,
              backgroundColor: colors.primary, 
              iconColor: colors.surface,
            ),
            
            // --- Center button: Add Project ---
            _CircleIconButton(
              iconData: Icons.add,
              onTap: onAddProjectTap,
              backgroundColor: const Color(0xFF121212),
              iconColor: colors.primary,
              isCentral: true, // Parámetro para cambiar tamaño y onda
            ),
            
            // --- Right button: USER ---
            _CircleIconButton(
              iconData: Icons.person,
              onTap: onUserTap,
              backgroundColor: colors.primary,
              iconColor: colors.surface,
            ),
          ],
        ),
      ),
    );
  }
}

// - Private internal widget for the circular buttons in the footer
class _CircleIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final bool isCentral;

  const _CircleIconButton({
    required this.iconData,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
    this.isCentral = false,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonSize = isCentral ? 56.0 : 64.0;
    final double iconSize = isCentral ? 32.0 : 28.0;

    return Material(
      color: Colors.transparent, // Invisible material to allow InkWell splash
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(), 
        splashColor: isCentral ? Colors.amber.withValues(alpha: 0.3) : Colors.black12,
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle, // Circular shape
            // Small border for central button to make it pop a bit more
            border: isCentral ? Border.all(color: Colors.amber.withValues(alpha: 0.2), width: 0.5) : null,
          ),
          child: Center(
            child: Icon(
              iconData,
              color: iconColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}