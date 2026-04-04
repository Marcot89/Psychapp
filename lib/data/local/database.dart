// lib/data/local/database.dart
// Define a estrutura do banco de dados SQLite usando Drift.
// Drift gera código automaticamente a partir destas definições.
// Após qualquer alteração aqui, rode: flutter pub run build_runner build

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Importa o arquivo gerado (será criado pelo build_runner)
part 'database.g.dart';

// --- Definição das Tabelas ---

// Tabela de pacientes
class PatientsTable extends Table {
  @override
  String get tableName => 'patients';

  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// Tabela de sessões/consultas
class AppointmentsTable extends Table {
  @override
  String get tableName => 'appointments';

  TextColumn get id => text()();
  TextColumn get patientId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get sessionNumber => integer().withDefault(const Constant(1))();
  TextColumn get type => text().withDefault(const Constant('individual'))();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get googleEventId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Tabela de transações financeiras
class TransactionsTable extends Table {
  @override
  String get tableName => 'transactions';

  TextColumn get id => text()();
  TextColumn get patientId => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  TextColumn get method => text().withDefault(const Constant('pix'))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

// --- Configuração do Banco ---

@DriftDatabase(tables: [PatientsTable, AppointmentsTable, TransactionsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Versão do schema — incremente ao fazer migrações
  @override
  int get schemaVersion => 1;
}

// Abre a conexão com o arquivo do banco no dispositivo
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'psychapp.db'));
    return NativeDatabase.createInBackground(file);
  });
}
