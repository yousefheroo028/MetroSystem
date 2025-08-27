import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro_system/coordinates_ar.dart' as ar_list;
import 'package:metro_system/coordinates_en.dart' as en_list;

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final stations = (Get.locale?.languageCode == 'ar' ? ar_list.stations : en_list.stations);

  @override
  Widget build(BuildContext context) {
    final route = shortestRoute(Get.arguments[0], Get.arguments[1]);

    return Scaffold(
      appBar: AppBar(
        title: Text('appTitle'.tr, style: const TextStyle(fontSize: 20)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _RouteInfo(route: route),
              Divider(
                color: Theme.of(context).dividerColor,
                thickness: 2,
                indent: 20,
                radius: const BorderRadius.all(Radius.circular(16.0)),
                endIndent: 20,
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: route.length,
                  itemBuilder: (_, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LineCard(
                        route: route[index],
                        lineNumber: stations.firstWhere((station) => station.name == route[index][0]).lineNumber,
                      ),
                      if (index < route.length - 1)
                        ListTile(
                          title: Text(
                            'exchangeStation'.trParams(
                              {
                                "station": route[index].last,
                                "firstLineNumber":
                                    "${stations.firstWhere((station) => station.name == route[index].first).lineNumber + 1}",
                                "secondLineNumber":
                                    "${stations.firstWhere((station) => station.name == route[index + 1].first).lineNumber + 1}"
                              },
                            ),
                          ),
                          leading: const Text(
                            '\u2022',
                            style: TextStyle(fontSize: 30),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<List<String>> shortestRoute(String currentStation, String targetedStation) {
    final Map<String, List<String>> network = {};
    final helwanLine = stations.where((station) => station.lineNumber == 0).toList();

    final elmounibLine = stations.where((station) => station.lineNumber == 1).toList();

    final adlyMansourBranch1 =
        stations.where((station) => station.lineNumber == 2 && (station.branch == 1 || station.branch == null)).toList();

    final adlyMansourBranch2 =
        stations.where((station) => station.lineNumber == 2 && (station.branch == 2 || station.branch == null)).toList();
    final lines = [helwanLine, elmounibLine, adlyMansourBranch1, adlyMansourBranch2];
    List<List<String>> path = [];
    final firstlineNumber = stations.firstWhere((station) => station.name == currentStation).lineNumber;
    final secondlineNumber = stations.firstWhere((station) => station.name == targetedStation).lineNumber;
    if (firstlineNumber == secondlineNumber) {
      final firstIndex = lines[firstlineNumber].map((station) => station.name).toList().indexOf(currentStation);
      final seconddIndex = lines[firstlineNumber].map((station) => station.name).toList().indexOf(targetedStation);
      final temp = <String>[];
      if (firstIndex < seconddIndex) {
        for (int i = firstIndex; i <= seconddIndex; i++) {
          temp.add(lines[firstlineNumber].map((station) => station.name).toList()[i]);
        }
      } else {
        for (int i = firstIndex; i >= seconddIndex; i--) {
          temp.add(lines[firstlineNumber].map((station) => station.name).toList()[i]);
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
      List<String> temp = [];
      List<String> transferStations = Get.locale?.languageCode == 'ar'
          ? ["الشهداء", "السادات", "جمال عبد الناصر", "العتبة", "جامعة القاهرة"]
          : ["Shohadaa", "Sadat", "Gamal Abdel Nasser", "Attaba", "Cairo University"];

      while (current != null) {
        temp.insert(0, current);
        final lineN = stations.firstWhere((st) => st.name == current).lineNumber;
        current = previous[current];
        if (current != null && previous[current] != null) {
          if (transferStations.contains(current) &&
              lineN != stations.firstWhere((st) => st.name == previous[current]).lineNumber) {
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

class _LineCard extends StatelessWidget {
  const _LineCard({required this.route, required this.lineNumber});

  final List<String> route;
  final int lineNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: lineNumber == 0
            ? Colors.blue.shade900
            : lineNumber == 1
                ? Colors.red.shade900
                : Colors.green.shade900,
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(4.0),
      width: context.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          lineNumber == 0
              ? const Icon(Icons.looks_one_outlined)
              : lineNumber == 1
                  ? const Icon(Icons.looks_two_outlined)
                  : const Icon(Icons.looks_3_outlined),
          route.length > 2
              ? Expanded(
                  child: ExpansionTile(
                    title: Text(
                      '${'from'.tr}: ${route.first}\n'
                      '${'to'.tr}: ${route.last}',
                    ),
                    children: route
                        .map(
                          (station) => SizedBox(
                            width: context.width,
                            child: ListTile(
                              minVerticalPadding: 2.0,
                              minTileHeight: 0.0,
                              minLeadingWidth: 2.0,
                              title: Text(station),
                              leading: const Text(
                                '\u2022',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              : Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: route
                        .map(
                          (station) => SizedBox(
                            width: context.width,
                            child: ListTile(
                              minVerticalPadding: 2.0,
                              minTileHeight: 0.0,
                              title: Text(station),
                              minLeadingWidth: 2.0,
                              leading: const Text(
                                '\u2022',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
        ],
      ),
    );
  }
}

class _RouteInfo extends StatelessWidget {
  const _RouteInfo({required this.route});

  final List<List<String>> route;

  @override
  Widget build(BuildContext context) {
    final noOfStations = route.fold(0, (sum, list) => sum + list.length);
    final double ticketPrice;
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
              flex: 2,
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
              flex: 3,
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
