import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_app/player_controler.dart';
import 'package:test_app/song.dart';

const TextStyle _titleStyle = TextStyle(
  color: Color(0xFFDADADA),
  fontSize: 12,
  fontWeight: FontWeight.w900,
  fontFamily: 'Opensans',
);

const TextStyle _artistStyle = TextStyle(
  color: Color(0xFF9E9E9E),
  fontSize: 10,
  fontWeight: FontWeight.w400,
  fontFamily: 'Opensans',
);

//کلاس اصلی موزیک کارت
//کلاس اصلی موزیک کارت
class MusicCard extends StatefulWidget {
  final Song song;

  const MusicCard({super.key, required this.song});

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      //تنظیمات مربوط به کانتیرنر
      width: 150.0,
      height: 230,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [
          // بخش تصویر کاور
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              // باز کردن صفحه پخش آهنگ
              debugPrint("Music selected: ${widget.song.title}");
              if (!isPlaying) {
                setState(() {
                  isPlaying = true;
                });
              }

              MusicPlayerManager.instance.stopPlaying();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayPage(song: widget.song),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child:
                  widget.song.artwork != null
                      ? Image.memory(
                        widget.song.artwork!,
                        width: double.infinity,
                        height: 170,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        widget.song.coverPath,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
            ),
          ),

