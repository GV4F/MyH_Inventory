import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'project_link.dart';

class ProjectsListSection extends StatefulWidget {
  const ProjectsListSection({super.key});

  @override
  State<ProjectsListSection> createState() => _ProjectsListSectionState();
}
class _ProjectsListSectionState extends State<ProjectsListSection> {
  final _supabase = Supabase.instance.client;

  List<dynamic> activeProjects = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchActiveProjects();
  }

  Future<void> _fetchActiveProjects() async {
    try {
      final response = await _supabase
          .from('locations')
          .select();

      setState(() {
        activeProjects = response as List<dynamic>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching projects: $e';
        isLoading = false;
      });
    }
}
@override
Widget build(BuildContext context) {

  // ! Debugging: Print the loading state and the number of projects fetched
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.amber));
    }

    return Container(
      color: const Color(0x12121222), 
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          // --- Fixed links ---
          ProjectLink(
            title: 'Bodega Salamá',
            isPrimary: true,
            leftIcon: Icons.home_work_outlined,
            onTap: () {
              // Lógica de navegación
            },
          ),
          const SizedBox(height: 12.0),
          ProjectLink(
            title: 'Bodega Santa Bárbara',
            isPrimary: true, 
            leftIcon: Icons.warehouse_outlined,
            onTap: () {
              // Lógica de navegación
            },
          ),
          
          const SizedBox(height: 24.0), // Separador visual
          
          // ---  Dynamic links ---
          //- We use the operator spread (...) to insert a list of widgets generated from the activeProjects list.

          ...activeProjects.map((project) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ProjectLink(
                title: project['name'],
                onTap: () {
                  context.push('/project/${project['id']}');
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}