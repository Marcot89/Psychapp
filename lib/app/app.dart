// lib/app/app.dart
// Configuração raiz do app: tema, roteamento, localização.

import 'package:flutter/material.dart';
import '../shared/theme/app_theme.dart';
import 'router.dart';

class PsychApp extends StatelessWidget {
  const PsychApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PsychApp',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
