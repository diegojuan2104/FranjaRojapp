import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:franja_rojapp/models/userModel.dart';
import 'package:franja_rojapp/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User firebaseUser = FirebaseAuth.instance.currentUser;

  returnCurrentUser<User>() {
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

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel> get authStateChanges {
    try {
      return _auth.authStateChanges().map((User firebaseUser) =>
          (firebaseUser != null) ? UserModel(uid: firebaseUser.uid) : null);
    } catch (e) {
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
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      bool isNewUser = userCredential.additionalUserInfo.isNewUser;

      print(isNewUser.toString());
      if (isNewUser) {
        final user = userCredential.user;
        print(user.uid.toString());
        await setUserInitialState(user);
      }
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

      setUserInitialState(user);

      return _userFromFirebaseUser(user);
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          print("Email ya registrado");
        }
      }
    }
  }

  Future<void> signOutUser() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setUserInitialState(User user) async {
    await DatabaseService(uid: user.uid)
        .setInitialUserAttributes(user.email.toString());
  }
}
