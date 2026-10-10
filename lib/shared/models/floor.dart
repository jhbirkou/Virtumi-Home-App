import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A floor/level within a [House].
@immutable
class Floor {
  const Floor({
    required this.id,
    required this.houseId,
    required this.name,
    this.iconKey = 'obergeschoss',
    this.icon = Symbols.layers,
    this.accentKey = 'blue',
    this.roomCount = 0,
    this.deviceCount = 0,
  });

  final String id;
  final String houseId;
  final String name;
  final String iconKey;
  final IconData icon;

  /// Key into the [AppPalette] accent colors (e.g. 'blue', 'cyan').
  final String accentKey;
  final int roomCount;
  final int deviceCount;

  Floor copyWith({
    String? name,
    String? iconKey,
    IconData? icon,
  }) =>
      Floor(
        id: id,
        houseId: houseId,
        name: name ?? this.name,
        iconKey: iconKey ?? this.iconKey,
        icon: icon ?? this.icon,
        accentKey: accentKey,
        roomCount: roomCount,
        deviceCount: deviceCount,
      );
}
