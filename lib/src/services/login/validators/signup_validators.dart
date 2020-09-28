import 'dart:async';

class Validators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = new RegExp(pattern);

      if (regExp.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError('This is not an email.');
      }
    },
  );
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      Pattern digitPattern = r'.*[0-9].*';
      RegExp digitRegExp = new RegExp(digitPattern);
      Pattern lowercasePattern = '.*[a-z].*';
      RegExp lowercaseRegExp = new RegExp(lowercasePattern);
      Pattern uppercasePattern = '.*[A-Z].*';
      RegExp uppercaseRegExp = new RegExp(uppercasePattern);

      if (password.length == 0) {
        sink.add('');
        sink.addError('You need a password.');
      } else if (password.length < 8) {
        sink.addError('Your password needs more than 8 characters.');
      } else if (8 <= password.length && password.length <= 32) {
        if (!digitRegExp.hasMatch(password)) {
          sink.addError('Your password needs at least one digit number.');
        } else if (!lowercaseRegExp.hasMatch(password)) {
          sink.addError('Your password needs at least one lowercase letter.');
        } else if (!uppercaseRegExp.hasMatch(password)) {
          sink.addError('Your password needs at least one uppercase letter.');
        } else {
          sink.add(null);
        }
      } else {
        sink.addError('Your password can\'t be longer than 32 characters.');
      }
    },
  );
}
