class LeaveApplication {
  final String username;
  final String email;
  final DateTime timestamp;
  final DateTime fromDate;
  final DateTime toDate;
  final String description;
  final String status;
  final String leaveId;

  LeaveApplication({
    required this.username,
    required this.email,
    required this.timestamp,
    required this.fromDate,
    required this.toDate,
    required this.description,
    required this.status,
    required this.leaveId,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'timestamp': timestamp,
      'fromDate': fromDate,
      'toDate': toDate,
      'description': description,
      'status': status,
      'leaveId': leaveId,
    };
  }
}
