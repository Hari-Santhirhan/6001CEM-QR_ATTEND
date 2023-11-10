import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/attendance_info_page/attendance_info_page_view.dart';
import 'package:final_year_project_one/home_page/home_page_view.dart';
import 'package:final_year_project_one/profile_page/profile_page_view.dart';
import 'package:final_year_project_one/student_info_page/student_info_page_view.dart';
import 'package:final_year_project_one/take_attendance_lecturer/qr_code_page_view.dart';
import 'package:final_year_project_one/take_attendance_lecturer/take_attendance_page_viewModel.dart';
import 'package:final_year_project_one/take_attendance_lecturer/test_qr_generator.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../home_page/home_page_viewModel.dart';

class TakeAttendancePageViewLecturer extends StatefulWidget {
  final String lecturerAttendEmail; // lecturer email
  const TakeAttendancePageViewLecturer(
      {Key? key, required this.lecturerAttendEmail})
      : super(key: key);

  @override
  State<TakeAttendancePageViewLecturer> createState() =>
      _TakeAttendancePageViewLecturerState();
}

class _TakeAttendancePageViewLecturerState
    extends State<TakeAttendancePageViewLecturer> {
  late TakeAttendancePageViewModel _takeAttendancePageViewModel;
  List<String> classRoom = []; // list of ble-registered classrooms
  String? selectedItem; // variable for dropdown box

  // To fetch ble-registered classrooms
  Future<void> fetchDataDropdown() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('ble').get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          // Clear the existing data
          classRoom.clear();

          // Extract the 'room' field and store it in the variable
          classRoom.addAll(
              querySnapshot.docs.map((doc) => doc['ble_room'] as String));
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataDropdown().then((_) {
      setState(() {
        // Set the initial value for selectedItem
        selectedItem = classRoom.isNotEmpty ? classRoom[0] : null;
      });
    });
    // fetchDataDropdown();
    _takeAttendancePageViewModel = TakeAttendancePageViewModel();
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePageViewLecturer(
                  lecturerHomeEmail: widget.lecturerAttendEmail,
                )),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TakeAttendancePageViewLecturer(
                  lecturerAttendEmail: widget.lecturerAttendEmail,
                )),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AttendanceInfoPageViewLecturer(
                  lecturerAttendInfoEmail: widget.lecturerAttendEmail,
                )),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePageViewLecturer(
                  lecturerProfileEmail: widget.lecturerAttendEmail,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Take Attendance",
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
                // When the bell icon is pressed
              },
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              // BEFORE 1st Square
              height: 20,
            ),
            Center(
              child: Text(
                "Please Select the Classroom",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(
              // BEFORE 1st Square
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ), // Add a black border
              child: DropdownButton<String>(
                value: selectedItem ??
                    (classRoom.isNotEmpty ? classRoom[0] : null),
                items: classRoom.map((String room) {
                  return DropdownMenuItem<String>(
                    value: room,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        room,
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle dropdown item selection here
                  setState(() {
                    selectedItem = newValue!;
                  });
                },
                iconSize: 35.0, // Adjust the dropdown icon size
                underline: SizedBox(),
              ),
            ),
            SizedBox(
              // BEFORE 1st Square
              height: 20,
            ),
            Center(
              child: Text(
                "Please Select the Subject",
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
                    .where('subject_lecturers',
                        arrayContains: widget.lecturerAttendEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final subjects = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      final subjectName = subject['subject_name'];
                      final subjectCode = subject['subject_code'];
                      final semSession = subject['semester_session'];

                      return GestureDetector(
                        onTap: () {
                          // For Subject Selection
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    "Generate QR Code for\n$subjectCode $subjectName\n$semSession"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                        "Do you want to generate the QR Code for $selectedItem"),
                                  ],
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QrCodePageView(
                                              subjectName: subjectName,
                                              subjectCode: subjectCode,
                                              semesterSession: semSession,
                                              classRoom:
                                                  selectedItem.toString(),
                                              generatedQrTime: DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(
                                                DateTime.now()
                                              )),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      primary: Colors.greenAccent,
                                    ),
                                    child: Text(
                                      "Generate QR Code",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // WHEN GENERATE QR CODE IS SELECTED
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      primary: Colors.orange,
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF0075FF),
                          ),
                          margin: EdgeInsets.fromLTRB(40, 8, 40, 8),
                          padding: EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Center(
                              child: Text(
                                semSession +
                                    "\n" +
                                    subjectCode +
                                    "\n" +
                                    subjectName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Add other subject details as needed
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              // BEFORE 2nd Square
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue, // Set selected icon color to blue
        unselectedItemColor: Colors.black, // Set unselected icon color to black
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_sharp),
            label: "Take Attendance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_sharp),
            label: "Attendance Info",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
