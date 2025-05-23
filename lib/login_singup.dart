import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/login.dart';
import 'package:test_app/navigation.dart';

//صفحه ی ورود
class SingupPage extends StatefulWidget {
  const SingupPage({super.key});

  @override
  State<SingupPage> createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final int _currentIndex = 1;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // رنگ بکگراند
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                //ایمیل فیلد
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@._-]'),
                      ),
                    ],

                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'E-mail',

                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xFF4F4F4F), //رنگ ایکون
                      ),

                      hintStyle: TextStyle(
                        color: Color(0xFF4F4F4F),
                      ), //رنگ متن راهنما

                      filled: true,
                      fillColor: Color(0xFF1A1A1A), // رنگ داخل فیلد
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),

                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // فیلد رمز عبور
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _passwordController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@._-]'),
                      ),
                    ],
                    obscureText: _obscureText,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.key,
                        color: Color(0xFF4F4F4F),
                      ),
                      hintStyle: TextStyle(color: Color(0xFF4F4F4F)),
                      filled: true,
                      fillColor: Color(0xFF1A1A1A),
                      suffixIcon: IconButton(
                        icon: Icon(
                          color: Color(0xFF0069D2),
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),

                //دکمه ی لاگین
                const SizedBox(height: 30),
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: Colors.blue[700],
                      backgroundColor: Color(0xFF004B95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      debugPrint('email ${_emailController.text}');
                      debugPrint(' password : ${_passwordController.text}');
                    },
                    child: const Text(
                      'Log-in',
                      style: TextStyle(
                        fontFamily: 'Opensans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 169, 169, 169),
                      ),
                    ),
                  ),
                ),

                //متن زیر دکمه ی لاگین
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Creat Acount',
                      style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontFamily: 'Opensans',
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        //Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                        //انتقال به صفحه ثبت نام
                      },
                      child: const Text(
                        'sing-up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Opensans',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: navigationControler(context, _currentIndex),
    );
  }
}
