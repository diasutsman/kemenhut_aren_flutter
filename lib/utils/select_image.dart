import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> selectImage() async {
  final ImagePicker picker = ImagePicker();
// Pick an image.
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image == null) return null;

  return File(image.path);
}
