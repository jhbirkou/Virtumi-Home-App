import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';

/// Card header with tinted icon, title and subtitle for update settings.
class UpdateSettingsCardHeader extends StatelessWidget {
  const UpdateSettingsCardHeader({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconBox(icon: icon, color: iconColor, size: AppSizes.iconBoxMd),
        const SizedBox(width: AppSpacing.gutter),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.text.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Update Status" card with enable toggle.
class UpdateStatusCard extends StatelessWidget {
  const UpdateStatusCard({
    super.key,
    required this.enabled,
    required this.editing,
    required this.onChanged,
  });

  final bool enabled;
  final bool editing;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UpdateSettingsCardHeader(
            icon: Symbols.download,
            iconColor: AppColors.accentIndigo,
            title: 'Update Status',
            subtitle: 'Automatische Updates konfigurieren',
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text('Update aktiviert', style: context.text.bodyLarge),
              ),
              AppToggle(
                value: enabled,
                onChanged: editing ? onChanged : (_) {},
                semanticLabel: 'Update aktiviert',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Update Modus" card with schedule and optional weekday pickers.
class UpdateModusCard extends StatelessWidget {
  const UpdateModusCard({
    super.key,
    required this.schedule,
    required this.weekday,
    required this.editing,
    required this.onScheduleTap,
    required this.onWeekdayTap,
  });

  final UpdateSchedule schedule;
  final Weekday weekday;
  final bool editing;
  final VoidCallback? onScheduleTap;
  final VoidCallback? onWeekdayTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UpdateSettingsCardHeader(
            icon: Symbols.calendar_month,
            iconColor: AppColors.accentGreen,
            title: 'Update Modus',
            subtitle: 'Wann sollen Updates durchgeführt werden',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Update Zeitplan', style: context.text.labelSmall),
          const SizedBox(height: AppSpacing.xs),
          _SelectField(
            value: schedule.label,
            onTap: editing ? onScheduleTap : null,
          ),
          if (schedule == UpdateSchedule.specificDay) ...[
            const SizedBox(height: AppSpacing.gutter),
            Text('Wochentag', style: context.text.labelSmall),
            const SizedBox(height: AppSpacing.xs),
            _SelectField(
              value: weekday.label,
              onTap: editing ? onWeekdayTap : null,
            ),
          ],
        ],
      ),
    );
  }
}

/// "Update Zeit" card with time input.
class UpdateTimeCard extends StatelessWidget {
  const UpdateTimeCard({
    super.key,
    required this.editing,
    required this.controller,
    required this.onPickTime,
  });

  final bool editing;
  final TextEditingController controller;
  final VoidCallback? onPickTime;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UpdateSettingsCardHeader(
            icon: Symbols.schedule,
            iconColor: AppColors.accentSky,
            title: 'Update Zeit',
            subtitle: 'Zeit für die Update-Durchführung',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Uhrzeit (HH:MM:SS)', style: context.text.labelSmall),
          const SizedBox(height: AppSpacing.xs),
          NeumorphicContainer(
            style: NeumorphicStyle.sunken,
            borderRadius: AppRadius.smAll,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: editing,
                    style: context.text.bodyLarge,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (editing)
                  IconButton(
                    onPressed: onPickTime,
                    icon: Icon(
                      Symbols.schedule,
                      color: context.colors.onSurfaceVariant,
                    ),
                    tooltip: 'Uhrzeit wählen',
                  )
                else
                  Icon(
                    Symbols.schedule,
                    color: context.colors.onSurfaceVariant,
                    size: 22,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Zeit für die Update-Durchführung',
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({required this.value, this.onTap});

  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = NeumorphicContainer(
      style: NeumorphicStyle.sunken,
      borderRadius: AppRadius.smAll,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gutter,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          Expanded(child: Text(value, style: context.text.bodyLarge)),
          Icon(
            Symbols.expand_more,
            color: context.colors.onSurfaceVariant,
            size: 22,
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return Semantics(
      button: true,
      label: value,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        splashColor: Colors.transparent,
        child: content,
      ),
    );
  }
}
