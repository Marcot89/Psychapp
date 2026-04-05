# Session Edit + Pending Payments Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Allow editing existing appointments (date/time/duration/type/notes) and add a Pending Payments screen listing patients with unpaid transactions.

**Architecture:** Task 1 adds `updateAppointment()` to `ScheduleNotifier` and extends `AppointmentFormScreen` with an optional `appointment` parameter for edit mode. Task 2 creates `PendingPaymentsScreen` with a `FutureProvider` that aggregates unpaid transactions by patient across 12 months. No schema changes needed.

**Tech Stack:** Flutter 3.41.6 · Riverpod 2.x · Drift 2.x · existing repositories

---

### Task 1: Edit Appointment — ScheduleNotifier

**Files:**
- Modify: `lib/presentation/schedule/schedule_notifier.dart`

**Step 1: Add `updateAppointment` method to `ScheduleNotifier`**

Open `lib/presentation/schedule/schedule_notifier.dart`. After the `updateStatus` method, add:

```dart
/// Updates all editable fields of an existing appointment.
/// Cancels old notifications, reschedules new ones, and syncs to Google Calendar.
Future<void> updateAppointment(Appointment updated) async {
  await _repo.update(updated);

  // Cancel old notifications and reschedule with new times
  final notifier = ref.read(notificationSchedulerProvider);
  await notifier.cancelForAppointment(updated.id);
  await notifier.scheduleForAppointment(updated);

  // Sync to Google Calendar if connected
  if (updated.googleEventId != null) {
    final patient = await _patientRepo.getById(updated.patientId);
    final patientName = patient?.fullName ?? 'Paciente';
    await ref.read(googleCalendarServiceProvider)
        .updateEvent(updated, patientName);
  }

  ref.invalidateSelf();
}
```

**Step 2: Run analyze**

```bash
cd "/c/Users/Admin/OneDrive/Área de Trabalho/APP psicologia/psychapp" && /c/flutter/flutter/bin/flutter.bat analyze
```
Expected: no issues.

**Step 3: Commit**

```bash
git add lib/presentation/schedule/schedule_notifier.dart
git commit -m "feat: add updateAppointment method to ScheduleNotifier"
```

---

### Task 2: Edit Appointment — AppointmentFormScreen

**Files:**
- Modify: `lib/presentation/schedule/appointment_form_screen.dart`

**Step 1: Read the current file**

Read `lib/presentation/schedule/appointment_form_screen.dart` to understand current state.

**Step 2: Add optional `appointment` parameter to the widget**

Change the widget class from:
```dart
class AppointmentFormScreen extends ConsumerStatefulWidget {
  const AppointmentFormScreen({super.key});
```
to:
```dart
class AppointmentFormScreen extends ConsumerStatefulWidget {
  /// If provided, the form opens in edit mode pre-filled with this appointment.
  final Appointment? appointment;
  const AppointmentFormScreen({super.key, this.appointment});
```

**Step 3: Initialize state fields from existing appointment in edit mode**

In `_AppointmentFormScreenState`, find `_startDate`, `_duration`, `_type`, `_notesCtrl` declarations and change the initializers to use the existing appointment when present:

```dart
Patient? _selectedPatient;
late DateTime _startDate;
late Duration _duration;
late SessionType _type;
late final TextEditingController _notesCtrl;
bool _loading = false;

bool get _isEditing => widget.appointment != null;
DateTime get _endDate => _startDate.add(_duration);
```

Add an `initState` override to initialize from the existing appointment:

```dart
@override
void initState() {
  super.initState();
  final a = widget.appointment;
  if (a != null) {
    _startDate = a.startDate;
    _duration = a.endDate.difference(a.startDate);
    _type = a.type;
    _notesCtrl = TextEditingController(text: a.notes);
  } else {
    _startDate = DateTime.now().add(const Duration(hours: 1));
    _duration = const Duration(hours: 1);
    _type = SessionType.individual;
    _notesCtrl = TextEditingController();
  }
}
```

**Step 4: Update `_submit` to call `updateAppointment` in edit mode**

Replace the existing `_submit` method with:

