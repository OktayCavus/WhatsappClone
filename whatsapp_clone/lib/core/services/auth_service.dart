import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signIn() async {
    var user = await _firebaseAuth.signInAnonymously();

    return user;
  }
}
