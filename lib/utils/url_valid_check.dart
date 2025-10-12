import 'package:get/get.dart';

bool urlValidCheck(String url) {
  bool valid = true;
  final uri = Uri.parse(url);

  if (uri.hasScheme && uri.toString().isURL && uri.host.isNotEmpty) {
    valid = true;
  } else {
    valid = false;
  }

  return valid;
}

String extractBaseUrl(String url) {
  final uri = Uri.parse(url);

  return '${uri.scheme}://${uri.host}';
}
