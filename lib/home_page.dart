import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:metro_system/coordinates_ar.dart' as ar_list;
import 'package:metro_system/coordinates_en.dart' as en_list;
import 'package:metro_system/map_view.dart';
import 'package:metro_system/route_page.dart';
import 'package:metro_system/station.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _fromController = TextEditingController();

  final TextEditingController _toController = TextEditingController();

  final TextEditingController _targetedAddressController = TextEditingController();

  final HomeController _controller = Get.put(HomeController());

  @override
  void dispose() {
    _fromController.dispose();
    _controller.dispose();
    _toController.dispose();
    _targetedAddressController.dispose();
    super.dispose();
  }

  final RxInt _pageIndex = 0.obs;

  final RxBool isDark = Get.isDarkMode.obs;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> stationsList = (Get.locale?.languageCode == 'ar' ? ar_list.stations : en_list.stations)
        .map((Station station) => station.name)
        .toSet()
        .map((String station) => DropdownMenuEntry<String>(value: station, label: station))
        .toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.changeThemeMode(isDark.value ? ThemeMode.light : ThemeMode.dark);
            isDark.value = !isDark.value;
          },
          icon: Obx(() => isDark.value ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode)),
        ),
        title: Text('appTitle'.tr, style: const TextStyle(fontSize: 20)),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final List<String> arabicNamesOfStations = ar_list.stations.map((Station station) => station.name).toSet().toList();
              final List<String> englishNamesOfStations =
                  en_list.stations.map((Station station) => station.name).toSet().toList();
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
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: _pageIndex.value,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  spacing: 8.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownMenu<String>(
                      hintText: 'currentStation'.tr,
                      menuHeight: 300.0,
                      dropdownMenuEntries: stationsList,
                      width: context.width - 32.0,
                      menuStyle: MenuStyle(
                        elevation: WidgetStateProperty.all(0),
                        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry?>(
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                        ),
                      ),
                      controller: _fromController,
                      enableSearch: true,
                      alignmentOffset: const Offset(0.0, 8.0),
                      enableFilter: true,
                      requestFocusOnTap: true,
                      leadingIcon: const Icon(Icons.train_outlined),
                      onSelected: (String? value) {
                        _fromController.text = value!;
                        _controller.fromIsEntered.value = true;
                      },
                    ),
                    Obx(
                      () => Row(
                        spacing: 8.0,
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton.icon(
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
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(EdgeInsetsGeometry.all(8.0)),
                              ),
                              label: Text('nearestStation'.tr),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: !_controller.fromIsEntered.value
                                  ? null
                                  : () async {
                                      await launchUrl(
                                        Uri(
                                          scheme: 'google.navigation',
                                          queryParameters: <String, dynamic>{
                                            'q':
                                                '${_controller.nearestStation!.latitude}, ${_controller.nearestStation!.longitude}',
                                          },
                                        ),
                                      );
                                    },
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(EdgeInsetsGeometry.all(8.0)),
                              ),
                              icon: const Icon(Icons.map),
                              label: Text('locationOfStation'.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenu<String>(
                      hintText: 'targetedStation'.tr,
                      width: context.width - 32.0,
                      menuHeight: 300.0,
                      menuStyle: MenuStyle(
                        elevation: WidgetStateProperty.all(0),
                        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry?>(
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                        ),
                      ),
                      dropdownMenuEntries: stationsList,
                      alignmentOffset: const Offset(0.0, 8.0),
                      controller: _toController,
                      enableSearch: true,
                      leadingIcon: const Icon(Icons.train_outlined),
                      enableFilter: true,
                      requestFocusOnTap: true,
                      onSelected: (String? value) {
                        _toController.text = value!;
                        _controller.toIsEntered.value = true;
                      },
                    ),
                    Obx(
                      () => ElevatedButton(
                        onPressed: _controller.fromIsEntered.value && _controller.toIsEntered.value
                            ? () => _fromController.text != _toController.text
                                ? Get.to(
                                    () => const RoutePage(),
                                    arguments: <String>[_fromController.text, _toController.text],
                                    transition: Transition.cupertino,
                                  )
                                : Get.snackbar(
                                    'sameStations'.tr,
                                    'You\'re Already in'.trParams(<String, String>{"station": _fromController.text}),
                                  )
                            : null,
                        child: Text('findRoute'.tr),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Obx(
                          () {
                            return IconButton(
                              onPressed: _controller.targetedIsEntered.value
                                  ? () {
                                      _targetedAddressController.text = '';
                                      _controller.targetedIsEntered.value = false;
                                    }
                                  : null,
                              icon: const Icon(Icons.delete_outline),
                            );
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _targetedAddressController,
                            decoration: InputDecoration(
                              hintText: 'addressHint'.tr,
                            ),
                            onChanged: (String value) {
                              _controller.targetedIsEntered.value = _targetedAddressController.text.isNotEmpty;
                            },
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => Row(
                        spacing: 8.0,
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: ElevatedButton.icon(
                              onPressed: _controller.targetedIsEntered.value
                                  ? () async {
                                      final List<Location> locations = await locationFromAddress(_targetedAddressController.text);
                                      final Station targetedAddress = calculatenearestStation(locations[0]);
                                      _toController.text = targetedAddress.name;
                                      _controller.toIsEntered.value = _toController.text.isNotEmpty;
                                    }
                                  : null,
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(EdgeInsetsGeometry.all(8.0)),
                              ),
                              label: Text('nearestStationForAddress'.tr),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: ElevatedButton.icon(
                              onPressed: !_controller.targetedIsEntered.value
                                  ? null
                                  : () async {
                                      final List<Location> locations = await locationFromAddress(_targetedAddressController.text);
                                      await launchUrl(
                                        Uri(
                                          scheme: 'google.navigation',
                                          queryParameters: <String, String>{
                                            'q': '${locations[0].latitude}, ${locations[0].longitude}',
                                          },
                                        ),
                                      );
                                    },
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(EdgeInsetsGeometry.all(8.0)),
                              ),
                              label: Text('locationOfAddress'.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const MapView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'homePage'.tr),
            BottomNavigationBarItem(icon: const Icon(Icons.map), label: 'map'.tr),
          ],
          elevation: 0,
          currentIndex: _pageIndex.value,
          onTap: (int value) => _pageIndex.value = value,
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  RxBool isFound = false.obs;
  RxBool fromIsEntered = false.obs;
  RxBool toIsEntered = false.obs;
  RxBool targetedIsEntered = false.obs;

  Station? nearestStation;
}

Future<Station> _findNearestStation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future<Station>.error('locationDisabled'.tr);
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Get.snackbar('locationDeniedTitle'.tr, 'locationDeniedMessage'.tr);
      return Future<Station>.error('permissionsDisabled'.tr);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future<Station>.error('permanentlyDenied'.tr);
  }

  return calculatenearestStation(await Geolocator.getCurrentPosition());
}

double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadiusKm = 6371.0;

  final double dLat = _toRadians(lat2 - lat1);
  final double dLon = _toRadians(lon2 - lon1);

  final double a = sin(dLat / 2) * sin(dLat / 2) + cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadiusKm * c;
}

double _toRadians(double degree) {
  return degree * pi / 180;
}

Station calculatenearestStation(dynamic location) {
  final List<Station> stationList = Get.locale?.languageCode == 'ar' ? ar_list.stations : en_list.stations;
  double minDistance = double.infinity;

  Station nearestStation = stationList.first;
  for (final Station st in stationList) {
    final double distance = _calculateDistance(st.latitude, st.longitude, location.latitude, location.longitude);
    if (distance < minDistance) {
      minDistance = distance;
      nearestStation = st;
    }
  }
  return nearestStation;
}
