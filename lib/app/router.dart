// lib/app/router.dart
// Placeholder — será implementado na Task 9

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('PsychApp — Em construção')),
      ),
    ),
  ],
);
