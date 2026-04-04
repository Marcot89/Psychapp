import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:psychapp/shared/theme/app_theme.dart';
import 'package:psychapp/shared/theme/app_colors.dart';

void main() {
  group('AppTheme', () {
    test('light theme usa brightness light', () {
      final theme = AppTheme.light;
      expect(theme.colorScheme.brightness, Brightness.light);
    });

    test('dark theme usa brightness dark', () {
      final theme = AppTheme.dark;
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    test('AppColors.primary é o roxo correto', () {
      expect(AppColors.primary, const Color(0xFF5856D6));
    });

    test('cardRadius é 14.0', () {
      expect(AppTheme.cardRadius, 14.0);
    });

    test('buttonRadius é 10.0', () {
      expect(AppTheme.buttonRadius, 10.0);
    });
  });
}
