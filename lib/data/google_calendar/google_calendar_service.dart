// lib/data/google_calendar/google_calendar_service.dart
// Encapsula autenticação Google e operações na Google Calendar API.
// Princípio: banco local (Drift) é sempre a fonte de verdade.
// Google Calendar é apenas um espelho — falhas de sync NÃO bloqueiam o app.

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:http/http.dart' as http;
import '../../domain/models/appointment.dart';

class GoogleCalendarService {
  static const _scopes = [gcal.CalendarApi.calendarScope];

  // Client ID do projeto Google Cloud (app-psico-492422)
  static const _clientId =
      '252808342911-idtlssa3hmv1cguoko3srvtm35soj1hq.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
    clientId: _clientId,
  );

  bool get isSignedIn => _googleSignIn.currentUser != null;
  String? get userEmail => _googleSignIn.currentUser?.email;

  // Login silencioso (sem tela) ou com tela se necessário
  Future<bool> signIn() async {
    try {
      var account = await _googleSignIn.signInSilently();
      account ??= await _googleSignIn.signIn();
      return account != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  // Retorna API autenticada ou null se não estiver logado
  Future<gcal.CalendarApi?> _getApi() async {
    final account = _googleSignIn.currentUser;
    if (account == null) return null;
    final authHeaders = await account.authHeaders;
    final client = _AuthenticatedClient(authHeaders);
    return gcal.CalendarApi(client);
  }

  // Cria evento no Google Calendar. Retorna o ID do evento ou null em caso de falha.
  Future<String?> createEvent(Appointment appointment, String patientName) async {
    try {
      final api = await _getApi();
      if (api == null) return null;

      final event = gcal.Event(
        summary: 'Sessão #${appointment.sessionNumber} — $patientName',
        description: appointment.notes.isNotEmpty ? appointment.notes : null,
        start: gcal.EventDateTime(
          dateTime: appointment.startDate.toUtc(),
          timeZone: 'America/Sao_Paulo',
        ),
        end: gcal.EventDateTime(
          dateTime: appointment.endDate.toUtc(),
          timeZone: 'America/Sao_Paulo',
        ),
        reminders: gcal.EventReminders(
          useDefault: false,
          overrides: [gcal.EventReminder(method: 'popup', minutes: 60)],
        ),
      );

      final created = await api.events.insert(event, 'primary');
      return created.id;
    } catch (e) {
      return null; // Falha silenciosa — sync não é crítico
    }
  }

  // Atualiza evento existente. Falha silenciosa.
  Future<void> updateEvent(Appointment appointment, String patientName) async {
    try {
      final api = await _getApi();
      if (api == null || appointment.googleEventId == null) return;

      final event = gcal.Event(
        summary: 'Sessão #${appointment.sessionNumber} — $patientName',
        description: appointment.notes.isNotEmpty ? appointment.notes : null,
        start: gcal.EventDateTime(
          dateTime: appointment.startDate.toUtc(),
          timeZone: 'America/Sao_Paulo',
        ),
        end: gcal.EventDateTime(
          dateTime: appointment.endDate.toUtc(),
          timeZone: 'America/Sao_Paulo',
        ),
      );

      await api.events.update(event, 'primary', appointment.googleEventId!);
    } catch (e) {
      // Falha silenciosa
    }
  }

  // Deleta evento do Google Calendar. Falha silenciosa.
  Future<void> deleteEvent(String googleEventId) async {
    try {
      final api = await _getApi();
      if (api == null) return;
      await api.events.delete('primary', googleEventId);
    } catch (e) {
      // Falha silenciosa
    }
  }
}

// Cliente HTTP que injeta headers de autenticação Google em cada requisição
class _AuthenticatedClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  _AuthenticatedClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
