import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Brightness control: a percent text field (1-100) kept in sync with a slider.
class BrightnessControl extends StatefulWidget {
  const BrightnessControl({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final bool enabled;

  @override
  State<BrightnessControl> createState() => _BrightnessControlState();
}

class _BrightnessControlState extends State<BrightnessControl> {
  late final TextEditingController _controller =
      TextEditingController(text: '${widget.value}');

  @override
  void didUpdateWidget(BrightnessControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value &&
        widget.value.toString() != _controller.text) {
      _controller.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commit(int raw) {
    final clamped = raw.clamp(1, 100);
    widget.onChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconBox(
                icon: Symbols.brightness_6,
                color: context.palette.accentAmber,
                glow: true,
              ),
              const SizedBox(width: AppSpacing.gutter),
              Expanded(
                child: Text('Helligkeit',
                    style: context.text.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                width: 64,
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  style: context.text.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700, color: primary),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (text) {
                    final parsed = int.tryParse(text);
                    if (parsed != null) _commit(parsed);
                  },
                  onEditingComplete: () {
                    final parsed = int.tryParse(_controller.text) ?? widget.value;
                    final clamped = parsed.clamp(1, 100);
                    _controller.text = '$clamped';
                    widget.onChanged(clamped);
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              Text('%',
                  style: context.text.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700, color: primary)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              activeTrackColor: primary,
              inactiveTrackColor:
                  context.colors.surfaceContainerHighest,
              thumbColor: Colors.white,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: widget.value.toDouble().clamp(1, 100),
              min: 1,
              max: 100,
              divisions: 99,
              label: '${widget.value}%',
              onChanged:
                  widget.enabled ? (v) => _commit(v.round()) : null,
            ),
          ),
        ],
      ),
    );
  }
}
