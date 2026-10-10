import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/security/app_lock_providers.dart';
import '../../../core/security/app_lock_service.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import 'pin_keypad.dart';

/// Full-screen overlay that blocks app access until PIN or biometrics succeed.
class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({
    super.key,
    required this.userId,
    required this.biometricEnabled,
    required this.pinEnabled,
    required this.onUnlocked,
  });

  final String userId;
  final bool biometricEnabled;
  final bool pinEnabled;
  final VoidCallback onUnlocked;

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  static const _pinLength = 4;

  var _pin = '';
  var _hasError = false;
  var _busy = false;
  var _autoBiometricTriggered = false;

  @override
  void initState() {
    super.initState();
    if (widget.biometricEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric(auto: true));
    }
  }

  Future<void> _tryBiometric({bool auto = false}) async {
    if (_busy) return;
    if (auto) {
      if (_autoBiometricTriggered) return;
      _autoBiometricTriggered = true;
    }

    final lockNotifier = ref.read(appLockProvider.notifier);
    lockNotifier.suppressResumeLockFor(const Duration(seconds: 5));
    setState(() => _busy = true);

    final service = ref.read(appLockServiceProvider);
    final success = await service.authenticateWithBiometrics(
      reason: 'Virtumi Home entsperren',
    );

    lockNotifier.suppressResumeLockFor(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _busy = false);

    if (success) {
      widget.onUnlocked();
    }
  }

  Future<void> _submitPin() async {
    if (_pin.length != _pinLength || _busy) return;
    setState(() => _busy = true);

    final service = ref.read(appLockServiceProvider);
    final valid = await service.verifyPin(widget.userId, _pin);

    if (!mounted) return;
    if (valid) {
      widget.onUnlocked();
      return;
    }

    setState(() {
      _busy = false;
      _hasError = true;
      _pin = '';
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _hasError = false);
  }

  void _onDigit(String digit) {
    if (_busy || _pin.length >= _pinLength) return;
    setState(() {
      _hasError = false;
      _pin += digit;
    });
    if (_pin.length == _pinLength) _submitPin();
  }

  void _onBackspace() {
    if (_busy || _pin.isEmpty) return;
    setState(() {
      _hasError = false;
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  String _subtitleText() {
    if (widget.biometricEnabled && widget.pinEnabled) {
      return 'Face ID / Touch ID oder PIN zum Entsperren';
    }
    if (widget.pinEnabled) return 'PIN eingeben zum Entsperren';
    return 'Mit Biometrie entsperren';
  }

  @override
  Widget build(BuildContext context) {
    final showPin = widget.pinEnabled;
    final showBiometric =
        widget.biometricEnabled && AppLockService.isPlatformSupported;

    return Material(
      color: context.colors.surface,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.containerPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconBox(
                    icon: Symbols.lock,
                    color: context.colors.primary,
                    size: AppSizes.avatar,
                    filled: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Virtumi Home', style: context.text.headlineMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _subtitleText(),
                    style: context.text.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (showPin) ...[
                    const SizedBox(height: AppSpacing.lg),
                    PinDots(
                      filled: _pin.length,
                      pinLength: _pinLength,
                      hasError: _hasError,
                    ),
                    if (_hasError) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Falscher PIN',
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    PinKeypad(
                      enabled: !_busy,
                      onDigit: _onDigit,
                      onBackspace: _onBackspace,
                    ),
                  ],
                  if (showBiometric) ...[
                    SizedBox(
                      height: showPin
                          ? AppSpacing.lg
                          : AppSpacing.sectionMargin,
                    ),
                    FilledButton.icon(
                      onPressed: _busy ? null : () => _tryBiometric(),
                      icon: const Icon(Symbols.fingerprint),
                      label: const Text('Biometrie verwenden'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
