import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/pages/admin/admin_main_page.dart';

import 'package:stock_tracker/src/pages/home_page.dart';
import 'package:stock_tracker/src/pages/login_page.dart';
import 'package:stock_tracker/src/pages/navigation_page.dart';
import 'package:stock_tracker/src/services/login/authenticate_bloc.dart';

class IndexPage extends StatelessWidget {
  IndexPage({Key key}) : super(key: key);

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.data == null) {
          return LoginPage();
        } else {
          return StreamBuilder(
            stream: Provider.of<AuthBloc>(context).profileStream,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.hasData) {
                final account = snapshot.data;
                if (account['isSuspended']) {
                  return buildAlertDialog(context,
                      alert: 'Your account was suspended.');
                } else if (account['isAdmin'] || account['isSuperAdmin']) {
                  return NavigationPage();
                } else {
                  if (!account['isSuscribed']) {
                    return buildAlertDialog(context,
                        alert: 'You are not a member.');
                  } else {
                    return NavigationPage();
                  }
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        }
      },
    );
  }

  AlertDialog buildAlertDialog(BuildContext context, {@required String alert}) {
    return AlertDialog(
        title: Text('Unable to login'),
        content: Text('$alert'),
        actions: [
          FlatButton(
            onPressed: () =>
                Provider.of<AuthBloc>(context, listen: false).signOut(),
            child: Text('Go back'),
            textColor: kPrimaryColor,
          ),
        ]);
  }
}
