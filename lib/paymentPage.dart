import 'package:flutter/material.dart';

void main() {
  runApp(PaymentPage());
}

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payment Page',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.white70),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          // دکمه‌ها استایل جداگانه دارند، پس این خط حذف شد
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Payment Page'),
          backgroundColor: Colors.grey[900],
        ),
        body: PaymentForm(),
      ),
    );
  }
}

class PaymentForm extends StatefulWidget {
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();

  String cardNumber = '';
  String cardHolder = '';
  String expiryDate = '';
  String cvv = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Card Number',
              ),
              keyboardType: TextInputType.number,
              maxLength: 16,
              style: TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.length != 16) {
                  return 'Card number must be 16 digits';
                }
                return null;
              },
              onSaved: (value) => cardNumber = value!,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Card Holder Name',
              ),
              style: TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card holder name';
                }
                return null;
              },
              onSaved: (value) => cardHolder = value!,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Expiry Date (MM/YY)',
              ),
              keyboardType: TextInputType.datetime,
              maxLength: 5,
              style: TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                  return 'Enter expiry date as MM/YY';
                }
                return null;
              },
              onSaved: (value) => expiryDate = value!,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'CVV',
              ),
              keyboardType: TextInputType.number,
              maxLength: 3,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.length != 3) {
                  return 'CVV must be 3 digits';
                }
                return null;
              },
              onSaved: (value) => cvv = value!,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Pay'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Payment Info'),
                      content: Text(
                          'Card Number: $cardNumber\nCard Holder: $cardHolder\nExpiry Date: $expiryDate\nCVV: $cvv'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
