// lib/data/local/drift_transaction_repository.dart
import 'package:drift/drift.dart';
import '../../domain/models/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'database.dart';

class DriftTransactionRepository implements TransactionRepository {
  final AppDatabase _db;
  DriftTransactionRepository(this._db);

  Transaction _fromData(TransactionsTableData d) => Transaction(
    id: d.id,
    patientId: d.patientId,
    amount: d.amount,
    date: d.date,
    isPaid: d.isPaid,
    method: PaymentMethod.values.firstWhere((e) => e.name == d.method, orElse: () => PaymentMethod.pix),
    notes: d.notes,
  );

  TransactionsTableCompanion _toCompanion(Transaction t) => TransactionsTableCompanion(
    id: Value(t.id),
    patientId: Value(t.patientId),
    amount: Value(t.amount),
    date: Value(t.date),
    isPaid: Value(t.isPaid),
    method: Value(t.method.name),
    notes: Value(t.notes),
  );

  @override
  Future<List<Transaction>> getByPatient(String patientId) async {
    final rows = await (_db.select(_db.transactionsTable)
      ..where((t) => t.patientId.equals(patientId))
      ..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
    return rows.map(_fromData).toList();
  }

  @override
  Future<List<Transaction>> getByMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final rows = await (_db.select(_db.transactionsTable)
      ..where((t) => t.date.isBetweenValues(start, end))
      ..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
    return rows.map(_fromData).toList();
  }

  @override
  Future<double> getTotalPaidByMonth(int year, int month) async {
    final list = await getByMonth(year, month);
    return list.where((t) => t.isPaid).fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  Future<double> getTotalPendingByMonth(int year, int month) async {
    final list = await getByMonth(year, month);
    return list.where((t) => !t.isPaid).fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  Future<void> save(Transaction transaction) async {
    await _db.into(_db.transactionsTable).insert(_toCompanion(transaction));
  }

  @override
  Future<void> update(Transaction transaction) async {
    await (_db.update(_db.transactionsTable)
      ..where((t) => t.id.equals(transaction.id)))
        .write(_toCompanion(transaction));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.transactionsTable)..where((t) => t.id.equals(id))).go();
  }
}
