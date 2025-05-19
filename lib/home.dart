import 'package:flutter/material.dart';
import 'package:test_app/musiccard.dart';
import 'package:test_app/navigation.dart';
import 'package:test_app/song.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0; // برای پیگیری تب فعال
  final TextEditingController _searchController = TextEditingController();

  final List<Song> songs = [
    Song(
      id: "sds",
      title: "Pink Floyd",
      artist: "Ross",
      coverPath: "assets/images/pink.jpg",
      filePath: "sdss",
    ),
    Song(
      id: "sdsd",
      title: "Save Your Tears",
      artist: "The Weeknd",
      coverPath: "assets/images/drug.jpg",
      filePath: "sdsd",
    ),
    Song(
      id: "sssd",
      title: "Starboy",
      artist: "The Weeknd",
      coverPath: "assets/images/rock.jpg",
      filePath: "Ssdsd",
    ),
    Song(
      id: "sds",
      title: "Shape of You",
      artist: "Ed Sheeran",
      coverPath: "assets/images/see.jpg",
      filePath: "dssds",
    ),
    Song(
      id: "ksdjs",
      title: "Bad Guy",
      artist: "Billie Eilish",
      coverPath: "assets/images/pink.jpg",
      filePath: "sdssd",
    ),
    Song(
      id: "dksd",
      title: "Stay",
      artist: "Justin Bieber",
      coverPath: "assets/images/see.jpg",
      filePath: "sdssdds",
    ),
  ];

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
              // نوار جستجو
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 1.0,
                ),

                child: Container(
                  // تنظیمات ظاهری نوار جستجو
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF1A1A1A), //رنگ داخل نوار
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: _searchController,
                    cursorColor: Color(0xFF004B95),
                    style: const TextStyle(color: Colors.white), //رنگ متن جستجو
                    textAlignVertical:
                        TextAlignVertical.center, // تنظیم عمودی متن در مرکز
                    onChanged: (value) {
                      // به‌روزرسانی UI برای نمایش یا مخفی کردن دکمه ضربدر
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      // آیکون جستجو در سمت چپ
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: IconButton(
                          onPressed: () {
                            List<Song> searchedSong = [];
                            for (Song s in songs) {
                              if (s.title.contains(_searchController.text)) {
                                searchedSong.add(s);
                              }
                            }

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
                          icon: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF004B95),
                            size: 25,
                          ),
                        ),
                      ),
                      // آیکون ضربدر در سمت راست - فقط زمانی که متنی وجود دارد
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Color(0xFF004B95),
                                  size: 20,
                                ),
                                onPressed: () {
                                  // پاک کردن متن
                                  _searchController.clear();
                                  // به‌روزرسانی UI
                                  setState(() {});
                                },
                              )
                              : null,

                      hintText: 'Search Songs..',
                      hintStyle: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontFamily: 'Opensans',
                        fontWeight: FontWeight.w200,
                      ),

                      border: InputBorder.none,
                      //تنظیم حاشیه نوار
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 0,
                      ),
                    ),
                  ),
                ),
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
                                songs: songs,
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

              // لیست اهنگ های محلی
              SizedBox(
                height: 250, // ارتفاع کل لیست
                child: musicList(songs),
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
                                songs: songs,
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
                child: musicList(songs),
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
