import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database _galaxiadatabase;
  static final _databaseName = "galaxiadatabase.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  Future<Database> get database async {
    if (_galaxiadatabase != null) return _galaxiadatabase;
    // lazily instantiate the db the first time it is accessed
    _galaxiadatabase = await _initDatabase();
    return _galaxiadatabase;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }
//
  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE student (stID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, groupClass TEXT, group_1 TEXT, group_2 TEXT, group_3 TEXT, group_4 TEXT, group_5 TEXT, group_6 TEXT, group_7 TEXT, group_8 TEXT, group_9 TEXT, group_10 TEXT)");
    await db.execute(
        "CREATE TABLE feedback(fbID INTEGER PRIMARY KEY AUTOINCREMENT, statement TEXT, category TEXT, score INTEGER)");
    await db.execute(
        "CREATE TABLE deliveredFeedback(tenID INTEGER PRIMARY KEY AUTOINCREMENT, recipient TEXT, recipientPhone TEXT, recipientGroupClass TEXT, recipientGroup TEXT, topic TEXT, category TEXT, statement TEXT, statementID TEXT, senderName TEXT, senderPhone TEXT, timeStamp TEXT)");

  }

  // Helper methods
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.

//Feedback table handling
  Future<int> insertFeedback(FeedbackObject feedback) async {
    Database _galaxiadatabase = await instance.database;
    return await _galaxiadatabase.insert('feedback', feedback.toMap());
  }

  Future<List<CategoryObject>> getFeedbackListOfACategory(String category) async {
    Database _galaxiadatabase = await instance.database;
    final List<Map<String, dynamic>> maps = await _galaxiadatabase.rawQuery('SELECT DISTINCT statement FROM feedback Where category = \'$category\'');
    return List.generate(maps.length, (i){
      return CategoryObject(
        statement: maps[i]['statement'],
      );
    });
  }

  Future<List<FeedbackObject>> getFeedbackList() async {
    Database _galaxiadatabase = await instance.database;
    final List<Map<String, dynamic>> maps = await _galaxiadatabase.query('feedback');
    return List.generate(maps.length, (i){
      return FeedbackObject(
        fbID: maps[i]['fbID'],
        statement: maps[i]['statement'],
        category: maps[i]['category'],
        score: maps[i]['score'],
      );
    });
  }

  Future<List<CategoriesObject>> getListOfACategories() async {
    Database _galaxiadatabase = await instance.database;
    final List<Map<String, dynamic>> maps = await _galaxiadatabase.rawQuery('SELECT DISTINCT category FROM feedback');
    return List.generate(maps.length, (i){
      return CategoriesObject(
        category: maps[i]['category'],
      );
    });
  }

  Future<int> updateFeedback(FeedbackObject feedback) async {
    Database _galaxiadatabase = await instance.database;
    return await _galaxiadatabase.update(
        'feedback',
        feedback.toMap(),
        where: 'feedback.fbID = ?',
        whereArgs: [feedback.fbID]);
  }

  Future<int> deleteFeedback(FeedbackObject feedback) async
  {
    Database _galaxiadatabase = await instance.database;
    return _galaxiadatabase.delete('feedback', where: 'feedback.fbID = ?', whereArgs: [feedback.fbID]);
  }

  //Student table handling

  Future<int> insertStudent(Student student) async {
    Database _galaxiadatabase = await instance.database;
    return await _galaxiadatabase.insert('student', student.toMap());
  }

  Future<List<String>> getStudent(String name) async {
    Database _galaxiadatabase = await instance.database;
    var results = await _galaxiadatabase.rawQuery('SELECT selectedStudent FROM student Where name = \'$name\'');
    return results.map((Map<String, dynamic> row) {
      return row["selectedStudent"] as String;
    }).toList();
  }

  Future<List<Student>> getStudentList() async {
    Database _galaxiadatabase = await instance.database;
    final List<Map<String, dynamic>> maps = await _galaxiadatabase.query('student');
    return List.generate(maps.length, (i){
      return Student(
        stID: maps[i]['stID'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
        groupClass: maps[i]['groupClass'],
        group_1: maps[i]['group_1'],
        group_2: maps[i]['group_2'],
        group_3: maps[i]['group_3'],
        group_4: maps[i]['group_4'],
        group_5: maps[i]['group_5'],
        group_6: maps[i]['group_6'],
        group_7: maps[i]['group_7'],
        group_8: maps[i]['group_8'],
        group_9: maps[i]['group_9'],
        group_10: maps[i]['group_10'],

      );
    });

  }
  Future<List<Student>> getGroupClassStudentList(String groupClass) async {
    Database _galaxiadatabase = await instance.database;
    final List<Map<String, dynamic>> maps = await _galaxiadatabase.rawQuery('SELECT * FROM student Where groupClass = \'$groupClass\'');
    return List.generate(maps.length, (i){
      return Student(
        stID: maps[i]['stID'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
        groupClass: maps[i]['groupClass'],
        group_1: maps[i]['group_1'],
        group_2: maps[i]['group_2'],
        group_3: maps[i]['group_3'],
        group_4: maps[i]['group_4'],
        group_5: maps[i]['group_5'],
        group_6: maps[i]['group_6'],
        group_7: maps[i]['group_7'],
        group_8: maps[i]['group_8'],
        group_9: maps[i]['group_9'],
        group_10: maps[i]['group_10'],

      );
    });

  }
  Future<int> updateStudent(Student student) async {
    Database _galaxiadatabase = await instance.database;
    return await _galaxiadatabase.update(
        'student',
        student.toMap(),
        where: 'student.stID = ?',
        whereArgs: [student.stID]);
  }

  Future<int> deleteStudent(Student student) async
  {
    Database _galaxiadatabase = await instance.database;
    return _galaxiadatabase.delete('student', where: 'student.stID = ?', whereArgs: [student.stID]);
  }

//DeliveredFeedback table handling
  Future<int> insertDeliveredFeedback(DeliveredFeedbackObject deliveredFeedback) async {
    Database _galaxiadatabase = await instance.database;
    return await _galaxiadatabase.insert('deliveredFeedback', deliveredFeedback.toMap());
  }

  Future<List<DeliveredFeedbackObject>> getDeliveredFeedbackList() async {
    Database _galaxiadatabase = await instance.database;
    final List<Map<String, dynamic>> maps = await _galaxiadatabase.query('deliveredFeedback');
    return List.generate(maps.length, (i){
      return DeliveredFeedbackObject(
        tenID: maps[i]['tenID'],
        recipient: maps[i]['recipient'],
        recipientPhone: maps[i]['recipientPhone'],
        recipientGroupClass: maps[i]['recipientGroupClass'],
        recipientGroup: maps[i]['recipientGroup'],
        topic: maps[i]['topic'],
        category: maps[i]['category'],
        statement: maps[i]['statement'],
        statementID: maps[i]['statementID'],
        senderName: maps[i]['senderName'],
        senderPhone: maps[i]['senderPhone'],
        timeStamp: maps[i]['timeStamp'],
      );
    });

  }
  Future<int> updateDeliveredFeedback(DeliveredFeedbackObject deliveredFeedback) async {
    Database _galaxiadatabase = await instance.database;
    return await _galaxiadatabase.update(
        'deliveredFeedback',
        deliveredFeedback.toMap(),
        where: 'deliveredFeedback.tenID = ?',
        whereArgs: [deliveredFeedback.tenID]);

  }

  Future<int> deleteDeliveredFeedback(DeliveredFeedbackObject deliveredFeedback) async
  {
    Database _galaxiadatabase = await instance.database;
    return _galaxiadatabase.delete('deliveredFeedback', where: 'deliveredFeedback.tenID = ?', whereArgs: [deliveredFeedback.tenID]);
  }

}

class CategoryObject {
  String statement;

  CategoryObject({this.statement});
  Map<String, dynamic> toMap(){
    return {'statement': statement};
  }
}

class CategoriesObject {
  String category;

  CategoriesObject({this.category});
  Map<String, dynamic> toMap(){
    return {'category': category};
  }
}

class FeedbackObject {
  int fbID;
  String statement;
  String category;
  String score;
  FeedbackObject({this.fbID, this.statement, this.category, this.score});
  Map<String, dynamic> toMap(){
    return {'fbID': fbID, 'statement': statement, 'category': category, 'score': score};
  }
}

class DeliveredFeedbackObject {
  int tenID;
  String recipient;
  String recipientPhone;
  String recipientGroupClass;
  String recipientGroup;
  String topic;
  String category;
  String statement;
  String statementID;
  String senderName;
  String senderPhone;
  String timeStamp;


  DeliveredFeedbackObject({this.tenID, this.recipient, this.recipientPhone, this.recipientGroupClass, this.recipientGroup, this.topic, this.category, this.statement, this.statementID, this.senderName, this.senderPhone, this.timeStamp});
  Map<String, dynamic> toMap(){
    return {'tenID': tenID, 'recipient': recipient, 'recipientPhone': recipientPhone, 'recipientGroupClass': recipientGroupClass, 'recipientGroup': recipientGroup, 'topic': topic, 'category': category, 'statement': statement, 'statementID': statementID, 'senderName': senderName, 'senderPhone': senderPhone, 'timeStamp': timeStamp};
  }
}

class Student {
  int stID = 0;
  String name;
  String phone;
  String groupClass;
  String group_1;
  String group_2;
  String group_3;
  String group_4;
  String group_5;
  String group_6;
  String group_7;
  String group_8;
  String group_9;
  String group_10;

  Student({this.name, this.phone, this.stID, this.groupClass, this.group_1, this.group_2, this.group_3, this.group_4, this.group_5, this.group_6, this.group_7, this.group_8, this.group_9, this.group_10});
  Map<String, dynamic> toMap(){
    return {'name': name, 'phone': phone, 'stID': stID, 'groupClass': groupClass, 'group_1': group_1, 'group_2': group_2, 'group_3': group_3, 'group_4': group_4, 'group_5': group_5, 'group_6': group_6, 'group_7': group_7, 'group_8': group_8, 'group_9': group_9, 'group_10': group_10};
  }
}
