class UserModel {
  final String uid;
  final String username;
  final String email;
  // final String course;
  final String profileImageUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    // required this.course,
    required this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      // course: json['password'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      // 'password': course,
      'profileImageUrl': profileImageUrl,
    };
  }
}
