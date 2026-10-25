import '../domain/cp_settings_repository.dart';
import '../models/cp_parameter.dart';
import '../models/cp_parameter_device_option.dart';
import 'supabase/mappers/extended_mappers.dart';

class MockCpSettingsRepository implements CpSettingsRepository {
  final _cache = <String, List<CpParameter>>{};

  final _selectableDevices = <CpParameterDeviceOption>[
    const CpParameterDeviceOption(
      deviceId: 'led1',
      name: 'Smart LED Büro',
      code: 'LED001',
      espnowMac: 'AA:BB:CC:11:22:33',
      ipAddress: '192.168.1.50',
      port: 6000,
      deviceType: 80,
      deviceTypeName: 'Smart LED',
      locationPath: 'Home / Etage 1 / Büro',
    ),
  ];

  Future<List<CpParameter>> _allParameters(String deviceId) async {
    if (!_cache.containsKey(deviceId)) {
      _cache[deviceId] = defaultCpParameters();
    }
    return _cache[deviceId]!;
  }

  @override
  Future<List<CpParameter>> getParameters(String deviceId) async {
    return _allParameters(deviceId);
  }

  @override
  Future<List<CpParameter>> getActiveParameters(String deviceId) async {
    final all = await _allParameters(deviceId);
    return all.where((p) => p.active == 1).toList();
  }

  @override
  Future<int?> nextFreeParameterIndex(String deviceId) async {
    final all = await _allParameters(deviceId);
    for (final parameter in all) {
      if (parameter.active != 1) return parameter.parameterIndex;
    }
    return null;
  }

  @override
  Future<void> saveParameter(String deviceId, CpParameter parameter) async {
    final list = List<CpParameter>.from(await _allParameters(deviceId));
    final index =
        list.indexWhere((p) => p.parameterIndex == parameter.parameterIndex);
    if (index >= 0) {
      list[index] = parameter;
    } else {
      list.add(parameter);
    }
    _cache[deviceId] = list;
  }

  @override
  Future<void> deactivateParameter(
    String deviceId,
    int parameterIndex,
  ) async {
    final list = List<CpParameter>.from(await _allParameters(deviceId));
    final index = list.indexWhere((p) => p.parameterIndex == parameterIndex);
    if (index < 0) return;
    list[index] = list[index].copyWith(active: 0);
    _cache[deviceId] = list;
  }

  @override
  Future<List<CpParameterDeviceOption>> getSelectableDevices({
    required String excludeDeviceId,
  }) async {
    return _selectableDevices
        .where((d) => d.deviceId != excludeDeviceId)
        .toList();
  }
}
