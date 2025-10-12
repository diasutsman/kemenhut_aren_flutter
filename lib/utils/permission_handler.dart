import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kemenhut_aren_flutter/core/exceptions/app_exception.dart';

Future<void> storagePermissionHandler() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.androidInfo;

  if ((deviceInfo.version.sdkInt) < 33) {
    final storagePermission = await Permission.storage.request();
    if (!storagePermission.isGranted) {
      throw AppException('Please enable storage permission');
    }
  }
}
