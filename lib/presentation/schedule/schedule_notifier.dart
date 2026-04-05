// lib/presentation/schedule/schedule_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../app/providers.dart';

final weekAppointmentsProvider = AsyncNotifierProvider<ScheduleNotifier, List<Appointment>>(
  ScheduleNotifier.new,
);

class ScheduleNotifier extends AsyncNotifier<List<Appointment>> {
  AppointmentRepository get _repo => ref.read(appointmentRepositoryProvider);

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

    final appointment = Appointment(
      id: const Uuid().v4(),
      patientId: patientId,
      startDate: startDate,
      endDate: endDate,
      sessionNumber: sessionNumber,
      type: type,
      notes: notes,
    );
    await _repo.save(appointment);
    ref.invalidateSelf();
  }

  Future<void> updateStatus(String id, AppointmentStatus newStatus) async {
    final appointment = await _repo.getById(id);
    if (appointment == null) return;
    await _repo.update(appointment.copyWith(status: newStatus));
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    ref.invalidateSelf();
  }
}
