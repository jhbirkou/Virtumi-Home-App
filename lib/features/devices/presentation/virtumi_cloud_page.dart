import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/data_providers.dart';
import '../../../shared/providers/repository_providers.dart';
import 'widgets/connection_status_card.dart';

/// Virtumi Cloud account & sync settings.
class VirtumiCloudPage extends ConsumerStatefulWidget {
  const VirtumiCloudPage({super.key, required this.deviceId});
  final String deviceId;

  @override
  ConsumerState<VirtumiCloudPage> createState() => _VirtumiCloudPageState();
}

class _VirtumiCloudPageState extends ConsumerState<VirtumiCloudPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _editing = false;
  bool _obscure = true;
  bool _enabled = true;
  bool _initialized = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _hydrate(VirtumiCloudConfig config) {
    if (_initialized) return;
    _email.text = config.account;
    _password.text = config.password;
    _enabled = config.enabled;
    _initialized = true;
  }

  Future<void> _save(CloudConfig cloud) async {
    final updated = cloud.virtumi.copyWith(
      enabled: _enabled,
      account: _email.text.trim(),
      password: _password.text,
    );
    await ref
        .read(deviceConfigRepositoryProvider)
        .saveCloudConfig(widget.deviceId, cloud.copyWith(virtumi: updated));
    ref.invalidate(cloudConfigProvider(widget.deviceId));
    if (mounted) setState(() => _editing = false);
  }

  void _cancel(VirtumiCloudConfig config) {
    _initialized = false;
    _hydrate(config);
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final cloudAsync = ref.watch(cloudConfigProvider(widget.deviceId));
    final p = context.palette;

    return AppScaffold(
      header: AppHeader(
        isEditing: _editing,
        onEdit: () => setState(() => _editing = !_editing),
        onRefresh: () => ref.invalidate(cloudConfigProvider(widget.deviceId)),
      ),
      body: AsyncValueView<CloudConfig>(
        value: cloudAsync,
        onRetry: () => ref.invalidate(cloudConfigProvider(widget.deviceId)),
        data: (cloud) {
          _hydrate(cloud.virtumi);
          return AppScrollView(
            children: [
              const SectionHeaderCard(
                title: 'Virtumi Cloud',
                subtitle: 'Konto & Synchronisierung',
                icon: Symbols.cloud_done,
                filled: true,
              ),
              ConnectionStatusCard(
                status: cloud.virtumi.status,
                title: _enabled ? 'Cloud aktiv' : 'Cloud deaktiviert',
              ),
              const AppSectionLabel('Konto'),
              GroupedListCard(
                children: [
                  SettingsRow.toggle(
                    icon: Symbols.cloud_sync,
                    title: 'Cloud aktiviert',
                    iconColor: p.accentBlue,
                    value: _enabled,
                    onChanged: _editing
                        ? (v) => setState(() => _enabled = v)
                        : (_) {},
                  ),
                  SettingsInputRow(
                    icon: Symbols.mail,
                    label: 'E-Mail Adresse',
                    controller: _email,
                    iconColor: p.accentIndigo,
                    enabled: _editing,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SettingsInputRow(
                    icon: Symbols.lock,
                    label: 'Passwort',
                    controller: _password,
                    iconColor: p.accentOrange,
                    enabled: _editing,
                    obscure: _obscure,
                    onToggleObscure: _editing
                        ? () => setState(() => _obscure = !_obscure)
                        : null,
                  ),
                ],
              ),
              if (_editing)
                SaveCancelCard(
                  onCancel: () => _cancel(cloud.virtumi),
                  onSave: () => _save(cloud),
                ),
            ],
          );
        },
      ),
    );
  }
}
