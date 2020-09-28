import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/services/login/authenticate_bloc.dart';
import 'package:stock_tracker/src/services/login/login_form_bloc.dart';

class LoginForm extends StatefulWidget {
  LoginForm(this.toggleView, {Key key}) : super(key: key);

  final void Function() toggleView;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailLoginCtrl = TextEditingController();

  final TextEditingController _passwordLoginCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LoginFormBloc>(context);
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
            child: Column(
              children: [
                _loginTitle('Welcome to \nInvierto En Mi', context),
                SizedBox(height: 30.0),
                _createEmailLogin(bloc),
                _createPasswordLogin(bloc),
                SizedBox(height: 30.0),
                _createLoginErrorText(context),
                SizedBox(height: 30.0),
                _createFormButtonLogin(bloc),
                SizedBox(height: 30.0),
                _createSignupText(),
              ],
            ),
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 2.0)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Center _loginTitle(String title, BuildContext context) {
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _createEmailLogin(LoginFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            controller: _emailLoginCtrl,
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

  Widget _createPasswordLogin(LoginFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            controller: _passwordLoginCtrl,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: kPrimaryColor),
              labelText: 'Password',
              errorText: snapshot.error,
              errorMaxLines: 3,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _createFormButtonLogin(LoginFormBloc bloc) {
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
              ? () {
                  Provider.of<AuthBloc>(context, listen: false).emailLogIn(
                      _emailLoginCtrl.text, _passwordLoginCtrl.text);
                }
              : null,
        );
      },
    );
  }

  Widget _createSignupText() {
    final TextStyle textLinkStyle = TextStyle(color: kPrimaryColor);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don\'t have an account yet? '),
        InkWell(
          child: Text('Sign up', style: textLinkStyle),
          onTap: () {
            this.widget.toggleView();
          },
        ),
      ],
    );
  }

  Widget _createLoginErrorText(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<AuthBloc>(context).loginError,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return (snapshot.hasData)
            ? Text(
                "${snapshot.data}",
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.red),
              )
            : SizedBox();
      },
    );
  }

  @override
  void dispose() {
    _emailLoginCtrl?.dispose();
    _passwordLoginCtrl?.dispose();
    super.dispose();
  }
}
