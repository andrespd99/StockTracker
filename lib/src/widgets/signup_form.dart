import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/services/login/authenticate_bloc.dart';
import 'package:stock_tracker/src/services/login/signup_form_bloc.dart';

class SignupForm extends StatefulWidget {
  SignupForm(this.toggleView, {Key key}) : super(key: key);

  final void Function() toggleView;

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  // Text Controllers.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignupFormBloc>(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child: Container(height: 180)),
          Container(
            padding: EdgeInsets.all(50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            width: size.width * 0.85,
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Create an account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(height: 30.0),
                _createFirstNameTextField(),
                _createLastNameTextField(),
                SizedBox(height: 15.0),
                _createEmailTextField(bloc),
                _createPasswordTextField(bloc),
                SizedBox(height: 30.0),
                _createSignupErrorText(context),
                SizedBox(height: 30.0),
                _createSignupFormButton(bloc),
                SizedBox(height: 30.0),
                _createAlreadySignedText(context),
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
                  spreadRadius: 2.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createEmailTextField(SignupFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: kPrimaryColor),
              hintText: 'example@email.com',
              labelText: 'E-mail',
              errorText: snapshot.error,
              errorMaxLines: 2,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _createPasswordTextField(SignupFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            controller: _passwordController,
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

  Widget _createFirstNameTextField() {
    final validCharacters = RegExp(r'^[a-zA-Z]');
    return Container(
      child: TextField(
          controller: _firstNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            icon: Icon(Icons.person, color: kPrimaryColor),
            labelText: 'First name',
            hintText: 'John',
            errorMaxLines: 3,
          ),
          onChanged: (input) {
            // Avoid characters that are not letters.
            final lastValue = input.substring(input.length - 1);
            if (!validCharacters.hasMatch(lastValue))
              _firstNameController.text =
                  _firstNameController.text.replaceFirst(lastValue, '');
          }),
    );
  }

  Widget _createLastNameTextField() {
    // Valid chars for textfield.
    final validCharacters = RegExp(r'^[a-zA-Z]');

    return Container(
      child: TextField(
          controller: _lastNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            icon: Icon(Icons.person_outline, color: kPrimaryColor),
            labelText: 'Last name',
            hintText: 'Doe',
            errorMaxLines: 3,
          ),
          onChanged: (input) {
            // Avoid characters that are not letters.
            final lastValue = input.substring(input.length - 1);
            if (!validCharacters.hasMatch(lastValue))
              _firstNameController.text =
                  _firstNameController.text.replaceFirst(lastValue, '');
          }),
    );
  }

  Widget _createSignupFormButton(SignupFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return RaisedButton(
          padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 2.5, vertical: kDefaultPadding),
          child: Container(
            child: Text(
              'Create account',
            ),
          ),
          onPressed: (snapshot.hasData) ? () => _register(context) : null,
        );
      },
    );
  }

  _createAlreadySignedText(BuildContext context) {
    final TextStyle textLinkStyle = TextStyle(color: kPrimaryColor);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already a member? '),
        InkWell(
          child: Text('Log in', style: textLinkStyle),
          onTap: () {
            this.widget.toggleView();
          },
        ),
      ],
    );
  }

  void _register(BuildContext context) async {
    User user =
        await Provider.of<AuthBloc>(context, listen: false).signInWithEmail(
      _emailController.text,
      _passwordController.text,
      _firstNameController.text,
      _lastNameController.text,
    );

    if (user != null) {
      Navigator.popAndPushNamed(context, 'auth');
    }
  }

  Widget _createSignupErrorText(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<AuthBloc>(context).signupError,
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

  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
  }
}
