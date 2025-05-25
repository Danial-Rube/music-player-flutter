import 'package:flutter/foundation.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  final String filePath;
  final Duration? duration;
  final String? genre;
  final String coverPath;
  final Uint8List? artwork;
  final double price;
  double stars;
  int downloadCount;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.filePath,
    this.duration,
    this.genre = 'Unknown',
    this.artwork,
    this.price = 1.99,
    this.stars = 1.0,
    this.downloadCount = 17,
    String? coverPath,
  }) : coverPath = coverPath ?? "assets/images/pink.jpg ";
}
