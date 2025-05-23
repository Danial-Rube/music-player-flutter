import 'package:flutter/material.dart';
import 'package:test_app/navigation.dart';
import 'package:test_app/song.dart';

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
            onTap: () {
              //
              debugPrint('Clicked on ${categories[index].name}');

              // مثال: نمایش یک اسنک‌بار
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${categories[index].name} category selected'),
                  duration: const Duration(seconds: 1),
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
