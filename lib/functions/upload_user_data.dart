import 'dart:io';

import 'package:attendance_management_system/user_pannel/models/user_model.dart';
import 'package:attendance_management_system/widgets/custom_toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//! Function to upload the profile image to the firebase storage
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> uploadImageToFirebaseStorage(
    BuildContext context, File imageFile, String uid) async {
  Reference storageReference =
      FirebaseStorage.instance.ref().child('profile_images/$uid');
  UploadTask uploadTask = storageReference.putFile(imageFile);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
  if (taskSnapshot.state == TaskState.success) {
    print('Image uploaded successfully');
  }
  String imageUrl = await storageReference.getDownloadURL();
  return imageUrl;
}

//! Creating a function to upload the user information to the firebase firestore
Future<void> uploadUserDataToFirestore(UserModel user, String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  await usersCollection.doc(user.uid).set({
    'uid': user.uid,
    'username': user.username,
    'email': user.email,
    'currentRole': prefs.getString('CurrentRole'),
    'profileImageUrl': user.profileImageUrl,
  });
}

//? function to update the data of the user from firebase firestore
Future<void> updateUserDataToFirestore(BuildContext context,UserModel user, String userId) async {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  await usersCollection.doc(user.uid).update({
    'username': user.username,
    'email': user.email,
  }).then((value){
    toastMessage(context,'Profile updated successfully');
  }).onError((error, stackTrace){
    toastMessage(context,'Error: $error');
  });
}
