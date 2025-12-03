import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocationMap extends StatefulWidget {
  const CurrentLocationMap({super.key});

  @override
  State<CurrentLocationMap> createState() => _CurrentLocationMapState();
}

class _CurrentLocationMapState extends State<CurrentLocationMap> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;

  // Default camera position (Doha, Qatar)
  static const _initialPosition = CameraPosition(
    target: LatLng(25.276987, 51.520008),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Fetch and display the current location
  Future<void> _getCurrentLocation() async {
    try {
      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
            );
          }
          return;
        }
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
        // Animate camera to current location
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(_currentLocation!),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching location: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current Location Map')),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        // Display marker at current location if available
        markers: _currentLocation != null
            ? {
                Marker(
                  markerId: const MarkerId('current_location'),
                  position: _currentLocation!,
                  infoWindow: const InfoWindow(title: "Your Location"),
                ),
              }
            : {},
        onMapCreated: (controller) => _mapController = controller,
        myLocationEnabled: true, // Show blue dot at user's location
        myLocationButtonEnabled: true, // Show location button
      ),
    );
  }
}
