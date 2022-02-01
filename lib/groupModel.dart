import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String id;
  String name;
  String leader;
  List<String> members;
  List<String> tokens;
  Timestamp groupCreated;

  GroupModel({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.tokens,
    this.groupCreated,
  });

  GroupModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    id = doc.id;
    name = doc.get('groupName');
    leader = doc.get('groupCreator');
    members = List<String>.from(doc.get('groupMembers'));
    tokens = List<String>.from(doc.get('tokens') ?? []);
    groupCreated = doc.get('groupCreated');
  }
}