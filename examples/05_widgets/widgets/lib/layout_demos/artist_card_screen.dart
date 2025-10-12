import 'package:flutter/material.dart';
import '../models/artist.dart';

final alfred = Artist(
  firstName: "Alfred",
  lastName: "Sisley",
  country: "France",
  birthYear: 1839,
  deathYear: 1899,
  artWorksCount: 471,
  photoPath: 'assets/images/img_alfred_sisley.png',
  paintingPath: 'assets/images/img_alfred_sisley_painting.png',
);

class ArtistCardScreen extends StatelessWidget {
  const ArtistCardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artist Card'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ArtistCard(artist: alfred),
      ),
    );
  }
}

class ArtistCard extends StatelessWidget {
  final Artist artist;

  const ArtistCard({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stack Demo: Photo with favorite icon overlay
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(artist.photoPath),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(Icons.favorite, color: Colors.red, size: 20),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${artist.firstName} ${artist.lastName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text('${artist.birthYear} - ${artist.deathYear}'),
                    Text('${artist.artWorksCount} artworks'),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Simple painting display
        Expanded(child: Image.asset(artist.paintingPath, fit: BoxFit.contain)),
      ],
    );
  }
}
