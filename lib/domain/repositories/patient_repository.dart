// lib/domain/repositories/patient_repository.dart
// Interface (contrato) do repositório de pacientes.
// A camada de domínio não sabe COMO os dados são salvos — só O QUE pode fazer.

import '../models/patient.dart';

abstract interface class PatientRepository {
  Future<List<Patient>> getAll();
  Future<List<Patient>> getAllIncludingInactive();
  Future<Patient?> getById(String id);
  Future<List<Patient>> searchByName(String query);
  Future<void> save(Patient patient);
  Future<void> update(Patient patient);
  Future<void> archive(String id);
}
