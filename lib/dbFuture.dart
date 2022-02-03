import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:math';


class DBFuture {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference userReference = FirebaseFirestore.instance.collection('fbUsers');
  final CollectionReference groupReference = FirebaseFirestore.instance.collection('fbGroups');
  final String uId;
  DBFuture({this.uId});

  Future<String> createGroup(
    String groupName, String userId, String userName) async {
    String retVal = "error";

    List<String> members = [];
    List<String> memberPhones = [];
    List<String> myGroups = [];
    List<String> myGroupIds = [];

    try {
      String  _docRef = getRandomString(5);
      members.add(userName);
      myGroups.add(groupName);
      myGroupIds.add(_docRef);

      DocumentSnapshot  userPhone = await _firestore.collection("fbUsers").doc(userId).get();
      String addPhone = userPhone['phone'];
      memberPhones.add(addPhone);

      await _firestore.collection("fbGroups").doc(_docRef).set({
        'groupId': _docRef,
        'groupName': groupName.trim(),
        'groupCreator': userId,
        'groupMembers': members,
        'groupMemberPhones': memberPhones,
        'groupCreated': Timestamp.now(),
      });


      await _firestore.collection("fbUsers").doc(userId).update({
        'groupId': _docRef,
        'groupName': groupName.trim(),
        'myGroups': FieldValue.arrayUnion(myGroups),
        'myGroupIds': FieldValue.arrayUnion(myGroupIds),
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<String> joinGroup(String groupId, String userId, String userName) async {
    String retVal = "error";
    List<String> members = [];
    List<String> memberPhones = [];
    List<String> myGroups = [];
    List<String> myGroupIds = [];

    try {
      DocumentSnapshot  groupName = await _firestore.collection("fbGroups").doc(groupId).get();
      String joinGroupName = groupName['groupName'];
      print(joinGroupName);
      members.add(userName);
      myGroups.add(joinGroupName);
      print(myGroups);
      myGroupIds.add(groupId);
      print(myGroupIds);
//      print('Members' + '${members}');
      DocumentSnapshot  userPhone = await _firestore.collection("fbUsers").doc(userId).get();
      String addPhone = userPhone['phone'];
      memberPhones.add(addPhone);

      await _firestore.collection("fbGroups").doc(groupId).update({
        'groupMembers': FieldValue.arrayUnion(members),
        'groupMemberPhones': FieldValue.arrayUnion(memberPhones),
      });

      await _firestore.collection("fbUsers").doc(userId).update({
      'myGroups': FieldValue.arrayUnion(myGroups),
      'myGroupIds': FieldValue.arrayUnion(myGroupIds),
      'groupName': joinGroupName,
      'groupId': groupId.trim(),

      });

      retVal = "success";
    } on PlatformException catch (e) {
      print('יש להשתמש בקוד קבוצה נכון!');
      retVal = "יש להשתמש בקוד קבוצה נכון!";
      print(e);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

/*
  Future<String> leaveGroup(String groupId, String userId, String userName) async {
    String retVal = "error";
    List<String> members = [];
    List<String> memberPhones = [];
    List<String> myGroups = [];
    List<String> myGroupIds = [];

    try {
      DocumentSnapshot  groupName = await _firestore.collection("fbGroups").doc(groupId).get();
      String joinGroupName = groupName['groupName'];
      print(joinGroupName);
      members.add(userName);
      myGroups.add(joinGroupName);
      print(myGroups);
      myGroupIds.add(groupId);
      print(myGroupIds);
//      print('Members' + '${members}');
      DocumentSnapshot  userPhone = await _firestore.collection("fbUsers").doc(userId).get();
      String addPhone = userPhone['phone'];
      memberPhones.add(addPhone);

      await _firestore.collection("fbGroups").doc(groupId).update({
        'groupMembers': FieldValue.arrayUnion(members),
        'groupMemberPhones': FieldValue.arrayUnion(memberPhones),
      });

      await _firestore.collection("fbUsers").doc(userId).update({
      'myGroups': FieldValue.arrayUnion(myGroups),
      'myGroupIds': FieldValue.arrayUnion(myGroupIds),
      'groupName': joinGroupName,
      'groupId': groupId.trim(),

      });

      retVal = "success";
    } on PlatformException catch (e) {
      print('יש להשתמש בקוד קבוצה נכון!');
      retVal = "יש להשתמש בקוד קבוצה נכון!";
      print(e);
    } catch (e) {
      print(e);
    }

    return retVal;
  }
*/


  Future<String> createUser(String userId, String userName, String userPhone) async {
    String retVal = "error";

    try {
      await _firestore.collection("fbUsers").doc(userId).set({
        'name': userName.trim(),
        'accountCreated': Timestamp.now(),
        'phone': userPhone.trim(),
        'userId': userId,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;// added 3Feb22_2216

}}