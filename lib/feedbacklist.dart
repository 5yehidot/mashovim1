import 'package:flutter/material.dart';
import 'ten_feedback_database_helper.dart';

class MyFeedbackListPage extends StatefulWidget {
  @override
  _MyFeedbackListPageState createState() => _MyFeedbackListPageState();
}

class _MyFeedbackListPageState extends State<MyFeedbackListPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('יצירת היגד משוב חדש'), centerTitle: true),
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
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        //labelText: 'כאן מקלידים היגד משוב חדש',
                        hintText: 'הקלדת היגד משוב חדש',
                        labelStyle: TextStyle(
                            color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold, )),
                    controller: _statementController,
                    validator: (val) => val.isNotEmpty ? null : 'משוב לא יכול להשאר ריק',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        //labelText: 'כאן מקלידים קטגוריה חדשה',
                        hintText: 'הקלדת קטגוריה / בחירה מרשימה',
                        labelStyle: TextStyle(
                          color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold, )),
                    controller: _categoryNameController,
                    validator: (val) => val.isNotEmpty ? null : 'קטגוריה לא יכולה להשאר ריקה',
                  ),
                ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FutureBuilder(
                        future: dbHelper.getListOfACategories(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                            categories = snapshot.data;
                            return ListView.builder(
                              shrinkWrap: true,
                              //scrollDirection: Axis.horizontal,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                              categories == null ? 0 : categories.length,
                              itemBuilder: (BuildContext context, int index) {
                                CategoriesObject cat = categories[index];
                                //print(fb.statement);
                                return Card(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: const EdgeInsets.all(5.0),
                                          color: Colors.purple[100],
                                          width: width * 0.82,
                                          //width: 82.0,
                                          height: 50.0,
                                          child: TextButton(
                                            // make a feedback card clickable
                                            onPressed: () {
                                              // Update input fields with current statement, categoryid and categoryname if user clicks on a feedback card
                                              _categoryNameController.text =
                                                  cat.category;
                                              listOfCategories =
                                                  cat; // Notify submitFeedback that feedback is not null
                                              updateCatIndex =
                                                  index; // Notify list builder which card needs update
                                            }, // onPressed
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '${cat.category}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                ),
                                      IconButton(
                                        onPressed: () {
                                          listOfCategories = cat;
                                          // Delete feedback record from feedback table in galaxia database
                                          //dbHelper.deleteFeedback(feedback).then((fbid) {
                                            setState(() {
                                              categories.removeAt(index);
                                              _categoryNameController.clear();
                                            });
                                          //});
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }, // itemBuilder
                              reverse: true,
                            );
                          }
                          else {
                            if (snapshot.hasError) {
                              print('Error: ${snapshot.error}');
                            } else {
                              return CircularProgressIndicator();
                            }
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder(
                      future: dbHelper.getFeedbackList(),
                      builder: (context, snapshot) {
                        //if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                          feedbacklist = snapshot.data;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                feedbacklist == null ? 0 : feedbacklist.length,
                            itemBuilder: (BuildContext context, int index) {
                              FeedbackObject fb = feedbacklist[index];
                              //print(fb.statement);
                              return Card(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        margin: const EdgeInsets.all(5.0),
                                        color: Colors.purple[500],
                                        width: width * 0.82,
                                        height: 150.0,
                                        child: TextButton(
                                          // make a feedback card clickable
                                          onPressed: () {
                                            // Update input fields with current statement, categoryid and categoryname if user clicks on a feedback card
                                            _statementController.text =
                                                fb.statement;
                                            _categoryNameController.text =
                                                fb.category;
                                            feedback =
                                                fb; // Notify submitFeedback that feedback is not null
                                            updatefbIndex =
                                                index; // Notify list builder which card needs update
                                          }, // onPressed
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '${fb.statement}\n ${fb.category}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        )),
                                    IconButton(
                                      onPressed: () {
                                        feedback = fb;
                                        // Delete feedback record from feedback table in galaxia database
                                        dbHelper.deleteFeedback(feedback).then((fbid) {
                                          setState(() {
                                            // refresh Feedback List cards;
                                            feedbacklist.removeAt(index);
                                            _statementController.clear();
                                            _categoryNameController.clear();
                                            //print('setstate removeAt update list after feedback $index removed from list');
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }, // itemBuilder
                            reverse: true,
                          );
                        }
                        else {
                          if (snapshot.hasError) {
                            print('Error: ${snapshot.error}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ]
            ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode()); // make soft keyboard disappeared
          setState(() {
            print('משוב חדש המקושר לקטגוריה חדשה נוצר בבסיס הנתונים');
            _submitFeedback(context);
          });
        },
        label: const Text(''),
        icon: const Icon(Icons.send),
        backgroundColor: Colors.lightBlue,
        splashColor: Colors.yellow,
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
