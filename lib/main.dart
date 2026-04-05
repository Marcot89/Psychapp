// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  // Inicializa banco de fusos horários (necessário para notificações agendadas)
  tz.initializeTimeZones();
  runApp(
    const ProviderScope(
      child: PsychApp(),
    ),
  );
}
