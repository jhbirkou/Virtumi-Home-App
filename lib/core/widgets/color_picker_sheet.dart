import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'save_cancel_card.dart';

/// Opens a neumorphic bottom sheet with a full HSV color palette and returns the
/// chosen [Color] (or null when cancelled).
Future<Color?> showColorPicker({
  required BuildContext context,
  required Color initialColor,
}) {
  return showModalBottomSheet<Color>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) => _ColorPickerSheet(initialColor: initialColor),
  );
}

class _ColorPickerSheet extends StatefulWidget {
  const _ColorPickerSheet({required this.initialColor});
  final Color initialColor;

  @override
  State<_ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<_ColorPickerSheet> {
  late HSVColor _hsv = HSVColor.fromColor(widget.initialColor);

  Color get _color => _hsv.toColor();

  String get _hex =>
      '#${_color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.gutter),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.cardLgAll,
          boxShadow: context.palette.raised,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.gutter),
                decoration: BoxDecoration(
                  color: context.colors.outlineVariant,
                  borderRadius: AppRadius.full,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _color,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.colors.outlineVariant),
                    boxShadow: context.palette.raisedSmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.gutter),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Eigene Farbe', style: context.text.titleMedium),
                      Text(_hex, style: context.text.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _SaturationValueArea(
              hsv: _hsv,
              onChanged: (s, v) =>
                  setState(() => _hsv = _hsv.withSaturation(s).withValue(v)),
            ),
            const SizedBox(height: AppSpacing.md),
            _HueSlider(
              hue: _hsv.hue,
              onChanged: (h) => setState(() => _hsv = _hsv.withHue(h)),
            ),
            const SizedBox(height: AppSpacing.md),
            SaveCancelCard(
              saveLabel: 'Übernehmen',
              onCancel: () => Navigator.of(context).pop(),
              onSave: () => Navigator.of(context).pop(_color),
            ),
          ],
        ),
      ),
    );
  }
}

/// Saturation (x) / value (y) selection area for the current hue.
class _SaturationValueArea extends StatelessWidget {
  const _SaturationValueArea({required this.hsv, required this.onChanged});

  final HSVColor hsv;
  final void Function(double saturation, double value) onChanged;

  static const double _height = 180;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        void handle(Offset p) {
          final s = (p.dx / width).clamp(0.0, 1.0);
          final v = (1 - p.dy / _height).clamp(0.0, 1.0);
          onChanged(s, v);
        }

        return GestureDetector(
          onPanDown: (d) => handle(d.localPosition),
          onPanUpdate: (d) => handle(d.localPosition),
          child: ClipRRect(
            borderRadius: AppRadius.mdAll,
            child: SizedBox(
              width: width,
              height: _height,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ColoredBox(
                      color: HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor(),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white.withValues(alpha: 0)],
                        ),
                      ),
                    ),
                  ),
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: hsv.saturation * width - 10,
                    top: (1 - hsv.value) * _height - 10,
                    child: const _Thumb(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Horizontal hue slider (0-360 degrees).
class _HueSlider extends StatelessWidget {
  const _HueSlider({required this.hue, required this.onChanged});

  final double hue;
  final ValueChanged<double> onChanged;

  static const double _height = 28;

  @override
  Widget build(BuildContext context) {
    final hues = [
      for (var i = 0; i <= 360; i += 60)
        HSVColor.fromAHSV(1, i.toDouble() % 360, 1, 1).toColor(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        void handle(Offset p) =>
            onChanged((p.dx / width).clamp(0.0, 1.0) * 360);

        return GestureDetector(
          onPanDown: (d) => handle(d.localPosition),
          onPanUpdate: (d) => handle(d.localPosition),
          child: SizedBox(
            width: width,
            height: _height,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: _height,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.full,
                    gradient: LinearGradient(colors: hues),
                  ),
                ),
                Positioned(
                  left: (hue / 360) * width - 10,
                  child: const _Thumb(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
