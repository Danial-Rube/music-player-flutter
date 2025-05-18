// مدل داده ساده برای آهنگ
class Song {
  final String id;
  final String title;
  final String artist;
  final String filePath;
  final Duration? duration;
  final String? genre;
  final String coverPath;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.filePath,
    this.duration,
    this.genre,
    String? coverPath,
  }) : coverPath = coverPath ?? "dsds ";
}
