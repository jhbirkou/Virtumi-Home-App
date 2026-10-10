import 'package:flutter/widgets.dart';

/// A single Smart LED animation effect (firmware `effect_number`).
@immutable
class SmartLedEffect {
  const SmartLedEffect({
    required this.number,
    required this.name,
    this.needsSecondaryColor = false,
  });

  final int number;
  final String name;
  final bool needsSecondaryColor;

  String get label => '$number – $name';
}

/// All Smart LED effects (-1 … 100), aligned with firmware / web app.
const List<SmartLedEffect> smartLedEffects = [
  SmartLedEffect(number: -1, name: 'Stop LEDs'),
  SmartLedEffect(number: 0, name: 'Einfache Farbe'),
  SmartLedEffect(number: 1, name: 'Twinkle Wave'),
  SmartLedEffect(number: 2, name: 'Regenbogen'),
  SmartLedEffect(number: 3, name: 'Color Wipe'),
  SmartLedEffect(number: 4, name: 'Theater Chase'),
  SmartLedEffect(number: 5, name: 'Strobe'),
  SmartLedEffect(number: 6, name: 'BPM'),
  SmartLedEffect(number: 7, name: 'Sparkle'),
  SmartLedEffect(number: 8, name: 'Running Lights'),
  SmartLedEffect(number: 9, name: 'Feuer'),
  SmartLedEffect(number: 10, name: 'Color Cycle'),
  SmartLedEffect(number: 11, name: 'Disco'),
  SmartLedEffect(number: 12, name: 'Heartbeat'),
  SmartLedEffect(number: 13, name: 'Welle'),
  SmartLedEffect(number: 14, name: 'Falling Stars'),
  SmartLedEffect(number: 15, name: 'Twinkling Stars'),
  SmartLedEffect(number: 16, name: 'Knight Rider'),
  SmartLedEffect(number: 17, name: 'Color Fade (2 Farben)', needsSecondaryColor: true),
  SmartLedEffect(number: 18, name: 'Meteor Rain'),
  SmartLedEffect(number: 19, name: 'Confetti'),
  SmartLedEffect(number: 20, name: 'Polizeilicht'),
  SmartLedEffect(number: 21, name: 'Zufällige Farbe'),
  SmartLedEffect(number: 22, name: 'Chasing Color'),
  SmartLedEffect(number: 23, name: 'Wave Rainbow'),
  SmartLedEffect(number: 24, name: 'Kerzenflamme'),
  SmartLedEffect(number: 25, name: 'Color Blink'),
  SmartLedEffect(number: 26, name: 'Running Rainbow'),
  SmartLedEffect(number: 27, name: 'Color Transition (2 Farben)', needsSecondaryColor: true),
  SmartLedEffect(number: 28, name: 'Spirale'),
  SmartLedEffect(number: 29, name: 'Starburst'),
  SmartLedEffect(number: 30, name: 'Bouncing Ball'),
  SmartLedEffect(number: 31, name: 'Gradient'),
  SmartLedEffect(number: 32, name: 'Pulse'),
  SmartLedEffect(number: 33, name: 'Wave Pattern'),
  SmartLedEffect(number: 34, name: 'Rainbow Twinkle'),
  SmartLedEffect(number: 35, name: 'Flash'),
  SmartLedEffect(number: 36, name: 'Random Twinkle'),
  SmartLedEffect(number: 37, name: 'Color Sine Wave'),
  SmartLedEffect(number: 38, name: 'Moving Wash'),
  SmartLedEffect(number: 39, name: 'Circling Lights'),
  SmartLedEffect(number: 40, name: 'Dual Color Wave (2 Farben)', needsSecondaryColor: true),
  SmartLedEffect(number: 41, name: 'Disco Ball'),
  SmartLedEffect(number: 42, name: 'Feuerwerk'),
  SmartLedEffect(number: 43, name: 'Twinkle Fade'),
  SmartLedEffect(number: 44, name: 'Color Wave'),
  SmartLedEffect(number: 45, name: 'Color Pulse'),
  SmartLedEffect(number: 46, name: 'Rainbow Cycle'),
  SmartLedEffect(number: 47, name: 'Slow Fade'),
  SmartLedEffect(number: 48, name: 'Sternenlicht'),
  SmartLedEffect(number: 49, name: 'Wellen'),
  SmartLedEffect(number: 50, name: 'Heartbeat Effect'),
  SmartLedEffect(number: 51, name: 'Spinning Colors'),
  SmartLedEffect(number: 52, name: 'Flicker Effect'),
  SmartLedEffect(number: 53, name: 'Color Shift'),
  SmartLedEffect(number: 54, name: 'Ripple'),
  SmartLedEffect(number: 55, name: 'Alternating Colors'),
  SmartLedEffect(number: 56, name: 'Color Explosion'),
  SmartLedEffect(number: 57, name: 'Pulsing Glow'),
  SmartLedEffect(number: 58, name: 'Snake'),
  SmartLedEffect(number: 59, name: 'Random Color Fade'),
  SmartLedEffect(number: 60, name: 'Firefly Effect'),
  SmartLedEffect(number: 61, name: 'Rainbow Wave'),
  SmartLedEffect(number: 62, name: 'Breathing Effect'),
  SmartLedEffect(number: 63, name: 'Comet Effect'),
  SmartLedEffect(number: 64, name: 'Theater Chase (Variante)'),
  SmartLedEffect(number: 65, name: 'Kaleidoscope Effect'),
  SmartLedEffect(number: 66, name: 'Fire Effect'),
  SmartLedEffect(number: 67, name: 'Color Breath'),
  SmartLedEffect(number: 68, name: 'Random Sparkle'),
  SmartLedEffect(number: 69, name: 'Shimmering Lights'),
  SmartLedEffect(number: 70, name: 'Disco Fever'),
  SmartLedEffect(number: 71, name: 'Waterfall Effect'),
  SmartLedEffect(number: 72, name: 'Slow Rainbow'),
  SmartLedEffect(number: 73, name: 'Thunder Effect'),
  SmartLedEffect(number: 74, name: 'Aurora Borealis'),
  SmartLedEffect(number: 75, name: 'Random Color Explosion'),
  SmartLedEffect(number: 76, name: 'Wave Ripple'),
  SmartLedEffect(number: 77, name: 'Heartbeat Color'),
  SmartLedEffect(number: 78, name: 'Light Chase'),
  SmartLedEffect(number: 79, name: 'Color Twinkle'),
  SmartLedEffect(number: 80, name: 'Flickering Flame'),
  SmartLedEffect(number: 81, name: 'Color Fade (Variante)'),
  SmartLedEffect(number: 82, name: 'Strobe Effect'),
  SmartLedEffect(number: 83, name: 'Color Shimmer'),
  SmartLedEffect(number: 84, name: 'Firecracker'),
  SmartLedEffect(number: 85, name: 'Falling Leaves'),
  SmartLedEffect(number: 86, name: 'Spiral Effect'),
  SmartLedEffect(number: 87, name: 'Random Color Wave'),
  SmartLedEffect(number: 88, name: 'Aurora Effect'),
  SmartLedEffect(number: 89, name: 'Nebula Effect'),
  SmartLedEffect(number: 90, name: 'Glowing Orbs'),
  SmartLedEffect(number: 91, name: 'Pulsating Rainbow'),
  SmartLedEffect(number: 92, name: 'Cosmic Twinkle'),
  SmartLedEffect(number: 93, name: 'Thunderstorm'),
  SmartLedEffect(number: 94, name: 'Color Shift Wave'),
  SmartLedEffect(number: 95, name: 'Soft Glow'),
  SmartLedEffect(number: 96, name: 'Flickering Stars'),
  SmartLedEffect(number: 97, name: 'Heartbeat Pulse'),
  SmartLedEffect(number: 98, name: 'Wave Motion'),
  SmartLedEffect(number: 99, name: 'Sparkling Fireworks'),
  SmartLedEffect(number: 100, name: 'Random Flicker'),
];

SmartLedEffect smartLedEffectByNumber(int number) {
  return smartLedEffects.firstWhere(
    (e) => e.number == number,
    orElse: () => SmartLedEffect(number: number, name: 'Effekt $number'),
  );
}

bool smartLedEffectNeedsSecondaryColor(int effectNumber) {
  return smartLedEffectByNumber(effectNumber).needsSecondaryColor;
}
