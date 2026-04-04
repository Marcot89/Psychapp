// lib/data/local/drift_patient_repository.dart
// Implementação concreta do PatientRepository usando Drift (SQLite).

import 'package:drift/drift.dart';
import '../../domain/models/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import 'database.dart';

class DriftPatientRepository implements PatientRepository {
  final AppDatabase _db;

  DriftPatientRepository(this._db);

  // Converte linha do banco → modelo de domínio
  Patient _fromData(PatientsTableData data) {
    return Patient(
      id: data.id,
      fullName: data.fullName,
      email: data.email,
      phone: data.phone,
      dateOfBirth: data.dateOfBirth,
      notes: data.notes,
      createdAt: data.createdAt,
      isActive: data.isActive,
    );
  }

  // Converte modelo de domínio → formato para inserir no banco
  PatientsTableCompanion _toCompanion(Patient p) {
    return PatientsTableCompanion(
      id: Value(p.id),
      fullName: Value(p.fullName),
      email: Value(p.email),
      phone: Value(p.phone),
      dateOfBirth: Value(p.dateOfBirth),
      notes: Value(p.notes),
      createdAt: Value(p.createdAt),
      isActive: Value(p.isActive),
    );
  }

  @override
  Future<List<Patient>> getAll() async {
    final rows = await (_db.select(_db.patientsTable)
      ..where((t) => t.isActive.equals(true))).get();
    return rows.map(_fromData).toList();
  }

  @override
  Future<List<Patient>> getAllIncludingInactive() async {
    final rows = await _db.select(_db.patientsTable).get();
    return rows.map(_fromData).toList();
  }

  @override
  Future<Patient?> getById(String id) async {
    final row = await (_db.select(_db.patientsTable)
      ..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _fromData(row) : null;
  }

  @override
  Future<List<Patient>> searchByName(String query) async {
    final rows = await (_db.select(_db.patientsTable)
      ..where((t) => t.fullName.contains(query) & t.isActive.equals(true))).get();
    return rows.map(_fromData).toList();
  }

  @override
  Future<void> save(Patient patient) async {
    await _db.into(_db.patientsTable).insert(_toCompanion(patient));
  }

  @override
  Future<void> update(Patient patient) async {
    await (_db.update(_db.patientsTable)
      ..where((t) => t.id.equals(patient.id)))
        .write(_toCompanion(patient));
  }

  @override
  Future<void> archive(String id) async {
    await (_db.update(_db.patientsTable)..where((t) => t.id.equals(id)))
        .write(const PatientsTableCompanion(isActive: Value(false)));
  }
}
