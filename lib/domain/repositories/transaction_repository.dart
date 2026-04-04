// lib/domain/repositories/transaction_repository.dart
import '../models/transaction.dart';

abstract interface class TransactionRepository {
  Future<List<Transaction>> getByPatient(String patientId);
  Future<List<Transaction>> getByMonth(int year, int month);
  Future<double> getTotalPaidByMonth(int year, int month);
  Future<double> getTotalPendingByMonth(int year, int month);
  Future<void> save(Transaction transaction);
  Future<void> update(Transaction transaction);
  Future<void> delete(String id);
}
