import 'package:flutter/material.dart';
import 'package:test_app/song.dart';

class MusicShopPage extends StatefulWidget {
  final String title;
  final List<Song> songs;
  const MusicShopPage({super.key, required this.title, required this.songs});

  @override
  State<MusicShopPage> createState() => _MusicShopPageState();
}

class _MusicShopPageState extends State<MusicShopPage> {
  final List<Song> cartItems = [];

  //تابع بررسی و اضافه کردن کارت به لیست خرید
  void addToCart(Song song) {
    if (!cartItems.any((item) => item.id == song.id)) {
      setState(() => cartItems.add(song));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF1A1A1A),
          content: Text(
            '"${song.title}" added to cart',
            style: TextStyle(color: Colors.green[300]),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF1A1A1A),
          content: Text(
            '"${song.title}" is already in the cart!',
            style: TextStyle(color: Colors.blue[200]),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void goToCheckoutPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => CheckoutPage(
              cartItems: List.from(cartItems),
              onCartUpdated: (updatedList) {
                setState(() {
                  cartItems.clear();
                  cartItems.addAll(updatedList);
                });
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), //رنگ پس زمیه

      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,

        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Opensans',
            fontWeight: FontWeight.bold,
          ),
        ),

        //ایکون بازگشت
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left_rounded, color: Colors.white70),
          onPressed: () {
            Navigator.pop(context);
          },
          //check here!!!!!!!!!!!!!!!!!!!!!!
        ),

        actions: [
          //ایکون پروفایل
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // فاصله از سمت راست
            child: IconButton(
              iconSize: 28,
              icon: const Icon(Icons.account_circle, color: Color(0xFF0064C8)),
              onPressed: () {},
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                //آیکون لیست خرید
                IconButton(
                  iconSize: 28,
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Color(0xFF0064C8),
                  ),
                  onPressed: goToCheckoutPage,
                ),

                if (cartItems.isNotEmpty)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1DB954),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cartItems.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      //بدنه ی اصلی صفحه
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            itemCount: (widget.songs.length + 1) ~/ 2, // تعداد ردیف‌ها
            itemBuilder: (context, rowIndex) {
              // ساخت یک ردیف با یک یا دو کارت
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    // کارت اول در ردیف
                    Expanded(
                      child: ShopCard(
                        song: widget.songs[rowIndex * 2],
                        onAddToCart: addToCart,
                      ),
                    ),

                    // کارت دوم در ردیف (اگر وجود داشته باشد)
                    if (rowIndex * 2 + 1 < widget.songs.length)
                      Expanded(
                        child: ShopCard(
                          song: widget.songs[rowIndex * 2 + 1],
                          onAddToCart: addToCart,
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

//صفحه ی لیست خرید
class CheckoutPage extends StatefulWidget {
  final List<Song> cartItems;
  final Function(List<Song>) onCartUpdated;
  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.onCartUpdated,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late List<Song> _currentCartItems;

  @override
  void initState() {
    super.initState();
    _currentCartItems = List.from(widget.cartItems);
  }

  void _removeFromCart(Song song) {
    setState(() {
      _currentCartItems.removeWhere((item) => item.id == song.id);
    });
    widget.onCartUpdated(_currentCartItems);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${song.title} removed from cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //بک گراند رنگ
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        toolbarHeight: 70.0,
        title: const Text(
          "Checkout",
          style: TextStyle(
            fontFamily: 'Opensans',
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 20,
          ),
        ),

        backgroundColor: const Color(0xFF1A1A1A),

        //دکمه ی بازگشت
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.keyboard_arrow_left_rounded, color: Colors.white70),
        ),
      ),

      body: ListView.builder(
        itemCount: _currentCartItems.length,
        itemBuilder: (context, index) {
          final song = _currentCartItems[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                song.coverPath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white54,
                      ),
                    ),
              ),
            ),

            title: Text(
              song.title,
              style: const TextStyle(color: Colors.white),
            ),

            subtitle: Text(
              song.artist,
              style: const TextStyle(color: Colors.grey),
            ),

            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => _removeFromCart(song),
            ),
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF369D2C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),

            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          //اکشن پرداخت
          onPressed: () {},
          child: const Text(
            'Pay Now',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Opensans',
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

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

class ShopCard extends StatefulWidget {
  final Song song;
  final Function(Song) onAddToCart;

  const ShopCard({super.key, required this.song, required this.onAddToCart});

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  bool isPlaying = false;

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
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              // باز کردن صفحه جزئیات آهنگ
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child:
                  widget.song.artwork != null
                      ? Image.memory(
                        widget.song.artwork!,
                        width: double.infinity,
                        height: 170,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        widget.song.coverPath,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
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
                            widget.song.title,
                            style: _titleStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2), // فاصله بین دو متن
                          // نام خواننده
                          Text(
                            widget.song.artist,
                            style: _artistStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // دکمه خرید در سمت راست
                  IconButton(
                    onPressed: () {
                      widget.onAddToCart(widget.song);
                    },

                    iconSize: 32.0,

                    icon: Icon(
                      Icons.add_circle_rounded,
                      color: Color(0xFF53C148),
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
