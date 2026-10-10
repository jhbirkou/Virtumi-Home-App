import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import 'pin_keypad.dart';

/// Bottom sheet to set a new 4-digit PIN (enter + confirm).
Future<String?> showPinSetupSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => const PinSetupSheet(),
  );
}

class PinSetupSheet extends StatefulWidget {
  const PinSetupSheet({super.key});

  @override
  State<PinSetupSheet> createState() => _PinSetupSheetState();
}

class _PinSetupSheetState extends State<PinSetupSheet> {
  static const _pinLength = 4;

  var _step = 0;
  var _firstPin = '';
  var _currentPin = '';
  var _hasError = false;

  String get _title => switch (_step) {
        0 => 'PIN festlegen',
        _ => 'PIN bestätigen',
      };

  String get _subtitle => switch (_step) {
        0 => 'Wähle einen 4-stelligen PIN',
        _ => 'Gib den PIN erneut ein',
      };

  void _onDigit(String digit) {
    if (_currentPin.length >= _pinLength) return;
    setState(() {
      _hasError = false;
      _currentPin += digit;
    });

    if (_currentPin.length == _pinLength) {
      Future<void>.delayed(const Duration(milliseconds: 120), _onPinComplete);
    }
  }

  void _onBackspace() {
    if (_currentPin.isEmpty) return;
    setState(() {
      _hasError = false;
      _currentPin = _currentPin.substring(0, _currentPin.length - 1);
    });
  }

  void _onPinComplete() {
    if (_step == 0) {
      setState(() {
        _firstPin = _currentPin;
        _currentPin = '';
        _step = 1;
      });
      return;
    }

    if (_currentPin == _firstPin) {
      Navigator.pop(context, _firstPin);
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _hasError = true;
      _currentPin = '';
      _step = 0;
      _firstPin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.containerPadding,
        right: AppSpacing.containerPadding,
        top: AppSpacing.md,
        bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconBox(
                icon: Symbols.pin,
                color: context.palette.accentBlue,
                size: AppSizes.iconBoxMd,
              ),
              const SizedBox(width: AppSpacing.gutter),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_title, style: context.text.titleLarge),
                    Text(
                      _subtitle,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Symbols.close),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          PinDots(
            filled: _currentPin.length,
            pinLength: _pinLength,
            hasError: _hasError,
          ),
          if (_hasError) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'PINs stimmen nicht überein. Bitte erneut versuchen.',
              style: context.text.bodySmall?.copyWith(
                color: context.colors.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          PinKeypad(onDigit: _onDigit, onBackspace: _onBackspace),
        ],
      ),
    );
  }
}
