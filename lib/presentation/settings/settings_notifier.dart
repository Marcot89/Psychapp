// lib/presentation/settings/settings_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';

class SettingsState {
  final bool isGoogleSignedIn;
  final String? googleEmail;
  final bool notificationsEnabled;

  const SettingsState({
    required this.isGoogleSignedIn,
    required this.googleEmail,
    required this.notificationsEnabled,
  });

  SettingsState copyWith({
    bool? isGoogleSignedIn,
    String? googleEmail,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      isGoogleSignedIn: isGoogleSignedIn ?? this.isGoogleSignedIn,
      googleEmail: googleEmail ?? this.googleEmail,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    final gcal = ref.read(googleCalendarServiceProvider);
    return SettingsState(
      isGoogleSignedIn: gcal.isSignedIn,
      googleEmail: gcal.userEmail,
      notificationsEnabled: true,
    );
  }

  Future<void> signInGoogle() async {
    final gcal = ref.read(googleCalendarServiceProvider);
    final success = await gcal.signIn();
    if (success) {
      state = AsyncData(state.value!.copyWith(
        isGoogleSignedIn: true,
        googleEmail: gcal.userEmail,
      ));
    }
  }

  Future<void> signOutGoogle() async {
    final gcal = ref.read(googleCalendarServiceProvider);
    await gcal.signOut();
    state = AsyncData(state.value!.copyWith(
      isGoogleSignedIn: false,
      googleEmail: null,
    ));
  }

  Future<void> toggleNotifications(bool enabled) async {
    final notifications = ref.read(notificationSchedulerProvider);
    if (!enabled) {
      await notifications.cancelAll();
    } else {
      await notifications.scheduleDailySummary();
    }
    state = AsyncData(state.value!.copyWith(notificationsEnabled: enabled));
  }
}
