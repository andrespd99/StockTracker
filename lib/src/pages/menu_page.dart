import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/pages/admin/admin_main_page.dart';
import 'package:stock_tracker/src/services/login/authenticate_bloc.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AuthBloc>(context, listen: false);
    final userProfile = Provider.of<AuthBloc>(context).profile;
    final userName = userProfile['firstName'].toString() +
        ' ' +
        userProfile['lastName'].toString();
    final optionTextStyle = TextStyle(fontSize: 20.0);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, $userName",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: kDefaultPadding * 2),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Row(
                          children: [
                            Icon(Icons.settings, color: Colors.amber),
                            SizedBox(width: kDefaultPadding / 2),
                            Text('Admin tools',
                                style: optionTextStyle.copyWith(
                                    color: Colors.amber)),
                          ],
                        ),
                      ),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AdminMainPage())),
                    ),
                  ),
                  ListTile(
                    title: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Row(
                          children: [
                            Icon(Icons.credit_card),
                            SizedBox(width: kDefaultPadding / 2),
                            Text('Membership', style: optionTextStyle),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: kDefaultPadding / 2),
                            Text('Profile', style: optionTextStyle),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: kDefaultPadding),
                  ListTile(
                    title: GestureDetector(
                      child: Center(
                        child: Text(
                          'Log out',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      onTap: () => bloc.signOut(),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
