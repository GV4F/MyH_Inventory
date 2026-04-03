import 'package:flutter/material.dart';

class ProjectLink extends StatelessWidget {
  final String title;
  final bool isPrimary;
  final IconData? leftIcon;
  final VoidCallback onTap;

  const ProjectLink({
    super.key,
    required this.title,
    required this.onTap,
    this.isPrimary = false,
    this.leftIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: isPrimary ? colors.primary : colors.secondary,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Color(0x75434343), // Shadow color with opacity
                offset: Offset(2, 4),                // Shadow position: right and down
                blurRadius: 5,                       // Softness of the shadow
                spreadRadius: 1,                     // Extend the shadow
              ),
            ],
          ),
          child: Row(
            children: [
              if (leftIcon != null) ...[
                Icon(
                  leftIcon,
                  color: isPrimary ? colors.surface : colors.tertiary,
                  size: 24.0,
                ),
                const SizedBox(width: 16.0),
              ],

              Expanded(
                child: Text(
                  title,
                  textAlign: isPrimary ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    color: isPrimary ? colors.surface : colors.tertiary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Icon(
                Icons.arrow_forward_ios,
                color: isPrimary ? colors.surface : colors.tertiary,
                size: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}