import 'package:flutter/material.dart';

import '../../../../devices/presentation/widgets/settings_forms/wizard_password_form.dart';
import '../../../application/new_device_wizard_controller.dart';
import '../../../application/new_device_wizard_state.dart';

class WizardPasswordStep extends StatelessWidget {
  const WizardPasswordStep({
    super.key,
    required this.state,
    required this.controller,
  });

  final NewDeviceWizardState state;
  final NewDeviceWizardController controller;

  @override
  Widget build(BuildContext context) {
    return WizardPasswordForm(
      changePassword: state.changeDevicePassword,
      onChangePassword: controller.setChangeDevicePassword,
      onPasswordsChanged: controller.setNewPasswords,
      onSave: controller.savePasswordOptAndContinue,
      onSkip: controller.skipPasswordOpt,
      isBusy: state.isBusy,
    );
  }
}
