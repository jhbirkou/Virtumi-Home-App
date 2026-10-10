import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../shared/models/models.dart';
import '../../../../devices/presentation/widgets/settings_forms/update_settings_form.dart';
import '../../../application/new_device_wizard_controller.dart';
import '../../../application/new_device_wizard_state.dart';

class WizardUpdateStep extends StatelessWidget {
  const WizardUpdateStep({
    super.key,
    required this.state,
    required this.controller,
  });

  final NewDeviceWizardState state;
  final NewDeviceWizardController controller;

  @override
  Widget build(BuildContext context) {
    final config = state.updateConfig;
    if (config == null) return const SizedBox.shrink();

    return UpdateSettingsForm(
      config: config,
      enabled: true,
      onChanged: controller.updateUpdateConfig,
      onPickSchedule: () async {
        final result = await showOptionPicker<UpdateSchedule>(
          context: context,
          title: 'Update Zeitplan',
          options: UpdateSchedule.values,
          labelOf: (option) => option.label,
          selected: config.updateSchedule,
        );
        if (result != null) {
          controller.updateUpdateConfig(
            config.copyWith(updateSchedule: result),
          );
        }
      },
      onPickWeekday: () async {
        final result = await showOptionPicker<Weekday>(
          context: context,
          title: 'Wochentag',
          options: Weekday.values,
          labelOf: (option) => option.label,
          selected: config.weekday,
        );
        if (result != null) {
          controller.updateUpdateConfig(config.copyWith(weekday: result));
        }
      },
      footer: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.lg),
        child: FilledButton(
          onPressed:
              state.isBusy ? null : controller.saveUpdateAndContinue,
          child: const Text('Weiter'),
        ),
      ),
    );
  }
}
