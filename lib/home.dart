import 'package:flutter/material.dart';
import 'package:test_app/musiccard.dart';
import 'package:test_app/navigation.dart';
import 'package:test_app/song.dart';
import 'package:test_app/player_controler.dart';

const Text _localTitle = Text(
  'Local Songs',
  style: TextStyle(
    color: Color(0xFFD7D7D7),
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'Opensans',
  ),
);

const Text _downloadText = Text(
  'Downloads',
  style: TextStyle(
    color: Color(0xFFD7D7D7),
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'Opensans',
  ),
);

const Text _likedTitle = Text(
  'Liked',
  style: TextStyle(
    color: Color(0xFFD7D7D7),
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'Opensans',
  ),
);

bool _isLoading = true;
bool _isLodingLikedSongs = true;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0; // برای پیگیری تب فعال
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // فراخوانی متد بارگذاری آهنگ‌ها در زمان شروع
    if (_isLoading) {
      _loadDeviceSongs();
    }
    if (_isLodingLikedSongs) {
      _initLikedSongs();
    }
  }

  // متد جدید برای بارگذاری آهنگ‌های گوشی
  Future<void> _loadDeviceSongs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // استفاده از MusicPlayerManager برای بارگذاری آهنگ‌ها
      await MusicPlayerManager.loadDeviceMusic();

      setState(() {
        _isLoading = false;
      });

      // نمایش تعداد آهنگ‌های یافت شده در کنسول
      debugPrint('Found ${localSongs.length} songs on device');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading songs: $e');
    }
  }

  //بارگذاری آهنگ های لایک شده
  Future<void> _initLikedSongs() async {
    try {
      await MusicPlayerManager.instance.loadLikedSongs();
      setState(() {
        _isLodingLikedSongs = false;
      });
    } catch (e) {
      setState(() {
        _isLodingLikedSongs = false;
        debugPrint("Errore lodaing liked songs: $e");
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //رنگ پس زمینه
      backgroundColor: Color(0xFF0F0F0F),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchBar(
                controller: _searchController,
                onSearch: (sdfsdf) {
                  List<Song> searchedSong = [];
                  for (Song s in localSongs) {
                    if (s.title.toLowerCase().contains(
                      _searchController.text.toLowerCase().trim(),
                    )) {
                      searchedSong.add(s);
                    }
                  }
                  for (Song s in downloadSongs) {
                    if (s.title.toLowerCase().contains(
                      _searchController.text.toLowerCase().trim(),
                    )) {
                      searchedSong.add(s);
                    }
                  }
                  // مولد صفحه‌ی سرچ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MusicPageList(
                            title: _searchController.text,
                            songs: searchedSong,
                          ),
                    ),
                  );
                },
              ),

              // محتوای اصلی صفحه
              Align(
                alignment: Alignment.centerLeft,

                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 5.0, bottom: 0),

                  child: TextButton(
                    onPressed: () {
                      //  عملیات کلیک روی عنوان لوکال
                      debugPrint('Local Songs button pressed');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MusicPageList(
                                title: 'Local Songs',
                                //بررسی خالی یا پر بودن لیست اهنگ های دریافت شده از گوشی
                                songs:
                                    localSongs.isEmpty
                                        ? downloadSongs
                                        : localSongs,
                              ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      alignment: Alignment.centerLeft,
                    ),
                    child: _localTitle,
                  ),
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Loading songs...",
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w200,
                          fontFamily: 'Opensans',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.refresh_rounded, color: Color(0xFF4F4F4F)),
                    ],
                  ),
                ),

              // لیست اهنگ های محلی
              SizedBox(
                height: 250, // ارتفاع کل لیست
                child: musicList(localSongs),
              ),

              //عنوان اهنگ های دانلود شده
              Align(
                alignment: Alignment.centerLeft,

                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    top: 5.0,
                    bottom: 1.0,
                  ),

                  child: TextButton(
                    onPressed: () {
                      // عملیات مورد نظر هنگام کلیک
                      debugPrint('Downlods button pressed');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MusicPageList(
                                title: 'Downlodas',
                                songs: downloadSongs,
                              ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      alignment: Alignment.centerLeft,
                    ),
                    child: _downloadText,
                  ),
                ),
              ),

              //لیست اهنگ های دانلودی
              SizedBox(
                height: 250, // ارتفاع کل لیست
                child: musicList(downloadSongs),
              ),

              //عنوان اهنگ های لایک شده
              if (likedSongs.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,

                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      top: 5.0,
                      bottom: 1.0,
                    ),

                    child: TextButton(
                      onPressed: () {
                        // عملیات مورد نظر هنگام کلیک
                        debugPrint('Downlods button pressed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MusicPageList(
                                  title: 'Liked',
                                  songs: likedSongs,
                                ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        alignment: Alignment.centerLeft,
                      ),
                      child: _likedTitle,
                    ),
                  ),
                ),

              //لیست اهنگ های دانلودی
              if (likedSongs.isNotEmpty)
                SizedBox(
                  height: 250, // ارتفاع کل لیست
                  child: musicList(likedSongs),
                ),
            ],
          ),
        ),
      ),

      // نوار ناوبری پایین صفحه با تغییرات
      bottomNavigationBar: navigationControler(context, _currentIndex),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onSearch; // تابع جستجو که به عنوان ورودی دریافت می‌شود

  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText = 'Search Songs..',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 5),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(22),
        ),
        child: TextField(
          controller: controller,
          cursorColor: Color(0xFF004B95),
          style: const TextStyle(color: Colors.white),
          textAlignVertical: TextAlignVertical.center,
          onChanged: (value) {
            // به‌روزرسانی UI برای نمایش یا مخفی کردن دکمه ضربدر
            (context as Element).markNeedsBuild();
          },
          decoration: InputDecoration(
            // آیکون جستجو در سمت چپ
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: IconButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    onSearch(controller.text);
                  }
                },
                icon: Icon(
                  Icons.search_rounded,
                  color: Color(0xFF004B95),
                  size: 25,
                ),
              ),
            ),
            // آیکون ضربدر در سمت راست - فقط زمانی که متنی وجود دارد
            suffixIcon:
                controller.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Color(0xFF004B95),
                        size: 20,
                      ),
                      onPressed: () {
                        // پاک کردن متن
                        controller.clear();
                        // به‌روزرسانی UI
                        (context as Element).markNeedsBuild();
                      },
                    )
                    : null,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Color(0xFF4F4F4F),
              fontFamily: 'Opensans',
              fontWeight: FontWeight.w200,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 0,
            ),
          ),
        ),
      ),
    );
  }
}
