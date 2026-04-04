// lib/shared/theme/app_colors.dart
// Define todas as cores do app em um único lugar.
// Nunca use cores diretamente nas telas — sempre use AppColors.

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Impede instanciação — esta classe só tem constantes

  // Cor principal do app (roxo iOS)
  static const primary = Color(0xFF5856D6);
  static const primaryLight = Color(0xFF7B79E0);
  static const primaryDark = Color(0xFF3D3BB8);

  // Cores de status das sessões
  static const scheduled = Color(0xFF007AFF);   // azul — agendada
  static const confirmed = Color(0xFF34C759);   // verde — confirmada
  static const completed = Color(0xFF8E8E93);   // cinza — concluída
  static const cancelled = Color(0xFFFF3B30);   // vermelho — cancelada
  static const noShow = Color(0xFFFF9500);      // laranja — falta

  // Cores financeiras
  static const paid = Color(0xFF34C759);        // verde — pago
  static const pending = Color(0xFFFF9500);     // laranja — pendente
}
