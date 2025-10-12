import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kemenhut_aren_flutter/core/bindings/app_binding.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kemenhut_aren_flutter/constants/_index.dart';
import 'package:kemenhut_aren_flutter/core/routes/app_routes.dart';
import 'package:kemenhut_aren_flutter/utils/custom_scroll_behaviour.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      fontSizeResolver:
          (fontSize, instance) => FontSizeResolvers.radius(fontSize, instance),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            final currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: GetMaterialApp(
              // localizationsDelegates: context.localizationDelegates,
              // supportedLocales: context.supportedLocales,
              // locale: context.locale,
              initialBinding: AppBinding(),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.theme,
              title: AppName.applicationName,
              initialRoute: AppRoutes.root,
              getPages: pageRoutes,
            ),
          ),
        );
      },
    );
  }
}
