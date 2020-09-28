import 'package:flutter/material.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/pages/admin/manage_users_page.dart';
import 'package:stock_tracker/src/widgets/drawer.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      drawer: CustomDrawer(onAdmin: true),
      appBar: AppBar(
        title: Text('Admin tools'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ManageUsersPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(kDefaultPadding),
                  alignment: Alignment.center,
                  child: Text('Users', style: textTheme.headline4),
                  decoration: BoxDecoration(color: kSecondaryColor, boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.26),
                      blurRadius: 10.0,
                    )
                  ]),
                ),
              ),
              SizedBox(height: kDefaultPadding * 3),
              // FlatButton(
              //   onPressed: () {},
              //   child: Container(
              //     padding: EdgeInsets.all(kDefaultPadding),
              //     alignment: Alignment.center,
              //     child: Text('Posts', style: textTheme.headline4),
              //     decoration: BoxDecoration(color: kSecondaryColor, boxShadow: [
              //       BoxShadow(
              //         color: kPrimaryColor.withOpacity(0.26),
              //         blurRadius: 10.0,
              //       )
              //     ]),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
