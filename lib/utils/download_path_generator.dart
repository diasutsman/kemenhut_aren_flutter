import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:kemenhut_aren_flutter/core/exceptions/app_exception.dart';
import 'package:kemenhut_aren_flutter/utils/permission_handler.dart';

Future<File> generatePathWithFileName(String fileName) async {
  final output = await path.getApplicationDocumentsDirectory();
  File file = File('${output.path}/$fileName');

  if (await file.exists()) {
    await file.delete();
  }
  return file;
}

Future<String?> generateDownloadFolderPath() async {
  bool dirDownloadExists = true;
  String? directory;

  if (Platform.isIOS) {
    directory = (await path.getApplicationDocumentsDirectory()).path;
  } else if (Platform.isAndroid) {
    await storagePermissionHandler();

    directory = '/storage/emulated/0/Download/';

    try {
      dirDownloadExists = await Directory(directory).exists();
      if (dirDownloadExists) {
        directory = '/storage/emulated/0/Download/';
      } else {
        directory = '/storage/emulated/0/Downloads/';
      }
    } catch (e) {
      directory = '/storage/emulated/0/Downloads/';
    }
  } else {
    final dir = await path.getDownloadsDirectory();
    directory = dir?.path;
  }

  return directory;
}

Future<void> openDownloadedFile(String path) async {
  final result = await OpenFilex.open(path);

  if (result.type == ResultType.permissionDenied) {
    throw AppException(
      'Permission denied, please enable storage permission for this app',
    );
  } else if (result.type == ResultType.noAppToOpen) {
    throw AppException(
      'No supported apps to open this file, file saved on $path',
    );
  } else if (result.type == ResultType.fileNotFound) {
    throw AppException('Failed open file at $path');
  }
}
