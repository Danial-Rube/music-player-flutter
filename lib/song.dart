// مدل داده ساده برای آهنگ
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

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.filePath,
    this.duration,
    this.genre,
    this.artwork,
    String? coverPath,
  }) : coverPath = coverPath ?? "dsds ";
}
