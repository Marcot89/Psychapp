// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa dados de localização para pt_BR (datas em português)
  await initializeDateFormatting('pt_BR', null);
  runApp(
    const ProviderScope(
      child: PsychApp(),
    ),
  );
}