```dart
Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;
  if (!_isEditing && _selectedPatient == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selecione um paciente')));
    return;
  }
  setState(() => _loading = true);

  if (_isEditing) {
    // Edit mode: update existing appointment
    final updated = widget.appointment!.copyWith(
      startDate: _startDate,
      endDate: _endDate,
      type: _type,
      notes: _notesCtrl.text.trim(),
    );
    await ref.read(weekAppointmentsProvider.notifier).updateAppointment(updated);
  } else {
    // Create mode: add new appointment
    await ref.read(weekAppointmentsProvider.notifier).add(
      patientId: _selectedPatient!.id,
      startDate: _startDate,
      endDate: _endDate,
      type: _type,
      notes: _notesCtrl.text.trim(),
    );
  }

  if (mounted) Navigator.of(context).pop();
}
```

**Step 5: Update AppBar title to be dynamic**

```dart
appBar: AppBar(
  title: Text(_isEditing ? 'Editar Sessão' : 'Nova Sessão'),
),
```

**Step 6: In edit mode, hide the patient dropdown (patient cannot change)**

In the `build` method, wrap the patient dropdown with a condition:

```dart
if (!_isEditing)
  patientsAsync.when(
    loading: () => const LinearProgressIndicator(),
    error: (e, _) => Text('Erro: $e'),
    data: (patients) => DropdownButtonFormField<Patient>(
      // ... existing code ...
    ),
  ),
```

**Step 7: Run analyze**

```bash
cd "/c/Users/Admin/OneDrive/Área de Trabalho/APP psicologia/psychapp" && /c/flutter/flutter/bin/flutter.bat analyze
```
Fix any issues found.

**Step 8: Commit**

```bash
git add lib/presentation/schedule/appointment_form_screen.dart
git commit -m "feat: add edit mode to AppointmentFormScreen"
```

---

### Task 3: Edit Appointment — ScheduleScreen "Editar" option

**Files:**
- Modify: `lib/presentation/schedule/schedule_screen.dart`

**Step 1: Read the current file**

Read `lib/presentation/schedule/schedule_screen.dart`.

**Step 2: Add "Editar" option to PopupMenuButton in `_AppointmentCard`**

The current `PopupMenuButton` only lists `AppointmentStatus` values. Replace it with a custom menu that has both "Editar" and the status options.

Replace the `trailing:` widget in `_AppointmentCard.build()`:

```dart
trailing: PopupMenuButton<String>(
  icon: const Icon(Icons.more_vert),
  onSelected: (value) {
    if (value == 'edit') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AppointmentFormScreen(appointment: appointment),
      ));
    } else {
      final status = AppointmentStatus.values
          .firstWhere((s) => s.name == value);
      ref.read(weekAppointmentsProvider.notifier)
          .updateStatus(appointment.id, status);
    }
  },
  itemBuilder: (_) => [
    const PopupMenuItem(
      value: 'edit',
      child: Row(
        children: [
          Icon(Icons.edit, size: 18),
          SizedBox(width: 8),
          Text('Editar'),
        ],
      ),
    ),
    const PopupMenuDivider(),
    ...AppointmentStatus.values.map((s) =>
      PopupMenuItem(value: s.name, child: Text(_statusLabel(s))),
    ),
  ],
),
```

**Step 3: Run analyze**

```bash
cd "/c/Users/Admin/OneDrive/Área de Trabalho/APP psicologia/psychapp" && /c/flutter/flutter/bin/flutter.bat analyze
```
Fix any issues.

**Step 4: Run tests**

```bash
cd "/c/Users/Admin/OneDrive/Área de Trabalho/APP psicologia/psychapp" && /c/flutter/flutter/bin/flutter.bat test
```
Expected: all tests pass.

**Step 5: Commit**

```bash
git add lib/presentation/schedule/schedule_screen.dart
git commit -m "feat: add Edit option to appointment card popup menu"
```

---

### Task 4: Pending Payments Screen

**Files:**
- Create: `lib/presentation/finance/pending_payments_screen.dart`
- Modify: `lib/presentation/finance/finance_screen.dart`

**Step 1: Create `lib/presentation/finance/pending_payments_screen.dart`**

