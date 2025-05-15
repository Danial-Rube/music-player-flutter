import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF94E795),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/basket.png', height: 200, width: 200),

            SizedBox(height: 20),

            Text(
              'Welcome to\nGrocery shopping',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Opensans',
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),

            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {},

                child: Text(
                  'SING IN',
                  style: TextStyle(color: Color(0xFF94E795)),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('SING UP', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
