import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/verifytool.dart';
import 'user.dart';

User currentUser = activeUser!;

void showMessage(context, String ms, Color c) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Color(0xFF1A1A1A),
      content: Text(ms, style: TextStyle(color: c)),
      duration: const Duration(seconds: 1),
    ),
  );
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEditing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.text = currentUser.name;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      setState(() {
        currentUser.setProfilePicture(bytes);
      });
    }
  }

  //نمایش اشتراک ها
  void _showSubscriptionOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF0F0F0F),
      isScrollControlled: true,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Plans",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Opensans',
                  ),
                ),
                SizedBox(height: 20),

                _buildSubscriptionOption(
                  title: "Monthly",
                  price: 29000,
                  description: "Access to all features for one month",
                  features: ["No ads", "offline playback"],
                ),
                Divider(height: 32),

                _buildSubscriptionOption(
                  title: "Three Month",
                  price: 79000,
                  description: "Access to all features with a 10% discount.",
                  features: [
                    "All Monthly Subscription Benefits",
                    "10% discount",
                  ],
                ),
                Divider(height: 32),

                _buildSubscriptionOption(
                  title: "Yearly",
                  price: 299000,
                  description: "Access to all features with a 15% discount.",
                  features: [
                    "All benefits of a three-month subscription",
                    "15% discount",
                    "One T-shirt",
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildSubscriptionOption({
    required String title,
    required double price,
    required String description,
    required List<String> features,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF262626),
        borderRadius: BorderRadius.circular(12),
        //border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${price.toStringAsFixed(0)}",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Opensans',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              //دکمه ی پرداخت
              ElevatedButton(
                onPressed: () {
                  if (currentUser.pay(price)) {
                    setState(() {
                      currentUser.acount = Subscription.premium;
                    });
                    Navigator.pop(context);
                    showMessage(
                      context,
                      'Premium successfully activated.',
                      Colors.green,
                    );
                  } else {
                    Navigator.pop(context);
                    showMessage(context, 'Balance is not enouth', Colors.red);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Pay", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: 8),
          ...features.map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text(feature),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      _errorMessage = null;

      if (!_isEditing) {
        _nameController.text = currentUser.name;
        _passwordController.clear();
      }
    });
  }

  void _saveChanges() {
    final String newName = _nameController.text.trim();
    final String newPassword = _passwordController.text.trim();

    // اگر فیلد نام خالی باشد، از نام فعلی استفاده می‌شود
    final String nameToUpdate = newName.isEmpty ? currentUser.name : newName;
    // اگر فیلد رمز خالی باشد، از رمز فعلی استفاده می‌شود
    final String passToUpdate =
        newPassword.isEmpty ? currentUser.passWord : newPassword;

    final bool result = currentUser.editInfo(nameToUpdate, passToUpdate);

    if (result) {
      setState(() {
        _isEditing = false;
        _errorMessage = null;
        _passwordController.clear();
      });

      showMessage(
        context,
        'Information was successfully updated.',
        Colors.green,
      );
    } else {
      setState(
        () =>
            _errorMessage =
                "PassWord must be at last 8 character(number, small&cpaitla letter) and not equals name.",
      );
    }
  }

  void _showAddBalanceDialog() {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Balance"),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Amount",
              hintText: "Insert amount",
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("exit"),
            ),
            ElevatedButton(
              onPressed: () {
                final double? amount = double.tryParse(amountController.text);
                if (currentUser.addbalance(amount)) {
                  setState(() {
                    Navigator.pop(context);
                    showMessage(context, 'Amount Added!', Colors.green);
                  });
                } else {
                  showMessage(context, 'Invalid Amoutn', Colors.red);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F0F),
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(
          "Profile",
          style: TextStyle(fontFamily: 'Opensans', fontWeight: FontWeight.bold),
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),

        actions: [
          //دکمه ی ادیت
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: _toggleEditMode,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        currentUser.takenProfile != null
                            ? MemoryImage(currentUser.takenProfile!)
                            : AssetImage(currentUser.defultProfile)
                                as ImageProvider,
                  ),
                  //تنظیمات ظاهری دکمه ی عکس
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            // پیام خوشامدگویی
            Text(
              "Welcome ${currentUser.name}",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Opensans',
                fontWeight: FontWeight.w700,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 24),

            // بخش اشتراک
            Container(
              height: 70,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        currentUser.acount == Subscription.premium
                            ? "Premium Terial"
                            : "Free Terial",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Opensans',
                        ),
                      ),
                    ],
                  ),
                  if (currentUser.acount == Subscription.regular)
                    TextButton.icon(
                      icon: Icon(Icons.star),
                      label: Text("Get Premium"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue[500],
                      ),
                      onPressed: _showSubscriptionOptions,
                    ),

                  if (currentUser.acount == Subscription.premium)
                    Icon(Icons.workspace_premium_rounded, color: Colors.amber),
                ],
              ),
            ),

            SizedBox(height: 24),

            // موجودی
            InkWell(
              onTap: _showAddBalanceDialog,
              child: Container(
                height: 70,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Balance:",
                      style: TextStyle(
                        fontFamily: 'Opensans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "\$${currentUser.balance.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 9),
                        Icon(Icons.add_circle_outline, color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32),

            if (_errorMessage != null)
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            TextField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: "E-mail",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: Icon(Icons.email),
              ),
              controller: TextEditingController(text: currentUser.email),
            ),
            SizedBox(height: 16),

            if (_isEditing)
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  helperText: "Leav it if you dont need to up-date",
                ),
              ),

            SizedBox(height: 24),

            if (_isEditing)
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Opensans',
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
