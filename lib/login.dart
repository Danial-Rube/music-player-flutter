import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/login_singup.dart';
import 'package:test_app/navigation.dart';
import 'package:test_app/verifytool.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repassController = TextEditingController();
  bool _obscureText = true;
  final int _currentIndex = 1;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //back ground settings
      backgroundColor: const Color(0xFF000000), // رنگ بکگراند
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                //فیلد ایمیل
                SizedBox(
                  width: 300,
                  child: TextField(
                    cursorColor: Color(0xFF004B95),
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
                        color: Color(0xFF4F4F4F),
                      ),
                      hintStyle: TextStyle(color: Color(0xFF4F4F4F)),
                      filled: true,
                      fillColor: Color(0xFF282828),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // فیلد نام
                SizedBox(
                  width: 300,
                  child: TextField(
                    cursorColor: Color(0xFF004B95),
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@._-]'),
                      ),
                    ],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xFF4F4F4F),
                      ),
                      hintStyle: TextStyle(color: Color(0xFF4F4F4F)),
                      filled: true,
                      fillColor: Color(0xFF282828),
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
                    cursorColor: Color(0xFF004B95),
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
                      fillColor: Color(0xFF282828),
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

                SizedBox(height: 15.0),

                //فیلد کنترل دوباره پسورد
                SizedBox(
                  width: 300,
                  child: TextField(
                    cursorColor: Color(0xFF004B95),
                    controller: _repassController,

                    obscureText: _obscureText,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      /*prefixIcon: const Icon(
                        Icons.key,
                        color: Color(0xFF4F4F4F),
                      ),*/
                      hintStyle: TextStyle(color: Color(0xFF4F4F4F)),
                      filled: true,
                      fillColor: Color(0xFF282828),
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

                //sing in dutton
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
                    // اکشن دکمه ی ثبت نام
                    onPressed: () {
                      debugPrint('email ${_emailController.text}');
                      debugPrint('name : ${_nameController.text}');
                      debugPrint(' password : ${_passwordController.text}');
                      debugPrint(' password : ${_repassController.text}');

                      bool vrifyed = ValidationHelper.verify(
                        context,
                        _emailController.text,
                        _nameController.text,
                        _passwordController.text,
                        _repassController.text,
                      );

                      if (vrifyed) {
                        debugPrint("verifyed");
                      } else {
                        debugPrint("not verifyed!");
                      }
                    },

                    child: const Text(
                      'Sing-up',
                      style: TextStyle(
                        fontFamily: 'Opensans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 169, 169, 169),
                      ),
                    ),
                  ),
                ),

                //متن زیر دکمه ی ثبت نام
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'already have acount?',
                      style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontFamily: 'Opensans',
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingupPage(),
                          ), // انتقال به صفحه لاگین
                        );
                      },
                      child: const Text(
                        'log-in',
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
