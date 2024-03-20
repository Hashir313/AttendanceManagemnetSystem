class AttendanceRecord {
  final String userId;
  final String username;
  final String email;
  // final String course;
  final String status; // 'present' or 'absent'
  final DateTime dateTime;

  AttendanceRecord({
    required this.userId,
    required this.username,
    required this.email,
    // required this.course,
    required this.status,
    required this.dateTime,
  });

  // Convert AttendanceRecord to a Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      // 'course': course,
      'status': status,
      'dateTime': dateTime,
    };
  }
}
