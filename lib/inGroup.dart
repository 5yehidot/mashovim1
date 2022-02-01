import 'groupModel.dart';
import 'userModel.dart';
import 'homepage.dart';
//import 'joinGroup.dart';
import 'auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dbFuture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'login_page.dart';

class InGroup extends StatefulWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  InGroupState createState() => InGroupState();
}

class InGroupState extends State<InGroup> {
  final key = new GlobalKey<ScaffoldState>();
  // Get the firebase user
  User firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

/*  void _signOut(BuildContext context) async {
    String retVal = "error";
    try {
      await authBloc.logout();
      retVal = "success";
    } catch (e) {
      print(e);
    }
    if (retVal == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
            (route) => false,
      );
    }
  }*/

  void _switchGroup(BuildContext context) async {
    GroupModel group = Provider.of<GroupModel>(context, listen: false);
    UserModel user = Provider.of<UserModel>(context, listen: false);
    String _returnString = await DBFuture().joinGroup(group.id, firebaseUser.uid, firebaseUser.displayName);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
            (route) => false,
      );
    }
  }

/*

  void _leaveGroup(BuildContext context) async {
    GroupModel group = Provider.of<GroupModel>(context, listen: false);
    UserModel user = Provider.of<UserModel>(context, listen: false);
    String _returnString = await DBFuture().leaveGroup(group.id, user);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
            (route) => false,
      );
    }
  }
*/

/*
  void _copyGroupId(BuildContext context) {
    GroupModel group = Provider.of<GroupModel>(context, listen: false);
    if (group.id != '') {
      Clipboard.setData(ClipboardData(text: group.id));
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text('הועתק!'),
          duration: Duration(seconds: 2),
        ),
     );
    } else {print('אין אף קבוצה מוגדרת במערכת');};
  }
*/

//  final dbHelper = DatabaseHelper.instance;
  final _classCodeController = TextEditingController();
//  final _categoryNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _groupController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String fbUserID;
  String fbName;
  var beginningDate = new DateTime(2021, 8, 5);




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final authBloc = Provider.of<AuthBloc>(context);
    final userModel = Provider.of<UserModel>(context);
    final groupModel = Provider.of<GroupModel>(context);
    DateTime now = DateTime.now();
    // Get the firebase user
    User firebaseUser = FirebaseAuth.instance.currentUser;

    GroupModel group = Provider.of<GroupModel>(context, listen: false);
    print('GROUP ' + '$group.id');
    print('Authentication sendfeedback firebaseUser: '+ ' - ' + '${firebaseUser.displayName}');

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.lightBlue[900],
            height: 550.0,
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
                          hintStyle: TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, ),
                            labelStyle: TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, )
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
                            hintStyle: TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, ),
                            labelStyle: TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, )
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
                            hintStyle: TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, ),
                            labelStyle: TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, ),
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
                            hintStyle: TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold,  ),
                            labelStyle: TextStyle(color: Colors.yellow, fontSize: 8, fontWeight: FontWeight.bold, ),
                          ),
                          controller: _phoneController,
                        ),
                      ),
/*
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextButton(
                          child: Text("העתקת קוד קבוצה"),
                          onPressed: () => _copyGroupId(context),
                        ),
                      ),
*/
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                        child: TextButton(
                          child: Text("החלפת קבוצה"),
                          onPressed: () => _switchGroup(context),
                        ),
                      ),
/*
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                        child: TextButton(
                          child: Text("יציאה מקבוצה"),
                          onPressed: () => _leaveGroup(context),
                        ),
                      ),
*/

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
// Add container here
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
      onPressed: () async {
        FocusScope.of(context).requestFocus(new FocusNode()); // make soft keyboard disappeared
          if (firebaseUser != null) {
            fbName = firebaseUser.displayName;
            fbUserID = firebaseUser.uid;
            //LoggedIn();
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
/*

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
*/
/*
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: IconButton(
                  onPressed: () => _signOut(context),
                  icon: Icon(Icons.exit_to_app),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
*//*

            ],
          ),
         Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextButton(
              child: Text("העתקת קוד קבוצה"),
              onPressed: () => _copyGroupId(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: TextButton(
              child: Text("החלפת קבוצה"),
              onPressed: () => _switchGroup(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: TextButton(
              child: Text("יציאה מקבוצה"),
              onPressed: () => _leaveGroup(context),
            ),
          ),
        ],
      ),
    );
  }
}*/
