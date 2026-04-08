import 'package:flutter/material.dart';

class ProjectLink extends StatelessWidget {
  final String title;
  final bool isPrimary;
  final bool isSecondary;
  final IconData? leftIcon;
  final VoidCallback onTap;

  const ProjectLink({
    super.key,
    required this.title,
    required this.onTap,
    this.isPrimary = false,
    this.isSecondary = false,
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
            color: isPrimary 
              ? colors.primary
              : isSecondary 
                ? Color(0xFFC61D24)
              : colors.secondary,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000), 
                offset: Offset(2, 5),               
                blurRadius: 5,                       
                spreadRadius: 1,                    
              ),
            ],
          ),
          child: Row(
            children: [
              if (leftIcon != null) ...[
                Icon(
                  leftIcon,
                  color: colors.surface,
                  size: 24.0,
                ),
                const SizedBox(width: 16.0),
              ],

              Expanded(
                child: Text(
                  title,
                  textAlign: isPrimary || isSecondary ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    color: isPrimary 
                      ? colors.surface 
                      : isSecondary 
                        ? colors.surface
                      : colors.tertiary,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Icon(
                Icons.arrow_forward_ios,
                color: isPrimary 
                  ? colors.surface 
                  : isSecondary 
                      ? colors.surface
                  : colors.tertiary,
                size: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}