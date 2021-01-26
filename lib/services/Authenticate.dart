import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arm_flutter_test_app/helpers/constants.dart';
import 'package:arm_flutter_test_app/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference storage = FirebaseStorage.instance.ref();
  StreamSubscription<QuerySnapshot> _subscription;
  List<DocumentSnapshot> usersList;

  Future<User> getCurrentUser(String uid) async {
    DocumentSnapshot userDocument = await firestore.collection(USERS).doc(uid).get();
    if (userDocument != null && userDocument.exists) {
      return User.fromJson(userDocument.data());
    } else {
      return null;
    }
  }

  Future<List<DocumentSnapshot>> getAllUsers() async {
    //Stream<QuerySnapshot> querySnapshot = firestore.collection("users").snapshots();
    //return querySnapshot;
    _subscription = firestore.collection("users").snapshots().listen((dataSnapshot) {
        usersList = dataSnapshot.docs;
        print("Users List ${usersList.length}");
    });
    return usersList;
  }

  static Future<User> updateCurrentUser(User user) async {
    return await firestore
        .collection(USERS)
        .doc(user.userID)
        .set(user.toJson())
        .then((document) {
      return user;
    });
  }

  Future<String> uploadUserImageToFireStorage(File image, String userID) async {
    Reference upload = storage.child("images/$userID.png");
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}
