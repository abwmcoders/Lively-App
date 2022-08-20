import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final String? userId;

  DatabaseServices({this.userId});

  //! reference to collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  //! saving user data
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(userId).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": '',
      "uid": userId,
    });
  }

  //! getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //! get user group
  getUserGroup() async {
    return userCollection.doc(userId).snapshots();
  }

  //! creating a group
  Future createGroup(String userName, String userId, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": '',
      "admin": "${userId}_$userName",
      "members": [],
      "groudId": '',
      "recentMessage": '',
      "recentSender": '',
    });

//! updating group values
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${userId}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(userId);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"]),
    });
  }

  //! getting chat and admin
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }
}
