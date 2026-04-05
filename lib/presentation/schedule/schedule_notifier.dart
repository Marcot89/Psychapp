// lib/presentation/schedule/schedule_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/repositories/patient_repository.dart';
import '../../app/providers.dart';

final weekAppointmentsProvider = AsyncNotifierProvider<ScheduleNotifier, List<Appointment>>(
  ScheduleNotifier.new,
);

class ScheduleNotifier extends AsyncNotifier<List<Appointment>> {
  AppointmentRepository get _repo => ref.read(appointmentRepositoryProvider);
  PatientRepository get _patientRepo => ref.read(patientRepositoryProvider);

  @override
  Future<List<Appointment>> build() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final end = start.add(const Duration(days: 7));
    return _repo.getByDateRange(start, end);
  }

  Future<void> add({
    required String patientId,
    required DateTime startDate,
    required DateTime endDate,
    SessionType type = SessionType.individual,
    String notes = '',
  }) async {
    final existing = await _repo.getByPatient(patientId);
    final sessionNumber = existing.length + 1;

    var appointment = Appointment(
      id: const Uuid().v4(),
      patientId: patientId,
      startDate: startDate,
      endDate: endDate,
      sessionNumber: sessionNumber,
      type: type,
      notes: notes,
    );

    // Salva localmente primeiro (fonte de verdade)
    await _repo.save(appointment);

    // Tenta sincronizar com Google Calendar (falha silenciosa)
    final gcalService = ref.read(googleCalendarServiceProvider);
    if (gcalService.isSignedIn) {
      final patient = await _patientRepo.getById(patientId);
      final patientName = patient?.fullName ?? 'Paciente';
      final googleEventId = await gcalService.createEvent(appointment, patientName);
      if (googleEventId != null) {
        // Atualiza registro local com o ID do evento Google
        appointment = appointment.copyWith(googleEventId: googleEventId);
        await _repo.update(appointment);
      }
    }

    // Agenda notificações locais
    await ref.read(notificationSchedulerProvider).scheduleForAppointment(appointment);

    ref.invalidateSelf();
  }

  Future<void> updateStatus(String id, AppointmentStatus newStatus) async {
    final appointment = await _repo.getById(id);
    if (appointment == null) return;
    final updated = appointment.copyWith(status: newStatus);
    await _repo.update(updated);

    if (newStatus == AppointmentStatus.cancelled) {
      await ref.read(notificationSchedulerProvider).cancelForAppointment(id);
      // Remove do Google Calendar se existir
      if (appointment.googleEventId != null) {
        await ref.read(googleCalendarServiceProvider)
            .deleteEvent(appointment.googleEventId!);
      }
    }

    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    final appointment = await _repo.getById(id);
    await ref.read(notificationSchedulerProvider).cancelForAppointment(id);
    if (appointment?.googleEventId != null) {
      await ref.read(googleCalendarServiceProvider)
          .deleteEvent(appointment!.googleEventId!);
    }
    await _repo.delete(id);
    ref.invalidateSelf();
  }
}
