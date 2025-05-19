import 'package:flutter/material.dart';
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
class MusicCard extends StatefulWidget {
  final String _title;
  final String _artist;
  final String _coverPath;

  MusicCard({super.key, required Song song})
    : _title = song.title,
      _artist = song.artist,
      _coverPath = song.coverPath;

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  bool isPlaying = false;

  void _changePlayStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

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
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.asset(
              widget._coverPath,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
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
                            widget._title,
                            style: _titleStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2), // فاصله بین دو متن
                          // نام خواننده
                          Text(
                            widget._artist,
                            style: _artistStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // دکمه پخش در سمت راست
                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
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
        toolbarHeight: 60,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              displayedSongs.isEmpty
                  ? Center(
                    child: Text(
                      "No Songs Found! 😢",
                      style: TextStyle(
                        color: Color.fromARGB(255, 67, 67, 67),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Opensans',
                      ),
                    ),
                  )
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
