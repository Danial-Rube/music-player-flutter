import 'package:flutter/material.dart';
import 'package:test_app/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // برای پیگیری تب فعال
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //رنگ پس زمینه
      backgroundColor: Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: [
            // نوار جستجو
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                // تنظیمات ظاهری نوار جستجو
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A), //رنگ داخل نوار
                  borderRadius: BorderRadius.circular(22),
                ),
                // استفاده از Row برای قرار دادن آیکون و TextField کنار هم
                child: Row(
                  children: [
                    // آیکون جستجو
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF004B95),
                        ),
                        onPressed: () {
                          debugPrint('searched for: ${_searchController.text}');
                        },
                        // اندازه آیکون
                        iconSize: 24,
                      ),
                    ),

                    // فیلد متن جستجو
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        cursorColor: Color(0xFF004B95),
                        style: const TextStyle(
                          color: Colors.white,
                        ), //رنگ متن جستجو
                        textAlignVertical:
                            TextAlignVertical.center, // تنظیم عمودی متن در مرکز

                        decoration: InputDecoration(
                          hintText: 'Search Songs..',
                          hintStyle: TextStyle(
                            color: Color(0xFF4F4F4F),
                            fontFamily: 'Opensans',
                            fontWeight: FontWeight.w200,
                          ),
                          border: InputBorder.none, //تنظیم حاشیه نوار
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            //   تنظیم عمودی متن
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // محتوای اصلی صفحه
            Expanded(
              child: Center(
                child: Text(
                  'محتوای صفحه اصلی اینجا قرار می‌گیرد',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),

      // نوار ناوبری پایین صفحه با تغییرات
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

        child: SizedBox(
          height: 80, // ارتفاع نوار ناوبری

          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Theme(
              data: Theme.of(context).copyWith(
                // حذف انیمیشن‌های کلیک
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),

              child: BottomNavigationBar(
                //رنگ امیزی ایکون ها
                backgroundColor: Color(0xFF1A1A1A),
                selectedItemColor: Color(0xFF004B95),
                unselectedItemColor: Color(0xFF4F4F4F),

                currentIndex: 0,
                onTap: (index) {
                  // برررسی صفحه
                  if (index != _currentIndex) {
                    setState(() {
                      _currentIndex = index;
                    });

                    // انتقال به صفحه مربوطه
                    switch (index) {
                      case 0:
                        // انتقال به صفحه خانه
                        debugPrint('go home');
                        break;
                      case 1:
                        // انتقال به صفحه فروشگاه
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );

                        debugPrint('go shop');
                        break;
                    }
                  }
                  // اگر ایندکس یکسان باشد، هیچ کاری انجام نمی‌شود
                },
                // حذف سایه
                elevation: 0,
                // جلوگیری از انیمیشن shift
                type: BottomNavigationBarType.fixed,

                // تنظیم اندازه آیکون‌ها و فاصله از متن
                selectedIconTheme: IconThemeData(size: 28),
                unselectedIconTheme: IconThemeData(size: 26),
                selectedLabelStyle: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Opensans',
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Opensans',
                ),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_basket),
                    label: 'Shop',
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
