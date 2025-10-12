// import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:logger/logger.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/core/app_client/app_client.dart';
// import 'package:kemenhut_aren_flutter/modules/_index.dart';
import 'package:kemenhut_aren_flutter/utils/_index.dart';
// import 'package:kemenhut_aren_flutter/utils/snackbar.dart';

class AppInterceptor extends Interceptor {
  // final _session = getx.Get.find<Session>();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // if (!options.path.contains(ApiPath.login) &&
    //     !options.path.contains(ApiPath.listDatabase) &&
    //     _session.cookies != null) {
    //   options.headers['Cookie'] = _session.cookies;
    // }

    options.headers['User-Agent'] = AppName.applicationName;

    return handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    try {
      if ((response.data['error'] != null &&
              (response.data['error']['data'] != null &&
                  response.data['error']['data']['message'] != null &&
                  (response.data['error']['data']['message']
                          .toString()
                          .toLowerCase()
                          .contains('session expired') ||
                      response.data['error']['data']['message']
                          .toString()
                          .toLowerCase()
                          .contains(
                            'current transaction is aborted, commands ignored until end of transaction block',
                          )))) ||
          (response.data['error'] != null &&
              response.data['error']['code'] != null &&
              response.data['error']['code'] == 404)) {
        await Future.delayed(const Duration(seconds: 2));
        // await getx.Get.find<AuthenticationController>().refreshCookie();
        final newResponse = await AppClient().dio.fetch(
          response.requestOptions,
        );

        return handler.resolve(newResponse);
      } else if (response.data['error'] != null &&
          response.data['error']['data']['message'] != null) {
        showSnackbar(
          getx.Get.context!,
          response.data['error']['data']['message'],
          false,
          titleMessage: 'Error Occured',
        );

        Logger().e(response.data['error']['data']);

        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            message: response.data['error']['data']['message'],
            type: DioExceptionType.badResponse,
          ),
        );
      } else {
        handler.next(response);
      }
    } catch (e) {
      handler.next(response);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // if (_session.internetConnection != null &&
    //     await _session.internetConnection!.hasInternetAccess == false) {
    //   return;
    // }

    // if (err.response != null && err.response!.statusCode == 404) {
    //   await getx.Get.find<AuthenticationController>().refreshCookie();
    //   final newResponse = await AppClient().dio.fetch(err.requestOptions);
    //   return handler.resolve(newResponse);
    // }

    return handler.next(err);
  }
}
