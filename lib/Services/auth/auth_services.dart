import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  //* Create an Instance of Firebase Auth
  final _auth = FirebaseAuth.instance;

  //* SignIn
  Future<UserCredential> signIn(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //* SignUp
  Future<UserCredential> signUp(String email, password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //* SignOut
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
