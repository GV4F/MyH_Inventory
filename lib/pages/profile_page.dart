import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myh_inventory/auth/auth_sevice.dart';

import '../layout/profile_card.dart';
import '../layout/user_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {

    final user = Supabase.instance.client.auth.currentUser;
    final username = user?.userMetadata?['username'] ?? 'Usuario';
    // final colors = Theme.of(context).colorScheme;
    final authService = AuthService();

    return Column(
      children: [
        UserHeader(
          content: 'Bienvenido $username',
          isAuth: true,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: ProfileCard(title: 'Cerrar Sesión', leftIcon: Icons.exit_to_app, onTap: authService.signOut),
        )
      ],
    );
  }
}