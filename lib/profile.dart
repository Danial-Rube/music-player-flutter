import 'dart:io';
import 'package:flutter/material.dart';

class User {
  String name;
  String password;
  String email;
  double balance;
  String subscription;
  String? profileImagePath;

  User({
    required this.name,
    required this.password,
    required this.email,
    this.balance = 10.0,
    this.subscription = 'Regular',
    this.profileImagePath,
  });
}

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: _currentUser.name);
    final passwordController = TextEditingController(text: _currentUser.password);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        passwordController.text.length >= 6) {
                      setState(() {
                        _currentUser.name = nameController.text;
                        _currentUser.password = passwordController.text;
                      });
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Name cannot be empty and password must be at least 6 characters'),
                          backgroundColor: Colors.red[800],
                        ),
                      );
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addBalance() async {
    final amountController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount to add',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final amount = double.tryParse(amountController.text) ?? 0;
                    if (amount > 0) {
                      Navigator.pop(context);
                      _navigateToPayment(amount);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Please enter a valid amount'),
                          backgroundColor: Colors.red[800],
                        ),
                      );
                    }
                  },
                  child: const Text('Pay'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToPayment(double amount) {
    // پیاده‌سازی پرداخت
    setState(() {
      _currentUser.balance += amount;
    });
  }

  Future<void> _changeSubscription() async {
    final subscriptions = [
      {'name': 'Monthly', 'price': 9.99, 'songs': '50 songs/month'},
      {'name': 'Quarterly', 'price': 24.99, 'songs': '50 songs/month'},
      {'name': 'Yearly', 'price': 89.99, 'songs': '50 songs/month'},
      {'name': 'Regular', 'price': 0.0, 'songs': '30 songs/month'}, // اضافه کردن گزینه Regular
    ];

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Subscription',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              const SizedBox(height: 20),
              ...subscriptions.map((sub) => ListTile(
                title: Text(
                  '${sub['name']} - \$${sub['price']}',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  sub['songs'] as String,
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentUser.subscription == sub['name']
                        ? Colors.green
                        : Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_currentUser.subscription == sub['name']) {
                      Navigator.pop(context);
                      return;
                    }

                    if (_currentUser.balance >= (sub['price'] as double)) {
                      setState(() {
                        _currentUser.balance -= sub['price'] as double;
                        _currentUser.subscription = sub['name'] as String;
                      });
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Insufficient balance'),
                          backgroundColor: Colors.red[800],
                        ),
                      );
                    }
                  },
                  child: Text(
                    _currentUser.subscription == sub['name'] ? 'Current' : 'Buy',
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.grey[900],
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[800],
                        backgroundImage: _currentUser.profileImagePath != null
                            ? AssetImage(_currentUser.profileImagePath!) as ImageProvider
                            : null,
                        child: _currentUser.profileImagePath == null
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Add change profile image functionality here later
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: ListTile(
                    title: const Text('Name', style: TextStyle(color: Colors.white)),
                    subtitle: Text(_currentUser.name, style: TextStyle(color: Colors.grey[400])),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: _editProfile,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Subscription', style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                      '${_currentUser.subscription}\n${_currentUser.subscription == 'Regular' ? 'download 30 songs in month' : 'download 50 songs in month'}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentUser.subscription == 'Regular'
                            ? Colors.blue
                            : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _changeSubscription,
                      child: Text(
                        _currentUser.subscription == 'Regular'
                            ? 'Buy Premium'
                            : 'Change Plan',
                      ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Email', style: TextStyle(color: Colors.white)),
                    subtitle: Text(_currentUser.email, style: TextStyle(color: Colors.grey[400])),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Balance', style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                      '\$${_currentUser.balance.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: Colors.blue),
                      onPressed: _addBalance,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    onPressed: () {
                      // Delete account logic
                    },
                    child: const Text('Delete Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  final user = User(
    name: 'Ali',
    password: '123456',
    email: 'ali@example.com',
    balance: 20.0,
    subscription: 'Regular',
    profileImagePath: 'assets/Untitled-2.png',
  );

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User user;

  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Demo',
      theme: ThemeData.dark(),
      home: ProfilePage(user: user),
    );
  }
}
