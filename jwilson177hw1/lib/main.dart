// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jwilson177hw1/screens/wrapper.dart';
import 'package:jwilson177hw1/services/auth.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _auth.signInAnon();
            return StreamProvider<MyUser>.value(
              initialData: null,
              value: AuthService().user,
              child: MaterialApp(
                home: Wrapper(),
              ),
            );
          }
          print("ERROR!!!!");
          return StreamProvider<MyUser>.value(
            initialData: null,
            value: AuthService().user,
            child: MaterialApp(
              home: Wrapper(),
            ),
          );
        });
  }
}
