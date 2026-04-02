import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// * LAYOUT
import '../layout/project_header.dart';
import '../layout/project_item_list.dart';

class ProjectPage extends StatefulWidget {
  final String projectId;
  const ProjectPage({
    super.key,
    required this.projectId
  });

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final _supabase = Supabase.instance.client;

  List<dynamic> projectItems = [];
  String projectName = 'Cargando...';

  @override
  void initState() {
    super.initState();
    _fetchProjectDetails();
  }

  Future<void> _fetchProjectDetails() async {
    try {
      // - Fetch project details
      final projectResponse = await _supabase
          .from('locations')
          .select()
          .eq('id', widget.projectId)
          .single();

      setState(() {
        projectName = projectResponse['name'] ?? 'Proyecto sin nombre';
      });

      // - Fetch items related to the project
      final itemsResponse = await _supabase
          .from('products')
          .select()
          .eq('id_location', widget.projectId);

      setState(() {
        projectItems = itemsResponse as List<dynamic>;
      });
    } catch (e) {
      setState(() {
        projectName = 'Error al cargar el proyecto';
        projectItems = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProjectHeader(projectName: projectName),
          ItemsListContainer(projectId: widget.projectId),
        ],
      ),
    );
  }
}