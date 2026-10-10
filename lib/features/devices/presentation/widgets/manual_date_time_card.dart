import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';

/// Card for manually setting date & time, shown when automatic sync is off.
class ManualDateTimeCard extends StatelessWidget {
  const ManualDateTimeCard({
    super.key,
    required this.config,
    required this.enabled,
    required this.onChanged,
  });

  final DateTimeConfig config;
  final bool enabled;
  final ValueChanged<DateTimeConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    final dateText = config.manualDate.isEmpty ? _formatDate(DateTime.now()) : config.manualDate;
    final timeText = config.manualTime.isEmpty ? _formatTime(DateTime.now()) : config.manualTime;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconBox(
                icon: Symbols.edit_calendar,
                color: context.colors.primary,
                glow: true,
              ),
              const SizedBox(width: AppSpacing.gutter),
              Text('Manuell einstellen', style: context.text.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SystemTimeButton(
            enabled: enabled,
            onTap: () {
              final now = DateTime.now();
              onChanged(config.copyWith(
                manualDate: _formatDate(now),
                manualTime: _formatTime(now),
              ));
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _Field(
            label: 'Datum',
            value: dateText,
            icon: Symbols.calendar_month,
            enabled: enabled,
            onTap: () => _pickDate(context, dateText),
          ),
          const SizedBox(height: AppSpacing.gutter),
          _Field(
            label: 'Uhrzeit',
            value: timeText,
            icon: Symbols.schedule,
            enabled: enabled,
            onTap: () => _pickTime(context, timeText),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, String current) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _parseDate(current) ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
      useRootNavigator: true,
    );
    if (picked != null) {
      onChanged(config.copyWith(manualDate: _formatDate(picked)));
    }
  }

  Future<void> _pickTime(BuildContext context, String current) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _parseTime(current),
      useRootNavigator: true,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      final value =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      onChanged(config.copyWith(manualTime: value));
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}';

  DateTime? _parseDate(String value) {
    final parts = value.split('.');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    return DateTime(y, m, d);
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    return TimeOfDay(
      hour: parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0,
      minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
    );
  }
}

class _SystemTimeButton extends StatelessWidget {
  const _SystemTimeButton({required this.enabled, required this.onTap});
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return Semantics(
      button: true,
      label: 'Systemzeit übernehmen',
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.gutter),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: AppRadius.mdAll,
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Symbols.history, size: 22, color: context.colors.onPrimary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Systemzeit übernehmen',
                  style: context.text.bodyLarge?.copyWith(
                    color: context.colors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.value,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: context.text.labelSmall),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: enabled ? onTap : null,
          behavior: HitTestBehavior.opaque,
          child: NeumorphicContainer(
            style: NeumorphicStyle.sunken,
            borderRadius: AppRadius.mdAll,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.gutter,
              vertical: AppSpacing.gutter,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(value, style: context.text.bodyLarge),
                ),
                Icon(icon, color: context.colors.onSurfaceVariant, size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
