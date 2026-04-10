import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final String content;
  final bool isAuth;

  const UserHeader({
    super.key,
    required this.content,
    required this.isAuth,
  });

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.2;
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: headerHeight,
      decoration: BoxDecoration(
        color: colors.secondary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: SafeArea( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(
                      color: colors.tertiary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), 
                const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}