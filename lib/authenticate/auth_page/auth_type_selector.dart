import 'package:flutter/material.dart';

import '../../core/components/navigator/push.dart';
import '../login/email_password_form.dart';
import '../register/register_page.dart';

class AuthTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 160, 10, 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/splashh.png'),
                    ),
                  ),
                  SizedBox(height: 20),
                  EmailPasswordForm(),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(Icons.person_add, color: Colors.white),
                      label: Text("Register"),
                      onPressed: () => navigatorPush(
                        context,
                        RegisterPage(),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
