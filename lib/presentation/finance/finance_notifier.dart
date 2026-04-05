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
  final List<MapEntry<DateTime, double>> monthlyRevenue;

  const FinanceState({
    required this.transactions,
    required this.totalPaid,
    required this.totalPending,
    this.monthlyRevenue = const [],
  });

  FinanceState copyWith({
    List<Transaction>? transactions,
    double? totalPaid,
    double? totalPending,
    List<MapEntry<DateTime, double>>? monthlyRevenue,
  }) {
    return FinanceState(
      transactions: transactions ?? this.transactions,
      totalPaid: totalPaid ?? this.totalPaid,
      totalPending: totalPending ?? this.totalPending,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
    );
  }
}

final financeProvider = AsyncNotifierProvider<FinanceNotifier, FinanceState>(
  FinanceNotifier.new,
);

class FinanceNotifier extends AsyncNotifier<FinanceState> {
  TransactionRepository get _repo => ref.read(transactionRepositoryProvider);

  @override
  Future<FinanceState> build() async {
    final repo = ref.read(transactionRepositoryProvider);
    final now = DateTime.now();

    // Last 6 months including current
    final monthly = <MapEntry<DateTime, double>>[];
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final paid = await repo.getTotalPaidByMonth(month.year, month.month);
      monthly.add(MapEntry(month, paid));
    }

    final transactions = await repo.getByMonth(now.year, now.month);
    final totalPaid = await repo.getTotalPaidByMonth(now.year, now.month);
    final totalPending = await repo.getTotalPendingByMonth(now.year, now.month);

    return FinanceState(
      transactions: transactions,
      totalPaid: totalPaid,
      totalPending: totalPending,
      monthlyRevenue: monthly,
    );
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