```dart
// lib/presentation/finance/pending_payments_screen.dart
// Tela que lista pacientes com cobranças pendentes (não pagas).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app/providers.dart';
import '../../domain/models/patient.dart';
import '../patients/patient_detail_screen.dart';

// Record com paciente e total pendente
typedef _PendingEntry = ({Patient patient, double totalPending});

/// Carrega todos os pacientes com ao menos uma transação não paga nos últimos 12 meses.
final pendingPaymentsProvider = FutureProvider<List<_PendingEntry>>((ref) async {
  final txRepo = ref.read(transactionRepositoryProvider);
  final patientRepo = ref.read(patientRepositoryProvider);
  final now = DateTime.now();

  // Acumula total pendente por patientId
  final pendingByPatient = <String, double>{};
  for (int i = 0; i < 12; i++) {
    final month = DateTime(now.year, now.month - i, 1);
    final txs = await txRepo.getByMonth(month.year, month.month);
    for (final t in txs) {
      if (!t.isPaid) {
        pendingByPatient[t.patientId] =
            (pendingByPatient[t.patientId] ?? 0) + t.amount;
      }
    }
  }

  if (pendingByPatient.isEmpty) return [];

  // Busca dados dos pacientes
  final entries = <_PendingEntry>[];
  for (final entry in pendingByPatient.entries) {
    final patient = await patientRepo.getById(entry.key);
    if (patient != null) {
      entries.add((patient: patient, totalPending: entry.value));
    }
  }

  // Ordena pelo maior valor pendente primeiro
  entries.sort((a, b) => b.totalPending.compareTo(a.totalPending));
  return entries;
});

class PendingPaymentsScreen extends ConsumerWidget {
  const PendingPaymentsScreen({super.key});

  static final _moneyFmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(pendingPaymentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pagamentos Pendentes')),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 64, color: Color(0xFF34C759)),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum pagamento pendente!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final e = entries[i];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFF3B30),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(e.patient.fullName),
                  subtitle: const Text('Pagamento pendente'),
                  trailing: Text(
                    _moneyFmt.format(e.totalPending),
                    style: const TextStyle(
                      color: Color(0xFFFF3B30),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PatientDetailScreen(patient: e.patient),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

**Step 2: Add button to FinanceScreen AppBar**

In `lib/presentation/finance/finance_screen.dart`, find the AppBar:
```dart
appBar: AppBar(title: const Text('Financeiro')),
```

Replace with:
```dart
appBar: AppBar(
  title: const Text('Financeiro'),
  actions: [
    IconButton(
      icon: const Icon(Icons.warning_amber),
      tooltip: 'Pagamentos pendentes',
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PendingPaymentsScreen(),
        ),
      ),
    ),
  ],
),
```

Add import at top of `finance_screen.dart`:
```dart
import 'pending_payments_screen.dart';
```

**Step 3: Run analyze**

```bash
cd "/c/Users/Admin/OneDrive/Área de Trabalho/APP psicologia/psychapp" && /c/flutter/flutter/bin/flutter.bat analyze
```
Fix any issues.

**Step 4: Run tests**

```bash
cd "/c/Users/Admin/OneDrive/Área de Trabalho/APP psicologia/psychapp" && /c/flutter/flutter/bin/flutter.bat test
```
Expected: all tests pass.

**Step 5: Commit**

```bash
git add lib/presentation/finance/pending_payments_screen.dart lib/presentation/finance/finance_screen.dart
git commit -m "feat: add pending payments screen with patient list"
```

---

### Task 5: Build and push

**Step 1: Final analyze + tests**

```bash
cd "/c/Users/Admin/OneDrive/Área de Trabalho/APP psicologia/psychapp" && /c/flutter/flutter/bin/flutter.bat analyze && /c/flutter/flutter/bin/flutter.bat test
```
Expected: no issues, all tests pass.

**Step 2: Push to GitHub (triggers iOS build)**

```bash
git push
```

**Step 3: Build Android APK**

```bash
rm -rf "/c/psychapp" && cp -r "/c/Users/Admin/OneDrive/Área de Trabalho/APP psicologia/psychapp" "/c/psychapp"
cd "/c/psychapp" && /c/flutter/flutter/bin/flutter.bat build apk --release
```
Expected: `✓ Built build\app\outputs\flutter-apk\app-release.apk`
