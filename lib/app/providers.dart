// lib/app/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/database.dart';
import '../data/local/drift_patient_repository.dart';
import '../data/local/drift_appointment_repository.dart';
import '../data/local/drift_transaction_repository.dart';
import '../domain/repositories/patient_repository.dart';
import '../domain/repositories/appointment_repository.dart';
import '../domain/repositories/transaction_repository.dart';
import '../infrastructure/notifications/notification_scheduler.dart';
import '../data/google_calendar/google_calendar_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return DriftPatientRepository(ref.watch(databaseProvider));
});

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return DriftAppointmentRepository(ref.watch(databaseProvider));
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return DriftTransactionRepository(ref.watch(databaseProvider));
});

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return NotificationScheduler();
});

final googleCalendarServiceProvider = Provider<GoogleCalendarService>((ref) {
  return GoogleCalendarService();
});
