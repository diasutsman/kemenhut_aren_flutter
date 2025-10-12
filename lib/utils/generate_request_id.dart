import 'dart:convert';
import 'package:crypto/crypto.dart';

Future<String> generateRequestId() async {
  var key = utf8.encode('key');
  var bytes = utf8.encode(DateTime.now().toString());

  var hmacSha256 = Hmac(sha1, key);
  var digest = hmacSha256.convert(bytes);
  return digest.toString();
}
