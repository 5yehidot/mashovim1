import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'homepage.dart';
import 'package:provider/provider.dart';
import 'auth_bloc.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}
class _LoginPageState extends State<LoginPage> {
  StreamSubscription<User> loginStateSubscription;

  @override
    void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    });
    super.initState();
    }
  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text('נותנים משוב מקדם למידה'),),
      body: Center(
        child: Container(
          width: 400.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Image.network('http://clipart-library.com/img/2102827.jpg'),
                  height: 300.0,
                  width: 300.0,
                ),
                ),
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('מקדמים התפתחות', style: TextStyle(fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('באמצעות משובים', style: TextStyle(fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: SignInButton(
                  Buttons.GoogleDark,
                  onPressed: () => authBloc.loginGoogle(),
                  text: 'Sign in',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('הזדהות באמצעות חשבון גוגל', style: TextStyle(fontSize: 10.0, color: Colors.blue, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}