          // بخش پایین کارت با متن و دکمه
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  // ستون متن‌ها (تایتل و نام خواننده) در سمت چپ
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          // عنوان آهنگ
                          Text(
                            widget.song.title,
                            style: _titleStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2), // فاصله بین دو متن
                          // نام خواننده
                          Text(
                            widget.song.artist,
                            style: _artistStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // دکمه پخش در سمت راست
                  IconButton(
                    onPressed: () {
                      debugPrint("music path: ${widget.song.filePath}");
                      MusicPlayerManager.instance.playOrPauseMusic(widget.song);
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },

                    icon:
                        isPlaying ||
                                MusicPlayerManager.instance.isPlayingthis(
                                  widget.song,
                                )
                            ? const Icon(
                              Icons.pause_circle_filled_rounded,
                              color: Color(0xFFDADADA),
                              size: 32,
                            )
                            : const Icon(
                              Icons.play_circle_fill_rounded,
                              color: Color(0xFFDADADA),
                              size: 32,
                            ),

                    //padding: EdgeInsets.zero,
                    //constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// موزیک لیست مولد افقی
Widget musicList(List<Song> songs) {
  return ListView.builder(
    padding: EdgeInsets.only(top: 0, left: 8.0, right: 8.0, bottom: 0.0),
    scrollDirection: Axis.horizontal, // جهت افقی
    itemCount: songs.length,
    itemBuilder: (context, index) {
      return MusicCard(song: songs[index]);
    },
  );
}

// صفحه ی موزیک لیست
class MusicPageList extends StatefulWidget {
  final String title;
  final List<Song> songs;

  //باید بهش یک عنوان و یک لیست از اهنگ ها پاس داده بشه!
  const MusicPageList({super.key, required this.title, required this.songs});

  @override
  State<MusicPageList> createState() => _MusicPageListState();
}

class _MusicPageListState extends State<MusicPageList> {
  bool isSorted = false;
  late List<Song> displayedSongs;

  @override
  void initState() {
    super.initState();
    // مقداردهی اولیه لیست نمایش داده شده
    displayedSongs = List.from(widget.songs);
  }

  // تابع مرتب سازی
  void _sortSongs() {
    setState(() {
      if (isSorted) {
        // بازگشت به ترتیب اصلی
        displayedSongs = List.from(widget.songs);
      } else {
        // مرتب سازی بر اساس عنوان
        displayedSongs.sort((a, b) => a.title.compareTo(b.title));
      }
      isSorted = !isSorted;
    });
  }

  // تابع انتخاب تصادفی
  void _shuffleSongs() {
    setState(() {
      displayedSongs = List.from(widget.songs);
      displayedSongs.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),

      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,

        title: Text(
          widget.title,
          style: TextStyle(
            color: Color(0xFFD7D7D7),
            fontSize: 15,
            fontFamily: 'Opensans',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.keyboard_arrow_left_rounded, color: Colors.white70),
        ),
        actions: [
          TextButton.icon(
            onPressed: _sortSongs,
            icon: Icon(
              isSorted ? Icons.sort : Icons.sort_by_alpha,
              color: Color(0xFF004B95),
            ),
            label: Text(
              'Sort',
              style: TextStyle(color: Colors.white, fontFamily: 'Opensans'),
            ),
          ),
          TextButton.icon(
            onPressed: _shuffleSongs,
            icon: Icon(Icons.shuffle, color: Color(0xFF004B95)),
            label: Text(
              'Shuffle',
              style: TextStyle(color: Colors.white, fontFamily: 'Opensans'),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      //بدنه ی اصلی صفحه
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              displayedSongs.isEmpty
                  ? notFoundMusicMessage()
                  : ListView.builder(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    itemCount:
                        (displayedSongs.length + 1) ~/ 2, // تعداد ردیف‌ها
                    itemBuilder: (context, rowIndex) {
                      // ساخت یک ردیف با یک یا دو کارت
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            // کارت اول در ردیف
                            Expanded(
                              child: MusicCard(
                                song: displayedSongs[rowIndex * 2],
                              ),
                            ),

                            // کارت دوم در ردیف (اگر وجود داشته باشد)
                            if (rowIndex * 2 + 1 < displayedSongs.length)
                              Expanded(
                                child: MusicCard(
                                  song: displayedSongs[rowIndex * 2 + 1],
                                ),
                              )
                            else
                              Expanded(
                                child: SizedBox(),
                              ), // فضای خالی اگر کارت دوم وجود نداشته باشد
                          ],
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}

Widget notFoundMusicMessage() {
  return Center(
    child: Column(
      children: [
        SizedBox(height: 50),

        Image.asset('assets/images/sademoji.png', width: 200),

        Text(
          "No Songs Found!",
          style: TextStyle(
            color: Color.fromARGB(255, 67, 67, 67),
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Opensans',
          ),
        ),
      ],
    ),
  );
}

//صفحه ی پخش موزیک
class MusicPlayPage extends StatefulWidget {
  Song song;

  MusicPlayPage({super.key, required this.song});

  @override
  State<MusicPlayPage> createState() => _MusicPlayPageState();
}

class _MusicPlayPageState extends State<MusicPlayPage> {
  final MusicPlayerManager _playerManager = MusicPlayerManager.instance;
  bool isPlaying = false;

  // متغیرهای کنترل زمان و پیشرفت
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // برای مدیریت اشتراک‌های Stream
  late StreamSubscription _positionSubscription;
  late StreamSubscription _durationSubscription;
  late StreamSubscription _playerStateSubscription;

  // متغیر برای ذخیره آهنگ فعلی
  late Song _currentSong;

  @override
  void initState() {
    super.initState();
    _currentSong = widget.song;
    _initPlayerAndListeners();
  }

  void _initPlayerAndListeners() {
    // گوش دادن به تغییرات زمان فعلی پخش
    _positionSubscription = _playerManager.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    // گوش دادن به تغییرات زمان کل آهنگ
    _durationSubscription = _playerManager.audioPlayer.durationStream.listen((
      duration,
    ) {
      if (mounted && duration != null) {
        setState(() {
          _duration = duration;
        });
      }
    });

    // گوش دادن به تغییرات وضعیت پخش
    _playerStateSubscription = _playerManager.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
      }
    });

    // شروع به پخش آهنگ
    _playThisSong();
  }

  void _playThisSong() async {
    await _playerManager.playOrPauseMusic(_currentSong);
    setState(() {
      isPlaying = true;
    });
  }

  void _playNextSong() async {
    await _playerManager.playNextSong();
    // آپدیت کردن آهنگ فعلی پس از تغییر
    if (_playerManager.currentSong != null) {
      setState(() {
        _currentSong = _playerManager.currentSong!;
      });
    }
  }

  void _playPreviousSong() async {
    await _playerManager.playPreviousSong();
    // آپدیت کردن آهنگ فعلی پس از تغییر
    if (_playerManager.currentSong != null) {
      setState(() {
        _currentSong = _playerManager.currentSong!;
      });
    }
  }

  // تبدیل مدت زمان به فرمت نمایشی
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    // لغو اشتراک‌های Stream برای جلوگیری از نشت حافظه
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _playerStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // فضای خالی از بالا
                SizedBox(height: 60),

                // کاور آهنگ - مرکزی
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 15,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child:
                        _currentSong.artwork != null
                            ? Image.memory(
                              _currentSong.artwork!,
                              width: double.infinity,
                              height: 170,
                              fit: BoxFit.cover,
                            )
                            : Image.asset(
                              _currentSong.coverPath,
                              height: 170,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                  ),
                ),

                SizedBox(height: 40),

                // نام آهنگ
                Text(
                  _currentSong.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Opensans',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8),

                // نام هنرمند
                Text(
                  _currentSong.artist,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontFamily: 'Opensans',
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 50),

                // نوار پیشرفت بدون کادر
                Container(
                  width: 280,
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
                      activeTrackColor: Color(0xFF004B95),
                      inactiveTrackColor: Colors.grey[800],
                      thumbColor: Colors.white,
                      overlayColor: Color(0xFF004B95).withOpacity(0.3),
                    ),
                    child: Slider(
                      min: 0.0,
                      max:
                          _duration.inSeconds.toDouble() > 0.0
                              ? _duration.inSeconds.toDouble()
                              : 1.0,
                      value: _position.inSeconds.toDouble().clamp(
                        0.0,
                        _duration.inSeconds.toDouble() > 0.0
                            ? _duration.inSeconds.toDouble()
                            : 1.0,
                      ),
                      onChanged: (value) {
                        final newPosition = Duration(seconds: value.toInt());
                        _playerManager.seekTo(newPosition);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 2),

                // نمایش زمان واقعی
                SizedBox(
                  width: 280,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_position), // زمان فعلی واقعی
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontFamily: 'Opensans',
                          ),
                        ),
                        Text(
                          _formatDuration(_duration), // زمان کل واقعی
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontFamily: 'Opensans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // دکمه‌های کنترل پخش
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // دکمه عقب
                      IconButton(
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: _playPreviousSong,
                      ),

                      // دکمه پخش/توقف با وضعیت واقعی
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {
                            _playerManager.playOrPauseMusic(_currentSong);
                          },
                        ),
                      ),

                      // دکمه جلو
                      IconButton(
                        icon: Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: _playNextSong,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
