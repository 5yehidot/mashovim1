import 'package:flutter/material.dart';
import 'login_page.dart';
import 'auth_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBloc>(create: (context) => AuthBloc()),
        //Provider<UserModel>(create: (context) => UserModel()),
        //Provider<GroupModel>(create: (context) => GroupModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mashovim',
        theme: ThemeData(
          backgroundColor: Colors.black,
          primarySwatch: Colors.purple,
        ),
        home: LoginPage(),
      ),
    );
  }
}
