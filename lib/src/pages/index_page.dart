import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_tracker/src/pages/admin/admin_main_page.dart';

import 'package:stock_tracker/src/pages/home_page.dart';
import 'package:stock_tracker/src/pages/login_page.dart';

class IndexPage extends StatelessWidget {
  IndexPage({Key key}) : super(key: key);

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        return (snapshot.data == null) ? LoginPage() : AdminMainPage();
      },
    );
  }
}
