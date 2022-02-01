import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ten_feedback_database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final dbHelper = DatabaseHelper.instance;
  final _statementController = TextEditingController();
  final _categoryNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
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
  var beginningDate = new DateTime(2021, 8, 5);
//  int filterByNumberOfDays;
  String nameSelect;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final authBloc = Provider.of<AuthBloc>(context);
    DateTime now = DateTime.now();

    // Get the firebase user
    User firebaseUser = FirebaseAuth.instance.currentUser;
    print(firebaseUser);
    if (firebaseUser != null) {
      fbName = firebaseUser.displayName;
      fbUserID = firebaseUser.uid;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('דיווח הודעות שנשלחו'),
      ),
      body:
      Column(
        children: [

          Container(
            color: Colors.lightBlue[900],
            height: MediaQuery.of(context).size.height * 0.06,
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
                                hintText: 'דו"ח לתלמיד - בחירה מהרשימה',
                                hintStyle: TextStyle(
                                  color: Colors.yellowAccent, fontSize: 10, fontWeight: FontWeight.bold, ),
                                labelStyle: TextStyle(
                                  color: Colors.yellowAccent, fontSize: 10, fontWeight: FontWeight.bold, ),
                              ),
                              controller: _nameController,
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
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),),
                            onPressed: () {// make a student card clickable
                              _nameController.text = '';
                              FocusScope.of(context).requestFocus(new FocusNode()); // make soft keyboard disappeared
                            }, // onPressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'בחירת תלמיד/ה לדו"ח',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Form(
                          key: _formKey1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
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
                                        //print(st.name);
                                        return Card(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin: const EdgeInsets.all(2.0),
                                                color: Colors.purple[500],
                                                width: width * 0.45,
                                                height: 30.0,
                                                child: TextButton(
                                                  onPressed: () {// make a student card clickable
                                                    // Update input fields with current name and phone if user clicks on a student card
                                                    _nameController.text = st.name;
                                                    student = st; // Notify submitstudent that student is not null
                                                    updateNameIndex = index; // Notify list builder which card needs update
                                                    var route = MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                          ReportPage(value: _nameController.text),
                                                    );
                                                    Navigator.of(context).push(route);

                                                  }, // onPressed
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                        '${st.name}',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white,
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
                            ],
                          ),
                        ),
                      ]
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextButton(
                          onPressed: () {
                            //Stream<QuerySnapshot> _myStream = FirebaseFirestore.instance.collection('sent_messages').where('time', isGreaterThan: now.subtract(const Duration(days: 1))).snapshots();
                            print('One Day Report Selected');
                          }, // onPressed
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'משובים מהיממה האחרונה',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('sent_messages').where('sourceID', isEqualTo: fbUserID).where('time', isGreaterThan: now.subtract(Duration(days: 1))).orderBy('time', descending: true).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView(
                              padding: const EdgeInsets.only(right: 20.0),
                              children: snapshot.data.docs.map((document) {
                                //print('Snapshot length');
                                //print(snapshot.data.docs.length);
                                return ListTile(title: Text(document['message'], style: TextStyle(fontSize: 10.0, color: Colors.purple, fontWeight: FontWeight.bold), textAlign: TextAlign.right,));
                              }).toList(),
                            );
                          },
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          //Stream<QuerySnapshot> _myStream = FirebaseFirestore.instance.collection('sent_messages').where('time', isGreaterThan: now.subtract(const Duration(days: 7))).snapshots();
                          print('One Week Report Selected');
                        }, // onPressed
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'משובים מהשבוע האחרון',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('sent_messages').where('sourceID', isEqualTo: fbUserID).where('time', isGreaterThan: now.subtract(Duration(days: 7))).orderBy('time', descending: true).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView(
                              padding: const EdgeInsets.only(right: 20.0),
                              children: snapshot.data.docs.map((document) {
                                //print('Snapshot length');
                                //print(snapshot.data.docs.length);

                                return ListTile(title: Text(document['message'], style: TextStyle(fontSize: 10.0, color: Colors.purple, fontWeight: FontWeight.bold), textAlign: TextAlign.right,));
                              }).toList(),
                            );
                          },
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          //Stream<QuerySnapshot> _myStream = FirebaseFirestore.instance.collection('sent_messages').where('time', isGreaterThan: now.subtract(const Duration(days: 30))).snapshots();
                          print('One Month Report Selected');
                        }, // onPressed
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'משובים מהחודש האחרון',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('sent_messages').where('sourceID', isEqualTo: fbUserID).where('time', isGreaterThan: now.subtract(Duration(days: 30))).orderBy('time', descending: true).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView(
                              padding: const EdgeInsets.only(right: 20.0),
                              children: snapshot.data.docs.map((document) {
                                //print('Snapshot length');
                                //print(snapshot.data.docs.length);

                                return ListTile(title: Text(document['message'], style: TextStyle(fontSize: 10.0, color: Colors.purple, fontWeight: FontWeight.bold), textAlign: TextAlign.right,));
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //Stream<QuerySnapshot> _myStream = FirebaseFirestore.instance.collection('sent_messages').where('time', isGreaterThan: now.subtract(const Duration(days: 7))).snapshots();
                          print('One Week Report Selected');
                        }, // onPressed
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'כל המשובים',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('sent_messages').where('sourceID', isEqualTo: fbUserID).orderBy('time', descending: true).snapshots(),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class ReportPage extends StatefulWidget {
  final String value;
  ReportPage({Key key, this.value}) : super (key: key);
  @override
  _ReportPageState createState() => _ReportPageState();

}
class _ReportPageState extends State<ReportPage> {


  @override
  Widget build(BuildContext contect) {
    DateTime now = DateTime.now();
    final authBloc = Provider.of<AuthBloc>(context);
    // Get the firebase user
    User firebaseUser = FirebaseAuth.instance.currentUser;
    String fbUserID;
    String fbName;

    if (firebaseUser != null) {
      fbName = firebaseUser.displayName;
      fbUserID = firebaseUser.uid;
    }

    String nameSelect = widget.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('משובים ל: '+nameSelect),
      ),
      body:
      Column(
        children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('sent_messages').where('sourceID', isEqualTo: fbUserID).where('name', isEqualTo: nameSelect).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 10.0),
                    child: Text(
                      'מספר המשובים הכולל: ' + '${snapshot.data.docs.length}',
                      style: TextStyle(fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () {
                //Stream<QuerySnapshot> _myStream = FirebaseFirestore.instance.collection('sent_messages').where('time', isGreaterThan: now.subtract(const Duration(days: 1))).snapshots();
                print('One Day Report Selected');
              }, // onPressed
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'משובים מהיממה האחרונה',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('sent_messages').where('sourceID', isEqualTo: fbUserID).where('name', isEqualTo: nameSelect).where('time', isGreaterThan: now.subtract(Duration(days: 1))).orderBy('time', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.only(right: 20.0),
                  children: snapshot.data.docs.map((document) {
                    //print('Snapshot length');
                    //print(snapshot.data.docs.length);
                    return ListTile(title: Text(document['message'], style: TextStyle(fontSize: 10.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.right,),);
                  }).toList(),
                );
              },
            ),
          ),

          TextButton(
            onPressed: () {
              //Stream<QuerySnapshot> _myStream = FirebaseFirestore.instance.collection('sent_messages').where('time', isGreaterThan: now.subtract(const Duration(days: 7))).snapshots();
              print('One Week Report Selected');
            }, // onPressed
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'משובים מהשבוע האחרון',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('sent_messages').where('sourceID', isEqualTo: fbUserID).where('name', isEqualTo: nameSelect).where('time', isGreaterThan: now.subtract(Duration(days: 7))).orderBy('time', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.only(right: 20.0),
                  children: snapshot.data.docs.map((document) {
                    //print('Snapshot length');
                    //print(snapshot.data.docs.length);

                    return ListTile(title: Text(document['message'], style: TextStyle(fontSize: 10.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.right,));
                  }).toList(),
                );
              },
            ),
          ),

          TextButton(
            onPressed: () {
              //Stream<QuerySnapshot> _myStream = FirebaseFirestore.instance.collection('sent_messages').where('time', isGreaterThan: now.subtract(const Duration(days: 30))).snapshots();
              print('One Month Report Selected');
            }, // onPressed
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'משובים מהחודש האחרון',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('sent_messages').where('sourceID', isEqualTo: fbUserID).where('name', isEqualTo: nameSelect).where('time', isGreaterThan: now.subtract(Duration(days: 30))).orderBy('time', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.only(right: 20.0),
                  children: snapshot.data.docs.map((document) {
                    //print('Snapshot length');
                    //print(snapshot.data.docs.length);

                    return ListTile(title: Text(document['message'], style: TextStyle(fontSize: 10.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.right,));
                  }).toList(),
                );
              },
            ),
          ),
          TextButton(
            onPressed: () {
              //Stream<QuerySnapshot> _myStream = FirebaseFirestore.instance.collection('sent_messages').where('time', isGreaterThan: now.subtract(const Duration(days: 7))).snapshots();
              print('One Week Report Selected');
            }, // onPressed
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'כל המשובים',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('sent_messages').where('sourceID', isEqualTo: fbUserID).where('name', isEqualTo: nameSelect).orderBy('time', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.only(right: 20.0),
                  children: snapshot.data.docs.map((document) {
                    return ListTile(title: Text(document['message'], style: TextStyle(fontSize: 10.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.right,));
                  }).toList(),
                );
              },
            ),
          ),

        ],
      ),

    );
  }
}