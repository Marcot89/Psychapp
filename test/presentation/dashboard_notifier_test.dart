import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:psychapp/domain/models/appointment.dart';
import 'package:psychapp/domain/repositories/appointment_repository.dart';
import 'package:psychapp/domain/repositories/transaction_repository.dart';
import 'package:psychapp/app/providers.dart';
import 'package:psychapp/presentation/dashboard/dashboard_notifier.dart';

class MockAppointmentRepository extends Mock implements AppointmentRepository {}
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group('DashboardNotifier', () {
    late MockAppointmentRepository mockAppt;
    late MockTransactionRepository mockTx;
    late ProviderContainer container;

    setUp(() {
      mockAppt = MockAppointmentRepository();
      mockTx = MockTransactionRepository();
      container = ProviderContainer(overrides: [
        appointmentRepositoryProvider.overrideWithValue(mockAppt),
        transactionRepositoryProvider.overrideWithValue(mockTx),
      ]);
    });

    tearDown(() => container.dispose());

    test('build carrega sessões de hoje e receita do mês', () async {
      final appt = Appointment(
        id: '1', patientId: 'p1',
        startDate: DateTime.now().add(const Duration(hours: 2)),
        endDate: DateTime.now().add(const Duration(hours: 3)),
        sessionNumber: 1,
      );
      when(() => mockAppt.getToday()).thenAnswer((_) async => [appt]);
      when(() => mockTx.getTotalPaidByMonth(any(), any())).thenAnswer((_) async => 500.0);

      final state = await container.read(dashboardProvider.future);
      expect(state.todayAppointments.length, 1);
      expect(state.monthRevenue, 500.0);
    });

    test('nextAppointment retorna próxima sessão futura não cancelada', () async {
      final past = Appointment(
        id: '1', patientId: 'p1',
        startDate: DateTime.now().subtract(const Duration(hours: 1)),
        endDate: DateTime.now(),
        sessionNumber: 1,
      );
      final future = Appointment(
        id: '2', patientId: 'p1',
        startDate: DateTime.now().add(const Duration(hours: 2)),
        endDate: DateTime.now().add(const Duration(hours: 3)),
        sessionNumber: 2,
      );
      when(() => mockAppt.getToday()).thenAnswer((_) async => [past, future]);
      when(() => mockTx.getTotalPaidByMonth(any(), any())).thenAnswer((_) async => 0.0);

      final state = await container.read(dashboardProvider.future);
      expect(state.nextAppointment?.id, '2');
    });
  });
}
