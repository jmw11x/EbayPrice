import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  //collection reference
  final String uid;
  Database({required this.uid});
  var role = 'customer';
  final CollectionReference user_refs =
      FirebaseFirestore.instance.collection('users');

  Future<String> isAdmin() async {
    DocumentSnapshot ds = await user_refs.doc(uid).get();
    return ds.get('role');
  }

  final CollectionReference message_refs =
      FirebaseFirestore.instance.collection('messages');

  // Future getMessages() async{
  //   var snapshot = FirebaseFirestore.instance
  //         .collection('messagee')
  //         .orderBy('createdAt', descending: true)
  //         .snapshots();
  // }

  Future addUserData(String first, String last, String role) async {
    await user_refs.doc(uid).set({
      'firstName': first,
      'lastName': last,
      'role': role,
    });
  }
}
