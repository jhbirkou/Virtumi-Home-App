import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A room within a [Floor], containing devices.
@immutable
class Room {
  const Room({
    required this.id,
    required this.floorId,
    required this.name,
    this.iconKey = 'wohnzimmer',
    this.icon = Symbols.meeting_room,
    this.accentKey = 'blue',
    this.deviceCount = 0,
  });

  final String id;
  final String floorId;
  final String name;
  final String iconKey;
  final IconData icon;
  final String accentKey;
  final int deviceCount;

  Room copyWith({
    String? name,
    String? iconKey,
    IconData? icon,
  }) =>
      Room(
        id: id,
        floorId: floorId,
        name: name ?? this.name,
        iconKey: iconKey ?? this.iconKey,
        icon: icon ?? this.icon,
        accentKey: accentKey,
        deviceCount: deviceCount,
      );
}
