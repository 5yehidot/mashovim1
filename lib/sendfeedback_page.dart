import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ten_feedback_database_helper.dart';
import 'package:flutter_sms/flutter_sms.dart';// method to send sms. Opens up the SMS app only, recipients is a required field. It works in emulator, you need to have a list of phone#s before using this method.
//import 'package:share/share.dart';// method to share through Whatsapp, SMS or mail.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'userModel.dart';


class SendFeedbackPage extends StatefulWidget {
  @override
  _SendFeedbackPageState createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {

  final dbHelper = DatabaseHelper.instance;
  final _statementController = TextEditingController();
  final _categoryNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _groupController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  Student student;
  List<Student> studentlist;
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
  String classCode;
  String groupClass;
  String groupN;

  var beginningDate = new DateTime(2021, 8, 5);



  // Create a CollectionReference to the firestore collection named: sent_messages
  CollectionReference collectionReference = FirebaseFirestore.instance.collection("sent_messages");
  User firebaseUser = FirebaseAuth.instance.currentUser;

  void _sendSMS(String message, List<String> recipents) async {
    var permission = Permission.sms.status;
    print('SMS_Permission status is: ' + '$permission');
    Map<Permission, PermissionStatus> statuses = await [
      Permission.sms,
//      Permission.location,
//      Permission.storage,
    ].request();
    print(statuses[Permission.sms]);
//    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.sms]);
    String _result = await sendSMS(
        message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
/*  void _fetchGroupClass() async {
    if (firebaseUser != null) {
      fbName = firebaseUser.displayName;
      fbUserID = firebaseUser.uid;

      DocumentSnapshot ds = await FirebaseFirestore.instance.collection(fbUserID).doc('xjm1alt32SIj5tTit5zx').get();
      classCode=ds['classCode'];
      groupClass=ds['groupClass'];

      setState(() {
        print(classCode);
        print(groupClass);
        _groupController.text = groupClass;

      });

    }
  }*/
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final authBloc = Provider.of<AuthBloc>(context);
    DateTime now = DateTime.now();
    // Get the firebase user
//    User firebaseUser = FirebaseAuth.instance.currentUser;
    print('Authentication sendfeedback firebaseUser: '+ ' - ' + '${firebaseUser.displayName}');

    void updateGroupName() async {
      groupN = await _fetchGroup(firebaseUser.uid);
        print('GROUPN is:' + groupN);
//      print('User Model groupId is: ' + '${UserModel().userId}');
//        print('User Model groupName is: ' + '${UserModel().groupName}');
    };
    setState(() {
      updateGroupName();
//      print('Update group name is:' + groupN);

    });


    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.lightBlue[900],
            height: 200.0,
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
                              hintText: 'כאן מוצגת הקבוצה של השם שנבחר',
                              hintStyle: TextStyle(
                                color: Colors.yellowAccent, fontSize: 8, fontWeight: FontWeight.bold, ),
                              labelStyle: TextStyle(
                                color: Colors.yellow, fontSize: 8, fontWeight: FontWeight.bold, ),
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
                            hintText: 'בחר/י היגד משוב מהרשימה מימין',
                            hintStyle: TextStyle(
                              color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, ),
                            labelStyle: TextStyle(
                              color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold, )
                            ),
                            controller: _statementController,
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
                              hintText: 'בחר/י שם מהרשימה משמאל',
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
                              hintText: 'כאן מוצג מספר טלפון של השם שנבחר',
                              hintStyle: TextStyle(
                                color: Colors.yellowAccent, fontSize: 8, fontWeight: FontWeight.bold, ),
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
          Container(
            color: Colors.lightBlue[50],

            height: height * 0.6,
            width: width,

            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Form(
                        key: _formKey1,
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
                                  stream: FirebaseFirestore.instance.collection('fbGroups')
//                                      .where('groupName', isEqualTo: 'דרור23')
                                      .where('groupName', isEqualTo: groupN)
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
                                        itemCount: snapshot.data.docs.first ['groupMembers'].length,
                                        itemBuilder: (ctx, i) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
//                                                SizedBox(height: 0.5,),

                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.purpleAccent,
                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                      border: Border.all(color: Colors.grey)
                                                  ),

                                                  child: ListTile(
                                                    title: Text(snapshot.data.docs.first.get('groupMembers')[i], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                                    subtitle: Text(snapshot.data.docs.first.get('groupMemberPhones')[i], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                                    onTap: (){
                                                      print('On tap group members length is: ');
                                                      print(snapshot.data.docs.first ['groupMembers'].length);
                                                      _nameController.text = snapshot.data.docs.first.get('groupMembers')[i];
                                                      _phoneController.text = snapshot.data.docs.first.get('groupMemberPhones')[i];
                                                      _groupController.text = groupN;
                                                      print('On tap group name is: ' + groupN);
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

                            /*
                            FutureBuilder(
                              future: dbHelper.getStudentList(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                  studentlist = snapshot.data;
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: studentlist == null ? 0 : studentlist.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      Student st = studentlist[index];
                                      return Card(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.all(2.0),
                                              color: Colors.purple[50],
                                              width: width * 0.45,
                                              height: 30.0,
                                              child: TextButton(
                                                onPressed: () {// make a student card clickable
                                                            // Update input fields with current name and phone if user clicks on a student card
                                                  _nameController.text = st.name;
                                                  _groupController.text = st.groupClass;
                                                  _phoneController.text = st.phone;
                                                  print('Single-select Phone: ' + _phoneController.text);
                                                  student = st; // Notify submitstudent that student is not null
                                                  updateNameIndex = index; // Notify list builder which card needs update
                                                }, // onPressed
                                                onLongPress: () {// make a student card clickable
                                                  // Update input fields with current name and phone if user clicks on a student card
                                                  _nameController.text = _nameController.text + ',' + st.name;
                                                  _phoneController.text = _phoneController.text + ',' + st.phone;
                                                  print('Multi-select name: ' + _nameController.text);
                                                  print('Multi-select Phone: ' + _phoneController.text);
                                                  student = st; // Notify submitstudent that student is not null
                                                  updateNameIndex = index; // Notify list builder which card needs update
                                                }, // onPressed
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      '${st.name}',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }, // itemBuilder
                                    reverse: true,
                                  );
                                } // if
                                else {
                                  if (snapshot.hasError) {
                                    print('Error: ${snapshot.error}');
                                  } else {
                                      return CircularProgressIndicator();
                                    } // else
                                  }
                                return CircularProgressIndicator();
                              }, // builder
                            ),
*/
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
                 Expanded(
                   child: ListView(
                     children: <Widget>[
                       Form(
                         key: _formKey2,
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             FutureBuilder(
                               future: dbHelper.getFeedbackList(),
                               builder: (context, snapshot) {
                                 if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                   feedbacklist = snapshot.data;
                                   return ListView.builder(
                                     shrinkWrap: true,
                                     physics: NeverScrollableScrollPhysics(),
                                     itemCount: feedbacklist == null ? 0 : feedbacklist.length,
                                     itemBuilder: (BuildContext context, int index) {
                                       FeedbackObject fb = feedbacklist[index];
                                       return Card(
                                         child: Row(
                                           children: <Widget>[
                                             Container(
                                               margin: const EdgeInsets.all(2.0),
                                               color: Colors.purple[50],
                                               width: width * 0.455,
                                               height: 120.0,
                                               child: TextButton(
                                                 onPressed: () {// make a student card clickable
                                                                // Update input fields with current statement and category if user clicks on a feedback card
                                                   _statementController.text = fb.statement;
                                                   _categoryNameController.text = fb.category;
                                                   feedback = fb; // Notify submitFeedback that feedback is not null
                                                   updateFbIndex = index; // Notify list builder which card needs update
                                                 }, // onPressed
                                                 child: Column(
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   crossAxisAlignment: CrossAxisAlignment.center,
                                                   children: <Widget>[
                                                     Text(
                                                       '${fb.statement}',
                                                       style: TextStyle(
                                                         fontSize: 10,
                                                         color: Colors.blue,
                                                         fontWeight: FontWeight.bold,
                                                       ),
                                                       textAlign: TextAlign.center,
                                                     ),
                                                     Text(
                                                       '${fb.category}',
                                                       style: TextStyle(
                                                         fontSize: 8,
                                                         color: Colors.black,
                                                         fontWeight: FontWeight.bold
                                                       ),
                                                       textAlign: TextAlign.center,
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ),
                                       );
                                     }, // itemBuilder
                                     reverse: true,
                                   );
                                 } // if
                                 else {
                                   if (snapshot.hasError) {
                                     print('Error: ${snapshot.error}');
                                   } else {
                                     return CircularProgressIndicator();
                                   } // else
                                 }
                                 return CircularProgressIndicator();
                               }, // builder
                             ),
                           ],
                         ),
                       ),
                     ]
                   ),
                 ),
               ],
              ),
            ),

/*
            Container(
              color: Colors.white70,
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [

                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30.0,
                      alignment: Alignment.center,

                      child: StreamBuilder<User>(
                        stream: authBloc.currentUser,
                        builder: (context, snapshot) {
                          if (firebaseUser.displayName != null)
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(' זמן שליחת ההודעה האחרונה '+firebaseUser.displayName+' '+'${now.hour}'+':'+'${now.minute}'+':'+'${now.second}', style: TextStyle(fontSize: 10.0)),
                                //Text(snapshot.data.displayName, style: TextStyle(fontSize: 15.0)),
                              ],
                            );
                          else return CircularProgressIndicator();
                                                  },
                      ),
                    ),
                  ),


                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('sent_messages').where('time', isGreaterThan: now.subtract(const Duration(minutes: 5))).orderBy('time', descending: true).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                          padding: const EdgeInsets.only(right: 20.0),
                          children: snapshot.data.docs.map((document) {
                            return ListTile(title: Text(document['message'], style: TextStyle(fontSize: 10.0, color: Colors.purple, fontWeight: FontWeight.bold), textAlign: TextAlign.right,));
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
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

/*
              DocumentSnapshot ds = await FirebaseFirestore.instance.collection(fbUserID).doc('s3Rr8nfBIQU9n2xCAm3zeENCkFq1').get();
                classCode=ds['classCode'];
*/

                setState(() {
/*
                  print(classCode);
                  print(groupClass);
*/

                });

            }
            List<String> nameList = _nameController.text.split(",");
            List<String> phoneList = _phoneController.text.split(",");
            if (nameList.length > 1) {
              for (int j = 0; j < nameList.length; j++) {
                print('hello ${nameList[j]}');
                String sendMessage = ' הידד ${nameList[j]}, ${_statementController.text}';
//                await collectionReference.add({'sourceID': fbUserID, 'sourceName': fbName, 'name': nameList[j], 'groupClass': _groupController.text, 'message': sendMessage, 'category': _categoryNameController.text, 'time': DateTime.now(), 'phone': phoneList[j], 'classCode': classCode}).then((value) => print('Message added'));
                await collectionReference.add({'sourceID': fbUserID, 'sourceName': fbName, 'name': nameList[j], 'groupClass': _groupController.text, 'message': sendMessage, 'category': _categoryNameController.text, 'time': DateTime.now(), 'phone': phoneList[j]}).then((value) => print('Message added'));
                _sendSMS(sendMessage, [phoneList[j]]);
              }
            } else {
              String sendMessage = ' הידד ${_nameController.text}, ${_statementController.text}';
//              await collectionReference.add({'sourceID': fbUserID, 'sourceName': fbName, 'name': _nameController.text, 'groupClass': _groupController.text, 'message': sendMessage, 'category': _categoryNameController.text, 'time': DateTime.now(), 'phone': _phoneController.text, 'classCode': classCode}).then((value) => print('Message added'));
              await collectionReference.add({'sourceID': fbUserID, 'sourceName': fbName, 'name': _nameController.text, 'groupClass': _groupController.text, 'message': sendMessage, 'category': _categoryNameController.text, 'time': DateTime.now(), 'phone': _phoneController.text}).then((value) => print('Message added'));
              _sendSMS(sendMessage, [_phoneController.text]);

            }
            //Share.share(' כל הכבוד $sendMessage');

            setState(() {
              _submitTenFeedback(context);
            });
          },
        label: const Text(''),
        icon: const Icon(Icons.send),
        backgroundColor: Colors.lightBlue,
        splashColor: Colors.yellow,
    ),

    );
  }

// Either add feedback record or update feedback record
  void _submitTenFeedback(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (tenFeedback == null) {
        DeliveredFeedbackObject ten = DeliveredFeedbackObject(
            recipient: _nameController.text,
            recipientPhone: _phoneController.text,
            recipientGroupClass: _groupController.text,
            recipientGroup: 'null recipient group',
            topic: 'null topic',
            category: _categoryNameController.text,
            statement:  _statementController.text,
            statementID: 'null statementID',
            senderName: 'null senderName',
            senderPhone: 'null senderPhone',
            timeStamp: 'null timeStamp');
        dbHelper.insertDeliveredFeedback(ten).then((tenid) =>
        {
          // Insert new feedback record to the feedback table in galaxia database
          // and clear the input fields statement, category id and category name
          _statementController.clear(),
          _nameController.clear(),
          _groupController.clear(),
          _phoneController.clear(),
          _categoryNameController.clear(),
        });
      } else {
        tenFeedback.statement = _statementController.text;
        tenFeedback.category = _categoryNameController.text;
        tenFeedback.recipient = _nameController.text;
        tenFeedback.recipientGroupClass = _groupController.text;

        // Update feedback record in feedback table in galaxia database after it was edited by the user
        dbHelper.updateDeliveredFeedback(tenFeedback).then((tenid) => {
          setState(() {
            tenFeedbackList[updateFbIndex].statement =
                _statementController.text;
            studentlist[updateNameIndex].name = _nameController.text;
            studentlist[updateNameIndex].groupClass = _groupController.text;

          }),
          // Clear input fields
          _statementController.clear(),
          _nameController.clear(),
          _phoneController.clear(),
          _groupController.clear(),
          _categoryNameController.clear(),

        });
        // Clear feedback to allow for new feedback submit
        tenFeedback = null;
      } // end else feedback is not null
    } // if _formKey
  } // _submitTenFeedback
  Future<String> _fetchGroup(String userId) async {
    String retVal = "error";
    try {
      DocumentSnapshot groupName = await FirebaseFirestore.instance.collection(
          'fbUsers').doc(userId).get();
      String myGroupName = groupName['groupName'];
      print('myGroupName is: ' + myGroupName);
      retVal = myGroupName;
//      print('myOtherGroupName is: ' + retVal);
    } catch (e) {
      print(e);
    }
    return retVal;
  }

}
