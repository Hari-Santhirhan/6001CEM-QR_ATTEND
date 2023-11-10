import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class SubjectSelectionAttendance extends StatefulWidget {
  final String lecturerSubSelect;

  const SubjectSelectionAttendance({
    Key? key,
    required this.lecturerSubSelect,
  }) : super(key: key);

  @override
  State<SubjectSelectionAttendance> createState() =>
      _SubjectSelectionAttendanceState();
}

class _SubjectSelectionAttendanceState
    extends State<SubjectSelectionAttendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Subject Selection",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Please Select a Subject",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('subjects')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Filter documents that contain lecturer enrolled
                  final filteredDocs = snapshot.data!.docs.where((document) {
                    final lecturers = document['subject_lecturers'] as List;
                    return lecturers.contains(widget.lecturerSubSelect);
                  }).toList();
                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final document = filteredDocs[index];
                      final subjectCode = document['subject_code'];
                      final subjectName = document['subject_name'];
                      final semesterSession = document['semester_session'];

                      return GestureDetector(
                        onTap: () {
                          // Page to the attendances taken for the subject
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectAttendanceLecturer(
                                subSession: semesterSession,
                                subCode: subjectCode,
                                subName: subjectName,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(16.0),
                          height: 200.0, // Set the height
                          width: 300.0, // Set the width
                          child: Container(
                            color: Colors.blueAccent,
                            child: Center(
                              child: Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 38, 0, 0),
                                      child: Text(
                                        "$subjectCode\n"
                                        "$subjectName\n"
                                        "$semesterSession",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

//=============================================================================
class SubjectAttendanceLecturer extends StatefulWidget {
  final subSession;
  final subCode;
  final subName;
  const SubjectAttendanceLecturer({
    Key? key,
    required this.subSession,
    required this.subCode,
    required this.subName,
  }) : super(key: key);
  @override
  State<SubjectAttendanceLecturer> createState() =>
      _SubjectAttendanceLecturerState();
}

class _SubjectAttendanceLecturerState extends State<SubjectAttendanceLecturer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Subject Attendances",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendance')
            .where('subject_code', isEqualTo: widget.subCode)
            .where('subject_name', isEqualTo: widget.subName)
            .where('semester_session', isEqualTo: widget.subSession)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              final timeCreated = document['time_created'];
              final classroomNumber = document['classroom_number'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedAttendanceView(
                        subCode: widget.subCode,
                        subName: widget.subName,
                        subSession: widget.subSession,
                        timeCreated: timeCreated,
                        classroomNumber: classroomNumber,
                      ),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  height: 200.0, // Set the height
                  width: 300.0, // Set the width
                  child: Container(
                    color: Colors.cyanAccent,
                    child: Center(
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
                              child: Text(
                                "$timeCreated\n"
                                "$classroomNumber\n",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

//=============================================================================
class DetailedAttendanceView extends StatefulWidget {
  final subCode;
  final subName;
  final subSession;
  final timeCreated;
  final classroomNumber;
  const DetailedAttendanceView({
    Key? key,
    required this.subCode,
    required this.subName,
    required this.subSession,
    required this.timeCreated,
    required this.classroomNumber,
  }) : super(key: key);
  @override
  State<DetailedAttendanceView> createState() => _DetailedAttendanceViewState();
}

class _DetailedAttendanceViewState extends State<DetailedAttendanceView> {
  List<List<dynamic>> arrays2D = [];

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    fetchAttendanceDetails();
  }

  Future<void> exportToExcel(List<List<dynamic>> arrays2d) async {
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        // Permission granted, continue to save the Excel file
        final excel = Excel.createExcel();
        final sheet = excel.sheets[excel.getDefaultSheet()];
        sheet!.setColWidth(2, 40);
        sheet.setColAutoFit(3);

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
            .value = "Student's Email";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
            .value = "Student ID";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
            .value = "Attendance Status";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
            .value = "Scan Status";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
            .value = "Scan Time";

        for (int i = 0; i < arrays2D.length; i++) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
              .value = arrays2D[i][0].toString();
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
              .value = arrays2D[i][1].toString();
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
              .value = arrays2D[i][2].toString();
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
              .value = arrays2D[i][3].toString();
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1))
              .value = arrays2D[i][4].toString();
        }
        // Call function save() to download the file
        var fileBytes = excel.save();

        // Get the downloads directory
        var directory = await getDownloadsDirectory();

        // Define the file path with a specific file name
        var filePath = '${directory?.path}/TestEXCEL.xlsx';

        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);

        // Trigger the download by opening the file using the default app
        OpenFile.open(filePath);

        print("SAVE SUCCESSFUL: $filePath");
      } else {
        // Permission denied
        print("Permission denied to write to external storage.");
      }
    } catch (e) {
      print("EXCEL ERROR: $e");
    }
  }

  void fetchAttendanceDetails() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('subject_code', isEqualTo: widget.subCode)
          .where('subject_name', isEqualTo: widget.subName)
          .where('semester_session', isEqualTo: widget.subSession)
          .where('time_created', isEqualTo: widget.timeCreated)
          .where('classroom_number', isEqualTo: widget.classroomNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs[0];
        final data = document.data() as Map<String, dynamic>;

        if (data != null) {
          for (var value in data.values) {
            if (value is List && value.length == 5) {
              arrays2D.add(value);
            }
          }
        } else {
          print('Document data is null.');
        }
      } else {
        print('No documents found.');
      }
    } catch (error) {
      print('Error fetching data from Firestore: $error');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Detailed View",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: () {
                // Download the details in Excel Format
                exportToExcel(arrays2D);
              },
              icon: Icon(
                Icons.save_alt,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align elements to the left
            children: <Widget>[
              for (var array in arrays2D)
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align elements to the left
                  children: <Widget>[
                    for (var value in array)
                      Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.all(8.0),
                        child: Text(
                          '$value',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    Divider(
                      color: Colors.black, // Customize the color of the line
                      thickness: 1, // Adjust the thickness of the line
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
//=============================================================================
