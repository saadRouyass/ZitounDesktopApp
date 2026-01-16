import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MoroccoMapPage extends StatelessWidget {
  const MoroccoMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
  options: MapOptions(
    initialCenter: LatLng(31.7917, -7.0926), // Morocco center
    initialZoom: 6.5,
    minZoom: 4,
    maxZoom: 18,
    interactionOptions: const InteractionOptions(
      flags: InteractiveFlag.all,
    ),
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.zitoun',
    ),
    MarkerLayer(
      markers: [
      Marker(
        point: LatLng(33.919639,-6.904833), // Casablanca
        width: 40,
        height: 40,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 32,
        ),
      ),
      Marker(
        point: LatLng(32.999990,-7.904833), // Casablanca
        width: 20,
        height: 20,
        child: const Icon(
          Icons.local_shipping,
          color: Colors.green,
          size: 32,
        ),
      ),
      Marker(
        point: LatLng(32.999641,-6.909833), // Casablanca
        width: 20,
        height: 20,
        child: const Icon(
          Icons.local_shipping,
          color: Colors.green,
          size: 32,
        ),
      ),
      ],
    ),
  ],
),
    );
  }


}
