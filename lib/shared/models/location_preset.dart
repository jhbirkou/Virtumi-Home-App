import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A named location preset with an associated icon for house, floor, or room
/// assignment on the device location screen.
@immutable
class LocationPreset {
  const LocationPreset({
    required this.key,
    required this.name,
    required this.icon,
  });

  final String key;
  final String name;
  final IconData icon;
}

/// Curated preset lists for the device location picker UI.
abstract final class LocationPresets {
  static const house = [
    LocationPreset(key: 'haus', name: 'Haus', icon: Symbols.home),
    LocationPreset(key: 'wohnung', name: 'Wohnung', icon: Symbols.apartment),
    LocationPreset(key: 'geschaeft', name: 'Geschäft', icon: Symbols.storefront),
    LocationPreset(key: 'buero_gebaeude', name: 'Büro', icon: Symbols.domain),
    LocationPreset(key: 'villa', name: 'Villa', icon: Symbols.villa),
    LocationPreset(key: 'ferienhaus', name: 'Ferienhaus', icon: Symbols.cabin),
    LocationPreset(key: 'bungalow', name: 'Bungalow', icon: Symbols.house_siding),
    LocationPreset(key: 'reihenhaus', name: 'Reihenhaus', icon: Symbols.other_houses),
    LocationPreset(key: 'garage_haus', name: 'Garage', icon: Symbols.garage_home),
    LocationPreset(key: 'lager', name: 'Lager', icon: Symbols.warehouse),
    LocationPreset(key: 'fabrik', name: 'Fabrik', icon: Symbols.factory),
    LocationPreset(key: 'keller_haus', name: 'Keller', icon: Symbols.foundation),
  ];

  static const floor = [
    LocationPreset(key: 'erdgeschoss', name: 'Erdgeschoss', icon: Symbols.door_front),
    LocationPreset(key: 'obergeschoss', name: 'Obergeschoss', icon: Symbols.layers),
    LocationPreset(key: 'dachgeschoss', name: 'Dachgeschoss', icon: Symbols.roofing),
    LocationPreset(key: 'keller', name: 'Keller', icon: Symbols.stairs),
    LocationPreset(key: 'garage', name: 'Garage', icon: Symbols.garage),
    LocationPreset(key: 'garten', name: 'Garten', icon: Symbols.yard),
    LocationPreset(key: 'terrasse', name: 'Terrasse', icon: Symbols.deck),
    LocationPreset(key: 'balkon', name: 'Balkon', icon: Symbols.balcony),
    LocationPreset(key: 'pool', name: 'Pool', icon: Symbols.pool),
    LocationPreset(key: 'fitness', name: 'Fitness', icon: Symbols.fitness_center),
    LocationPreset(key: 'waschraum', name: 'Waschraum', icon: Symbols.local_laundry_service),
    LocationPreset(key: 'abstellraum', name: 'Abstellraum', icon: Symbols.inventory_2),
  ];

  static const room = [
    LocationPreset(key: 'wohnzimmer', name: 'Wohnzimmer', icon: Symbols.weekend),
    LocationPreset(key: 'schlafzimmer', name: 'Schlafzimmer', icon: Symbols.bed),
    LocationPreset(key: 'kueche', name: 'Küche', icon: Symbols.skillet),
    LocationPreset(key: 'badezimmer', name: 'Badezimmer', icon: Symbols.water_drop),
    LocationPreset(key: 'buero', name: 'Büro', icon: Symbols.desktop_windows),
    LocationPreset(key: 'kinderzimmer', name: 'Kinderzimmer', icon: Symbols.star),
    LocationPreset(key: 'garage_raum', name: 'Garage', icon: Symbols.garage),
    LocationPreset(key: 'garten_raum', name: 'Garten', icon: Symbols.local_florist),
    LocationPreset(key: 'flur', name: 'Flur', icon: Symbols.stairs),
    LocationPreset(key: 'balkon_raum', name: 'Balkon', icon: Symbols.balcony),
  ];

  static String resolveIconKey(String? raw, List<LocationPreset> presets) {
    if (raw != null && raw.isNotEmpty) {
      for (final preset in presets) {
        if (preset.key == raw) return raw;
      }
    }
    return presets.first.key;
  }

  static IconData iconForKey(String key, List<LocationPreset> presets) {
    for (final preset in presets) {
      if (preset.key == key) return preset.icon;
    }
    return presets.first.icon;
  }

  static String keyForIcon(IconData icon, List<LocationPreset> presets) {
    for (final preset in presets) {
      if (preset.icon.codePoint == icon.codePoint &&
          preset.icon.fontFamily == icon.fontFamily) {
        return preset.key;
      }
    }
    return presets.first.key;
  }

  static String? keyForCodePoint(int codePoint, List<LocationPreset> presets) {
    for (final preset in presets) {
      if (preset.icon.codePoint == codePoint) return preset.key;
    }
    return null;
  }

  /// Resolves icon + preset key from a Supabase row (`icon_code` integer).
  static ({String key, IconData icon}) resolveFromIconCode(
    int? iconCode,
    List<LocationPreset> presets,
  ) {
    if (iconCode == null) {
      return (key: presets.first.key, icon: presets.first.icon);
    }

    final key = keyForCodePoint(iconCode, presets);
    if (key != null) {
      return (key: key, icon: iconForKey(key, presets));
    }

    return (
      key: presets.first.key,
      icon: IconData(iconCode, fontFamily: 'MaterialIcons'),
    );
  }
}
