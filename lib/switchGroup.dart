//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:feedback_flutter_app/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dbFuture.dart';
import 'package:flutter/material.dart';

class SwitchGroup extends StatefulWidget {
//  final UserModel userModel;

//  JoinGroup({this.userModel});
  @override
  _SwitchGroupState createState() => _SwitchGroupState();
}

class _SwitchGroupState extends State<SwitchGroup> {
//  GroupsObject groups;
//  List<GroupsObject> GroupsList;
  // Get the firebase user
  User firebaseUser = FirebaseAuth.instance.currentUser;

  void _switchGroup(BuildContext context, String groupId) async {
//    print('${firebaseUser.displayName}');
//    print(groupId);
    String _returnString1 = await DBFuture().joinGroup(groupId, firebaseUser.uid, firebaseUser.displayName);
    setState(() {});

    if ((_returnString1 == "success")) {
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
          content: Text(_returnString1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  TextEditingController _groupIdController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    int myGroupsLength;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('החלפת קבוצה'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightBlue[50],
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: height * 0.6,
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('fbUsers')
                      .where('userId', isEqualTo: firebaseUser.uid)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                      return Container(
                        width: width/1.2,
                        height: height/2,
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.first.get('myGroups').length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),

                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.purpleAccent,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        border: Border.all(color: Colors.grey)
                                    ),

                                    child: ListTile(
                                      title: Text(snapshot.data.docs.first.get('myGroups')[i], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                      subtitle: Text(snapshot.data.docs.first.get('myGroupIds')[i], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                      onTap: () {
                                        _groupIdController.text =
                                        snapshot.data.docs.first.get(
                                            'myGroupIds')[i];
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                  },
                ),
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

                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          FocusScope.of(context).requestFocus(new FocusNode()); // make soft keyboard disappeared
          _switchGroup(context, _groupIdController.text);
//          print(_groupIdController.text);
          setState(() {});
        },
        label: const Text('שליחה'),
        icon: const Icon(Icons.send),
        backgroundColor: Colors.lightBlue,
        splashColor: Colors.yellow,
      ),
    );
  }
}
