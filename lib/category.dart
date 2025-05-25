import 'package:flutter/material.dart';
import 'package:test_app/navigation.dart';
import 'package:test_app/profile.dart';
import 'package:test_app/shop.dart';
import 'package:test_app/song.dart';

List<Song> shopsongs = [
  Song(
    id: "_downloadlololvyyy",
    title: "ZarreBin",
    artist: "Mohsen Cavooshi",
    coverPath: "assets/downloaded_songs/c5.jpg",
    filePath: "assets/downloaded_songs/ZarreBin.mp3",
    price: 99.9,
    downloadCount: 13,
    stars: 4.5,
  ),
  Song(
    id: "_downloadzx002lkmk",
    title: "Something on the way",
    artist: "Nirvana",
    coverPath: "assets/downloaded_songs/c6.jpg",
    filePath: "assets/downloaded_songs/nirvana.mp3",
    price: 7.99,
    downloadCount: 5,
    stars: 1.2,
  ),
  Song(
    id: "_downloaduqwe8",
    title: "Kiss Me",
    artist: "Rob Vischer",
    coverPath: "assets/downloaded_songs/c7.jpg",
    filePath: "assets/downloaded_songs/kiss_me.mp3",
    price: 22.3,
    downloadCount: 22,
    stars: 1.0,
  ),
  Song(
    id: "_downloadhhgghh",
    title: "Assema Abi",
    artist: "Viguen",
    coverPath: "assets/downloaded_songs/c8.jpg",
    filePath: "assets/downloaded_songs/Asemane_Abi.mp3",
    downloadCount: 19,
  ),
  Song(
    id: "_downloadzx11zx",
    title: "One last goodbye",
    artist: "Vincent Cavanagh",
    coverPath: "assets/downloaded_songs/c9.jpg",
    filePath: "assets/downloaded_songs/One_Last_Goodbye.mp3",
    price: 9.1,
  ),
  Song(
    id: "_downloadzxd9sdk",
    title: "I Fead The End",
    artist: "Swarm of the Sun",
    coverPath: "assets/downloaded_songs/c10.jpg",
    filePath: "assets/downloaded_songs/Fear_End.mp3",
    price: 17.7,
    downloadCount: 2,
    stars: 3.8,
  ),
];

class CategoriesPage extends StatelessWidget {
  final int _currentIndex = 1; // برای پیگیری تب فعال
  const CategoriesPage({super.key});

  static const List<Category> categories = [
    Category(name: 'RAP', imagePath: 'assets/images/rap.png'),
    Category(name: 'ROCK', imagePath: 'assets/images/rock.png'),
    Category(name: 'POP', imagePath: 'assets/images/pop.png'),
    Category(name: 'CLASSIC', imagePath: 'assets/images/clasic.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Color(0xFFD7D7D7),
            fontFamily: 'Opensans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        centerTitle: true,
        actions: [
          //ایکون پروفایل
          Padding(
            padding: const EdgeInsets.only(
              right: 15.0,
              top: 5.0,
            ), // فاصله از سمت راست
            child: IconButton(
              iconSize: 26,
              icon: const Icon(Icons.account_circle, color: Color(0xFF0064C8)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ),
        ],
      ),

      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: categories.length,
        separatorBuilder:
            (context, index) =>
                const SizedBox(height: 0.0), // تنظیم فاصله بین عکس‌ها
        itemBuilder: (context, index) {
          return GestureDetector(
            //هدایت کاربر به صفحات کتگوری
            onTap: () {
              //
              debugPrint('Clicked on ${categories[index].name}');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MusicShopPage(
                        title: categories[index].name,
                        songs: shopsongs,
                      ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                categories[index].imagePath,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: navigationControler(context, _currentIndex),
    );
  }
}

class Category {
  final String name;
  final String imagePath;
  const Category({required this.name, required this.imagePath});
}
