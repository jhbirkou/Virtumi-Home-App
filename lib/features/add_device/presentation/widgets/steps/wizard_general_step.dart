import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../shared/models/models.dart';
import '../../../../devices/presentation/widgets/settings_forms/general_settings_form.dart';
import '../../../application/new_device_wizard_controller.dart';
import '../../../application/new_device_wizard_state.dart';

class WizardGeneralStep extends StatelessWidget {
  const WizardGeneralStep({
    super.key,
    required this.state,
    required this.controller,
  });

  final NewDeviceWizardState state;
  final NewDeviceWizardController controller;

  @override
  Widget build(BuildContext context) {
    final config = state.generalConfig;
    if (config == null) return const SizedBox.shrink();

    return GeneralSettingsForm(
      config: config,
      enabled: true,
      onChanged: controller.updateGeneralConfig,
      onPickCustomColor: () async {
        final picked = await showColorPicker(
          context: context,
          initialColor: Color(config.ledColorValue),
        );
        if (picked != null) {
          controller.updateGeneralConfig(
            config.copyWith(ledColorValue: picked.toARGB32()),
          );
        }
      },
      onPickStatus: () async {
        final result = await showOptionPicker<LedStatus>(
          context: context,
          title: 'LED Status',
          options: LedStatus.values,
          labelOf: (s) => s.label,
          selected: config.ledStatus,
        );
        if (result != null) {
          controller.updateGeneralConfig(config.copyWith(ledStatus: result));
        }
      },
      footer: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.lg),
        child: FilledButton(
          onPressed:
              state.isBusy ? null : controller.saveGeneralAndContinue,
          child: const Text('Weiter'),
        ),
      ),
    );
  }
}
