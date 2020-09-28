import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/subjects.dart';

class AuthBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //Login-related objects.
  final _loginFormController = StreamController<String>.broadcast();
  Function(String) get addLoginError => _loginFormController.sink.add;
  Stream<String> get loginError => _loginFormController.stream;

  //Signup-related objects.
  final _signupFormController = StreamController<String>.broadcast();
  Function(String) get addSignupError => _signupFormController.sink.add;
  Stream<String> get signupError => _signupFormController.stream;

  //User-related objects.
  final _pinnedStocksController = BehaviorSubject<List<String>>();
  Function(List<String>) get pinnedStocksSink =>
      _pinnedStocksController.sink.add;
  Stream<List<String>> get pinnedStocksStream => _pinnedStocksController.stream;

  User user;
  Map<String, dynamic> profile;
  List<String> pinnedStocks;

  void dispose() {
    _loginFormController?.close();
    _signupFormController?.close();
    _pinnedStocksController?.close();
  }

  AuthBloc() {
    loadUserProfile();
  }

  Future<User> createUserWithEmail(email, password, firstName, lastName) async {
    User user;
    profile = {
      'email': email,
      'pinnedStocks': [],
      'firstName': firstName,
      'lastName': lastName,
      'lastSeen': Timestamp.now(),
    };
    try {
      user = (await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (snap) async {
          db.collection('users').doc(snap.user.uid).set(profile);
          profile = await db
              .collection('users')
              .doc(snap.user.uid)
              .get()
              .then((snap) => snap.data());
          return snap.user;
        },
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        addSignupError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('That email is already in use.');
        addSignupError('That email is already registered.');
      }
    } catch (e) {
      print(e.toString());
    }
    return user;
  }

  void emailLogIn(String email, String password) async {
    try {
      // Try to log in with given user credentials
      user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((snap) => snap.user);

      // Check if user exists.
      if (user != null) {
        // Check if user has pinnedStocks array.
        bool hasStocks = await db
            .collection('users')
            .doc(user.uid)
            .get()
            .then((snap) => snap.data().containsKey('pinnedStocks'));
        //If he doesn't, create it and update lastSeen.
        if (!hasStocks) {
          await db.collection('users').doc(user.uid).set({
            'pinnedStocks': [],
            'lastSeen': Timestamp.now(),
          }, SetOptions(merge: true));
        } else {
          //If he does, just update lastSeen.
          await db
              .collection('users')
              .doc(user.uid)
              .update({'lastSeen': Timestamp.now()});
        }
        profile = await db
            .collection('users')
            .doc(user.uid)
            .get()
            .then((snap) => snap.data().map((key, value) => null));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        addLoginError('You are not registered.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        addLoginError('Incorrect password.');
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<Map<String, dynamic>> loadUserProfile() async {
    if (_auth.currentUser != null) {
      final docSnap =
          await db.collection('users').doc(_auth.currentUser.uid).get();

      profile = docSnap.data();
    }
    return profile;
  }

  void updateUserData(User user,
      {String email, String firstName, String lastName}) {
    db.collection('users').doc(user.uid).update({
      'email': email,
      'pinnedStocks': [],
      'firtName': firstName,
      'lastName': lastName,
    });
  }

  // Get pinned stocks from user.
  Future<List<String>> getPinnedStocks() async {
    final userId = _auth.currentUser.uid;
    print(userId);
    final doc = await db.collection('users').doc(userId).get();
    List<String> pinnedStocks;
    pinnedStocks =
        List.castFrom<dynamic, String>(doc.data()['pinnedStocks']).toList();
    print(pinnedStocks);
    return pinnedStocks;
  }

  void addPinnedStocks(String symbol) async {
    final userId = this._auth.currentUser.uid;
    if (pinnedStocks.contains(symbol)) {
      print('Stock already picked');
    } else {
      pinnedStocks.add(symbol);
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'pinnedStocks': pinnedStocks,
      });
      this.pinnedStocksSink(pinnedStocks);
      print('Added');
    }
  }

  void removePinnedStocks(String symbol) async {
    final userId = this._auth.currentUser.uid;
    if (pinnedStocks.contains(symbol)) {
      pinnedStocks.remove(symbol);
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'pinnedStocks': pinnedStocks,
      });
      this.pinnedStocksSink(pinnedStocks);
    } else {
      print('This stock was not selected.');
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
