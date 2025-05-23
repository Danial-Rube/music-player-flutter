import 'package:flutter/foundation.dart';

class User {
  String name;
  final String email;
  String passWord;
  final String defultProfile = 'assets/images/defultprofile.png';
  Uint8List? takenProfile;

  User({
    required this.name,
    required this.email,
    required this.passWord,
    this.takenProfile,
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
}
