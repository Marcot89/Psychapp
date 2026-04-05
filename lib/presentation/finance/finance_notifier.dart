// lib/presentation/finance/finance_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../app/providers.dart';

class FinanceState {
  final List<Transaction> transactions;
  final double totalPaid;
  final double totalPending;

  const FinanceState({
    required this.transactions,
    required this.totalPaid,
    required this.totalPending,
  });
}

final financeProvider = AsyncNotifierProvider<FinanceNotifier, FinanceState>(
  FinanceNotifier.new,
);

class FinanceNotifier extends AsyncNotifier<FinanceState> {
  TransactionRepository get _repo => ref.read(transactionRepositoryProvider);

  int get _year => DateTime.now().year;
  int get _month => DateTime.now().month;

  @override
  Future<FinanceState> build() async {
    final transactions = await _repo.getByMonth(_year, _month);
    final paid = await _repo.getTotalPaidByMonth(_year, _month);
    final pending = await _repo.getTotalPendingByMonth(_year, _month);
    return FinanceState(transactions: transactions, totalPaid: paid, totalPending: pending);
  }

  Future<void> add({
    required String patientId,
    required double amount,
    required PaymentMethod method,
    bool isPaid = false,
    String notes = '',
  }) async {
    final transaction = Transaction(
      id: const Uuid().v4(),
      patientId: patientId,
      amount: amount,
      date: DateTime.now(),
      isPaid: isPaid,
      method: method,
      notes: notes,
    );
    await _repo.save(transaction);
    ref.invalidateSelf();
  }

  Future<void> markAsPaid(String id) async {
    final currentState = await future;
    final transaction = currentState.transactions.where((t) => t.id == id).firstOrNull;
    if (transaction == null) return;
    await _repo.update(transaction.copyWith(isPaid: true));
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    ref.invalidateSelf();
  }
}
