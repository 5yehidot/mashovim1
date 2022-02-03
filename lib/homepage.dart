import 'package:feedback_flutter_app/reports.dart';
import 'package:flutter/material.dart';
import 'feedbacklist.dart';
import 'reports.dart';
import 'sendfeedback_page.dart';
import 'ten_feedback_database_helper.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';
import 'auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'import_messages.dart';
import 'joinGroup.dart';
import 'createGroup.dart';
import 'switchGroup.dart';
import 'createUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget
{
  // reference to our single class that manages the database
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  StreamSubscription<User> loginStateSubscription;
  User firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);

    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    });
    super.initState();

    }
void signUp() async {
  DocumentSnapshot ds = await FirebaseFirestore.instance.collection('fbUsers')
      .doc(firebaseUser.uid)
      .get();
  String phone = ds['phone'];
  print('Signup phone is:' + phone);
  if (phone == 'null') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateUser()),
    );
  }
}
  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }
    @override
  Widget build(BuildContext context)
  {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold
      (
      appBar: AppBar(title: Text('נותנים משוב מקדם למידה'),),
      body: Center(
        child:  Container(
          child: SendFeedbackPage(),
          ),
            ),
      drawer: Drawer
        (
        child: ListView
          (
          children: <Widget>
          [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: StreamBuilder<User>(
                stream: authBloc.currentUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //print(snapshot.data.photoURL);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Welcome', style: TextStyle(fontSize: 10.0)),
                        Text(snapshot.data.displayName, style: TextStyle(
                            fontSize: 15.0)),
                        SizedBox(height: 20.0,),
                        CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data.photoURL
                              .replaceFirst('s96', 's400')),
                          radius: 30.0,
                        ),
                      ],
                    );
                  } else {return CircularProgressIndicator();}
              }
            ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
//                  MaterialPageRoute(builder: (context) => JoinClassPage()),
                  MaterialPageRoute(builder: (context) => SwitchGroup()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.note_add),
                title: Text('בחירת קבוצה'),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyFeedbackListPage()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.note_add),
                title: Text('הודעות משוב'),
              ),
            ),
            Divider(),

            TextButton(
              onPressed: () {
                //print('דוחות');
                //return MyStudentPage();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Reports()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.data_usage),
                title: Text('דוחות'),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
//                  MaterialPageRoute(builder: (context) => JoinClassPage()),
                  MaterialPageRoute(builder: (context) => CreateGroup()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.note_add),
                title: Text('קבוצה חדשה'),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
//                  MaterialPageRoute(builder: (context) => JoinClassPage()),
                  MaterialPageRoute(builder: (context) => JoinGroup()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.note_add),
                title: Text('הצטרפות לקבוצה'),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImportFeedbackListPage()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.import_export),
                title: Text('יבוא הודעות משוב בהתקנה',style: TextStyle(
                  fontSize: 7,
                  color: Colors.red,
                ),),
              ),
            ),
            Divider(),

            TextButton(
              onPressed: () {
                print('יציאה');
                //return MyStudentPage();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => authBloc.logout()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('יציאה'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
