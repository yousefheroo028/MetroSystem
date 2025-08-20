import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:metro_system/coordinates.dart';
import 'package:metro_system/l10n/app_localizations.dart';
import 'package:metro_system/route_page.dart';
import 'package:metro_system/station.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _fromController = TextEditingController();

  final _toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final stationsList =
        stations.toSet().toList().map((station) => DropdownMenuEntry(value: station, label: station.name)).toList();
    var canFindRoute1 = false.obs;
    var canFindRoute2 = false.obs;
    final isFound = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 90.0,
            maxWidth: 300,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownMenu(
                      width: context.width,
                      hintText: 'Current Station',
                      menuHeight: 300.0,
                      dropdownMenuEntries: stationsList,
                      controller: _fromController,
                      enableSearch: true,
                      enableFilter: true,
                      requestFocusOnTap: true,
                      onSelected: (value) {
                        _fromController.text = value!.name;
                        canFindRoute1.value = true;
                      },
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      onPressed: isFound.value
                          ? null
                          : () async {
                              isFound.value = true;
                              Station nearestStation;
                              try {
                                nearestStation = await _findNearestStation();
                                _fromController.text = nearestStation.name;
                                canFindRoute1.value = true;
                              } catch (e) {
                                Get.snackbar('Open Location', 'We need Location Permissions to find Nearest Station to you.');
                              }
                              isFound.value = false;
                            },
                      icon: isFound.value
                          ? LoadingAnimationWidget.waveDots(color: Theme.of(context).primaryColorLight, size: 24.0)
                          : const Icon(Icons.location_on_outlined),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownMenu(
                hintText: 'Targeted Station',
                width: context.width,
                menuHeight: 300.0,
                dropdownMenuEntries: stationsList,
                controller: _toController,
                enableSearch: true,
                enableFilter: true,
                requestFocusOnTap: true,
                onSelected: (value) {
                  _toController.text = value!.name;
                  canFindRoute2.value = true;
                },
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => ElevatedButton(
                  onPressed: canFindRoute1.value && canFindRoute2.value
                      ? () => Get.to(
                            () => RoutePage(),
                            arguments: [_fromController.text, _toController.text],
                            transition: Transition.rightToLeft,
                          )
                      : null,
                  child: const Text('Find Route'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Station> _findNearestStation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('The location service on the device is disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Get.snackbar('You can\'t Use this App',
          'You Should Open Location to determine your current location to find the nearest metro station ');
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  if (!serviceEnabled) {}

  final station = stations;
  final currentPosition = await Geolocator.getCurrentPosition();
  var minDistance = double.infinity;
  var nearestStation = station.first;
  for (var st in station) {
    final distance = Geolocator.distanceBetween(st.latitude, st.longitude, currentPosition.latitude, currentPosition.longitude);
    if (distance < minDistance) {
      minDistance = distance;
      nearestStation = st;
    }
  }
  return nearestStation;
}
