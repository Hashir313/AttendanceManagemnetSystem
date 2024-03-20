import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//? use to display the role of the user in the app
final stringProvider = StateProvider<String>((ref) => '');

//? use to fetch the user data from firebase firestore
final userDataProvider = FutureProvider<DocumentSnapshot>((ref) async {
  // Fetch user data from Firestore
  DocumentSnapshot userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get();
  return userData;
});




class UpdatedImageState extends StateNotifier<String?> {
  UpdatedImageState() : super(null);

  void updateImage(String? imageUrl) {
    state = imageUrl;
  }
}

final updatedImageStateProvider = StateNotifierProvider<UpdatedImageState, String?>((ref) => UpdatedImageState());

//? use to fetch the user data from firebase firestore

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

class UserProfile {
  final String username;
  final String email;
  final String course;

  UserProfile(this.username, this.email, this.course);
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile('', '', 'Software Engineering'));

  void updateUserProfile(String username, String email, String course) {
    state = UserProfile(username, email, course);
  }
}
