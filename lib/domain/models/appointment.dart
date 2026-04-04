// lib/domain/models/appointment.dart
// Modelo de Sessão/Consulta.

import 'package:equatable/equatable.dart';

// Tipos de sessão possíveis
enum SessionType {
  individual,  // Sessão individual
  couple,      // Terapia de casal
  family,      // Terapia familiar
  evaluation,  // Avaliação psicológica
  other,       // Outros
}

// Status da sessão
enum AppointmentStatus {
  scheduled,   // Agendada (aguardando)
  confirmed,   // Confirmada pelo paciente
  completed,   // Realizada
  cancelled,   // Cancelada
  noShow,      // Paciente não compareceu
}

class Appointment extends Equatable {
  final String id;
  final String patientId;         // ID do paciente relacionado
  final DateTime startDate;       // Início da sessão
  final DateTime endDate;         // Fim da sessão
  final int sessionNumber;        // Número sequencial da sessão com este paciente
  final SessionType type;
  final AppointmentStatus status;
  final String notes;
  final String? googleEventId;    // ID no Google Calendar (para sincronização)

  const Appointment({
    required this.id,
    required this.patientId,
    required this.startDate,
    required this.endDate,
    required this.sessionNumber,
    this.type = SessionType.individual,
    this.status = AppointmentStatus.scheduled,
    this.notes = '',
    this.googleEventId,
  });

  Appointment copyWith({
    String? id,
    String? patientId,
    DateTime? startDate,
    DateTime? endDate,
    int? sessionNumber,
    SessionType? type,
    AppointmentStatus? status,
    String? notes,
    String? googleEventId,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sessionNumber: sessionNumber ?? this.sessionNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      googleEventId: googleEventId ?? this.googleEventId,
    );
  }

  // Duração calculada da sessão
  Duration get duration => endDate.difference(startDate);

  @override
  List<Object?> get props => [id, patientId, startDate, endDate, sessionNumber, type, status, notes, googleEventId];
}
