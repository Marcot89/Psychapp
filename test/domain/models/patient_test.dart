import 'package:flutter_test/flutter_test.dart';
import 'package:psychapp/domain/models/patient.dart';

void main() {
  group('Patient', () {
    final basePatient = Patient(
      id: '123',
      fullName: 'Maria Silva',
      email: 'maria@email.com',
      phone: '11999999999',
      createdAt: DateTime(2026, 1, 1),
    );

    test('cria paciente ativo por padrão', () {
      expect(basePatient.isActive, isTrue);
    });

    test('copyWith altera apenas os campos especificados', () {
      final archived = basePatient.copyWith(isActive: false);
      expect(archived.isActive, isFalse);
      expect(archived.fullName, equals(basePatient.fullName));
    });

    test('notas vazias por padrão', () {
      expect(basePatient.notes, equals(''));
    });
  });
}
