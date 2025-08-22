import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:metro_system/l10n/app_localizations.dart';

import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  await GetStorage.init();

  runApp(const Entry());
}

class Entry extends StatelessWidget {
  const Entry({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
