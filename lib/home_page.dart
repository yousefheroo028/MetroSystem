import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:metro_system/coordinates.dart';
import 'package:metro_system/l10n/app_localizations.dart';
import 'package:metro_system/route_page.dart';
import 'package:metro_system/station.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _fromController = TextEditingController();

  final _toController = TextEditingController();

  final _targetedAddressController = TextEditingController();

  final _controller = Get.put(HomeController());
  @override
  void dispose() {
    _fromController.dispose();
    _controller.dispose();
    _toController.dispose();
    _targetedAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stationsList = stations
        .map((station) => station.name)
        .toSet()
        .map((station) => DropdownMenuEntry(value: station, label: station))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle, style: TextStyle(fontSize: 20)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 90.0, maxWidth: 300),
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
                        _fromController.text = value!;
                        _controller.fromIsEntered.value = true;
                      },
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        IconButton(
                          onPressed: _controller.isFound.value
                              ? null
                              : () async {
                                  _controller.isFound.value = true;
                                  try {
                                    _controller.nearestStation = await _findNearestStation();
                                    _fromController.text = _controller.nearestStation!.name;
                                  } catch (e) {
                                    Get.snackbar('Open Location', 'We need Location Permissions to find Nearest Station to you.');
                                  }
                                  _controller.isFound.value = false;
                                  _controller.fromIsEntered.value = _fromController.text.isNotEmpty;
                                },
                          icon: _controller.isFound.value
                              ? LoadingAnimationWidget.waveDots(color: Theme.of(context).primaryColorLight, size: 24.0)
                              : const Icon(Icons.location_on_outlined),
                        ),
                        IconButton(
                          onPressed: !_controller.fromIsEntered.value
                              ? null
                              : () async {
                                  await launchUrl(
                                    Uri(
                                      scheme: 'google.navigation',
                                      queryParameters: {
                                        'q': '${_controller.nearestStation!.latitude}, ${_controller.nearestStation!.longitude}'
                                      },
                                    ),
                                  );
                                },
                          icon: const Icon(Icons.map),
                        )
                      ],
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
                  _toController.text = value!;
                  _controller.toIsEntered.value = true;
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
                  onPressed: _controller.fromIsEntered.value && _controller.toIsEntered.value
                      ? () => Get.to(
                            () => RoutePage(),
                            arguments: [_fromController.text, _toController.text],
                            transition: Transition.cupertino,
                          )
                      : null,
                  child: const Text('Find Route'),
                ),
              ),
              const SizedBox(height: 100),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _targetedAddressController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Address you want to Go',
                      ),
                      onChanged: (value) {
                        _targetedAddressController.text = value;
                        _controller.targetedIsEntered.value = _targetedAddressController.text.isNotEmpty;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _controller.targetedIsEntered.value
                            ? () async {
                                final locations = await locationFromAddress(_targetedAddressController.text);
                                final targetedAddress = calculatenearestStation(locations[0]);
                                _toController.text = targetedAddress.name;
                                _controller.toIsEntered.value = _toController.text.isNotEmpty;
                              }
                            : null,
                        icon: const Icon(Icons.location_searching_sharp),
                      ),
                      IconButton(
                        onPressed: !_controller.targetedIsEntered.value
                            ? null
                            : () async {
                                final locations = await locationFromAddress(_targetedAddressController.text);
                                await launchUrl(
                                  Uri(
                                    scheme: 'google.navigation',
                                    queryParameters: {'q': '${locations[0].latitude}, ${locations[0].longitude}'},
                                  ),
                                );
                              },
                        icon: const Icon(Icons.map),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  var isFound = false.obs;
  var fromIsEntered = false.obs;
  var toIsEntered = false.obs;
  var targetedIsEntered = false.obs;

  Station? nearestStation;
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

  return calculatenearestStation(await Geolocator.getCurrentPosition());
}

double calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
  const earthRadiusKm = 6371.0; // Earth's radius in kilometers

  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);

  final a = sin(dLat / 2) * sin(dLat / 2) + cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadiusKm * c;
}

double _toRadians(double degree) {
  return degree * pi / 180;
}

Station calculatenearestStation(location) {
  final stationList = stations;
  var minDistance = double.infinity;

  var nearestStation = stationList.first;
  for (var st in stationList) {
    final distance = calculateHaversineDistance(st.latitude, st.longitude, location.latitude, location.longitude);
    if (distance < minDistance) {
      minDistance = distance;
      nearestStation = st;
    }
  }
  return nearestStation;
}
