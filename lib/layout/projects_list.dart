import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'project_link.dart';
import 'dart:async';

class ProjectsListSection extends StatefulWidget {
  const ProjectsListSection({super.key});

  @override
  State<ProjectsListSection> createState() => _ProjectsListSectionState();
}
class _ProjectsListSectionState extends State<ProjectsListSection> {
  StreamSubscription? _subscription;
  final _supabase = Supabase.instance.client;

  List<dynamic> activeProjects = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _startListeningProjects();
  }

  void _startListeningProjects() {
    _subscription?.cancel(); // : We cancel any existing subscription before starting a new one

    try {
      _subscription = _supabase
          .from('locations')
          .stream(primaryKey: ['id'])
          .order('priority', ascending: true)
          .listen((data) {
            setState(() {
              activeProjects = data;
              isLoading = false;
            });
          });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching projects: $e';
        isLoading = false;
      });
    }
}

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  
@override
Widget build(BuildContext context) {

  final colors = Theme.of(context).colorScheme;
  
  // ! Debugging: Print the loading state and the number of projects fetched
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.amber));
    }

    return Container(
      color: colors.onSurface, 
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          ...activeProjects.map((project) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ProjectLink(
                title: project['name'],
                onTap: () {
                  context.push('/project/${project['id']}');
                },
                isPrimary: project['priority'] == 1,
                leftIcon: project['priority'] == 1 ? Icons.warehouse_rounded : null,
              ),
            );
          }),
        ],
      ),
    );
  }
}