// @dart=2.9
import 'package:flutter/material.dart';
import 'package:jwilson177hw1/models/user.dart';
import 'package:jwilson177hw1/screens/authenticate/authenticate.dart';
import 'package:jwilson177hw1/services/database.dart';
import 'package:provider/provider.dart';

import 'home/admin.dart';

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String role = 'customer';
  @override
  Widget build(BuildContext context) {
    // return either the Home or Authenticate widget
    final user = Provider.of<MyUser>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Admin();
    }
  }
}
