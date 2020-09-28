import 'package:flutter/material.dart';

import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/widgets/login_form.dart';
import 'package:stock_tracker/src/widgets/signup_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isOnSignup = false; //Page toggler from login to sign up.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            _createBackground(context),
            isOnSignup ? SignupForm(toggleView) : LoginForm(toggleView),
          ],
        ));
  }

  Widget _createBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final background = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: kLinearGradient,
      ),
    );

    final sphere = Container(
      width: 300.0,
      height: 300.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(300.0),
        color: Colors.white.withOpacity(0.3),
      ),
    );

    return ClipRRect(
      child: Stack(
        children: [
          background,
          Positioned(top: -150.0, left: -80.0, child: sphere),
          Positioned(top: 135.0, right: -190.0, child: sphere),
          Positioned(top: 250.0, left: -190.0, child: sphere)
        ],
      ),
    );
  }

  void toggleView() {
    setState(() {
      isOnSignup = !isOnSignup;
    });
  }
}
