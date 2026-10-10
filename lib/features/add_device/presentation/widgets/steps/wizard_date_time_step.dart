import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../devices/presentation/widgets/location_search_sheet.dart';
import '../../../../devices/presentation/widgets/settings_forms/date_time_settings_form.dart';
import '../../../application/new_device_wizard_controller.dart';
import '../../../application/new_device_wizard_state.dart';

class WizardDateTimeStep extends StatelessWidget {
  const WizardDateTimeStep({
    super.key,
    required this.state,
    required this.controller,
  });

  final NewDeviceWizardState state;
  final NewDeviceWizardController controller;

  @override
  Widget build(BuildContext context) {
    final config = state.dateTimeConfig;
    if (config == null) return const SizedBox.shrink();

    return DateTimeSettingsForm(
      config: config,
      enabled: true,
      onChanged: controller.updateDateTimeConfig,
      onPickTimezone: () async {
        final location = await showLocationSearch(context);
        if (location != null) {
          controller.updateDateTimeConfig(
            config.copyWith(
              timezone: location.label,
              timezoneTz: location.timezone,
            ),
          );
        }
      },
      footer: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.lg),
        child: FilledButton(
          onPressed:
              state.isBusy ? null : controller.saveDateTimeAndContinue,
          child: const Text('Weiter'),
        ),
      ),
    );
  }
}
