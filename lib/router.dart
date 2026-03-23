// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// - PAGES
import './pages/main_layout.dart';
import './pages/home_page.dart';
import './pages/project_page.dart';
import './pages/user_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // - Home: Initial route
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child); 
      },
      routes: [
        // : 1 Main Screen (Home)
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        
        // : 2 Project Screen with dynamic parameter
        GoRoute(
          path: '/project/:projectId', 
          builder: (context, state) {
            // - We extract the dynamic parameter from the URL
            final String projectId = state.pathParameters['projectId']!;
            
            return ProjectPage(projectId: projectId);
          },
        ),
        
        // : 3 User Profile Screen
        GoRoute(
          path: '/profile',
          builder: (context, state) => const UserPage(),
        ),
      ],
    )
  ]
);