import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:psychapp/domain/models/appointment.dart';
import 'package:psychapp/domain/repositories/appointment_repository.dart';
import 'package:psychapp/domain/repositories/patient_repository.dart';
import 'package:psychapp/app/providers.dart';
import 'package:psychapp/infrastructure/notifications/notification_scheduler.dart';
import 'package:psychapp/data/google_calendar/google_calendar_service.dart';
import 'package:psychapp/presentation/schedule/schedule_notifier.dart';

class MockAppointmentRepository extends Mock implements AppointmentRepository {}
class MockPatientRepository extends Mock implements PatientRepository {}
class MockNotificationScheduler extends Mock implements NotificationScheduler {}
class MockGoogleCalendarService extends Mock implements GoogleCalendarService {}
class FakeAppointment extends Fake implements Appointment {}

void main() {
  setUpAll(() => registerFallbackValue(FakeAppointment()));

  group('ScheduleNotifier', () {
    late MockAppointmentRepository mockRepo;
    late MockPatientRepository mockPatientRepo;
    late MockNotificationScheduler mockNotifications;
    late MockGoogleCalendarService mockGcal;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockAppointmentRepository();
      mockPatientRepo = MockPatientRepository();
      mockNotifications = MockNotificationScheduler();
      mockGcal = MockGoogleCalendarService();

      // Google Calendar desconectado por padrão nos testes
      when(() => mockGcal.isSignedIn).thenReturn(false);

      container = ProviderContainer(overrides: [
        appointmentRepositoryProvider.overrideWithValue(mockRepo),
        patientRepositoryProvider.overrideWithValue(mockPatientRepo),
        notificationSchedulerProvider.overrideWithValue(mockNotifications),
        googleCalendarServiceProvider.overrideWithValue(mockGcal),
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
