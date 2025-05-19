import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Categories',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      ),
      debugShowCheckedModeBanner: false, // حذف نشان DEBUG
      initialRoute: '/',
      routes: {
        '/': (context) => const CategoriesPage(),
        '/details': (context) => const CategoryDetailsPage(),
      },
    );
  }
}

class CategoriesPage extends StatelessWidget {
  final List<Category> categories = const [
    Category(name: 'RAP', imagePath: 'assets/Untitled-2.png'),
    Category(name: 'ROCK', imagePath: 'assets/rock.png'),
    Category(name: 'POP', imagePath: 'assets/pop.png'),
    Category(name: 'CLASSIC', imagePath: 'assets/clasic.png'),
  ];

  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F0F0F),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF0F0F0F),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: categories[index],
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      categories[index].imagePath,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        color: Colors.grey[800],
                        child: const Icon(Icons.broken_image, color: Colors.white),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryDetailsPage extends StatelessWidget {
  const CategoryDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Category category = ModalRoute.of(context)!.settings.arguments as Category;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F0F0F),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: Container(
          color: const Color(0xFF0F0F0F),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    category.imagePath,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 300,
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, size: 50, color: Colors.white),
                    ),
                  ),
                  Container(
                    color: const Color(0xFF0F0F0F),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Category {
  final String name;
  final String imagePath;

  const Category({required this.name, required this.imagePath});
}