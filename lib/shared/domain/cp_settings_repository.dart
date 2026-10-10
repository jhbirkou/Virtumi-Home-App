import '../models/cp_parameter.dart';
import '../models/cp_parameter_device_option.dart';

abstract interface class CpSettingsRepository {
  Future<List<CpParameter>> getParameters(String deviceId);

  Future<List<CpParameter>> getActiveParameters(String deviceId);

  Future<int?> nextFreeParameterIndex(String deviceId);

  Future<void> saveParameter(String deviceId, CpParameter parameter);

  Future<void> deactivateParameter(String deviceId, int parameterIndex);

  Future<List<CpParameterDeviceOption>> getSelectableDevices({
    required String excludeDeviceId,
  });
}
