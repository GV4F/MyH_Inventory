import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final IconData leftIcon;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    required this.title ,
    required this.leftIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(6.0)
            ),
            child: Row(
              children: [
                Icon(leftIcon, color: colors.surface, size: 20),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: colors.surface,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: colors.surface, size: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}