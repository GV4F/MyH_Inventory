import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: const Color(0x12121212),
      body: Column(
        children: [
          // - Header Main
          MainHeader(
            userName: 'GVAF',
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