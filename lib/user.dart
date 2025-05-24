import 'package:flutter/foundation.dart';

enum Subscription { regular, premium }

class User {
  String name;
  final String email;
  String passWord;
  final String defultProfile = 'assets/images/defultprofile.png';
  Uint8List? takenProfile;
  double balance;
  Subscription acount;

  User({
    required this.name,
    required this.email,
    required this.passWord,
    this.takenProfile,
    this.balance = 25.0,
    this.acount = Subscription.regular,
  });

  void setProfilePicture(Uint8List profile) {
    takenProfile = profile;
  }

  bool editInfo(String? name, String? pass) {
    if (name != null && name.trim().isNotEmpty) {
      this.name = name;
    } else {
      return false;
    }

    if (pass != null && pass.trim().isNotEmpty) {
      if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$').hasMatch(pass) ||
          pass.trim() == name.trim() ||
          pass.trim() == this.name) {
        return false;
      }
    } else {
      return false;
    }

    return true;
  }

  bool pay(double price) {
    if (price >= 0 && price <= balance) {
      balance -= price;
      return true;
    }
    return false;
  }

  bool addbalance(double? amount) {
    if (amount != null && amount > 0) {
      balance += amount;
      return true;
    }
    return false;
  }
}
