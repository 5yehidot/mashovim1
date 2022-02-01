import 'package:flutter/material.dart';
import 'ten_feedback_database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ImportFeedbackListPage extends StatefulWidget {
  @override
  _ImportFeedbackListPageState createState() => _ImportFeedbackListPageState();
}

class _ImportFeedbackListPageState extends State<ImportFeedbackListPage> {
  final dbHelper = DatabaseHelper.instance;
  final _statementController = TextEditingController();
  final _categoryNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FeedbackObject feedback;
  CategoriesObject listOfCategories;
  List<CategoriesObject> categories;
  List<FeedbackObject> feedbacklist;
  int updatefbIndex;
  int updateCatIndex;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Text('יבוא היגדי משוב'), centerTitle: true),
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
                          stream: FirebaseFirestore.instance.collection('premade_messages').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView(
                              padding: const EdgeInsets.only(right: 20.0),
                              children: snapshot.data.docs.map((document) {
                                FeedbackObject fb = FeedbackObject(
                                    statement: document['message'],
                                    category: document['category']);
                                print('${fb.category}'+' - '+'${fb.statement}');

                                dbHelper.insertFeedback(fb).then((fbid) => {
                                  // Insert new feedback record to the feedback table in galaxia database
                                  // and clear the input fields statement, category id and category name
                                  _statementController.clear(),
                                  _categoryNameController.clear(),
                                });


                                return Text(document['category']+' - '+document['message'], style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.right,);
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

// Add feedback record or update feedback record
  void _submitFeedback(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (feedback == null) {

        FeedbackObject fb = FeedbackObject(
            statement: _statementController.text,
            category: _categoryNameController.text);
        dbHelper.insertFeedback(fb).then((fbid) => {
          // Insert new feedback record to the feedback table in galaxia database
          // and clear the input fields statement, category id and category name
          _statementController.clear(),
          _categoryNameController.clear(),
        });
      } else {
        feedback.statement = _statementController.text;
        feedback.category = _categoryNameController.text;
        // Update feedback record in feedback table in galaxia database after it was edited by the user
        dbHelper.updateFeedback(feedback).then((fbid) => {
          setState(() {
            feedbacklist[updatefbIndex].statement =
                _statementController.text;
            feedbacklist[updatefbIndex].category =
                _categoryNameController.text;
          }),
          // Clear input fields
          _statementController.clear(),
          _categoryNameController.clear(),
        });
        // Clear feedback to allow for new feedback submit
        feedback = null;
      } // end else feedback is not null
    } // if _formKey
  } // _submitFeedback
}
