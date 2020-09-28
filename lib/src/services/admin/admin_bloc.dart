import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBloc {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUsers() async {
    final docs =
        await _db.collection('users').get().then((value) => value.docs);

    final usersList = docs.map((e) {
      final doc = e.data();
      doc.addAll({'id': e.id});
      return doc;
    }).toList();

    return usersList;
  }

  void suspendUser(String userId) async {
    final userDoc = _db.collection('users').doc(userId);

    await userDoc.set(
      {'suspended': true},
      SetOptions(merge: true),
    );
  }

  void unsuspendUser(String userId) async {
    final userDoc = _db.collection('users').doc(userId);

    await userDoc.set(
      {'suspended': false},
      SetOptions(merge: true),
    );
  }

  void upgradeUser(String userId) async {
    final userDoc = _db.collection('users').doc(userId);

    await userDoc.set(
      {'admin': true},
      SetOptions(merge: true),
    );
  }

  void downgradeUser(String userId) async {
    final userDoc = _db.collection('users').doc(userId);

    await userDoc.set(
      {'admin': false},
      SetOptions(merge: true),
    );
  }
}
