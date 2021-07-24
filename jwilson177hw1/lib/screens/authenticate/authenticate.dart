import 'package:flutter/material.dart';
import 'package:jwilson177hw1/screens/authenticate/register.dart';
import 'package:jwilson177hw1/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showSignIn
          ? SignIn(toggleView: toggleView)
          : Register(toggleView: toggleView),
    );
  }
}
