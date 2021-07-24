import 'package:flutter/material.dart';
import 'package:jwilson177hw1/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String first = '';
  String last = '';
  String role = '';

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Register to see Jacob now!'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                decoration: InputDecoration(
                    hintText: 'Email', helperText: 'Please enter your email'),
                onChanged: (v) => {setState(() => email = v)},
              ),
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'password',
                    helperText: 'Please enter your password'),
                onChanged: (v) => {setState(() => password = v)},
              ),
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                decoration: InputDecoration(
                    hintText: 'First Name',
                    helperText: 'Please enter your Name'),
                onChanged: (v) => {setState(() => first = v)},
              ),
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                decoration: InputDecoration(
                    hintText: 'Last name',
                    helperText: 'Please enter your last name'),
                onChanged: (v) => {setState(() => last = v)},
              ),
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                decoration: InputDecoration(
                    hintText: 'Role', helperText: 'Please enter your Role'),
                initialValue: 'customer',
                onChanged: (v) => {setState(() => role = v)},
              ),
              ElevatedButton(
                  child: Text('Confirm account'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      dynamic res = await _auth.registerWithEmailAndPassword(
                          email, password, first + ',' + last, role);

                      res == null ? print("error") : print("success");
                    } else {
                      print("fail");
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
