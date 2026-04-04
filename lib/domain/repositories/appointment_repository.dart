// lib/domain/repositories/appointment_repository.dart
import '../models/appointment.dart';

abstract interface class AppointmentRepository {
  Future<List<Appointment>> getByPatient(String patientId);
  Future<List<Appointment>> getByDateRange(DateTime start, DateTime end);
  Future<List<Appointment>> getToday();
  Future<Appointment?> getById(String id);
  Future<void> save(Appointment appointment);
  Future<void> update(Appointment appointment);
  Future<void> delete(String id);
}
