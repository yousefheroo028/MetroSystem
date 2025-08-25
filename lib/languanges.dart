import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar_AE': {
          "appTitle": "برنامج مترو القاهرة",
          "line": "الخط",
          "currentStation": "المحطة اللي هتحرك منها",
          "openLocation": "افتح الموقع",
          "needLocationPermission": "محتاجين صلاحيات الموقع عشان نحدد أقرب محطة مترو ليك",
          "targetedStation": "المحطة اللي عاوز أروحها",
          "from": "من",
          "to": "إلى",
          "findRoute": "وريني أمشي ازاي",
          "addressHint": "اكتب العنوان اللي عاوز تروحه",
          "locationDeniedTitle": "ماينفعش تستخدم البرنامج دا",
          "locationDeniedMessage": "لازم تشغل اللوكيشن عشان نعرف مكانك ومنها نعرف أقرب محطة مترو",
          "locationDisabled": "اللوكيشن مقفول",
          "permanentlyDenied": "مش هنقدر نستخدم اللوكيشن عشان مقفول بشكل نهائي",
          "permissionsDisabled": "صلاحيات اللوكيشن مقفولة",
          "sameStations": "خخخخخ، أنت بتعمل ايه؟!",
          "You're Already in": "أنت فعلًا موجود في محطة @station",
          "Station": "محطة",
          "exchangeStation": "هتحول من الخط @firstLineNumber للخط @secondLineNumber عن طريق محطة @station"
        },
        'en_US': {
          "appTitle": "Cairo Metro App",
          "findRoute": "Find Route",
          "line": "Line",
          "currentStation": "Current Station",
          "openLocation": "Open Location",
          "needLocationPermission": "We need Location Permissions to find Nearest Station to you.",
          "targetedStation": "Targeted Station",
          "addressHint": "Address you Want to Go",
          "from": "from",
          "to": "to",
          "locationDeniedTitle": "You can't Use this App",
          "locationDeniedMessage":
              "You Should Open Location to determine your current location to find the nearest metro station",
          "locationDisabled": "The location service on the device is disabled.",
          "permanentlyDenied": "Location permissions are permanently denied, we cannot request permissions.",
          "permissionsDisabled": "Location permissions are denied",
          "sameStations": "What are you doing?!",
          "You're Already in": "You're Already in @station Station",
          "Station": "Station",
          "exchangeStation": "You will exchange from Line @firstLineNumber to Line @secondLineNumber through @station Station"
        },
      };
}
