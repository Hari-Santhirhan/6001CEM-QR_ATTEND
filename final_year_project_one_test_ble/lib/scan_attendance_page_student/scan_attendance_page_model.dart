class ScanAttendancePageModel {
  String studentEmail;
  String timeTaken;
  String attendanceStatus;
  String scanStatus;

  ScanAttendancePageModel({
    required this.studentEmail,
    required this.timeTaken,
    required this.attendanceStatus,
    required this.scanStatus,
  });

  Map<String, dynamic> takeAttendanceMap(){
    return{
      'email' : studentEmail,
      'time_taken' : timeTaken,
      'attendance_status' : attendanceStatus,
      'scan_status' : scanStatus,
    };
  }
}
