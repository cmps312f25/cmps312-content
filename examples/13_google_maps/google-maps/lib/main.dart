import 'package:flutter/material.dart';
import 'package:google_maps/current_location_map.dart';
//import 'package:google_maps/google_offices.dart';
//import 'package:google_maps/malls_cluster.dart';

void main() {
  runApp(const GoogleMapApp());
}

class GoogleMapApp extends StatelessWidget {
  const GoogleMapApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Map Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
          CurrentLocationMap(), 
          //GoogleOffices(), 
          //MallsCluster(),
    );
  }
}