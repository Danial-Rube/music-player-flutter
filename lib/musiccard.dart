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
              width: 150.0,
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
