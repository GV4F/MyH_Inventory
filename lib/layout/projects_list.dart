import 'package:flutter/material.dart';
import 'project_link.dart';

class ProjectsListSection extends StatelessWidget {
  // Simulando el estado de los proyectos que irás agregando/quitando.
  // Más adelante esto vendrá de un estado global o una base de datos.
  final List<String> activeProjects = [
    'Plaza Comercial: Granados',
    'Casa de 2 niveles: El Valle Salamá',
  ];

  ProjectsListSection({super.key});

  @override
  Widget build(BuildContext context) {
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
          ...activeProjects.map((projectName) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ProjectLink(
                title: projectName,
                onTap: () {
                  // Aquí pasarías el ID o nombre del proyecto a la siguiente pantalla
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}