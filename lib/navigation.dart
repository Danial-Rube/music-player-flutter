import 'package:flutter/material.dart';
import 'package:test_app/category.dart';
import 'package:test_app/home.dart';
import 'package:test_app/login.dart';

Widget navigationControler(BuildContext context, int currentIndex) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: SizedBox(
      height: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: Color(0xFF1A1A1A),
            selectedItemColor: Color(0xFF004B95),
            unselectedItemColor: Color(0xFF4F4F4F),
            currentIndex: currentIndex,
            onTap: (index) {
              if (index != currentIndex) {
                switch (index) {
                  case 0:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    break;
                  case 1:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CategoriesPage()),
                    );
                    break;
                }
              }
            },
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(size: 28),
            unselectedIconTheme: IconThemeData(size: 26),
            selectedLabelStyle: TextStyle(fontSize: 13, fontFamily: 'Opensans'),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              fontFamily: 'Opensans',
            ),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket),
                label: 'Shop',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
