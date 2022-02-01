import 'package:flutter/cupertino.dart';
import 'package:feedback_flutter_app/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'userModel.dart';
import 'dbFuture.dart';
import 'package:flutter/material.dart';

class JoinGroup extends StatefulWidget {
//  final UserModel userModel;

//  JoinGroup({this.userModel});
  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  // Get the firebase user
  User firebaseUser = FirebaseAuth.instance.currentUser;

  void _joinGroup(BuildContext context, String groupId) async {
//    UserModel _currentUser = widget.userModel;
    print('${firebaseUser.displayName}');
    print(groupId);
    String _returnString1 = await DBFuture().joinGroup(groupId, firebaseUser.uid, firebaseUser.displayName);
    print(_returnString1);

//    String _returnString = await DBFuture().createGroup(groupName, firebaseUser.uid, firebaseUser.displayName);
//    String _returnString2 = await DBFuture().joinGroup(groupId, firebaseUser.uid);
//    if ((_returnString1 == "success") & (_returnString2 == "success")) {
    if ((_returnString1 == "success") ) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
              (route) => false);
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text(_returnString1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  TextEditingController _groupIdController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _groupIdController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "קוד קבוצה",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

/*
                  TextButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Text(
                        "הצטרפות",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      _joinGroup(context, _groupIdController.text);
                    },
                  ),
*/
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          FocusScope.of(context).requestFocus(new FocusNode()); // make soft keyboard disappeared
          _joinGroup(context, _groupIdController.text);
          print(_groupIdController.text);
        },
        label: const Text('הצטרפות'),
        icon: const Icon(Icons.send),
        backgroundColor: Colors.lightBlue,
        splashColor: Colors.yellow,
      ),

    );
  }
}