// lib/domain/models/transaction.dart
// Modelo de Transação Financeira.

import 'package:equatable/equatable.dart';

// Formas de pagamento aceitas
enum PaymentMethod {
  pix,
  creditCard,   // Cartão de crédito/débito
  cash,         // Dinheiro
  insurance,    // Plano de saúde
  bankTransfer, // Transferência bancária
}

class Transaction extends Equatable {
  final String id;
  final String patientId;
  final double amount;          // Valor em reais
  final DateTime date;          // Data da transação
  final bool isPaid;            // true = recebido, false = pendente
  final PaymentMethod method;
  final String notes;

  const Transaction({
    required this.id,
    required this.patientId,
    required this.amount,
    required this.date,
    this.isPaid = false,
    this.method = PaymentMethod.pix,
    this.notes = '',
  });

  Transaction copyWith({
    String? id,
    String? patientId,
    double? amount,
    DateTime? date,
    bool? isPaid,
    PaymentMethod? method,
    String? notes,
  }) {
    return Transaction(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isPaid: isPaid ?? this.isPaid,
      method: method ?? this.method,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, patientId, amount, date, isPaid, method, notes];
}
