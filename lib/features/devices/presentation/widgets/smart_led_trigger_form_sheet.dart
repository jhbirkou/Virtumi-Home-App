import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';
import '../../../rooms/presentation/widgets/smart_led_effect_picker.dart';

/// Add/edit form for a Smart LED trigger command slot.
class SmartLedTriggerFormSheet extends StatefulWidget {
  const SmartLedTriggerFormSheet({
    super.key,
    required this.draft,
    required this.isNew,
    required this.onSave,
  });

  final SmartLedTrigger draft;
  final bool isNew;
  final ValueChanged<SmartLedTrigger> onSave;

  @override
  State<SmartLedTriggerFormSheet> createState() =>
      _SmartLedTriggerFormSheetState();
}

class _SmartLedTriggerFormSheetState extends State<SmartLedTriggerFormSheet> {
  late SmartLedTrigger _draft = widget.draft;
  late final TextEditingController _nameController =
      TextEditingController(text: _draft.name);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _update(SmartLedTrigger Function(SmartLedTrigger current) transform) {
    setState(() => _draft = transform(_draft));
  }

  SmartLedTriggerType get _triggerType =>
      SmartLedTriggerType.fromValue(_draft.triggerType) ??
      SmartLedTriggerType.defaultType;

  Future<void> _pickTriggerType() async {
    final result = await showOptionPicker<SmartLedTriggerType>(
      context: context,
      title: 'Befehltyp',
      options: SmartLedTriggerType.values,
      labelOf: (type) => type.label,
      selected: _triggerType,
    );
    if (result != null) {
      _update((d) => d.copyWith(triggerType: result.value));
    }
  }

