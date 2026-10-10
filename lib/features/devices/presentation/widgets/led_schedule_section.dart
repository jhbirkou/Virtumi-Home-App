import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';

/// Schedule details shown when the LED status is [LedStatus.scheduled]:
/// command type, start/end time and (for a specific day) a date.
class LedScheduleSection extends StatelessWidget {
  const LedScheduleSection({
    super.key,
    required this.config,
    required this.enabled,
    required this.onChanged,
  });

  final GeneralConfig config;
  final bool enabled;
  final ValueChanged<GeneralConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final isSpecificDay = config.commandType == CommandType.specificDay;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSectionLabel('Zeitplan'),
        GroupedListCard(
          children: [
            SettingsRow.navigation(
              icon: Symbols.event_repeat,
              title: 'Befehl Typ',
              iconColor: p.accentIndigo,
              value: config.commandType.label,
              onTap: enabled ? () => _pickCommandType(context) : null,
            ),
            SettingsRow.navigation(
              icon: Symbols.play_circle,
              title: 'Start Zeit',
              iconColor: p.accentGreen,
              value: config.startTime,
              onTap: enabled ? () => _pickTime(context, isStart: true) : null,
            ),
            SettingsRow.navigation(
              icon: Symbols.stop_circle,
              title: 'End Zeit',
              iconColor: p.accentOrange,
              value: config.endTime,
              onTap: enabled ? () => _pickTime(context, isStart: false) : null,
            ),
            if (isSpecificDay)
              SettingsRow.navigation(
                icon: Symbols.calendar_month,
                title: 'Datum',
                iconColor: p.accentCyan,
                value: config.specificDate ?? 'Auswählen',
                onTap: enabled ? () => _pickDate(context) : null,
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickCommandType(BuildContext context) async {
    final result = await showOptionPicker<CommandType>(
      context: context,
      title: 'Befehl Typ',
      options: CommandType.values,
      labelOf: (c) => c.label,
      selected: config.commandType,
    );
    if (result != null) onChanged(config.copyWith(commandType: result));
  }

  Future<void> _pickTime(BuildContext context, {required bool isStart}) async {
    final initial = _parseTime(isStart ? config.startTime : config.endTime);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      useRootNavigator: true,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      final value = _formatTime(picked);
      onChanged(
        isStart
            ? config.copyWith(startTime: value)
            : config.copyWith(endTime: value),
      );
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = _parseDate(config.specificDate) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      useRootNavigator: true,
    );
    if (picked != null) {
      onChanged(config.copyWith(specificDate: _formatDate(picked)));
    }
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts.first) ?? 0,
      minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
    );
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  DateTime? _parseDate(String? value) {
    if (value == null) return null;
    final parts = value.split('.');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    return DateTime(y, m, d);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
