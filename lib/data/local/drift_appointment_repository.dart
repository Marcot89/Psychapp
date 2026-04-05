// lib/data/local/drift_appointment_repository.dart
import 'package:drift/drift.dart';
import '../../domain/models/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import 'database.dart';

class DriftAppointmentRepository implements AppointmentRepository {
  final AppDatabase _db;
  DriftAppointmentRepository(this._db);

  Appointment _fromData(AppointmentsTableData d) => Appointment(
    id: d.id,
    patientId: d.patientId,
    startDate: d.startDate,
    endDate: d.endDate,
    sessionNumber: d.sessionNumber,
    type: SessionType.values.firstWhere((e) => e.name == d.type, orElse: () => SessionType.individual),
    status: AppointmentStatus.values.firstWhere((e) => e.name == d.status, orElse: () => AppointmentStatus.scheduled),
    notes: d.notes,
    googleEventId: d.googleEventId,
  );

  AppointmentsTableCompanion _toCompanion(Appointment a) => AppointmentsTableCompanion(
    id: Value(a.id),
    patientId: Value(a.patientId),
    startDate: Value(a.startDate),
    endDate: Value(a.endDate),
    sessionNumber: Value(a.sessionNumber),
    type: Value(a.type.name),
    status: Value(a.status.name),
    notes: Value(a.notes),
    googleEventId: Value(a.googleEventId),
  );

  @override
  Future<List<Appointment>> getByPatient(String patientId) async {
    final rows = await (_db.select(_db.appointmentsTable)
      ..where((t) => t.patientId.equals(patientId))
      ..orderBy([(t) => OrderingTerm.desc(t.startDate)])).get();
    return rows.map(_fromData).toList();
  }

  @override
  Future<List<Appointment>> getByDateRange(DateTime start, DateTime end) async {
    final rows = await (_db.select(_db.appointmentsTable)
      ..where((t) => t.startDate.isBetweenValues(start, end))
      ..orderBy([(t) => OrderingTerm.asc(t.startDate)])).get();
    return rows.map(_fromData).toList();
  }

  @override
  Future<List<Appointment>> getToday() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return getByDateRange(start, end);
  }

  @override
  Future<Appointment?> getById(String id) async {
    final row = await (_db.select(_db.appointmentsTable)
      ..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _fromData(row) : null;
  }

  @override
  Future<void> save(Appointment appointment) async {
    await _db.into(_db.appointmentsTable).insert(_toCompanion(appointment));
  }

  @override
  Future<void> update(Appointment appointment) async {
    await (_db.update(_db.appointmentsTable)
      ..where((t) => t.id.equals(appointment.id)))
        .write(_toCompanion(appointment));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.appointmentsTable)..where((t) => t.id.equals(id))).go();
  }
}
