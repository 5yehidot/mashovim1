import 'package:flutter/material.dart';
import 'ten_feedback_database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ImportNamesListPage extends StatefulWidget {
  @override
  _ImportNamesListPageState createState() => _ImportNamesListPageState();
}

class _ImportNamesListPageState extends State<ImportNamesListPage> {
  final dbHelper = DatabaseHelper.instance;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Student student;
  List<Student> studentlist;
  int updatestIndex;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Text('יבוא שמות ומספרי טלפון'), centerTitle: true),
      body: Container(
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
                          stream: FirebaseFirestore.instance.collection('load_names').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView(
                              padding: const EdgeInsets.only(right: 20.0),
                              children: snapshot.data.docs.map((document) {
                                Student st = Student(
                                    name: document['name'],
                                    phone: document['phone']);
                                print('${st.name}'+' - '+'${st.phone}');

                                dbHelper.insertStudent(st).then((stid) => {
                                  // Insert new feedback record to the feedback table in galaxia database
                                  // and clear the input fields statement, category id and category name
                                  _nameController.clear(),
                                  _phoneController.clear(),
                                });


                                return Text(document['name']+' - '+document['phone'], style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.right,);
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
    );
  }

// Either add feedback record or update feedback record
  void _submitFeedback(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (student == null) {
        //print("******feedback null"); // Create a new feedback record

        FeedbackObject st = FeedbackObject(
            statement: _nameController.text,
            category: _phoneController.text);
        dbHelper.insertFeedback(st).then((stid) => {
          // Insert new feedback record to the feedback table in galaxia database
          // and clear the input fields statement, category id and category name
          _nameController.clear(),
          _phoneController.clear(),
        });
      } else {
        student.name = _nameController.text;
        student.phone = _phoneController.text;
        // Update feedback record in feedback table in galaxia database after it was edited by the user
        dbHelper.updateStudent(student).then((stid) => {
          setState(() {
            studentlist[updatestIndex].name =
                _nameController.text;
            studentlist[updatestIndex].phone =
                _phoneController.text;
          }),
          // Clear input fields
          _nameController.clear(),
          _phoneController.clear(),
        });
        // Clear feedback to allow for new feedback submit
        student = null;
      } // end else feedback is not null
    } // if _formKey
  } // _submitFeedback
}
