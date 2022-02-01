import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'ten_feedback_database_helper.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
//import 'auth_bloc.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'groupModel.dart';
import 'userModel.dart';
import 'inGroup.dart';
import 'joinGroup.dart';
import 'createGroup.dart';
import 'createUser.dart';

import 'splashScreen.dart';
import 'dbStream.dart';

class JoinClassPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    UserModel _userStream = Provider.of<UserModel>(context);
    Widget retVal;
    if (_userStream != null) {
      if (_userStream.groupId != null) {
        retVal = StreamProvider<GroupModel>.value(
          value: DBStream().getCurrentGroup(_userStream.groupId),
          initialData: null,
          child: InGroup(),
        );
      } else {
/*
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "הצטרפות לקבוצה",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () {
              retVal = JoinGroup();
//              return Container();
            },
          ),
        );
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "יצירת קבוצה",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () {
              retVal = CreateGroup();
//              return Container();
            },
          ),
        );
*/
//        retVal = JoinGroup();
        retVal = CreateGroup();
//        retVal = CreateUser();
      }
    } else {
      retVal = SplashScreen();
    }

    return retVal;
  }
}

/*

class JoinClassPage extends StatefulWidget {
  @override
  _JoinClassPageState createState() => _JoinClassPageState();
}

class _JoinClassPageState extends State<JoinClassPage> {
  final dbHelper = DatabaseHelper.instance;
  final _classCodeController = TextEditingController();
  final _categoryNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _groupController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
//  Group groups;
//  List<Group> groupList;
  FeedbackObject feedback;
  DeliveredFeedbackObject tenFeedback;
  List<DeliveredFeedbackObject> tenFeedbackList;
  CategoriesObject listOfCategories;
  List<CategoriesObject> categories;
  List<FeedbackObject> feedbacklist;
  int updateFbIndex;
  int updateNameIndex;
  String fbUserID;
  String fbName;
  var beginningDate = new DateTime(2021, 8, 5);




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final authBloc = Provider.of<AuthBloc>(context);
    DateTime now = DateTime.now();
    // Get the firebase user
    User firebaseUser = FirebaseAuth.instance.currentUser;
    print('Authentication sendfeedback firebaseUser: '+ ' - ' + '${firebaseUser.displayName}');

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.lightBlue[900],
            height: 250.0,
            alignment: Alignment.center,
            child: ListView(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold,),
                              decoration: InputDecoration(
                                  hintText: 'קוד קבוצה',
                                  hintStyle: TextStyle(
                                    color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, ),
                                  labelStyle: TextStyle(
                                    color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, )
                              ),
                              controller: _classCodeController,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold,),
                              decoration: InputDecoration(
                                  hintText: 'שם קבוצה',
                                  hintStyle: TextStyle(
                                    color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, ),
                                  labelStyle: TextStyle(
                                    color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, )
                              ),
                              controller: _groupController,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold,),
                              decoration: InputDecoration(
                                hintText: 'שם מלא',
                                hintStyle: TextStyle(
                                  color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, ),
                                labelStyle: TextStyle(
                                  color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, ),
                              ),
                              controller: _nameController,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold,),
                              decoration: InputDecoration(
                                hintText: 'מספר טלפון נייד',
                                hintStyle: TextStyle(
                                  color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold,  ),
                                labelStyle: TextStyle(
                                  color: Colors.yellow, fontSize: 8, fontWeight: FontWeight.bold, ),
                              ),
                              controller: _phoneController,
                            ),
                          ),

                        ]
                    ),
                  ),
                ]
            ),
          ),
/*
          Container(
            color: Colors.lightBlue[50],
            height: double.infinity,
            width: double.infinity,
            child: ListView(children: <Widget>[

              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: height * 0.95,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('fbGroups').snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                                return ListView(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  children: snapshot.data.docs.map((document) {
                                    Group gr = Group(
                                    groupClass: document['groupClass'],
                                    classCode: document['classCode']);
                                    print('${gr.groupClass}'+' - '+'${gr.classCode}');
                                    return Text(document['groupClass']+' - '+document['classCode'], style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.right,);
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]
            ),
          ),
*/
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          FocusScope.of(context).requestFocus(new FocusNode()); // make soft keyboard disappeared
          if (firebaseUser != null) {
            fbName = firebaseUser.displayName;
            fbUserID = firebaseUser.uid;
            LoggedIn();
          }

/*
          CollectionReference userCollection = FirebaseFirestore.instance.collection('fbUsers');// Create a unique CollectionReference in firestore for each student
          CollectionReference groupCollection = FirebaseFirestore.instance.collection('fbGroups');// Create a unique CollectionReference in firestore for each group

          await groupCollection.doc(_classCodeController.text).update({'groupClass': _groupController.text, 'time': DateTime.now()}).then((value) => print('Group added'));
          await userCollection.doc(fbUserID).update({'sourceID': fbUserID, 'sourceName': fbName, 'name': _nameController.text, 'phone': _phoneController.text, 'classCode': _classCodeController.text, 'groupClass': _groupController.text, 'time': DateTime.now()}).then((value) => print('Class Code added'));
*/

          setState(() {
          });
        },
        label: const Text(''),
        icon: const Icon(Icons.send),
        backgroundColor: Colors.lightBlue,
        splashColor: Colors.yellow,
      ),

    );
  }

}

 */
