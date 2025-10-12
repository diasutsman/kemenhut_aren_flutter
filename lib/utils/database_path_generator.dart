import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

Future<String> databasePathGenerator() async {
  final dir = kDebugMode
      ? await getApplicationDocumentsDirectory()
      : await getApplicationSupportDirectory();
  String result = '${dir.path}/flutter_template/database';

  final tempDir = Directory(result);
  final exists = await tempDir.exists();
  if (!exists) {
    await tempDir.create(recursive: true);
  }

  debugPrint('isar path: $result');
  return result;
}

Future<String> exportedPathGenerator() async {
  final dir = kDebugMode
      ? await getApplicationDocumentsDirectory()
      : await getApplicationSupportDirectory();
  String result = '${dir.path}/flutter_template/exported';

  final tempDir = Directory(result);
  final exists = await tempDir.exists();
  if (!exists) {
    await tempDir.create(recursive: true);
  }

  debugPrint('exported path: $result');
  return result;
}

Future<bool> fileExistsCheck(String path,
    {bool deleteWhenExists = false,}) async {
  final file = File(path);
  if (await file.exists()) {
    if (deleteWhenExists) {
      await file.delete();
    }

    return true;
  } else {
    return false;
  }
}

Future<bool> directoryExistsCheck(String path,
    {bool deleteWhenExists = false,}) async {
  final dir = Directory(path);
  if (await dir.exists()) {
    if (deleteWhenExists) {
      await dir.delete(recursive: true);
    }

    return true;
  } else {
    return false;
  }
}
