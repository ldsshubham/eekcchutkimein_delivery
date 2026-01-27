import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  /// Default location (India – Delhi)
  static const LatLng _initialLocation = LatLng(28.6139, 77.2090);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _initialLocation,
          zoom: 14,
        ),
        myLocationEnabled: false,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
