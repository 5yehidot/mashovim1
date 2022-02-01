import 'groupModel.dart';
import 'userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBStream {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<UserModel> getCurrentUser(String uid) {
    return _firestore
        .collection('fbUsers')
        .doc(uid)
        .snapshots()
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(doc: docSnapshot));
  }

  Stream<GroupModel> getCurrentGroup(String groupId) {
    return _firestore
        .collection('fbGroups')
        .doc(groupId)
        .snapshots()
        .map((docSnapshot) => GroupModel.fromDocumentSnapshot(doc: docSnapshot));
  }
}