import 'package:flutter/material.dart';

enum ValidationError {
  none,
  emptyFields,
  invalidEmail,
  weakPassword,
  passequalName,
  notConfirmPassword,
}

class ValidationHelper {
  static ValidationError getErrore(
    String email,
    String name,
    String pass,
    String repass,
  ) {
    if (email.isEmpty || name.isEmpty || pass.isEmpty || repass.isEmpty) {
      return ValidationError.emptyFields;
    }
    //check empty
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$').hasMatch(pass)) {
      return ValidationError.weakPassword;
      //check password
    } else if (pass == name) {
      return ValidationError.passequalName;
      //check name == pass
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return ValidationError.invalidEmail;
      //check email
    } else if (pass != repass) {
      return ValidationError.notConfirmPassword;
      //Confirm paee check
    }
    //ok result
    return ValidationError.none;
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFBCBCBC),
            fontFamily: 'Opensans',
          ),
        ),
        backgroundColor: Color(0xFF282828),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.only(
          bottom: 20.0, // فاصله از پایین
          left: 15.0, // فاصله از چپ
          right: 15.0, // فاصله از راست
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // گوشه‌های گرد
        ),
        behavior: SnackBarBehavior.floating, // حالت شناور
        elevation: 6.0, // سایه
        action: SnackBarAction(
          label: 'OK',

          textColor: Color(0xFF88E66F),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static bool verify(
    BuildContext context,
    String email,
    String name,
    String pass,
    String repass,
  ) {
    ValidationError errore = getErrore(email, name, pass, repass);

    switch (errore) {
      case ValidationError.emptyFields:
        showErrorSnackBar(context, "Please Fill all the fields!");
        return false;

      case ValidationError.invalidEmail:
        showErrorSnackBar(context, "Invalid email");
        return false;

      case ValidationError.weakPassword:
        showErrorSnackBar(context, "Choose Stronger Password");
        return false;

      case ValidationError.passequalName:
        showErrorSnackBar(context, "Password should not be equal to name");
        return false;
      case ValidationError.notConfirmPassword:
        showErrorSnackBar(context, "Password dosn't matchs !");
        return false;
      case ValidationError.none:
        showErrorSnackBar(context, "Signed Up Successfully");
        return true;
    }
  }
}
