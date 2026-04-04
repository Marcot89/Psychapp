// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PatientsTableTable extends PatientsTable
    with TableInfo<$PatientsTableTable, PatientsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
      'date_of_birth', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, fullName, email, phone, dateOfBirth, notes, createdAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(Insertable<PatientsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatientsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      dateOfBirth: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_of_birth']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $PatientsTableTable createAlias(String alias) {
    return $PatientsTableTable(attachedDatabase, alias);
  }
}

class PatientsTableData extends DataClass
    implements Insertable<PatientsTableData> {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final DateTime? dateOfBirth;
  final String notes;
  final DateTime createdAt;
  final bool isActive;
  const PatientsTableData(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.phone,
      this.dateOfBirth,
      required this.notes,
      required this.createdAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  PatientsTableCompanion toCompanion(bool nullToAbsent) {
    return PatientsTableCompanion(
      id: Value(id),
      fullName: Value(fullName),
      email: Value(email),
      phone: Value(phone),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      notes: Value(notes),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory PatientsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientsTableData(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String>(json['phone']),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String>(phone),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  PatientsTableData copyWith(
          {String? id,
          String? fullName,
          String? email,
          String? phone,
          Value<DateTime?> dateOfBirth = const Value.absent(),
          String? notes,
          DateTime? createdAt,
          bool? isActive}) =>
      PatientsTableData(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        isActive: isActive ?? this.isActive,
      );
  PatientsTableData copyWithCompanion(PatientsTableCompanion data) {
    return PatientsTableData(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientsTableData(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, fullName, email, phone, dateOfBirth, notes, createdAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientsTableData &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.dateOfBirth == this.dateOfBirth &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class PatientsTableCompanion extends UpdateCompanion<PatientsTableData> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> email;
  final Value<String> phone;
  final Value<DateTime?> dateOfBirth;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const PatientsTableCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsTableCompanion.insert({
    required String id,
    required String fullName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fullName = Value(fullName),
        createdAt = Value(createdAt);
  static Insertable<PatientsTableData> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? fullName,
      Value<String>? email,
      Value<String>? phone,
      Value<DateTime?>? dateOfBirth,
      Value<String>? notes,
      Value<DateTime>? createdAt,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return PatientsTableCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsTableCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppointmentsTableTable extends AppointmentsTable
    with TableInfo<$AppointmentsTableTable, AppointmentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sessionNumberMeta =
      const VerificationMeta('sessionNumber');
  @override
  late final GeneratedColumn<int> sessionNumber = GeneratedColumn<int>(
      'session_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('individual'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('scheduled'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _googleEventIdMeta =
      const VerificationMeta('googleEventId');
  @override
  late final GeneratedColumn<String> googleEventId = GeneratedColumn<String>(
      'google_event_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        startDate,
        endDate,
        sessionNumber,
        type,
        status,
        notes,
        googleEventId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppointmentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('session_number')) {
      context.handle(
          _sessionNumberMeta,
          sessionNumber.isAcceptableOrUnknown(
              data['session_number']!, _sessionNumberMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('google_event_id')) {
      context.handle(
          _googleEventIdMeta,
          googleEventId.isAcceptableOrUnknown(
              data['google_event_id']!, _googleEventIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppointmentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppointmentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      sessionNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_number'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      googleEventId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}google_event_id']),
    );
  }

  @override
  $AppointmentsTableTable createAlias(String alias) {
    return $AppointmentsTableTable(attachedDatabase, alias);
  }
}

class AppointmentsTableData extends DataClass
    implements Insertable<AppointmentsTableData> {
  final String id;
  final String patientId;
  final DateTime startDate;
  final DateTime endDate;
  final int sessionNumber;
  final String type;
  final String status;
  final String notes;
  final String? googleEventId;
  const AppointmentsTableData(
      {required this.id,
      required this.patientId,
      required this.startDate,
      required this.endDate,
      required this.sessionNumber,
      required this.type,
      required this.status,
      required this.notes,
      this.googleEventId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['session_number'] = Variable<int>(sessionNumber);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || googleEventId != null) {
      map['google_event_id'] = Variable<String>(googleEventId);
    }
    return map;
  }

  AppointmentsTableCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsTableCompanion(
      id: Value(id),
      patientId: Value(patientId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      sessionNumber: Value(sessionNumber),
      type: Value(type),
      status: Value(status),
      notes: Value(notes),
      googleEventId: googleEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(googleEventId),
    );
  }

  factory AppointmentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppointmentsTableData(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      sessionNumber: serializer.fromJson<int>(json['sessionNumber']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String>(json['notes']),
      googleEventId: serializer.fromJson<String?>(json['googleEventId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'sessionNumber': serializer.toJson<int>(sessionNumber),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String>(notes),
      'googleEventId': serializer.toJson<String?>(googleEventId),
    };
  }

  AppointmentsTableData copyWith(
          {String? id,
          String? patientId,
          DateTime? startDate,
          DateTime? endDate,
          int? sessionNumber,
          String? type,
          String? status,
          String? notes,
          Value<String?> googleEventId = const Value.absent()}) =>
      AppointmentsTableData(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        sessionNumber: sessionNumber ?? this.sessionNumber,
        type: type ?? this.type,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        googleEventId:
            googleEventId.present ? googleEventId.value : this.googleEventId,
      );
  AppointmentsTableData copyWithCompanion(AppointmentsTableCompanion data) {
    return AppointmentsTableData(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      sessionNumber: data.sessionNumber.present
          ? data.sessionNumber.value
          : this.sessionNumber,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      googleEventId: data.googleEventId.present
          ? data.googleEventId.value
          : this.googleEventId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsTableData(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('sessionNumber: $sessionNumber, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('googleEventId: $googleEventId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, startDate, endDate,
      sessionNumber, type, status, notes, googleEventId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppointmentsTableData &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.sessionNumber == this.sessionNumber &&
          other.type == this.type &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.googleEventId == this.googleEventId);
}

class AppointmentsTableCompanion
    extends UpdateCompanion<AppointmentsTableData> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> sessionNumber;
  final Value<String> type;
  final Value<String> status;
  final Value<String> notes;
  final Value<String?> googleEventId;
  final Value<int> rowid;
  const AppointmentsTableCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.sessionNumber = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.googleEventId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppointmentsTableCompanion.insert({
    required String id,
    required String patientId,
    required DateTime startDate,
    required DateTime endDate,
    this.sessionNumber = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.googleEventId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        startDate = Value(startDate),
        endDate = Value(endDate);
  static Insertable<AppointmentsTableData> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? sessionNumber,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? googleEventId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (sessionNumber != null) 'session_number': sessionNumber,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (googleEventId != null) 'google_event_id': googleEventId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppointmentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<int>? sessionNumber,
      Value<String>? type,
      Value<String>? status,
      Value<String>? notes,
      Value<String?>? googleEventId,
      Value<int>? rowid}) {
    return AppointmentsTableCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sessionNumber: sessionNumber ?? this.sessionNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      googleEventId: googleEventId ?? this.googleEventId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (sessionNumber.present) {
      map['session_number'] = Variable<int>(sessionNumber.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (googleEventId.present) {
      map['google_event_id'] = Variable<String>(googleEventId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsTableCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('sessionNumber: $sessionNumber, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pix'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, patientId, amount, date, isPaid, method, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

class TransactionsTableData extends DataClass
    implements Insertable<TransactionsTableData> {
  final String id;
  final String patientId;
  final double amount;
  final DateTime date;
  final bool isPaid;
  final String method;
  final String notes;
  const TransactionsTableData(
      {required this.id,
      required this.patientId,
      required this.amount,
      required this.date,
      required this.isPaid,
      required this.method,
      required this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['is_paid'] = Variable<bool>(isPaid);
    map['method'] = Variable<String>(method);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      patientId: Value(patientId),
      amount: Value(amount),
      date: Value(date),
      isPaid: Value(isPaid),
      method: Value(method),
      notes: Value(notes),
    );
  }

  factory TransactionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      method: serializer.fromJson<String>(json['method']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'isPaid': serializer.toJson<bool>(isPaid),
      'method': serializer.toJson<String>(method),
      'notes': serializer.toJson<String>(notes),
    };
  }

  TransactionsTableData copyWith(
          {String? id,
          String? patientId,
          double? amount,
          DateTime? date,
          bool? isPaid,
          String? method,
          String? notes}) =>
      TransactionsTableData(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        isPaid: isPaid ?? this.isPaid,
        method: method ?? this.method,
        notes: notes ?? this.notes,
      );
  TransactionsTableData copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionsTableData(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      method: data.method.present ? data.method.value : this.method,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('isPaid: $isPaid, ')
          ..write('method: $method, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, patientId, amount, date, isPaid, method, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.isPaid == this.isPaid &&
          other.method == this.method &&
          other.notes == this.notes);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<bool> isPaid;
  final Value<String> method;
  final Value<String> notes;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String id,
    required String patientId,
    required double amount,
    required DateTime date,
    this.isPaid = const Value.absent(),
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        amount = Value(amount),
        date = Value(date);
  static Insertable<TransactionsTableData> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<bool>? isPaid,
    Expression<String>? method,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (isPaid != null) 'is_paid': isPaid,
      if (method != null) 'method': method,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<bool>? isPaid,
      Value<String>? method,
      Value<String>? notes,
      Value<int>? rowid}) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isPaid: isPaid ?? this.isPaid,
      method: method ?? this.method,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('isPaid: $isPaid, ')
          ..write('method: $method, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTableTable patientsTable = $PatientsTableTable(this);
  late final $AppointmentsTableTable appointmentsTable =
      $AppointmentsTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [patientsTable, appointmentsTable, transactionsTable];
}

typedef $$PatientsTableTableCreateCompanionBuilder = PatientsTableCompanion
    Function({
  required String id,
  required String fullName,
  Value<String> email,
  Value<String> phone,
  Value<DateTime?> dateOfBirth,
  Value<String> notes,
  required DateTime createdAt,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$PatientsTableTableUpdateCompanionBuilder = PatientsTableCompanion
    Function({
  Value<String> id,
  Value<String> fullName,
  Value<String> email,
  Value<String> phone,
  Value<DateTime?> dateOfBirth,
  Value<String> notes,
  Value<DateTime> createdAt,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$PatientsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PatientsTableTable> {
  $$PatientsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$PatientsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientsTableTable> {
  $$PatientsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$PatientsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientsTableTable> {
  $$PatientsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$PatientsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientsTableTable,
    PatientsTableData,
    $$PatientsTableTableFilterComposer,
    $$PatientsTableTableOrderingComposer,
    $$PatientsTableTableAnnotationComposer,
    $$PatientsTableTableCreateCompanionBuilder,
    $$PatientsTableTableUpdateCompanionBuilder,
    (
      PatientsTableData,
      BaseReferences<_$AppDatabase, $PatientsTableTable, PatientsTableData>
    ),
    PatientsTableData,
    PrefetchHooks Function()> {
  $$PatientsTableTableTableManager(_$AppDatabase db, $PatientsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<DateTime?> dateOfBirth = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsTableCompanion(
            id: id,
            fullName: fullName,
            email: email,
            phone: phone,
            dateOfBirth: dateOfBirth,
            notes: notes,
            createdAt: createdAt,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fullName,
            Value<String> email = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<DateTime?> dateOfBirth = const Value.absent(),
            Value<String> notes = const Value.absent(),
            required DateTime createdAt,
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsTableCompanion.insert(
            id: id,
            fullName: fullName,
            email: email,
            phone: phone,
            dateOfBirth: dateOfBirth,
            notes: notes,
            createdAt: createdAt,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PatientsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientsTableTable,
    PatientsTableData,
    $$PatientsTableTableFilterComposer,
    $$PatientsTableTableOrderingComposer,
    $$PatientsTableTableAnnotationComposer,
    $$PatientsTableTableCreateCompanionBuilder,
    $$PatientsTableTableUpdateCompanionBuilder,
    (
      PatientsTableData,
      BaseReferences<_$AppDatabase, $PatientsTableTable, PatientsTableData>
    ),
    PatientsTableData,
    PrefetchHooks Function()>;
typedef $$AppointmentsTableTableCreateCompanionBuilder
    = AppointmentsTableCompanion Function({
  required String id,
  required String patientId,
  required DateTime startDate,
  required DateTime endDate,
  Value<int> sessionNumber,
  Value<String> type,
  Value<String> status,
  Value<String> notes,
  Value<String?> googleEventId,
  Value<int> rowid,
});
typedef $$AppointmentsTableTableUpdateCompanionBuilder
    = AppointmentsTableCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<int> sessionNumber,
  Value<String> type,
  Value<String> status,
  Value<String> notes,
  Value<String?> googleEventId,
  Value<int> rowid,
});

class $$AppointmentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppointmentsTableTable> {
  $$AppointmentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionNumber => $composableBuilder(
      column: $table.sessionNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get googleEventId => $composableBuilder(
      column: $table.googleEventId, builder: (column) => ColumnFilters(column));
}

class $$AppointmentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppointmentsTableTable> {
  $$AppointmentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionNumber => $composableBuilder(
      column: $table.sessionNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get googleEventId => $composableBuilder(
      column: $table.googleEventId,
      builder: (column) => ColumnOrderings(column));
}

class $$AppointmentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppointmentsTableTable> {
  $$AppointmentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get sessionNumber => $composableBuilder(
      column: $table.sessionNumber, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get googleEventId => $composableBuilder(
      column: $table.googleEventId, builder: (column) => column);
}

class $$AppointmentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppointmentsTableTable,
    AppointmentsTableData,
    $$AppointmentsTableTableFilterComposer,
    $$AppointmentsTableTableOrderingComposer,
    $$AppointmentsTableTableAnnotationComposer,
    $$AppointmentsTableTableCreateCompanionBuilder,
    $$AppointmentsTableTableUpdateCompanionBuilder,
    (
      AppointmentsTableData,
      BaseReferences<_$AppDatabase, $AppointmentsTableTable,
          AppointmentsTableData>
    ),
    AppointmentsTableData,
    PrefetchHooks Function()> {
  $$AppointmentsTableTableTableManager(
      _$AppDatabase db, $AppointmentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppointmentsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<int> sessionNumber = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String?> googleEventId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppointmentsTableCompanion(
            id: id,
            patientId: patientId,
            startDate: startDate,
            endDate: endDate,
            sessionNumber: sessionNumber,
            type: type,
            status: status,
            notes: notes,
            googleEventId: googleEventId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required DateTime startDate,
            required DateTime endDate,
            Value<int> sessionNumber = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String?> googleEventId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppointmentsTableCompanion.insert(
            id: id,
            patientId: patientId,
            startDate: startDate,
            endDate: endDate,
            sessionNumber: sessionNumber,
            type: type,
            status: status,
            notes: notes,
            googleEventId: googleEventId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppointmentsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppointmentsTableTable,
    AppointmentsTableData,
    $$AppointmentsTableTableFilterComposer,
    $$AppointmentsTableTableOrderingComposer,
    $$AppointmentsTableTableAnnotationComposer,
    $$AppointmentsTableTableCreateCompanionBuilder,
    $$AppointmentsTableTableUpdateCompanionBuilder,
    (
      AppointmentsTableData,
      BaseReferences<_$AppDatabase, $AppointmentsTableTable,
          AppointmentsTableData>
    ),
    AppointmentsTableData,
    PrefetchHooks Function()>;
typedef $$TransactionsTableTableCreateCompanionBuilder
    = TransactionsTableCompanion Function({
  required String id,
  required String patientId,
  required double amount,
  required DateTime date,
  Value<bool> isPaid,
  Value<String> method,
  Value<String> notes,
  Value<int> rowid,
});
typedef $$TransactionsTableTableUpdateCompanionBuilder
    = TransactionsTableCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<double> amount,
  Value<DateTime> date,
  Value<bool> isPaid,
  Value<String> method,
  Value<String> notes,
  Value<int> rowid,
});

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$TransactionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTableTable,
    TransactionsTableData,
    $$TransactionsTableTableFilterComposer,
    $$TransactionsTableTableOrderingComposer,
    $$TransactionsTableTableAnnotationComposer,
    $$TransactionsTableTableCreateCompanionBuilder,
    $$TransactionsTableTableUpdateCompanionBuilder,
    (
      TransactionsTableData,
      BaseReferences<_$AppDatabase, $TransactionsTableTable,
          TransactionsTableData>
    ),
    TransactionsTableData,
    PrefetchHooks Function()> {
  $$TransactionsTableTableTableManager(
      _$AppDatabase db, $TransactionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsTableCompanion(
            id: id,
            patientId: patientId,
            amount: amount,
            date: date,
            isPaid: isPaid,
            method: method,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required double amount,
            required DateTime date,
            Value<bool> isPaid = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsTableCompanion.insert(
            id: id,
            patientId: patientId,
            amount: amount,
            date: date,
            isPaid: isPaid,
            method: method,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTableTable,
    TransactionsTableData,
    $$TransactionsTableTableFilterComposer,
    $$TransactionsTableTableOrderingComposer,
    $$TransactionsTableTableAnnotationComposer,
    $$TransactionsTableTableCreateCompanionBuilder,
    $$TransactionsTableTableUpdateCompanionBuilder,
    (
      TransactionsTableData,
      BaseReferences<_$AppDatabase, $TransactionsTableTable,
          TransactionsTableData>
    ),
    TransactionsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableTableManager get patientsTable =>
      $$PatientsTableTableTableManager(_db, _db.patientsTable);
  $$AppointmentsTableTableTableManager get appointmentsTable =>
      $$AppointmentsTableTableTableManager(_db, _db.appointmentsTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
}
