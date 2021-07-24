import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwilson177hw1/screens/SubScreen/DynmaicLV.dart';
import 'package:jwilson177hw1/screens/home/profile.dart';
import 'package:jwilson177hw1/screens/home/settings.dart';
import 'package:jwilson177hw1/services/adminalert.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:jwilson177hw1/services/auth.dart';

class Admin extends StatefulWidget {
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String message = '';
  String msg = '';
  String current_user = '';
  var arr = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth1 = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    AdminAlert db = new AdminAlert();
    // Future<String> msgs = db.getMessagesAsString();
    Future<String> uzr = db.getUser();

    // msgs.then((value) => setState(() {
    //       msg = value;
    //     }));
    uzr.then((value) => setState(() {
          current_user = value;
        }));
    return Scaffold(
        appBar: AppBar(
          title: Text("Messanger!"),
          backgroundColor: Colors.greenAccent,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Profile'),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('settings'),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
              )
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(child: DynamicLV()),
            ],
          ),
        ));
  }
}
