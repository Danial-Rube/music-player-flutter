//صفحه ی لیست خرید
import 'package:flutter/material.dart';
import 'package:test_app/player_controler.dart';
import 'package:test_app/song.dart';

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

  double _sumPrices() {
    double sum = 0;
    for (Song s in _currentCartItems) {
      sum += s.price;
    }
    return sum;
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
            //اسم آهنگ
            title: Text(
              song.title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Opensans',
              ),
            ),
            //اسم آرتیست
            subtitle: Text(
              song.artist,
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Opensans',
              ),
            ),

            trailing: SizedBox(
              width: 120,
              child: Row(
                mainAxisSize: MainAxisSize.min,

                //قیمت اهنگ
                children: [
                  Expanded(
                    child: Text(
                      "\$${song.price}",
                      style: TextStyle(
                        color: Colors.green[400],
                        fontFamily: 'Opensans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  //ایکون حذف
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: () => _removeFromCart(song),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      //دکمه ی پرداخت
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF242424),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          //اکشن پرداخت
          onPressed: () {
            if (_currentCartItems.isEmpty) {
              //بررسی خالی بودن سبد خرید
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Your cart is empty!',
                    style: TextStyle(
                      color: Colors.red[300],
                      fontFamily: 'Opensans',
                    ),
                  ),
                  backgroundColor: Color(0xFF1A1A1A),
                ),
              );
              return;
            }
            //اضافه کردن اهنگ ها به پلی لیست دانلودی
            for (var song in _currentCartItems) {
              if (!downloadSongs.any((item) => item.id == song.id)) {
                downloadSongs.add(song);
              }
            }
            //خالی کردن لیست
            setState(() {
              _currentCartItems.clear();
            });
            widget.onCartUpdated(_currentCartItems);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Music added to your downloads.',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontFamily: 'Opensans',
                  ),
                ),
                backgroundColor: Color(0xFF1A1A1A),
              ),
            );
            //برگشت به صفحه ی قبل
            Navigator.of(context).pop();
          },

          child: Text(
            'Pay \$${_sumPrices()}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Opensans',
              color: Colors.green[400],
            ),
          ),
        ),
      ),
    );
  }
}
