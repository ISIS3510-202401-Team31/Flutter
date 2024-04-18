import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DevicesRepository {
  final FirebaseFirestore firestore;
  final DeviceInfoPlugin deviceInfoPlugin;

  DevicesRepository({
    required this.firestore,
    required this.deviceInfoPlugin,
  });

  Future<void> updateDevicesMap() async {
    String deviceId = await _getDeviceId();

    DocumentReference deviceDoc =
        firestore.collection('devices').doc('ZQFFAKbSpZn1V73L2Yv0');
    return firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(deviceDoc);

      if (!snapshot.exists) {
        throw Exception("Device document does not exist!");
      }

      Map<String, dynamic> devicesMap = snapshot.data() as Map<String, dynamic>;
      devicesMap.update(deviceId, (value) => value + 1, ifAbsent: () => 1);

      transaction.update(deviceDoc, devicesMap);
    });
  }

  Future<String> _getDeviceId() async {
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    String deviceId = 'Unknown Device';
    if (deviceInfo is AndroidDeviceInfo) {
      deviceId = deviceInfo.model ?? 'Unknown Android Device';
    } else if (deviceInfo is IosDeviceInfo) {
      deviceId = deviceInfo.utsname.machine ?? 'Unknown iOS Device';
    }
    return deviceId;
  }
}
