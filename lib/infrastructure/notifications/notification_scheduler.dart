// lib/infrastructure/notifications/notification_scheduler.dart
// Gerencia notificações locais do app.
// Usa flutter_local_notifications para agendar alertas antes das sessões.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../domain/models/appointment.dart';

class NotificationScheduler {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(initSettings);
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  Future<void> scheduleForAppointment(Appointment appointment) async {
    await cancelForAppointment(appointment.id);
    final now = DateTime.now();

    final notify24h = appointment.startDate.subtract(const Duration(hours: 24));
    if (notify24h.isAfter(now)) {
      await _schedule(
        id: _idFrom(appointment.id, '24h'),
        title: 'Sessão amanhã',
        body: 'Sessão #${appointment.sessionNumber} às ${_formatTime(appointment.startDate)}',
        scheduledDate: notify24h,
      );
    }

    final notify1h = appointment.startDate.subtract(const Duration(hours: 1));
    if (notify1h.isAfter(now)) {
      await _schedule(
        id: _idFrom(appointment.id, '1h'),
        title: 'Sessão em 1 hora',
        body: 'Sessão #${appointment.sessionNumber} às ${_formatTime(appointment.startDate)}',
        scheduledDate: notify1h,
      );
    }
  }

  Future<void> cancelForAppointment(String appointmentId) async {
    await _plugin.cancel(_idFrom(appointmentId, '24h'));
    await _plugin.cancel(_idFrom(appointmentId, '1h'));
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> scheduleDailySummary() async {
    await _plugin.cancel(9000);
    final now = DateTime.now();
    var next8am = DateTime(now.year, now.month, now.day, 8, 0);
    if (next8am.isBefore(now)) {
      next8am = next8am.add(const Duration(days: 1));
    }
    await _schedule(
      id: 9000,
      title: 'Bom dia!',
      body: 'Verifique suas sessões de hoje no PsychApp.',
      scheduledDate: next8am,
    );
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'psychapp_sessions',
          'Sessões',
          channelDescription: 'Alertas de sessões agendadas',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  int _idFrom(String appointmentId, String suffix) =>
      '${appointmentId}_$suffix'.hashCode.abs() % 2147483647;

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
