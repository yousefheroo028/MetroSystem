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
  List<String> transferStations = Get.locale?.languageCode == 'ar'
      ? ["الشهداء", "السادات", "جمال عبد الناصر", "العتبة", "جامعة القاهرة", "عدلي منصور"]
      : ["Shohadaa", "Sadat", "Gamal Abdel Nasser", "Attaba", "Cairo University", "Adly Mansour"];
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final route = shortestRoute(Get.arguments[0], Get.arguments[1]);
    for (int i = 1; i < route.length; i++) {
      if (route[i - 1].first.lineNumber == route[i].first.lineNumber || (route[i].length == 1 && transferStations.contains(route[i].first.name))) {
        for (final station in route[i]) {
          route[i - 1].add(station);
        }
        route.removeAt(i);
        i--;
      }
    }
    final summarize = true.obs;
    final stations = Get.locale?.languageCode == 'ar' ? ar_list.stations : en_list.stations;
    final helwanLine = stations.where((station) => station.lineNumber == 0).toList();
    final elmounibLine = stations.where((station) => station.lineNumber == 1).toList();
    final adlyMansourBranch1 = stations.where((station) => station.lineNumber == 2 && (station.branch == 0 || station.branch == null)).toList();
    final adlyMansourBranch2 = stations.where((station) => station.lineNumber == 2 && (station.branch == 1 || station.branch == null)).toList();
    final capitalTrainLineBranch1 =
        stations.where((station) => station.lineNumber == 4 && (station.branch == 0 || station.branch == null)).toList();
    final capitalTrainLineBranch2 =
        stations.where((station) => station.lineNumber == 4 && (station.branch == 1 || station.branch == null)).toList();

    // Helper function to get the correct line list for a station
    List<Station> getLineForStation(Station station) {
      switch (station.lineNumber) {
        case 0:
          return helwanLine;
        case 1:
          return elmounibLine;
        case 2:
          if (station.branch == 0) {
            return adlyMansourBranch1;
          } else {
            return adlyMansourBranch2;
          }
        case 4:
          if (station.branch == 0) {
            return capitalTrainLineBranch1;
          } else {
            return capitalTrainLineBranch2;
          }
      }
      return <Station>[];
    }

    // Helper function to get direction
    String getDirection(Station fromStation, Station toStation) {
      final currentLine = getLineForStation(fromStation);
      final fromIndex = currentLine.indexWhere((s) => s.name == fromStation.name);
      final toIndex = currentLine.indexWhere((s) => s.name == toStation.name);

      return fromIndex < toIndex ? currentLine.last.name : currentLine.first.name;
    }

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
                  itemBuilder: (context, index) => Obx(
                    () {
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
                                        "direction": getDirection(route[index].first, route[index].last),
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
                            endChild: summarize.value && route[index].length > 2
                                ? Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    color: colorScheme.surface.withValues(alpha: 0.9),
                                    shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: route[index].length > 1
                                          ? Column(
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
                                                if (route[index].length > 3) const Text('.'),
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
                                            )
                                          : Padding(
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
                                            .toList(),
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
                                        "secondLineNumber": route[index + 1].first.lineNumber == 4
                                            ? Get.locale?.languageCode == 'ar'
                                                ? "لخط قطار العاصمة"
                                                : "Capital Train Line"
                                            : '${Get.locale?.languageCode == 'ar' ? "للخط ال" : "Line"} ${route[index + 1].first.lineNumber + 1}',
                                        "station": route[index].last.name,
                                        "direction": getDirection(route[index + 1].first, route[index + 1].last),
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
                    },
                  ),
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
    final stations = Get.locale?.languageCode == 'ar' ? ar_list.stations : en_list.stations;
    final helwanLine = stations.where((station) => station.lineNumber == 0).toList();
    final elmounibLine = stations.where((station) => station.lineNumber == 1).toList();
    final adlyMansourBranch1 = stations.where((station) => station.lineNumber == 2 && (station.branch == 0 || station.branch == null)).toList();
    final adlyMansourBranch2 = stations.where((station) => station.lineNumber == 2 && (station.branch == 1 || station.branch == null)).toList();
    final capitalTrainLineBranch1 =
        stations.where((station) => station.lineNumber == 4 && (station.branch == 0 || station.branch == null)).toList();
    final capitalTrainLineBranch2 =
        stations.where((station) => station.lineNumber == 4 && (station.branch == 1 || station.branch == null)).toList();
    final lines = [helwanLine, elmounibLine, adlyMansourBranch1, adlyMansourBranch2, capitalTrainLineBranch1, capitalTrainLineBranch2];
    List<List<Station>> path = [];
    final firstlineNumber = stations.firstWhere((station) => station.name == currentStation).lineNumber +
        (stations.firstWhere((station) => station.name == currentStation).branch ?? 0);
    final secondlineNumber = stations.firstWhere((station) => station.name == targetedStation).lineNumber +
        (stations.firstWhere((station) => station.name == targetedStation).branch ?? 0);
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
      while (current != null) {
        temp.insert(0, stations.firstWhere((st) => st.name == current));
        final lineN = stations.firstWhere((st) => st.name == current).lineNumber;
        current = previous[current];
        if (current != null && previous[current] != null) {
          if (transferStations.contains(current) && lineN != stations.firstWhere((st) => st.name == previous[current]).lineNumber) {
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
    int noOfMetroStations = 0;
    int noOfCapitalTrainStations = 0;
    for (final listOfStations in route) {
      noOfMetroStations += listOfStations.where((station) => station.lineNumber < 4).length;
      noOfCapitalTrainStations += listOfStations.where((station) => station.lineNumber == 4).length;
    }
    final double metroTicketPrice;
    final double capitalTicketPrice;
    if (noOfMetroStations == 0) {
      metroTicketPrice = 0.0;
    } else if (noOfMetroStations <= 9) {
      metroTicketPrice = 8.0;
    } else if (noOfMetroStations <= 16) {
      metroTicketPrice = 10.0;
    } else if (noOfMetroStations <= 23) {
      metroTicketPrice = 15.0;
    } else {
      metroTicketPrice = 20.0;
    }
    if (noOfCapitalTrainStations == 0) {
      capitalTicketPrice = 0;
    } else if (noOfCapitalTrainStations <= 3) {
      capitalTicketPrice = 10.0;
    } else if (noOfCapitalTrainStations <= 7) {
      capitalTicketPrice = 15.0;
    } else {
      capitalTicketPrice = 20.0;
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 10,
              child: Card(
                surfaceTintColor: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'expectedTime'.trParams({"time": "${(noOfMetroStations + noOfCapitalTrainStations) * 2}"}),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Card(
                surfaceTintColor: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'noOfStations'.trParams(
                      {
                        "stations":
                            "${(noOfMetroStations + noOfCapitalTrainStations) == 2 && Get.locale?.languageCode == 'ar' ? "" : (noOfMetroStations + noOfCapitalTrainStations)}",
                        "number": Get.locale?.languageCode == 'ar'
                            ? (noOfMetroStations + noOfCapitalTrainStations) == 2
                                ? "محطتان"
                                : (noOfMetroStations + noOfCapitalTrainStations) <= 10
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
            if (noOfMetroStations > 0)
              Expanded(
                flex: 8,
                child: Card(
                  surfaceTintColor: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Price'.trParams(
                        {
                          "price": '${metroTicketPrice.toInt()}',
                          "line": Get.locale?.languageCode == 'ar' ? "المترو" : "Metro",
                          "currency": Get.locale?.languageCode == 'ar'
                              ? metroTicketPrice <= 10.0
                                  ? "جنيهات"
                                  : "جنيهًا"
                              : metroTicketPrice > 1.0
                                  ? "Pounds"
                                  : "Pound"
                        },
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            if (noOfCapitalTrainStations > 0)
              Expanded(
                flex: 10,
                child: Card(
                  surfaceTintColor: Colors.orange.withValues(alpha: 0.8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Price'.trParams(
                        {
                          "price": '${capitalTicketPrice.toInt()}',
                          "line": Get.locale?.languageCode == 'ar' ? "قطار العاصمة" : "Capital Train",
                          "currency": Get.locale?.languageCode == 'ar'
                              ? capitalTicketPrice <= 10.0
                                  ? "جنيهات"
                                  : "جنيهًا"
                              : capitalTicketPrice > 1.0
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
