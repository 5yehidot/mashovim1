import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  String phone;
  Timestamp accountCreated;
  String name;
  String groupId;
  String groupName;
  List myGroups;
  List myGroupIds;

  UserModel({
    this.userId,
    this.phone,
    this.accountCreated,
    this.name,
    this.groupId,
    this.groupName,
    this.myGroups,
    this.myGroupIds,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    userId = doc.get('userId');
    phone = doc.get('phone');
    accountCreated = doc.get('accountCreated');
    name = doc.get('name');
    groupId = doc.get('groupId');
    groupName = doc.get('groupName');
    myGroups = doc.get('myGroups');
    myGroupIds = doc.get('myGroupIds');
  }
}