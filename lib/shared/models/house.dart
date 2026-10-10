import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A home/property the user manages. Top level of the location hierarchy:
/// House -> Floor -> Room -> Device.
@immutable
class House {
  const House({
    required this.id,
    required this.name,
    this.iconKey = 'haus',
    this.icon = Symbols.home,
    this.deviceCount = 0,
    this.roomCount = 0,
    this.floorCount = 0,
  });

  final String id;
  final String name;
  final String iconKey;
  final IconData icon;
  final int deviceCount;
  final int roomCount;
  final int floorCount;

  House copyWith({
    String? name,
    String? iconKey,
    IconData? icon,
  }) =>
      House(
        id: id,
        name: name ?? this.name,
        iconKey: iconKey ?? this.iconKey,
        icon: icon ?? this.icon,
        deviceCount: deviceCount,
        roomCount: roomCount,
        floorCount: floorCount,
      );
}
