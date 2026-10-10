import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

/// Scenes tab ("Szenen"). Designed consistently with the system (no Stitch
/// reference exists for this tab yet).
class ScenesPage extends StatelessWidget {
  const ScenesPage({super.key});

  static const _scenes = [
    (Symbols.wb_sunny, 'Guten Morgen', 'green', '4 Geräte'),
    (Symbols.movie, 'Filmabend', 'purple', '3 Geräte'),
    (Symbols.bedtime, 'Gute Nacht', 'indigo', '6 Geräte'),
    (Symbols.work, 'Fokus', 'blue', '2 Geräte'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const AppHeader(showBack: false),
      body: AppScrollView(
        children: [
          const SectionHeaderCard(
            title: 'Szenen',
            icon: Symbols.bolt,
            subtitle: 'Automatisierungen mit einem Tipp',
            filled: true,
          ),
          ActionBannerCard(
            icon: Symbols.add_circle,
            title: 'Neue Szene erstellen',
            subtitle: 'Geräte & Aktionen kombinieren',
            accent: context.colors.primary,
            trailingIcon: Symbols.add,
            trailingFilledButton: true,
            onTap: () {},
          ),
          const AppSectionLabel('Meine Szenen'),
          for (final scene in _scenes) ...[
            _SceneCard(
              icon: scene.$1,
              title: scene.$2,
              accentKey: scene.$3,
              subtitle: scene.$4,
            ),
            const SizedBox(height: AppSpacing.cardGap),
          ],
        ],
      ),
    );
  }
}

class _SceneCard extends StatefulWidget {
  const _SceneCard({
    required this.icon,
    required this.title,
    required this.accentKey,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String accentKey;
  final String subtitle;

  @override
  State<_SceneCard> createState() => _SceneCardState();
}

class _SceneCardState extends State<_SceneCard> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.colors.primary;
    return AppCard(
      child: Row(
        children: [
          IconBox(
            icon: widget.icon,
            color: accent,
            size: AppSizes.iconBoxMd,
            filled: true,
            glow: true,
          ),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title,
                    style: context.text.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(widget.subtitle, style: context.text.bodySmall),
              ],
            ),
          ),
          AppToggle(
            value: _active,
            onChanged: (v) => setState(() => _active = v),
            semanticLabel: '${widget.title} aktivieren',
          ),
        ],
      ),
    );
  }
}