  Future<void> _pickCommandTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _draft.commandTimeHour,
        minute: _draft.commandTimeMinute,
      ),
      useRootNavigator: true,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null || !mounted) return;

    final seconds = await _pickSeconds(
      title: 'Sekunden',
      initial: _draft.commandTimeSecond,
    );
    if (seconds == null || !mounted) return;

    _update(
      (d) => d.copyWith(
        commandTimeHour: picked.hour,
        commandTimeMinute: picked.minute,
        commandTimeSecond: seconds,
      ),
    );
  }

  Future<void> _pickOffAutomaticTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _draft.offAutomaticTimeHour,
        minute: _draft.offAutomaticTimeMinute,
      ),
      useRootNavigator: true,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null || !mounted) return;

    final seconds = await _pickSeconds(
      title: 'Auto-Aus Sekunden',
      initial: _draft.offAutomaticTimeSecond,
    );
    if (seconds == null || !mounted) return;

    _update(
      (d) => d.copyWith(
        offAutomaticTimeHour: picked.hour,
        offAutomaticTimeMinute: picked.minute,
        offAutomaticTimeSecond: seconds,
      ),
    );
  }

  Future<int?> _pickSeconds({
    required String title,
    required int initial,
  }) {
    return showDialog<int>(
      context: context,
      builder: (context) => _SecondsPickerDialog(
        title: title,
        initial: initial,
      ),
    );
  }

  Future<void> _pickCommandDate() async {
    final now = DateTime.now();
    final initial = DateTime(
      _draft.commandDateYear,
      _draft.commandDateMonth,
      _draft.commandDateDay,
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      useRootNavigator: true,
    );
    if (picked == null || !mounted) return;
    _update(
      (d) => d.copyWith(
        commandDateDay: picked.day,
        commandDateMonth: picked.month,
        commandDateYear: picked.year,
      ),
    );
  }

  Future<void> _pickEffect() async {
    final result = await showSmartLedEffectPicker(
      context: context,
      selectedNumber: _draft.effectNumber,
    );
    if (result != null) {
      _update((d) => d.copyWith(effectNumber: result.number));
    }
  }

  SmartLedTrigger _finalizeDraft(SmartLedTrigger draft) {
    final name = draft.name.trim().isEmpty
        ? 'Befehl ${draft.parameterIndex + 1}'
        : draft.name.trim();
    return draft.copyWith(name: name, active: 1);
  }

  void _save() => widget.onSave(_finalizeDraft(_draft));

  @override
  Widget build(BuildContext context) {
    final effect = smartLedEffectByNumber(_draft.effectNumber);

    return NeumorphicContainer(
      style: NeumorphicStyle.raised,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.containerPadding,
        AppSpacing.gutter,
        AppSpacing.containerPadding,
        AppSpacing.containerPadding,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.palette.divider,
                    borderRadius: AppRadius.full,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.gutter),
              Text(
                widget.isNew ? 'Befehl hinzufügen' : 'Befehl bearbeiten',
                style: context.text.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Slot ${_draft.parameterIndex + 1}',
                style: context.text.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionCard(
                title: 'Befehl Daten',
                children: [
                  TextField(
                    controller: _nameController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      labelText: 'Name (max. 50)',
                    ),
                    onChanged: (value) => _update((d) => d.copyWith(name: value)),
                  ),
                  _ToggleRow(
                    label: 'Befehl aktiv',
                    value: _draft.active == 1,
                    onChanged: (value) =>
                        _update((d) => d.copyWith(active: value ? 1 : 0)),
                  ),
                  SettingsRow.navigation(
                    icon: Symbols.event_repeat,
                    title: 'Befehltyp',
                    iconColor: context.palette.accentIndigo,
                    value: _triggerType.label,
                    onTap: _pickTriggerType,
                  ),
                  SettingsRow.navigation(
                    icon: Symbols.schedule,
                    title: 'Befehlszeit',
                    iconColor: context.palette.accentOrange,
                    value: _draft.commandTimeLabel,
                    onTap: _pickCommandTime,
                  ),
                  if (_triggerType == SmartLedTriggerType.specificDay)
                    SettingsRow.navigation(
                      icon: Symbols.calendar_month,
                      title: 'Datum',
                      iconColor: context.palette.accentCyan,
                      value: _draft.commandDateLabel,
                      onTap: _pickCommandDate,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _SectionCard(
                title: 'LED',
                sectionEnabled: _draft.changeSwitchState == 1,
                onSectionEnabledChanged: (value) => _update(
                  (d) => d.copyWith(changeSwitchState: value ? 1 : 0),
                ),
                children: [
                  _ToggleRow(
                    label: 'Lampe',
                    value: _draft.lampOn == 1,
                    enabled: _draft.changeSwitchState == 1,
                    onChanged: (value) =>
                        _update((d) => d.copyWith(lampOn: value ? 1 : 0)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _SectionCard(
                title: 'Helligkeit',
                sectionEnabled: _draft.changeBrightness == 1,
                onSectionEnabledChanged: (value) => _update(
                  (d) => d.copyWith(changeBrightness: value ? 1 : 0),
                ),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _draft.brightness.toDouble().clamp(0, 100),
                          min: 0,
                          max: 100,
                          divisions: 100,
                          onChanged: _draft.changeBrightness == 1
                              ? (value) => _update(
                                    (d) => d.copyWith(brightness: value.round()),
                                  )
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: 48,
                        child: Text(
                          '${_draft.brightness}',
                          textAlign: TextAlign.center,
                          style: context.text.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _SectionCard(
                title: 'Ausschalten automatisch',
                sectionEnabled: _draft.changeOffAutomatic == 1,
                onSectionEnabledChanged: (value) => _update(
                  (d) => d.copyWith(changeOffAutomatic: value ? 1 : 0),
                ),
                children: [
                  _ToggleRow(
                    label: 'Auto-Aus aktiv',
                    value: _draft.offAutomatic == 1,
                    enabled: _draft.changeOffAutomatic == 1,
                    onChanged: (value) => _update(
                      (d) => d.copyWith(offAutomatic: value ? 1 : 0),
                    ),
                  ),
                  SettingsRow.navigation(
                    icon: Symbols.timer_off,
                    title: 'Auto-Aus Zeit',
                    iconColor: context.palette.accentOrange,
                    value: _draft.offAutomaticTimeLabel,
                    onTap: _draft.changeOffAutomatic == 1
                        ? _pickOffAutomaticTime
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _SectionCard(
                title: 'Effect',
                sectionEnabled: _draft.changeLedEffect == 1,
                onSectionEnabledChanged: (value) => _update(
                  (d) => d.copyWith(changeLedEffect: value ? 1 : 0),
                ),
                children: [
                  SettingsRow.navigation(
                    icon: Symbols.auto_awesome,
                    title: 'Effect-Nr.',
                    iconColor: context.palette.accentTeal,
                    value: '${effect.number}. ${effect.name}',
                    onTap: _draft.changeLedEffect == 1 ? _pickEffect : null,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SaveCancelCard(
                onCancel: () => Navigator.of(context).pop(),
                onSave: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
    this.sectionEnabled,
    this.onSectionEnabledChanged,
  });

  final String title;
  final List<Widget> children;
  final bool? sectionEnabled;
  final ValueChanged<bool>? onSectionEnabledChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (sectionEnabled != null && onSectionEnabledChanged != null)
                AppToggle(
                  value: sectionEnabled!,
                  onChanged: onSectionEnabledChanged,
                  semanticLabel: '$title aktiv',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: context.text.bodyMedium)),
          AppToggle(
            value: value,
            onChanged: enabled ? onChanged : null,
            semanticLabel: label,
          ),
        ],
      ),
    );
  }
}

class _SecondsPickerDialog extends StatefulWidget {
  const _SecondsPickerDialog({
    required this.title,
    required this.initial,
  });

  final String title;
  final int initial;

  @override
  State<_SecondsPickerDialog> createState() => _SecondsPickerDialogState();
}

class _SecondsPickerDialogState extends State<_SecondsPickerDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial.toString());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text) ?? 0;
    Navigator.of(context).pop(value.clamp(0, 59));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(labelText: 'Sekunden (0–59)'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('OK'),
        ),
      ],
    );
  }
}

Future<void> showSmartLedTriggerFormSheet({
  required BuildContext context,
  required SmartLedTrigger draft,
  required bool isNew,
  required ValueChanged<SmartLedTrigger> onSave,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, _) => SmartLedTriggerFormSheet(
          draft: draft,
          isNew: isNew,
          onSave: (updated) {
            Navigator.of(context).pop();
            onSave(updated);
          },
        ),
      ),
    ),
  );
}
