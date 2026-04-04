// lib/app/providers.dart
// Define os providers Riverpod globais do app.
// Providers são como "caixas" que guardam objetos — Riverpod gerencia o ciclo de vida.
// Use "ref.watch(nomeProvider)" em qualquer Widget para acessar estes valores.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/database.dart';
import '../data/local/drift_patient_repository.dart';
import '../domain/repositories/patient_repository.dart';

// Provider do banco de dados — singleton (criado uma vez, reutilizado)
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  // Quando o provider é descartado, fecha a conexão com o banco
  ref.onDispose(db.close);
  return db;
});

// Provider do repositório de pacientes
final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftPatientRepository(db);
});
