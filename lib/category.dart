import 'package:flutter/material.dart';
import 'package:test_app/navigation.dart';
import 'package:test_app/shop.dart';
import 'package:test_app/song.dart';

List<Song> shopsongs = [
  Song(
    id: "sds",
    title: "Pink Floyd",
    artist: "Ross",
    coverPath: "assets/images/pink.jpg",
    filePath: "sdss",
    price: 4.5,
  ),
  Song(
    id: "sdsd",
    title: "Save Your Tears",
    artist: "The Weeknd",
    coverPath: "assets/images/drug.jpg",
    filePath: "sdsd",
    price: 7.99,
  ),
  Song(
    id: "sssd",
    title: "Starboy",
    artist: "The Weeknd",
    coverPath: "assets/images/rock.jpg",
    filePath: "Ssdsd",
    price: 22.3,
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
    price: 9.1,
  ),
  Song(
    id: "dksd",
    title: "Stay",
    artist: "Justin Bieber",
    coverPath: "assets/images/see.jpg",
    filePath: "sdssdds",
  ),
];

const Text _localTitle = Text(
  'Local Songs',
  style: TextStyle(
    color: Color(0xFFD7D7D7),
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'Opensans',
  ),
);

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
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Color(0xFFD7D7D7),
            fontFamily: 'Opensans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF0F0F0F),
        centerTitle: true,
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
