import 'package:flutter/material.dart';
import 'ten_feedback_database_helper.dart';

class MyStudentPage extends StatefulWidget {
  @override
  _MyStudentPageState createState() => _MyStudentPageState();
}

class _MyStudentPageState extends State<MyStudentPage> {
  final dbHelper = DatabaseHelper.instance;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _groupClassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Student student;
  List<Student> studentlist;
  int updateIndex;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('רשימת קשר'), centerTitle: true),
      body: Container(
        color: Colors.grey[100],
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
                    padding: EdgeInsets.only(left: 25.0, top: 8.0, right: 25.0),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: 'שם מלא',
                          labelStyle: TextStyle(
                              color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold)),
                      controller: _nameController,
                      validator: (val) =>
                          val.isNotEmpty ? null : 'שם לא יכול להשאר ריק',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, top: 8.0, bottom: 25.0, right: 25.0),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: 'מספר טלפון נייד',
                          labelStyle: TextStyle(
                              color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold)),
                      controller: _phoneController,
                      validator: (val) => val.isNotEmpty
                          ? null
                          : 'מספר טלפון לא יכול להשאר ריק',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, top: 8.0, bottom: 25.0, right: 25.0),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: 'קבוצה',
                          labelStyle: TextStyle(
                              color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold)),
                      controller: _groupClassController,
                      validator: (val) => val.isNotEmpty
                          ? null
                          : 'קבוצה לא יכולה להשאר ריקה',
                    ),
                  ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder(
                    future: dbHelper.getStudentList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        studentlist = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: studentlist == null ? 0 : studentlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            Student st = studentlist[index];
                            print(st.name);
                            return Card(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: const EdgeInsets.all(5.0),
                                          color: Colors.purple[500],
                                          width: width * 0.82,
                                          height: 120.0,
                                          child: TextButton(
                                            // make a student card clickable
                                            onPressed: () {
                                              // Update input fields with current name and phone if user clicks on a student card
                                              _nameController.text = st.name;
                                              _phoneController.text = st.phone;
                                              _groupClassController.text = st.groupClass;

                                              student =
                                                  st; // Notify submitstudent that student is not null
                                              updateIndex =
                                                  index; // Notify list builder which card needs update
                                            }, // onPressed
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'שם: ${st.name}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.yellowAccent),
                                                ),
                                                Text(
                                                  'טלפון: ${st.phone}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  'קבוצה: ${st.groupClass}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          )),
                                      IconButton(
                                        onPressed: () {
                                          //print('onpressed call deleteStudent *** $index to be removed from database');
                                          student = st;
                                          // student.stid = index;
                                          // studentdbmanager.deleteStudent(index);
                                          // Delete student from student table in galaxia database
                                          dbHelper.deleteStudent(student).then((stid) {
                                            setState(() {
                                              // refresh StudentList cards;
                                              studentlist.removeAt(index);
                                              _nameController.clear();
                                              _phoneController.clear();
                                              _groupClassController.clear();
                                              //print('setstate removeAt update list after student $index removed from list');
                                            }); // setState
                                          });
                                        }, // onPressed
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
              ), // futureBuilder
            ], // widget
          ),
                ],
              ), // column
          ) // Form
        ] // widget
        ), // ListView
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            FocusScope.of(context).requestFocus(
                new FocusNode()); // make soft keyboard disappeared
            //Share.share(_phoneController.text); //_phoneController.text
            //_sendSMS('שלום, '+_nameController.text+', שאלת שאלה מעוררת השראה, '+_nameController.text, [_phoneController.text, ]);
            setState(() {
              print('Item was added');
              _submitStudent(context);
            });

          },
        label: const Text(''),
        icon: const Icon(Icons.send),
        backgroundColor: Colors.lightBlue,
        splashColor: Colors.yellow,
      ),
    ); // scaffold
  } //widget build
// Either add student record or update student record
  void _submitStudent(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (student == null) {
        //print("******student null"); // Create a new student record
        Student st =
            Student(name: _nameController.text, phone: _phoneController.text, groupClass: _groupClassController.text);
        //print('Student id is ${st.stid}');
        dbHelper.insertStudent(st).then((stid) => {
              // Insert new student record to the student table in galaxia database
              // and clear the input fields NAME and PHONE
              _nameController.clear(),
              _phoneController.clear(),
              _groupClassController.clear(),
            });
      } else {
        //print("******student NOT null");

        student.name = _nameController.text;
        student.phone = _phoneController.text;
        student.groupClass = _groupClassController.text;

        // Update student record in student table in galaxia database after it was edited by the user

        dbHelper.updateStudent(student).then((stid) => {
              setState(() {
                studentlist[updateIndex].name = _nameController.text;
                studentlist[updateIndex].phone = _phoneController.text;
                studentlist[updateIndex].groupClass = _groupClassController.text;

              }),
              // Clear input fields
              _nameController.clear(),
              _phoneController.clear(),
              _groupClassController.clear(),

        });
        // Clear student to allow for new student submital
        student = null;
      } // end else student is not null
    } // if _formKey
  } // _submitStudent

} //class _MyHomePageState
