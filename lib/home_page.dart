import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:metro_system/coordinates_ar.dart' as ar_list;
import 'package:metro_system/coordinates_en.dart' as en_list;
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
    final stationsList = (Get.locale?.languageCode == 'ar' ? ar_list.stations : en_list.stations)
        .toSet()
        .map((station) => DropdownMenuEntry(value: station.name, label: station.name))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('appTitle'.tr, style: const TextStyle(fontSize: 20)),
        leading: IconButton(
          onPressed: () async {
            final arabicNamesOfStations = ar_list.stations.map((station) => station.name).toSet().toList();
            final englishNamesOfStations = en_list.stations.map((station) => station.name).toSet().toList();
            (Get.locale?.languageCode == 'ar')
                ? await Get.updateLocale(const Locale('en', 'US'))
                : await Get.updateLocale(const Locale('ar', 'AA'));
            if (Get.locale?.languageCode != 'ar') {
              _fromController.text = englishNamesOfStations[arabicNamesOfStations.indexOf(_fromController.text)];
              _toController.text = englishNamesOfStations[arabicNamesOfStations.indexOf(_toController.text)];
            } else {
              _fromController.text = arabicNamesOfStations[englishNamesOfStations.indexOf(_fromController.text)];
              _toController.text = arabicNamesOfStations[englishNamesOfStations.indexOf(_toController.text)];
            }
          },
          icon: const Icon(Icons.translate),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 90.0, maxWidth: 300),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownMenu(
                      width: context.width,
                      hintText: 'currentStation'.tr,
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
                                    _controller.nearestStation = await _findNearestStation(context);
                                    _fromController.text = _controller.nearestStation!.name;
                                  } catch (e) {
                                    Get.snackbar('openLocation'.tr, 'needLocationPermission'.tr);
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
                hintText: 'targetedStation'.tr,
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
                      ? () => _fromController.text != _toController.text
                          ? Get.to(
                              () => const RoutePage(),
                              arguments: [_fromController.text, _toController.text],
                              transition: Transition.cupertino,
                            )
                          : Get.snackbar('Wrong'.tr, '${'You\'re Already in'.tr} ${_fromController.text} ${'Station'.tr}')
                      : null,
                  child: Text('findRoute'.tr),
                ),
              ),
              const SizedBox(height: 100),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _targetedAddressController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'addressHint'.tr,
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

Future<Station> _findNearestStation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('locationDisabled'.tr);
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Get.snackbar('locationDeniedTitle'.tr, 'locationDeniedMessage'.tr);
      return Future.error('permissionsDisabled'.tr);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('permanentlyDenied'.tr);
  }

  if (!serviceEnabled) {}

  return calculatenearestStation(await Geolocator.getCurrentPosition());
}

double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const earthRadiusKm = 6371.0;

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
  final stationList = Get.locale?.languageCode == 'ar' ? ar_list.stations : en_list.stations;
  var minDistance = double.infinity;

  var nearestStation = stationList.first;
  for (var st in stationList) {
    final distance = _calculateDistance(st.latitude, st.longitude, location.latitude, location.longitude);
    if (distance < minDistance) {
      minDistance = distance;
      nearestStation = st;
    }
  }
  return nearestStation;
}
