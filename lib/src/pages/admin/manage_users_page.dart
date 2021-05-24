import 'package:firebase_admin/firebase_admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/services/admin/admin_bloc.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAdmin admin = FirebaseAdmin.instance;
    return Scaffold(
      appBar: AppBar(title: Text('User management')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: Provider.of<AdminBloc>(context).getUsers(),
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, i) => UserTile(snapshot.data[i]));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile(this.userInfo, {Key key}) : super(key: key);
  final Map<String, dynamic> userInfo;

  @override
  Widget build(BuildContext context) {
    final adminBloc = Provider.of<AdminBloc>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;

    final userId = userInfo['id'];
    final email = userInfo['email'];
    final fullName = userInfo['firstName'].toString() +
        ' ' +
        userInfo['lastName'].toString();

    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(email),
          IconButton(
              icon: Icon(
                Icons.block,
                color: Colors.red,
              ),
              onPressed: () => adminBloc.suspendUser(userId))
        ],
      ),
      subtitle: Text(fullName,
          style: textTheme.bodyText1.copyWith(color: Colors.grey)),
    );
  }
}
