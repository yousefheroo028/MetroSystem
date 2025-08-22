import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Cairo Metro App'**
  String get appTitle;

  /// No description provided for @findRoute.
  ///
  /// In en, this message translates to:
  /// **'Find Route'**
  String get findRoute;

  /// No description provided for @line.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get line;

  /// No description provided for @elMonib.
  ///
  /// In en, this message translates to:
  /// **'El Monib'**
  String get elMonib;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @sakiatMekki.
  ///
  /// In en, this message translates to:
  /// **'Sakiat Mekki'**
  String get sakiatMekki;

  /// No description provided for @omElMasryeen.
  ///
  /// In en, this message translates to:
  /// **'Om El Masryeen'**
  String get omElMasryeen;

  /// No description provided for @giza.
  ///
  /// In en, this message translates to:
  /// **'Giza'**
  String get giza;

  /// No description provided for @faisal.
  ///
  /// In en, this message translates to:
  /// **'Faisal'**
  String get faisal;

  /// No description provided for @cairoUniversity.
  ///
  /// In en, this message translates to:
  /// **'Cairo University'**
  String get cairoUniversity;

  /// No description provided for @elBohoth.
  ///
  /// In en, this message translates to:
  /// **'El Bohoth'**
  String get elBohoth;

  /// No description provided for @dokki.
  ///
  /// In en, this message translates to:
  /// **'Dokki'**
  String get dokki;

  /// No description provided for @opera.
  ///
  /// In en, this message translates to:
  /// **'Opera'**
  String get opera;

  /// No description provided for @sadat.
  ///
  /// In en, this message translates to:
  /// **'Sadat'**
  String get sadat;

  /// No description provided for @mohamedNaguib.
  ///
  /// In en, this message translates to:
  /// **'Mohamed Naguib'**
  String get mohamedNaguib;

  /// No description provided for @attaba.
  ///
  /// In en, this message translates to:
  /// **'Attaba'**
  String get attaba;

  /// No description provided for @shohadaa.
  ///
  /// In en, this message translates to:
  /// **'Shohadaa'**
  String get shohadaa;

  /// No description provided for @elMesalla.
  ///
  /// In en, this message translates to:
  /// **'El Mesalla'**
  String get elMesalla;

  /// No description provided for @rodElFarag.
  ///
  /// In en, this message translates to:
  /// **'Rod El Farag'**
  String get rodElFarag;

  /// No description provided for @saintTeresa.
  ///
  /// In en, this message translates to:
  /// **'Saint Teresa'**
  String get saintTeresa;

  /// No description provided for @khalafawy.
  ///
  /// In en, this message translates to:
  /// **'Khalafawy'**
  String get khalafawy;

  /// No description provided for @elMazalat.
  ///
  /// In en, this message translates to:
  /// **'El Mazalat'**
  String get elMazalat;

  /// No description provided for @facultyOfAgriculture.
  ///
  /// In en, this message translates to:
  /// **'Faculty of Agriculture'**
  String get facultyOfAgriculture;

  /// No description provided for @shubra.
  ///
  /// In en, this message translates to:
  /// **'Shubra'**
  String get shubra;

  /// No description provided for @helwan.
  ///
  /// In en, this message translates to:
  /// **'Helwan'**
  String get helwan;

  /// No description provided for @ainHelwan.
  ///
  /// In en, this message translates to:
  /// **'Ain Helwan'**
  String get ainHelwan;

  /// No description provided for @helwanUniversity.
  ///
  /// In en, this message translates to:
  /// **'Helwan University'**
  String get helwanUniversity;

  /// No description provided for @wadiHof.
  ///
  /// In en, this message translates to:
  /// **'Wadi Hof'**
  String get wadiHof;

  /// No description provided for @hadayeqHelwan.
  ///
  /// In en, this message translates to:
  /// **'Hadayeq Helwan'**
  String get hadayeqHelwan;

  /// No description provided for @elMaasara.
  ///
  /// In en, this message translates to:
  /// **'El Maasara'**
  String get elMaasara;

  /// No description provided for @kozzika.
  ///
  /// In en, this message translates to:
  /// **'Kozzika'**
  String get kozzika;

  /// No description provided for @toraElBalad.
  ///
  /// In en, this message translates to:
  /// **'Tora El Balad'**
  String get toraElBalad;

  /// No description provided for @thakanatElMaadi.
  ///
  /// In en, this message translates to:
  /// **'Thakanat El Maadi'**
  String get thakanatElMaadi;

  /// No description provided for @maadi.
  ///
  /// In en, this message translates to:
  /// **'Maadi'**
  String get maadi;

  /// No description provided for @hadayeqElMaadi.
  ///
  /// In en, this message translates to:
  /// **'Hadayeq El Maadi'**
  String get hadayeqElMaadi;

  /// No description provided for @darElSalam.
  ///
  /// In en, this message translates to:
  /// **'Dar El Salam'**
  String get darElSalam;

  /// No description provided for @elZahraa.
  ///
  /// In en, this message translates to:
  /// **'El Zahraa'**
  String get elZahraa;

  /// No description provided for @marGirgis.
  ///
  /// In en, this message translates to:
  /// **'Mar Girgis'**
  String get marGirgis;

  /// No description provided for @elMalekElSaleh.
  ///
  /// In en, this message translates to:
  /// **'El Malek El Saleh'**
  String get elMalekElSaleh;

  /// No description provided for @sayedaZeinab.
  ///
  /// In en, this message translates to:
  /// **'Sayeda Zeinab'**
  String get sayedaZeinab;

  /// No description provided for @saadZaghloul.
  ///
  /// In en, this message translates to:
  /// **'Saad Zaghloul'**
  String get saadZaghloul;

  /// No description provided for @gamalAbdelNasser.
  ///
  /// In en, this message translates to:
  /// **'Gamal Abdel Nasser'**
  String get gamalAbdelNasser;

  /// No description provided for @ahmedOrabi.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Orabi'**
  String get ahmedOrabi;

  /// No description provided for @ghamra.
  ///
  /// In en, this message translates to:
  /// **'Ghamra'**
  String get ghamra;

  /// No description provided for @elDemerdash.
  ///
  /// In en, this message translates to:
  /// **'El Demerdash'**
  String get elDemerdash;

  /// No description provided for @manshietElSadr.
  ///
  /// In en, this message translates to:
  /// **'Manshiet El Sadr'**
  String get manshietElSadr;

  /// No description provided for @kobriElKobba.
  ///
  /// In en, this message translates to:
  /// **'Kobri El Kobba'**
  String get kobriElKobba;

  /// No description provided for @hammamatElKobba.
  ///
  /// In en, this message translates to:
  /// **'Hammamat El Kobba'**
  String get hammamatElKobba;

  /// No description provided for @hadayeqElZeitoun.
  ///
  /// In en, this message translates to:
  /// **'Hadayeq El Zeitoun'**
  String get hadayeqElZeitoun;

  /// No description provided for @helmietElZeitoun.
  ///
  /// In en, this message translates to:
  /// **'Helmiet El Zeitoun'**
  String get helmietElZeitoun;

  /// No description provided for @elMatarya.
  ///
  /// In en, this message translates to:
  /// **'El Matarya'**
  String get elMatarya;

  /// No description provided for @ainShams.
  ///
  /// In en, this message translates to:
  /// **'Ain Shams'**
  String get ainShams;

  /// No description provided for @ezbetElNakhl.
  ///
  /// In en, this message translates to:
  /// **'Ezbet El Nakhl'**
  String get ezbetElNakhl;

  /// No description provided for @elMarg.
  ///
  /// In en, this message translates to:
  /// **'El Marg'**
  String get elMarg;

  /// No description provided for @newElMarg.
  ///
  /// In en, this message translates to:
  /// **'New El Marg'**
  String get newElMarg;

  /// No description provided for @adlyMansour.
  ///
  /// In en, this message translates to:
  /// **'Adly Mansour'**
  String get adlyMansour;

  /// No description provided for @elHaykestep.
  ///
  /// In en, this message translates to:
  /// **'El Haykestep'**
  String get elHaykestep;

  /// No description provided for @omarIbnElKhattab.
  ///
  /// In en, this message translates to:
  /// **'Omar Ibn El Khattab'**
  String get omarIbnElKhattab;

  /// No description provided for @qobaa.
  ///
  /// In en, this message translates to:
  /// **'Qobaa'**
  String get qobaa;

  /// No description provided for @heshamBarakat.
  ///
  /// In en, this message translates to:
  /// **'Hesham Barakat'**
  String get heshamBarakat;

  /// No description provided for @elNozha.
  ///
  /// In en, this message translates to:
  /// **'El Nozha'**
  String get elNozha;

  /// No description provided for @elShamsClub.
  ///
  /// In en, this message translates to:
  /// **'El Shams Club'**
  String get elShamsClub;

  /// No description provided for @alfMaskan.
  ///
  /// In en, this message translates to:
  /// **'Alf Maskan'**
  String get alfMaskan;

  /// No description provided for @heliopolis.
  ///
  /// In en, this message translates to:
  /// **'Heliopolis'**
  String get heliopolis;

  /// No description provided for @haroun.
  ///
  /// In en, this message translates to:
  /// **'Haroun'**
  String get haroun;

  /// No description provided for @elAhram.
  ///
  /// In en, this message translates to:
  /// **'El Ahram'**
  String get elAhram;

  /// No description provided for @facultyOfGirls.
  ///
  /// In en, this message translates to:
  /// **'Faculty of Girls'**
  String get facultyOfGirls;

  /// No description provided for @stadium.
  ///
  /// In en, this message translates to:
  /// **'Stadium'**
  String get stadium;

  /// No description provided for @fairZone.
  ///
  /// In en, this message translates to:
  /// **'Fair Zone'**
  String get fairZone;

  /// No description provided for @abbasia.
  ///
  /// In en, this message translates to:
  /// **'Abbasia'**
  String get abbasia;

  /// No description provided for @abdoBasha.
  ///
  /// In en, this message translates to:
  /// **'Abdo Basha'**
  String get abdoBasha;

  /// No description provided for @elGeish.
  ///
  /// In en, this message translates to:
  /// **'El Geish'**
  String get elGeish;

  /// No description provided for @babElShaaria.
  ///
  /// In en, this message translates to:
  /// **'Bab El Shaaria'**
  String get babElShaaria;

  /// No description provided for @maspero.
  ///
  /// In en, this message translates to:
  /// **'Maspero'**
  String get maspero;

  /// No description provided for @safaaHegazy.
  ///
  /// In en, this message translates to:
  /// **'Safaa Hegazy'**
  String get safaaHegazy;

  /// No description provided for @kitKat.
  ///
  /// In en, this message translates to:
  /// **'Kit Kat'**
  String get kitKat;

  /// No description provided for @elSudan.
  ///
  /// In en, this message translates to:
  /// **'El Sudan'**
  String get elSudan;

  /// No description provided for @imbaba.
  ///
  /// In en, this message translates to:
  /// **'Imbaba'**
  String get imbaba;

  /// No description provided for @elBohi.
  ///
  /// In en, this message translates to:
  /// **'El Bohi'**
  String get elBohi;

  /// No description provided for @elQawmeya.
  ///
  /// In en, this message translates to:
  /// **'El Qawmeya'**
  String get elQawmeya;

  /// No description provided for @elTareeqElDaeri.
  ///
  /// In en, this message translates to:
  /// **'El Tareeq El Daeri'**
  String get elTareeqElDaeri;

  /// No description provided for @rodElFaragAxis.
  ///
  /// In en, this message translates to:
  /// **'Rod El Farag Axis'**
  String get rodElFaragAxis;

  /// No description provided for @elTawfikiya.
  ///
  /// In en, this message translates to:
  /// **'El Tawfikiya'**
  String get elTawfikiya;

  /// No description provided for @wadiElNile.
  ///
  /// In en, this message translates to:
  /// **'Wadi El Nile'**
  String get wadiElNile;

  /// No description provided for @gamaetElDowal.
  ///
  /// In en, this message translates to:
  /// **'Gamaet El Dowal'**
  String get gamaetElDowal;

  /// No description provided for @bulaqElDakrour.
  ///
  /// In en, this message translates to:
  /// **'Bulaq El Dakrour'**
  String get bulaqElDakrour;

  /// No description provided for @currentStation.
  ///
  /// In en, this message translates to:
  /// **'Current Station'**
  String get currentStation;

  /// No description provided for @openLocation.
  ///
  /// In en, this message translates to:
  /// **'Open Location'**
  String get openLocation;

  /// No description provided for @needLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'We need Location Permissions to find Nearest Station to you.'**
  String get needLocationPermission;

  /// No description provided for @targetedStation.
  ///
  /// In en, this message translates to:
  /// **'Targeted Station'**
  String get targetedStation;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Address you Want to Go'**
  String get addressHint;

  /// No description provided for @locationDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'You can\'t Use this App'**
  String get locationDeniedTitle;

  /// No description provided for @locationDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'You Should Open Location to determine your current location to find the nearest metro station'**
  String get locationDeniedMessage;

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'The location service on the device is disabled.'**
  String get locationDisabled;

  /// No description provided for @permanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied, we cannot request permissions.'**
  String get permanentlyDenied;

  /// No description provided for @permissionsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied'**
  String get permissionsDisabled;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
