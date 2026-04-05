import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:psychapp/domain/models/patient.dart';
import 'package:psychapp/domain/repositories/patient_repository.dart';
import 'package:psychapp/app/providers.dart';
import 'package:psychapp/presentation/patients/patients_notifier.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

class FakePatient extends Fake implements Patient {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePatient());
  });

  group('PatientsNotifier', () {
    late MockPatientRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockPatientRepository();
      container = ProviderContainer(overrides: [
        patientRepositoryProvider.overrideWithValue(mockRepo),
      ]);
    });

    tearDown(() => container.dispose());

    test('build carrega lista de pacientes ativos', () async {
      final patients = [
        Patient(id: '1', fullName: 'Ana', email: '', phone: '', createdAt: DateTime(2026)),
      ];
      when(() => mockRepo.getAll()).thenAnswer((_) async => patients);
      final result = await container.read(patientsProvider.future);
      expect(result, equals(patients));
    });

    test('add salva paciente e recarrega lista', () async {
      when(() => mockRepo.getAll()).thenAnswer((_) async => []);
      when(() => mockRepo.save(any())).thenAnswer((_) async {});
      final notifier = container.read(patientsProvider.notifier);
      await notifier.add('Maria', 'maria@email.com', '11999999999');
      verify(() => mockRepo.save(any())).called(1);
    });

    test('archive chama repo.archive e recarrega', () async {
      when(() => mockRepo.getAll()).thenAnswer((_) async => []);
      when(() => mockRepo.archive('1')).thenAnswer((_) async {});
      final notifier = container.read(patientsProvider.notifier);
      await notifier.archive('1');
      verify(() => mockRepo.archive('1')).called(1);
    });
  });
}
