import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// * LAYOUTS
import '../layout/main_header.dart';
import '../layout/projects_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = Supabase.instance.client.auth.currentUser;
    final username = user?.userMetadata?['username'] ?? 'Usuario';

    return Scaffold(
      backgroundColor: colors.onSurface,
      body: Column(
        children: [
          // - Header Main
          MainHeader(
            userName: username,
            logoWidget: Image.asset('assets/images/myh_logo.png'),
          ), 
          
          // - Main Content (Projects List)
          Expanded(
            child: ProjectsListSection(),
          ),          
        ],
      ),
    );
  }
}