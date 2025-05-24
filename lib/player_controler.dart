//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_app/song.dart';

//لیست آهنگ دانلودی
List<Song> downloadSongs = [
  Song(
    id: "_downloaddkfj",
    title: "Anathema",
    artist: "Vincent Cavanagh",
    coverPath: "assets/downloaded_songs/c1.jpg",
    filePath: "assets/downloaded_songs/fragile_dreams.mp3",
  ),
  Song(
    id: "_downloaddkjfk",
    title: "All of Me",
    artist: "Jason",
    coverPath: "assets/downloaded_songs/c2.jpg",
    filePath: "assets/downloaded_songs/all-of-me-john-legend.mp3",
  ),
  Song(
    id: "_downloadddfoofk",
    title: "Kaleo",
    artist: "The Weeknd",
    coverPath: "assets/downloaded_songs/c3.jpg",
    filePath: "assets/downloaded_songs/KALEO.mp3",
  ),
  Song(
    id: "_downloaddddddaofk",
    title: "Arayeshe Ghaliz",
    artist: "Homayoun Shajarian",
    coverPath: "assets/downloaded_songs/c4.jpg",
    filePath: "assets/downloaded_songs/Arayeshe_Ghaliz.mp3",
  ),
];

// لیست‌های گلوبال برای آهنگ‌ها
List<Song> localSongs = [];

//متغیر سراری برای اعمال ui
final ValueNotifier<String?> activeCardId = ValueNotifier(null);

class MusicPlayerManager {
  // الگوی سینگلتون
  static final MusicPlayerManager instance = MusicPlayerManager._internal();
  factory MusicPlayerManager() => instance;
  MusicPlayerManager._internal();

  // پلیر صوتی
  final AudioPlayer _audioPlayer = AudioPlayer();

  // متغیرهای مدیریت وضعیت
  Song? _currentSong;

  // گترها برای دسترسی به وضعیت فعلی
  Song? get currentSong => _currentSong;
  bool get isPlaying => _audioPlayer.playing;
  AudioPlayer get audioPlayer => _audioPlayer;

  bool isPlayingthis(Song song) {
    return _currentSong?.id == song.id && isPlaying;
  }

  // متد برای درخواست مجوز دسترسی به فایل‌های صوتی
  static Future<bool> _requestPermission() async {
    return await Permission.storage.request().isGranted;
  }

  // متد برای جستجوی آهنگ‌های داخل گوشی
  static Future<List<Song>> loadDeviceMusic() async {
    try {
      // درخواست مجوز
      bool hasPermission = await _requestPermission();
      if (!hasPermission) {
        return [];
      }

      final audioQuery = OnAudioQuery();

      // دریافت لیست آهنگ‌ها از گوشی
      final List<SongModel> deviceSongs = await audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      for (var song in deviceSongs) {
        final Uint8List? artwork = await audioQuery.queryArtwork(
          song.id,
          ArtworkType.AUDIO,
        );

        localSongs.add(
          Song(
            id: "#local${song.id.toString()}",
            title: song.title,
            artist: song.artist ?? 'Unknown Artist',
            filePath: song.uri ?? '',
            duration: Duration(milliseconds: song.duration ?? 0),
            coverPath: 'assets/images/see.jpg',
            artwork: artwork,
          ),
        );
      }

      return localSongs;
    } catch (e) {
      debugPrint('Error loading device music: $e');
      return [];
    }
  }

  // متد برای پخش یا توقف آهنگ
  Future<void> playOrPauseMusic(Song song) async {
    try {
      if (_currentSong == null || _currentSong?.id != song.id) {
        // آهنگ جدید یا متفاوت
        debugPrint('TRY TO SET NEW SONG');
        _currentSong = song;
        await _audioPlayer.stop();

        if (song.filePath.startsWith('assets/downloaded_songs/')) {
          // بررسی لوکال یا سمت سرور بودن آهنگ
          await _audioPlayer.setAsset(song.filePath);
        } else {
          // اگر فایل در حافظه دستگاه است
          await _audioPlayer.setAudioSource(
            AudioSource.uri(Uri.parse(song.filePath)),
          );
        }

        await _audioPlayer.play();
      } else {
        // همان آهنگ در حال پخش است - توقف/ادامه
        if (_audioPlayer.playing) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.play();
        }
      }
    } catch (e) {
      debugPrint('Error in playOrPauseMusic: $e');
    }
  }

  Future<void> stopPlaying() async {
    try {
      if (_currentSong != null && _audioPlayer.playing) {
        await _audioPlayer.stop();
      }
    } catch (e) {
      debugPrint('Errore in Stoping Song: $e');
    }
  }

  // متد برای پخش آهنگ بعدی
  Future<void> playNextSong() async {
    if (_currentSong == null || localSongs.isEmpty) {
      return;
    }

    int currentIndex = localSongs.indexWhere((s) => s.id == _currentSong!.id);
    if (currentIndex == -1) return;

    int nextIndex = (currentIndex + 1) % localSongs.length;
    await playOrPauseMusic(localSongs[nextIndex]);
  }

  // متد برای پخش آهنگ قبلی
  Future<void> playPreviousSong() async {
    if (_currentSong == null || localSongs.isEmpty) {
      return;
    }

    int currentIndex = localSongs.indexWhere((s) => s.id == _currentSong!.id);
    if (currentIndex == -1) return;

    currentIndex = (currentIndex - 1 + localSongs.length) % localSongs.length;
    _currentSong = localSongs[currentIndex];
    await playOrPauseMusic(_currentSong!);
  }

  // متد برای جلو یا عقب بردن آهنگ
  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // استریم‌های مورد نیاز برای UI
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Duration get position => _audioPlayer.position;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;
}
