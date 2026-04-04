// lib/domain/models/patient.dart
// Modelo puro de Paciente — sem dependências de banco ou UI.
// Usa Equatable para comparação por valor (dois objetos com mesmos dados são iguais).

import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;           // UUID único do paciente
  final String fullName;     // Nome completo
  final String email;
  final String phone;
  final DateTime? dateOfBirth; // Data de nascimento (opcional)
  final String notes;          // Observações clínicas gerais
  final DateTime createdAt;    // Data de cadastro
  final bool isActive;         // false = paciente arquivado

  const Patient({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.notes = '',
    required this.createdAt,
    this.isActive = true,
  });

  // copyWith permite criar uma cópia com alguns campos alterados
  Patient copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    String? notes,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Patient(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, phone, dateOfBirth, notes, createdAt, isActive];
}
