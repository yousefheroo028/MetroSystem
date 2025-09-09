import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: const AssetImage('assets/images/metroMap.webp'),
      filterQuality: FilterQuality.high,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 5,
    );
  }
}
