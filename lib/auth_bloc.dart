import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'authentication.dart';

class AuthBloc {
  final authService = AuthService(); //instance of Authentication service
  final googleSignin = GoogleSignIn(scopes: ['email']); //instance of GoogleSignIn
  Stream<User> get currentUser => authService.currentUser; //pointer to the value of currentUser returned from AuthService. It's null if User is not logged in

  loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
        //Firebase sign in
        final result = await authService.signInWithCredential(credential);
        print('Authentication name: '+ ' - ' + '${result.user.displayName}');
    } catch(error) {
      print('Authentication error: '+ error);
    }
  }
  logout() {
    try {
    authService.logout();
    print('Logout');

    return Container();
    } catch(e) {
      print('Logout error: '+ e);
      return e;
    }
  }
}