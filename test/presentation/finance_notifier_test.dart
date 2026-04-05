import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:psychapp/domain/models/transaction.dart';
import 'package:psychapp/domain/repositories/transaction_repository.dart';
import 'package:psychapp/app/providers.dart';
import 'package:psychapp/presentation/finance/finance_notifier.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}
class FakeTransaction extends Fake implements Transaction {}

void main() {
  setUpAll(() => registerFallbackValue(FakeTransaction()));

  group('FinanceNotifier', () {
    late MockTransactionRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockTransactionRepository();
      container = ProviderContainer(overrides: [
        transactionRepositoryProvider.overrideWithValue(mockRepo),
      ]);
    });

    tearDown(() => container.dispose());

    test('build carrega estado do mês atual', () async {
      when(() => mockRepo.getByMonth(any(), any())).thenAnswer((_) async => []);
      when(() => mockRepo.getTotalPaidByMonth(any(), any())).thenAnswer((_) async => 0.0);
      when(() => mockRepo.getTotalPendingByMonth(any(), any())).thenAnswer((_) async => 0.0);

      final state = await container.read(financeProvider.future);
      expect(state.transactions, isEmpty);
      expect(state.totalPaid, 0.0);
      expect(state.totalPending, 0.0);
    });

    test('markAsPaid atualiza transação como paga', () async {
      final t = Transaction(id: '1', patientId: 'p1', amount: 200.0, date: DateTime.now(), isPaid: false);
      when(() => mockRepo.getByMonth(any(), any())).thenAnswer((_) async => [t]);
      when(() => mockRepo.getTotalPaidByMonth(any(), any())).thenAnswer((_) async => 0.0);
      when(() => mockRepo.getTotalPendingByMonth(any(), any())).thenAnswer((_) async => 200.0);
      when(() => mockRepo.update(any())).thenAnswer((_) async {});

      await container.read(financeProvider.notifier).markAsPaid('1');

      final captured = verify(() => mockRepo.update(captureAny())).captured.first as Transaction;
      expect(captured.isPaid, isTrue);
    });
  });
}
