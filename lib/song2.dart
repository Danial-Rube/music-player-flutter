class Song {
  final int id;
  final String title;
  final String artist;
  final String coverPath;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverPath,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Song &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
