// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app/app.dart';
import 'app/providers.dart';
import 'infrastructure/notifications/notification_scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  tz.initializeTimeZones();

  // Inicializa o plugin de notificações antes do app subir
  final notificationScheduler = NotificationScheduler();
  await notificationScheduler.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Injeta a instância já inicializada
        notificationSchedulerProvider.overrideWithValue(notificationScheduler),
      ],
      child: const PsychApp(),
    ),
  );
}
