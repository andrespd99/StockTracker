import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/pages/home_page.dart';
import 'package:stock_tracker/src/services/validators/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _createBackground(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _createBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final background = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kPrimaryColor,
            Color(0xFF27B0B4),
          ],
        ),
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

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of<LoginBloc>(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 180,
            ),
          ),
          Container(
            padding: EdgeInsets.all(50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            width: size.width * 0.85,
            decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 2.0)
                ]),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Welcome to Stock Tracker',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(height: 30.0),
                _createEmail(bloc),
                _createPassword(bloc),
                SizedBox(height: 30.0),
                _createFormButton(bloc),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: kPrimaryColor),
              hintText: 'example@email.com',
              labelText: 'E-mail',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _createPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock_outline, color: kPrimaryColor),
                labelText: 'Password',
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _createFormButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return RaisedButton(
          padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 2.5, vertical: kDefaultPadding),
          child: Container(
            child: Text(
              'Log in',
            ),
          ),
          onPressed: (snapshot.hasData)
              ? () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomePage()))
              : null,
        );
      },
    );
  }
}
