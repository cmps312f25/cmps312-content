import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

// Mall class must implement ClusterItem to work with ClusterManager
class Mall with ClusterItem {
  final String name;
  final LatLng position;

  Mall({required this.name, required this.position});

  // ClusterItem requires a location getter
  @override
  LatLng get location => position;
}

class MallsCluster extends StatefulWidget {
  const MallsCluster({super.key});

  @override
  State<MallsCluster> createState() => _MallsClusterState();
}

class _MallsClusterState extends State<MallsCluster> {
  late ClusterManager _clusterManager;
  Set<Marker> _markers = {}; // Stores the current markers to display on map

  // List of all malls in Qatar with their coordinates
  static final List<Mall> _malls = [
    Mall(name: 'Villaggio Mall', position: const LatLng(25.3716, 51.5224)),
    Mall(name: 'City Center Mall', position: const LatLng(25.2854, 51.5310)),
    Mall(name: 'Mall of Qatar', position: const LatLng(25.3267, 51.4832)),
    Mall(name: 'Landmark Mall', position: const LatLng(25.2635, 51.5533)),
    Mall(name: 'Doha Festival City', position: const LatLng(25.3811, 51.5348)),
    Mall(name: 'Hyatt Plaza', position: const LatLng(25.2915, 51.5356)),
    Mall(name: 'Royal Plaza', position: const LatLng(25.2867, 51.5369)),
    Mall(name: 'Lulu Hypermarket', position: const LatLng(25.2863, 51.5331)),
    Mall(name: 'Ezdan Mall', position: const LatLng(25.2540, 51.4447)),
    Mall(name: 'Gulf Mall', position: const LatLng(25.2674, 51.5606)),
    Mall(name: 'Al Khor Mall', position: const LatLng(25.2876, 51.5287)),
    Mall(name: 'Tawar Mall', position: const LatLng(25.3195, 51.5293)),
    Mall(name: 'Dar Al Salam Mall', position: const LatLng(25.2619, 51.5361)),
    Mall(name: 'Place Vendôme', position: const LatLng(25.3742, 51.5413)),
    Mall(name: 'Lagoona Mall', position: const LatLng(25.2925, 51.5248)),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize ClusterManager with:
    // 1. List of items to cluster
    // 2. Callback to update markers when clustering changes
    // 3. Custom marker builder for cluster appearance
    _clusterManager = ClusterManager<Mall>(
      _malls,
      _updateMarkers,
      markerBuilder: (cluster) => _markerBuilder(cluster),
    );
  }

  // Called by ClusterManager when markers need to be updated
  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      _markers = markers;
    });
  }

  // Builds a marker for each cluster (can be a single mall or grouped malls)
  Future<Marker> _markerBuilder(Cluster<Mall> cluster) async {
    return Marker(
      markerId: MarkerId(cluster.getId()),
      position: cluster.location,
      // Use larger icon with count for clusters, smaller for individual malls
      icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
          text: cluster.isMultiple ? cluster.count.toString() : ''),
      infoWindow: InfoWindow(
        title: cluster.isMultiple
            ? '${cluster.count} Malls' // Show count for clusters
            : cluster.items.first.name, // Show name for individual mall
      ),
    );
  }

  // Creates a custom circular marker with optional text (for cluster count)
  Future<BitmapDescriptor> _getMarkerBitmap(int size,
      {String text = ''}) async {
    // Use Canvas to draw a custom marker
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = Colors.blue;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // Draw blue circle
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint);

    // Draw text (cluster count) in center if provided
    if (text.isNotEmpty) {
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(size / 2 - textPainter.width / 2,
            size / 2 - textPainter.height / 2),
      );
    }

    // Convert canvas drawing to bitmap for marker icon
    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qatar Malls Cluster')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(25.2854, 51.5310), // Center on Doha
          zoom: 11.0,
        ),
        markers: _markers, // Display clustered markers
        // These callbacks allow ClusterManager to recalculate clusters when map moves
        onCameraMove: _clusterManager.onCameraMove,
        onCameraIdle: _clusterManager.updateMap,
        onMapCreated: (controller) {
          _clusterManager.setMapId(controller.mapId);
        },
      ),
    );
  }
}
