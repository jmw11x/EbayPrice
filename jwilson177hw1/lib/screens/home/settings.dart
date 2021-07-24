import 'package:flutter/material.dart';
import 'package:jwilson177hw1/services/adminalert.dart';
import 'package:jwilson177hw1/services/auth.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String uid = '';
  String email = '';
  String password = '';
  String social = '';
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    AdminAlert db = new AdminAlert();

    Future<String> uzr = db.currentuid();
    uzr.then((value) => setState(() {
          uid = value;
        }));
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Profile Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                decoration: InputDecoration(
                    hintText: 'email', helperText: 'Reset email'),
                onChanged: (v) => {setState(() => email = v)},
              ),
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Social Media',
                    helperText: 'Reset Social media link'),
                onChanged: (v) => {setState(() => social = v)},
              ),
              ElevatedButton(
                  child: Text('Reset Name and social'),
                  onPressed: () async {
                    await db.updatesocial(social, uid);
                    await db.updateEmail(email);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
