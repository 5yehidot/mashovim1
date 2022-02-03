import 'package:feedback_flutter_app/homepage.dart';
import 'package:flutter/material.dart';
import 'dbFuture.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CreateGroup extends StatefulWidget {
//  final UserModel userModel;
//  CreateGroup({this.userModel});

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  // Get the firebase user
  User firebaseUser = FirebaseAuth.instance.currentUser;

  void _goToAddGroup(BuildContext context, String groupName) async {
    print('${firebaseUser.displayName}');
    print(groupName);
    String _returnString = await DBFuture().createGroup(groupName, firebaseUser.uid, firebaseUser.displayName);
    if (_returnString == "success") {
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
          content:Text(_returnString),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      4.0,
                      4.0,
                    ),
                  )
                ],
              ),

              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "שם הקבוצה",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
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
          _goToAddGroup(context, _groupNameController.text);

        },
        label: const Text('יצירה'),
        icon: const Icon(Icons.send),
        backgroundColor: Colors.lightBlue,
        splashColor: Colors.yellow,
      ),

    );
  }
}