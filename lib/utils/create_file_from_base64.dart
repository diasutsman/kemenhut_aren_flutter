import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:kemenhut_aren_flutter/utils/download_path_generator.dart';
import 'package:kemenhut_aren_flutter/utils/permission_handler.dart';

Future<File> createFileFromBase64(
  String base64content,
  String fileName, {
  bool openFile = true,
  bool useAction = false,
  Function(File)? customActionCallback,
  bool saveToDownloadsFolder = false,
}) async {
  log('Processing $fileName');

  if (saveToDownloadsFolder) {
    await storagePermissionHandler();
  }

  var bytes = base64Decode(base64content);
  File file = await generatePathWithFileName(fileName);
  await file.writeAsBytes(bytes.buffer.asUint8List());

  if (openFile) {
    openDownloadedFile(file.path);
  }

  return file;
}
