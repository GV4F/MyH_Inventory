import 'package:flutter/material.dart';

import '../layout/user_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserHeader(
          content: 'Bienvenido',
          isAuth: true,
        ),
      ],
    );
  }
}