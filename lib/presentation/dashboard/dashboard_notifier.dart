// lib/presentation/dashboard/dashboard_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../app/providers.dart';

class DashboardState {
  final List<Appointment> todayAppointments;
  final double monthRevenue;

  const DashboardState({
    required this.todayAppointments,
    required this.monthRevenue,
  });

  Appointment? get nextAppointment {
    final now = DateTime.now();
    final upcoming = todayAppointments
        .where((a) => a.startDate.isAfter(now) && a.status != AppointmentStatus.cancelled)
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    return upcoming.isEmpty ? null : upcoming.first;
  }
}

final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<DashboardState> {
  AppointmentRepository get _apptRepo => ref.read(appointmentRepositoryProvider);
  TransactionRepository get _txRepo => ref.read(transactionRepositoryProvider);

  @override
  Future<DashboardState> build() async {
    final now = DateTime.now();
    final today = await _apptRepo.getToday();
    final revenue = await _txRepo.getTotalPaidByMonth(now.year, now.month);
    return DashboardState(todayAppointments: today, monthRevenue: revenue);
  }
}
