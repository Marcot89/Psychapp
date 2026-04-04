// lib/main.dart
// Ponto de entrada do app.
// ProviderScope é obrigatório — envolve todo o app para habilitar o Riverpod.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: PsychApp(),
    ),
  );
}
