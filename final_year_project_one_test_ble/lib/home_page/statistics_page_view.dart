import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentStatisticsPageView extends StatefulWidget {
  final String studentEmailStats;
  final String studentNameStats;
  const StudentStatisticsPageView({
    Key? key,
    required this.studentEmailStats,
    required this.studentNameStats,
  }) : super(key: key);

  @override
  State<StudentStatisticsPageView> createState() =>
      _StudentStatisticsPageViewState();
}

class _StudentStatisticsPageViewState extends State<StudentStatisticsPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Statistics",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final subjectDocs = snapshot.data?.docs;

          if (subjectDocs == null || subjectDocs.isEmpty) {
            return Center(
                child: Text(
              "No subjects found for the current user.",
            ));
          }
          final subjectsForCurrentUser = subjectDocs.where((doc) {
            final studentSubjects = doc['subject_students'] as List<dynamic>;
            for (final innerArray in studentSubjects) {
              String emailCheck = innerArray['email'] as String;
              if (emailCheck == widget.studentEmailStats) {
                return true;
              }
            }
            return false;
          }).toList();

          return ListView.builder(
            itemCount: subjectsForCurrentUser.length,
            itemBuilder: (context, index) {
              final doc = subjectsForCurrentUser[index];
              final subjectName = doc['subject_name'] as String;
              final subjectCode = doc['subject_code'] as String;
              final semesterSession = doc['semester_session'] as String;
              final subjectStudents = doc['subject_students'] as List<dynamic>;
              int? scan;
              int? late;
              int? attendance;
              String? attendance_percentage;

              for (final studentData in subjectStudents) {
                final studentEntry = studentData as Map<String, dynamic>;
                final email = studentEntry['email'] as String;

                if (email == widget.studentEmailStats) {
                  scan = studentEntry['scan'] as int;
                  late = studentEntry['late'] as int;
                  attendance = scan - late;
                  attendance_percentage =
                      (attendance / scan * 100).toStringAsFixed(2);
                  break;
                }
              }

              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    'Subject Code: $subjectCode\n',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subject Name:\n$subjectName\n',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Semester/Session:\n$semesterSession\n',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Attendances Taken: ${attendance ?? 'N/A'}\n',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Number of Absents: ${late ?? 'N/A'}\n',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Attendance Percentage: '
                      '${attendance_percentage ?? 'N/A'}%\n',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1.0, // Adjust the thickness as needed
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
