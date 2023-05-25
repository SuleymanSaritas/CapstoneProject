import 'package:flutter/material.dart';
import 'package:lego_market_app/core/components/navigator/push.dart';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmailPasswordForm(),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 20.0), // Margin added here
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
