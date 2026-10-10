import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../application/new_device_wizard_controller.dart';
import '../models/wizard_step.dart';
import 'widgets/wizard_step_content.dart';

class NewDeviceWizardPage extends ConsumerStatefulWidget {
  const NewDeviceWizardPage({super.key});

  @override
  ConsumerState<NewDeviceWizardPage> createState() =>
      _NewDeviceWizardPageState();
}

class _NewDeviceWizardPageState extends ConsumerState<NewDeviceWizardPage> {
  bool _usesOwnHeader(WizardStep step) {
    return step == WizardStep.location ||
        step == WizardStep.dateTime ||
        step == WizardStep.general ||
        step == WizardStep.update ||
        step == WizardStep.passwordOpt;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newDeviceWizardControllerProvider.notifier).requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newDeviceWizardControllerProvider);
    final controller = ref.read(newDeviceWizardControllerProvider.notifier);

    ref.listen(newDeviceWizardControllerProvider, (prev, next) {
      if (prev?.step == next.step) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        switch (next.step) {
          case WizardStep.location:
            controller.loadLocationStep();
          case WizardStep.dateTime:
            controller.loadDateTimeStep();
          case WizardStep.general:
            controller.loadGeneralStep();
          case WizardStep.update:
            controller.loadUpdateStep();
          default:
            break;
        }
      });
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted) return;
            await controller.cleanup();
            ref.invalidate(newDeviceWizardControllerProvider);
          });
        }
      },
      child: AppScaffold(
        header: AppHeader(
          onBack: () async {
            if (state.step == WizardStep.password) {
              await controller.cleanup();
              if (context.mounted) context.pop();
            } else {
              await controller.goBack();
            }
          },
        ),
        body: AppScrollView(
          children: [
            if (!_usesOwnHeader(state.step))
              SectionHeaderCard(
                title: 'Neues Gerät suchen',
                subtitle: state.step.title,
                icon: Symbols.add_circle,
                accent: context.colors.primary,
                filled: true,
              ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Material(
                  color: context.colors.errorContainer,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      state.error!,
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onErrorContainer,
                      ),
                    ),
                  ),
                ),
              ),
            WizardStepContent(state: state, controller: controller),
            if (state.isBusy)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (state.step == WizardStep.done)
              FilledButton(
                onPressed: () {
                  context.go(Paths.home);
                },
                child: const Text('Zur Startseite'),
              ),
          ],
        ),
      ),
    );
  }
}
