import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metro_system/station.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'coordinates_ar.dart' as ar_list;
import 'coordinates_en.dart' as en_list;

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  static final _stations = Get.locale?.languageCode == 'ar' ? ar_list.stations : en_list.stations;
  static final _helwanLine = _stations.where((station) => station.lineNumber == 0).toList();
  static final _elmounibLine = _stations.where((station) => station.lineNumber == 1).toList();
  static final _adlyMansourBranch1 =
      _stations.where((station) => station.lineNumber == 2 && (station.branch == 0 || station.branch == null)).toList();
  static final _adlyMansourBranch2 =
      _stations.where((station) => station.lineNumber == 2 && (station.branch == 1 || station.branch == null)).toList();
  static final _capitalTrainLineBranch1 =
      _stations.where((station) => station.lineNumber == 3 && (station.branch == 0 || station.branch == null)).toList();
  static final _capitalTrainLineBranch2 =
      _stations.where((station) => station.lineNumber == 3 && (station.branch == 1 || station.branch == null)).toList();
  static final lines = [
    _helwanLine,
    _elmounibLine,
    _adlyMansourBranch1,
    _adlyMansourBranch2,
    _capitalTrainLineBranch1,
    _capitalTrainLineBranch2
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final route = shortestRoute(Get.arguments[0], Get.arguments[1]);
    final summarize = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: Text('routeLine'.tr, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _RouteInfo(route: route),
            const Divider(),
            Expanded(
              child: InkWell(
                onTap: () {
                  summarize.value = !summarize.value;
                },
                splashColor: Colors.transparent,
                child: ListView.builder(
                  itemCount: route.length,
                  itemBuilder: (context, index) {
                    final secondlineNumber =
                        index < route.length - 1 ? route[index + 1].first.lineNumber + (route[index + 1].first.branch ?? 0) : 0;

                    return Obx(() {
                      return Column(
                        children: [
                          if (index == 0)
                            TimelineTile(
                              isFirst: index == 0,
                              indicatorStyle: IndicatorStyle(
                                width: 30,
                                color: colorScheme.primary,
                                iconStyle: IconStyle(
                                  iconData: Icons.my_location,
                                  fontSize: 24.0,
                                  color: colorScheme.secondaryContainer,
                                ),
                              ),
                              afterLineStyle: LineStyle(color: colorScheme.primary, thickness: 3),
                              endChild: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                color: colorScheme.surface.withValues(alpha: 0.9),
                                shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "startOfRoute".trParams(
                                      {
                                        "station": route[index].first.name,
                                        "direction":
                                            lines[route[index].first.lineNumber + (route[index].first.branch ?? 0)].last.name,
                                      },
                                    ),
                                    style: GoogleFonts.merriweather(
                                      fontSize: 16,
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          TimelineTile(
                            indicatorStyle: IndicatorStyle(
                              width: 30,
                              color: colorScheme.primary,
                              iconStyle: IconStyle(
                                iconData: route[index][0].lineNumber == 0
                                    ? Icons.looks_one_outlined
                                    : route[index][0].lineNumber == 1
                                        ? Icons.looks_two_outlined
                                        : route[index][0].lineNumber == 2
                                            ? Icons.looks_3_outlined
                                            : Icons.train_outlined,
                                fontSize: 24.0,
                                color: colorScheme.secondaryContainer,
                              ),
                            ),
                            beforeLineStyle: LineStyle(color: colorScheme.primary, thickness: 3),
                            afterLineStyle: LineStyle(color: colorScheme.primary, thickness: 3),
                            endChild: summarize.value
                                ? Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    color: colorScheme.surface.withValues(alpha: 0.9),
                                    shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Text(
                                              route[index].first.name,
                                              style: GoogleFonts.merriweather(
                                                fontSize: 16,
                                                color: colorScheme.onSurface,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const Text('.'),
                                          const Text('.'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Text(
                                              route[index].last.name,
                                              style: GoogleFonts.merriweather(
                                                fontSize: 16,
                                                color: colorScheme.onSurface,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    color: colorScheme.surface.withValues(alpha: 0.9),
                                    shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: route[index]
                                            .map(
                                              (station) => Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                child: Text(
                                                  station.name,
                                                  style: GoogleFonts.merriweather(
                                                    fontSize: 16,
                                                    color: colorScheme.onSurface,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList()
                                            .sublist(index == 0 ? 1 : 0),
                                      ),
                                    ),
                                  ),
                          ),
                          if (index < route.length - 1)
                            TimelineTile(
                              indicatorStyle: IndicatorStyle(
                                width: 30,
                                color: colorScheme.primary,
                                iconStyle: IconStyle(
                                  iconData: Icons.compare_arrows,
                                  fontSize: 24.0,
                                  color: colorScheme.secondaryContainer,
                                ),
                              ),
                              beforeLineStyle: LineStyle(color: colorScheme.primary, thickness: 3),
                              afterLineStyle: LineStyle(color: colorScheme.primary, thickness: 3),
                              endChild: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                color: colorScheme.surface.withValues(alpha: 0.9),
                                shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'exchangeStation'.trParams(
                                      {
                                        "secondLineNumber": route[index].last.lineNumber == 3
                                            ? Get.locale?.languageCode == 'ar'
                                                ? "لخط قطار العاصمة"
                                                : "Capital Train Line"
                                            : '${Get.locale?.languageCode == 'ar' ? "للخط ال" : "Line"} ${route[index + 1].first.lineNumber + 1}',
                                        "station": route[index].last.name,
                                        "direction": lines[secondlineNumber]
                                                    .map((station) => station.name)
                                                    .toList()
                                                    .indexOf(route[index].last.name) <
                                                lines[secondlineNumber]
                                                    .map((station) => station.name)
                                                    .toList()
                                                    .indexOf(route[index + 1].first.name)
                                            ? lines[secondlineNumber].last.name
                                            : lines[secondlineNumber].first.name
                                      },
                                    ),
                                    style: GoogleFonts.merriweather(
                                      fontSize: 16,
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (index == route.length - 1)
                            TimelineTile(
                              isLast: index == route.length - 1,
                              indicatorStyle: IndicatorStyle(
                                width: 30,
                                color: colorScheme.primary,
                                iconStyle: IconStyle(
                                  iconData: Icons.location_on_outlined,
                                  fontSize: 24.0,
                                  color: colorScheme.secondaryContainer,
                                ),
                              ),
                              afterLineStyle: LineStyle(color: colorScheme.primary, thickness: 3),
                              endChild: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                color: colorScheme.surface.withValues(alpha: 0.9),
                                shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "routeCompleted".tr,
                                    style: GoogleFonts.merriweather(
                                      fontSize: 16,
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<List<Station>> shortestRoute(String currentStation, String targetedStation) {
    final Map<String, List<String>> network = {};
    List<List<Station>> path = [];
    final firstlineNumber = _stations.firstWhere((station) => station.name == currentStation).lineNumber +
        (_stations.firstWhere((station) => station.name == currentStation).branch ?? 0);
    final secondlineNumber = _stations.firstWhere((station) => station.name == targetedStation).lineNumber +
        (_stations.firstWhere((station) => station.name == targetedStation).branch ?? 0);
    if (firstlineNumber == secondlineNumber) {
      final firstIndex = lines[firstlineNumber].map((station) => station.name).toList().indexOf(currentStation);
      final seconddIndex = lines[firstlineNumber].map((station) => station.name).toList().indexOf(targetedStation);
      final temp = <Station>[];
      if (firstIndex < seconddIndex) {
        for (int i = firstIndex; i <= seconddIndex; i++) {
          temp.add(lines[firstlineNumber][i]);
        }
      } else {
        for (int i = firstIndex; i >= seconddIndex; i--) {
          temp.add(lines[firstlineNumber][i]);
        }
      }
      path.add(temp);
    } else {
      for (final line in lines) {
        for (int i = 0; i < line.length - 1; i++) {
          network.putIfAbsent(line[i].name, () => []);
          network.putIfAbsent(line[i + 1].name, () => []);
          network[line[i].name]!.add(line[i + 1].name);
          network[line[i + 1].name]!.add(line[i].name);
        }
      }
      Map<String, int> steps = {};
      Map<String, String?> previous = {};
      Set<String> visited = {};
      for (final station in network.keys) {
        steps[station] = 1000;
        previous[station] = null;
      }
      steps[currentStation] = 0;
      while (visited.length < network.keys.length) {
        final current = (steps.entries.where((e) => !visited.contains(e.key)).reduce((a, b) => a.value < b.value ? a : b)).key;
        if (current == targetedStation) break;
        visited.add(current);
        for (final neighbor in network[current]!) {
          if (visited.contains(neighbor)) continue;
          final newDist = steps[current]! + 1;
          if (newDist < steps[neighbor]!) {
            steps[neighbor] = newDist;
            previous[neighbor] = current;
          }
        }
      }
      String? current = targetedStation;
      List<Station> temp = [];
      List<String> transferStations = Get.locale?.languageCode == 'ar'
          ? ["الشهداء", "السادات", "جمال عبد الناصر", "العتبة", "جامعة القاهرة", "عدلي منصور"]
          : ["Shohadaa", "Sadat", "Gamal Abdel Nasser", "Attaba", "Cairo University", "Adly Mansour"];
      while (current != null) {
        temp.insert(0, _stations.firstWhere((st) => st.name == current));
        final lineN = _stations.firstWhere((st) => st.name == current).lineNumber;
        current = previous[current];
        if (current != null && previous[current] != null) {
          if (transferStations.contains(current) &&
              lineN != _stations.firstWhere((st) => st.name == previous[current]).lineNumber) {
            path.insert(0, temp.toList());
            temp.clear();
          }
        } else {
          if (current != null) path.insert(0, temp);
        }
      }
    }
    return path;
  }
}

class _RouteInfo extends StatelessWidget {
  const _RouteInfo({required this.route});

  final List<List<Station>> route;

  @override
  Widget build(BuildContext context) {
    final noOfStations = route.fold(0, (sum, list) => sum + list.length);
    double ticketPrice = 0;
    if (noOfStations == 0) {
      ticketPrice = 0.0;
    } else if (noOfStations <= 9) {
      ticketPrice = 8.0;
    } else if (noOfStations <= 16) {
      ticketPrice = 10.0;
    } else if (noOfStations <= 23) {
      ticketPrice = 15.0;
    } else {
      ticketPrice = 20.0;
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 8,
              child: Card(
                surfaceTintColor: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'expectedTime'.trParams({"time": "${noOfStations * 2}"}),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Card(
                surfaceTintColor: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'noOfStations'.trParams(
                      {
                        "stations": "${noOfStations == 2 && Get.locale?.languageCode == 'ar' ? "" : noOfStations}",
                        "number": Get.locale?.languageCode == 'ar'
                            ? noOfStations == 2
                                ? "محطتان"
                                : noOfStations <= 10
                                    ? "محطات"
                                    : "محطة"
                            : "Stations"
                      },
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                surfaceTintColor: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Price'.trParams(
                      {
                        "price": "${ticketPrice.toInt()}",
                        "currency": Get.locale?.languageCode == 'ar'
                            ? ticketPrice <= 10.0
                                ? "جنيهات"
                                : "جنيهًا"
                            : ticketPrice > 1.0
                                ? "Pounds"
                                : "Pound"
                      },
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
