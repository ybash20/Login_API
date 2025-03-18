// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_app/providors/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  void submit() {
    Provider.of<Auth>(context, listen: false).login(credentials: {
      'email': _email,
      'password': _password,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Login'),
      ),
      body: Form(
        key: _formkey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: 'Belal@gmail.com',
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email@gmail.com',
                  ),
                  onSaved: (value) {
                    _email = value; // تعيين قيمة الإيميل
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // مسافة بين الحقول
                TextFormField(
                  initialValue: '123456',
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'ABCabc@#123',
                  ),
                  obscureText: true, // لإخفاء النص
                  onSaved: (value) {
                    _password = value; // تعيين قيمة كلمة المرور
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24), // مسافة أكبر قبل الزر
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Login'),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        // التحقق من صحة النموذج
                        _formkey.currentState!.save(); // حفظ القيم
                        this.submit(); // استدعاء دالة submit
                      }
                    },
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
