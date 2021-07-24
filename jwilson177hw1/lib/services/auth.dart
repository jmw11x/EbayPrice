// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwilson177hw1/models/user.dart';
import 'package:jwilson177hw1/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyUser _userFromFirebaseUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

//auth change user stream

  Stream<MyUser> get user {
    return _auth
        .authStateChanges()
        // .map((FirebaseUser user) => _userFromFirebaseUser(user))
        .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //sign in email

  //register
  Future registerWithEmailAndPassword(
      String email, String password, String firstlast, String role) async {
    String first = firstlast.split(',')[0];
    String last = firstlast.split(',')[1];
    try {
      UserCredential si = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User currentuser = si.user;
      await Database(uid: currentuser.uid).addUserData(first, last, role);

      return _userFromFirebaseUser(currentuser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateuserWithEmailAndPassword(
      String email, String password, String first, String last) async {
    try {
      UserCredential si = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User currentuser = si.user;
      await Database(uid: currentuser.uid).addUserData(first, last, "Newuser");

      return _userFromFirebaseUser(currentuser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signinWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential si = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User currentuser = si.user;
      return _userFromFirebaseUser(currentuser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //logout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
