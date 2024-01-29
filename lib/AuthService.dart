import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      final UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return authResult.user;
    } catch (error) {
      print("Error signing up with email and password: $error");
      return null;
    }
  }

  // Other methods (signInWithGoogle, signOut) remain unchanged...
}
