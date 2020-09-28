import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/services/login/authenticate_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({@required this.onAdmin, Key key}) : super(key: key);

  final bool onAdmin;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AuthBloc>(context);
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding * 2,
          ),
          child: ListView(
            children: [
              DrawerHeader(
                child: Text(
                  'Welcome, ${getUserName(bloc)}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
              ),
              ListTile(
                title: (onAdmin)
                    ? GestureDetector(
                        child: Row(
                          children: [
                            Icon(Icons.settings),
                            SizedBox(width: kDefaultPadding / 2),
                            Text(
                              'Home',
                            ),
                          ],
                        ),
                        onTap: () => Navigator.popAndPushNamed(context, 'home'),
                      )
                    : GestureDetector(
                        child: Row(
                          children: [
                            Icon(Icons.settings, color: Colors.amber),
                            SizedBox(width: kDefaultPadding / 2),
                            Text('Admin tools',
                                style: TextStyle(color: Colors.amber)),
                          ],
                        ),
                        onTap: () =>
                            Navigator.popAndPushNamed(context, 'admin'),
                      ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: kDefaultPadding / 2),
                    Text('Profile'),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.credit_card),
                    SizedBox(width: kDefaultPadding / 2),
                    Text('Membership'),
                  ],
                ),
              ),
              ListTile(
                title: GestureDetector(
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  onTap: () =>
                      Provider.of<AuthBloc>(context, listen: false).signOut(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getUserName(AuthBloc bloc) {
    String name;
    name = bloc.profile['firstName'].toString() +
        ' ' +
        bloc.profile['lastName'].toString();

    return name;
  }
}
