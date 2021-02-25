import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:franja_rojapp/constants/constants.dart';
import 'package:franja_rojapp/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User firebaseUser = FirebaseAuth.instance.currentUser;

  returnCurrentUser() {
    return firebaseUser;
  }

  Future<void> sendVerificationEmail() async {
    await firebaseUser.sendEmailVerification();
  }

  Future<void> sendPasswordreset(_email) async {
    await _auth.sendPasswordResetEmail(email: _email);
  }


  emailIsVerified() {
    if (firebaseUser != null) {
      return firebaseUser.emailVerified;
    } else {
      return null;
    }
  }

  User_model _userFromFirebaseUser(User user) {
    return user != null ? User_model(uid: user.uid) : null;
  }

  Stream<User_model> get user {
    try{
    return _auth.authStateChanges().map((User firebaseUser) =>
        (firebaseUser != null) ? User_model(uid: firebaseUser.uid) : null);
    }catch(e){
      print("HA OCURRIDO UN ERROR CON LA AUTENTICACION");
      return null;
    }
  }

  Future<void> signInUserWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]);

    try {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: _googleAuth.idToken,
        accessToken: _googleAuth.accessToken,
      );
      print("CREDENTIALS" + credential.toString());
      await _auth.signInWithCredential(credential);
    } on PlatformException catch (e) {
      print(e.code);
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register in with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOutUser() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
