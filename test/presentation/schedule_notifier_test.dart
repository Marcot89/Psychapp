import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:psychapp/domain/models/appointment.dart';
import 'package:psychapp/domain/repositories/appointment_repository.dart';
import 'package:psychapp/app/providers.dart';
import 'package:psychapp/infrastructure/notifications/notification_scheduler.dart';
import 'package:psychapp/presentation/schedule/schedule_notifier.dart';

class MockAppointmentRepository extends Mock implements AppointmentRepository {}
class MockNotificationScheduler extends Mock implements NotificationScheduler {}
class FakeAppointment extends Fake implements Appointment {}

void main() {
  setUpAll(() => registerFallbackValue(FakeAppointment()));

  group('ScheduleNotifier', () {
    late MockAppointmentRepository mockRepo;
    late MockNotificationScheduler mockNotifications;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockAppointmentRepository();
      mockNotifications = MockNotificationScheduler();
      container = ProviderContainer(overrides: [
        appointmentRepositoryProvider.overrideWithValue(mockRepo),
        notificationSchedulerProvider.overrideWithValue(mockNotifications),
      ]);
    });

    tearDown(() => container.dispose());

    test('build carrega sessões da semana', () async {
      when(() => mockRepo.getByDateRange(any(), any())).thenAnswer((_) async => []);
      final result = await container.read(weekAppointmentsProvider.future);
      expect(result, isEmpty);
    });

    test('updateStatus chama repo.update com novo status', () async {
      final appt = Appointment(
        id: '1', patientId: 'p1',
        startDate: DateTime.now(), endDate: DateTime.now().add(const Duration(hours: 1)),
        sessionNumber: 1,
      );
      when(() => mockRepo.getByDateRange(any(), any())).thenAnswer((_) async => []);
      when(() => mockRepo.getById('1')).thenAnswer((_) async => appt);
      when(() => mockRepo.update(any())).thenAnswer((_) async {});
      when(() => mockNotifications.cancelForAppointment(any())).thenAnswer((_) async {});

      await container.read(weekAppointmentsProvider.notifier)
          .updateStatus('1', AppointmentStatus.completed);

      final captured = verify(() => mockRepo.update(captureAny())).captured.first as Appointment;
      expect(captured.status, AppointmentStatus.completed);
    });

    test('updateStatus cancela notificações quando status é cancelled', () async {
      final appt = Appointment(
        id: '1', patientId: 'p1',
        startDate: DateTime.now(), endDate: DateTime.now().add(const Duration(hours: 1)),
        sessionNumber: 1,
      );
      when(() => mockRepo.getByDateRange(any(), any())).thenAnswer((_) async => []);
      when(() => mockRepo.getById('1')).thenAnswer((_) async => appt);
      when(() => mockRepo.update(any())).thenAnswer((_) async {});
      when(() => mockNotifications.cancelForAppointment('1')).thenAnswer((_) async {});

      await container.read(weekAppointmentsProvider.notifier)
          .updateStatus('1', AppointmentStatus.cancelled);

      verify(() => mockNotifications.cancelForAppointment('1')).called(1);
    });
  });
}
