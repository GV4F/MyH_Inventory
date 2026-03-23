import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}