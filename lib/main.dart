import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:kemenhut_aren_flutter/constants/app_locales.dart';

import 'package:kemenhut_aren_flutter/core/_index.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  return runApp(
    const App(),
    // EasyLocalization(
    //   /// Add more supported locales here: e.g : AppLocales.id
    //   /// This template only support en-US locale
    //   supportedLocales: const [AppLocales.en],
    //   path: 'assets/locales',
    //   fallbackLocale: AppLocales.en,
    //   startLocale: AppLocales.en,
    //   assetLoader: const JsonAssetLoader(),
    //   child: const App(),
    // ),
  );
}
