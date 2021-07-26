// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jwilson177hw1/models/user.dart';

class AdminAlert {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  final Query messages1 =
      FirebaseFirestore.instance.collection('messages').orderBy('datetime');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference items =
      FirebaseFirestore.instance.collection('items');
  Future<String> getUser() async {
    User uid = await _auth.currentUser!;
    String user_id = uid.uid.toString();
    DocumentSnapshot ds = await users.doc(user_id).get();
    String name = ds.get('firstName');
    return name;
  }

  Future<String> getsocial() async {
    User uid = await _auth.currentUser!;
    String user_id = uid.uid.toString();
    DocumentSnapshot ds = await users.doc(user_id).get();
    String name = ds.get('social');
    return name;
  }

  Future<String> currentuid() async {
    User uid = await _auth.currentUser!;
    String user_id = uid.uid.toString();
    return user_id;
  }

  Future<String> getUsersAsString() async {
    String registered = '';
    await users.get().then((message) {
      message.docs.forEach((value) {
        if (value['firstName'] != null) {
          registered = registered + value.id + ", " + value['firstName'] + "\n";
        }
      });
    });
    return registered;
  }

  Future<String> getBoardsAsString() async {
    String avaialble = '';
    await items.get().then((message) {
      message.docs.forEach((value) {
        if (value['items'] != null) {
          avaialble = avaialble + value['items'] + "\n";
        }
      });
    });
    return avaialble;
  }

  Future<bool> chatExists(String other, String current) async {
    final snapshot =
        await FirebaseFirestore.instance.collection(other + current).get();
    final snapshot1 =
        await FirebaseFirestore.instance.collection(current + other).get();
    if (snapshot.docs.length == 0) {
      return false;
    }
    return true;
  }

  Future<bool> chatExists1(String other, String current) async {
    final snapshot =
        await FirebaseFirestore.instance.collection(other + current).get();
    final snapshot1 =
        await FirebaseFirestore.instance.collection(current + other).get();
    if (snapshot.docs.length == 0 || snapshot1.docs.length == 0) {
      return false;
    }
    return true;
  }

  Future<String> search(String current) async {
    String msgs = '';
    // print(current);
    final Query chats1 = FirebaseFirestore.instance
        .collection(current)
        .where('item', isGreaterThanOrEqualTo: current);
    // print(current);
    await chats1.get().then((message) {
      message.docs.forEach((value) {
        // print("54" + value["message"]);
        if (value["item"] != null)
          msgs = msgs +
              value["item"] +
              " " +
              value["condition"] +
              ": " +
              (value['price']) +
              "\n";
        // print(msgs);
      });
    });
    return msgs;
  }

  Future<String> getMessagesAsString(String current, String search) async {
    print(current + "MSG");
    String msgs = '';
    // print(current);

    if (search != '') {
      final qry = FirebaseFirestore.instance
          .collection(current)
          .where('item', isGreaterThanOrEqualTo: search);
      await qry.get().then((message) {
        message.docs.forEach((value) {
          // print("54" + value["message"]);
          if (value["item"] != null)
            msgs = msgs +
                value["item"] +
                " " +
                value["condition"] +
                ": " +
                value['price'] +
                "\n";
          // print(msgs);
        });
      });
    } else {
      final CollectionReference qry =
          FirebaseFirestore.instance.collection(current);
      await qry.get().then((message) {
        message.docs.forEach((value) {
          // print("54" + value["message"]);
          if (value["item"] != null)
            msgs = msgs +
                value["item"] +
                " " +
                value["condition"] +
                ": " +
                value['price'] +
                "\n";
          // print(msgs);
        });
      });
    }
    // print(current);

    return msgs;
  }

  Future<String> getWatchItemAsString(String current) async {
    print(current + "MSG");
    String msgs = '';
    // print(current);
    final CollectionReference qry =
        FirebaseFirestore.instance.collection(current);
    // print(current);
    await qry.get().then((message) {
      message.docs.forEach((value) {
        // print("54" + value["message"]);
        if (value["item"] != null) msgs = msgs + value["item"] + "\n";
        // print(msgs);
      });
    });
    return msgs;
  }

  Future addAdminMessage(String message, String current, String name) async {
    await FirebaseFirestore.instance.collection(current).doc().set({
      'Message': message,
      'datetime': DateTime.now().toLocal().toString(),
      'author': name
    });
  }

  Future addItem(String message, String current) async {
    await FirebaseFirestore.instance.collection(current).doc().set({
      'item': message,
    });
  }

  Future updateProfile(String first, String current, String last) async {
    await FirebaseFirestore.instance.collection(current).doc().update({
      'firstName': first,
      'lastname': last,
    });
  }

  Future updatesocial(String social, String current) async {
    await FirebaseFirestore.instance.collection('users').doc(current).update({
      'social': social,
    });
  }

  Future<void> updateEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
