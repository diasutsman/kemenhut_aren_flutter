import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/core/_index.dart';

class AppClient {
  late Dio dio;

  AppClient() {
    // final testMode = Get.find<Session>().testMode;

    // if (testMode) {
    //   dio = Get.find<Session>().dio!;
    // } else {
    dio = Dio(
        BaseOptions(
          baseUrl: AppSettings.URL_BASE,
          sendTimeout: const Duration(seconds: 15),
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(minutes: 3),
        ),
      )
      ..interceptors.addAll([
        AppInterceptor(),
        if (kDebugMode)
          AwesomeDioInterceptor(
            logRequestHeaders: false,
            logRequestTimeout: false,
            logResponseHeaders: false,
          ),
      ]);
  }
  // }
}
