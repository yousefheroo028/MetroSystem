import 'package:flutter/material.dart' show BuildContext;
import 'package:metro_system/l10n/app_localizations_en.dart';

import 'l10n/app_localizations.dart' show AppLocalizations;

class LocalizationService {
  static AppLocalizations local = AppLocalizationsEn();

  static void init(BuildContext context) {
    local = AppLocalizations.of(context)!;
  }
}
