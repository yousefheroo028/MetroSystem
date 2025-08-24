import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:metro_system/coordinates_ar.dart' as ar_list;
import 'package:metro_system/coordinates_en.dart' as en_list;

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final net = GetStorage();

  final stations = (Get.locale?.languageCode == 'ar' ? ar_list.stations : en_list.stations);
  @override
  Widget build(BuildContext context) {
    final route = bestRoute(Get.arguments[0], Get.arguments[1]);

    return Scaffold(
      appBar: AppBar(
        title: Text('appTitle'.tr, style: TextStyle(fontSize: 20)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: route.length,
            itemBuilder: (_, index) => LineCard(
              route: route[index],
              lineNumber: stations.firstWhere((station) => station.name == route[index][0]).lineNumber,
            ),
          ),
        ),
      ),
    );
  }

  List<List<String>> bestRoute(String currentStation, String targetedStation) {
    final Map<String, List<String>> network = {};
    final helwanLine = stations.where((station) => station.lineNumber == 0).toList();

    final elmounibLine = stations.where((station) => station.lineNumber == 1).toList();

    final adlyMansourBranch1 =
        stations.where((station) => station.lineNumber == 2 && (station.branch == 1 || station.branch == null)).toList();

    final adlyMansourBranch2 =
        stations.where((station) => station.lineNumber == 2 && (station.branch == 2 || station.branch == null)).toList();
    for (final line in [helwanLine, elmounibLine, adlyMansourBranch1, adlyMansourBranch2]) {
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

    List<List<String>> path = [];
    String? current = targetedStation;
    List<String> temp = [];
    while (current != null) {
      temp.insert(0, current);
      final lineN = stations.firstWhere((st) => st.name == current).lineNumber;
      current = previous[current];
      if (current != null) {
        if (lineN != stations.firstWhere((st) => st.name == current).lineNumber) {
          path.insert(0, temp.toList());
          temp = [];
        }
      } else {
        path.insert(0, temp);
      }
    }

    return path;
  }
}

class LineCard extends StatelessWidget {
  const LineCard({super.key, required this.route, required this.lineNumber});

  final List<String> route;
  final int lineNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${'line'.tr} ${lineNumber + 1}',
          style: const TextStyle(fontSize: 20),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: lineNumber == 0
                ? Colors.blue.shade900
                : lineNumber == 1
                    ? Colors.red.shade900
                    : Colors.green.shade900,
          ),
          padding: const EdgeInsets.all(16.0),
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
                        title: Text('${'from'.tr}: ${route.first}\n${'to'.tr}: ${route.last}'),
                        children: route
                            .map(
                              (station) => SizedBox(
                                width: context.width,
                                child: ListTile(
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
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: route
                          .map(
                            (station) => Text(
                              '$station \u2022',
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 20),
                            ),
                          )
                          .toList(),
                    )
            ],
          ),
        ),
      ],
    );
  }
}
