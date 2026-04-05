// lib/presentation/patients/patients_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../../app/providers.dart';

final patientsProvider = AsyncNotifierProvider<PatientsNotifier, List<Patient>>(
  PatientsNotifier.new,
);

class PatientsNotifier extends AsyncNotifier<List<Patient>> {
  PatientRepository get _repo => ref.read(patientRepositoryProvider);

  @override
  Future<List<Patient>> build() => _repo.getAll();

  Future<void> add(String fullName, String email, String phone, {String notes = ''}) async {
    final patient = Patient(
      id: const Uuid().v4(),
      fullName: fullName,
      email: email,
      phone: phone,
      notes: notes,
      createdAt: DateTime.now(),
    );
    await _repo.save(patient);
    ref.invalidateSelf();
  }

  Future<void> updatePatient(Patient patient) async {
    await _repo.update(patient);
    ref.invalidateSelf();
  }

  Future<void> archive(String id) async {
    await _repo.archive(id);
    ref.invalidateSelf();
  }

  Future<List<Patient>> search(String query) => _repo.searchByName(query);
}
