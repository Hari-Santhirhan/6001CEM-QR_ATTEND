import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/subject_page/subject_details_page_viewModel.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SubjectDetailsAddPageView extends StatefulWidget {
  const SubjectDetailsAddPageView({Key? key}) : super(key: key);

  @override
  State<SubjectDetailsAddPageView> createState() =>
      _SubjectDetailsAddPageViewState();
}

class _SubjectDetailsAddPageViewState extends State<SubjectDetailsAddPageView> {
  TextEditingController subjectCode = TextEditingController();
  TextEditingController subjectName = TextEditingController();
  TextEditingController semSessionStart = TextEditingController();
  TextEditingController semSessionEnd = TextEditingController();
  TextEditingController adminID = TextEditingController();
  TextEditingController adminPass = TextEditingController();
  SubjectDetailsPageViewModel _subjectDetailsPageViewModel =
      SubjectDetailsPageViewModel();
  List<String> semSessions = [];
  String? selectedItem;

  Future<void> fetchDataDropdown() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('semester_session').get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          // Clear the existing data
          semSessions.clear();
          semSessions.addAll(
              querySnapshot.docs.map((doc) => doc['sem_session'] as String));
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
        selectedItem = semSessions.isNotEmpty ? semSessions[0] : null;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    subjectCode.dispose();
    subjectName.dispose();
    semSessionStart.dispose();
    semSessionEnd.dispose();
    adminID.dispose();
    adminPass.dispose();
    super.dispose();
  }

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  String encryptID(String id) {
    final bytes = utf8.encode(id);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Add Subjects",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: subjectCode,
                  decoration: InputDecoration(
                    hintText: "Subject Code (e.g., 6005CEM)",
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: subjectName,
                  decoration: InputDecoration(
                    hintText: "Subject Name (e.g., Security)",
                  ),
                ),
                SizedBox(height: 30),
                // TextFormField(
                //   controller: semSessionStart,
                //   decoration: InputDecoration(
                //     hintText: "Semester Session Start (e.g., AUG2023)",
                //   ),
                // ),
                // SizedBox(height: 30),
                // TextFormField(
                //   controller: semSessionEnd,
                //   decoration: InputDecoration(
                //     hintText: "Semester Session End (e.g., DEC2023)",
                //   ),
                // ),
                // DropdownButton<String>(
                //   value: selectedItem ??
                //       (semSessions.isNotEmpty ? semSessions[0] : null),
                //   items: semSessions.map((String room) {
                //     return DropdownMenuItem<String>(
                //       value: room,
                //       child: Padding(
                //         padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                //         child: Text(
                //           room,
                //           style: TextStyle(
                //             fontSize: 25.0,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     );
                //   }).toList(),
                //   onChanged: (String? newValue) {
                //     // Handle dropdown item selection here
                //     setState(() {
                //       selectedItem = newValue!;
                //     });
                //   },
                //   iconSize: 35.0, // Adjust the dropdown icon size
                //   underline: SizedBox(),
                // ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Adjust the border color as needed
                      width: 2.0,         // Adjust the border width as needed
                    ),
                    borderRadius: BorderRadius.circular(5.0), // Adjust the border radius as needed
                  ),
                  child: DropdownButton<String>(
                    value: selectedItem ??
                        (semSessions.isNotEmpty ? semSessions[0] : null),
                    items: semSessions.map((String room) {
                      return DropdownMenuItem<String>(
                        value: room,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            room,
                            style: TextStyle(
                              fontSize: 25.0,
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
                SizedBox(height: 30),
                TextFormField(
                  controller: adminPass,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Admin Password",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Add Subjects
                    String subjCode = subjectCode.text;
                    String subjName = subjectName.text;
                    String semesterSession = selectedItem.toString();
                    String admPass = adminPass.text;

                    CollectionReference adminRef =
                        FirebaseFirestore.instance.collection('users');

                    try {
                      QuerySnapshot querySnapshot = await adminRef
                          .where(
                            'password',
                            isEqualTo: encryptPassword(admPass),
                          )
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        _subjectDetailsPageViewModel.addSubject(
                          subjCode,
                          subjName,
                          semesterSession,
                          context,
                        );

                        subjectCode.clear();
                        subjectName.clear();
                        semSessionStart.clear();
                        semSessionEnd.clear();
                        adminID.clear();
                        adminPass.clear();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Incorrect Credentials Entered!"),
                              content: Text(
                                  "The Admin Password are incorrect!"),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16), // Adjust padding as needed
                    minimumSize:
                        Size(200, 50), // Adjust width and height as needed
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectEnrolLecturersPageView extends StatefulWidget {
  final String documentID;

  const SubjectEnrolLecturersPageView({Key? key, required this.documentID})
      : super(key: key);

  @override
  State<SubjectEnrolLecturersPageView> createState() =>
      _SubjectEnrolLecturersPageViewState();
}

class _SubjectEnrolLecturersPageViewState
    extends State<SubjectEnrolLecturersPageView> {
  List<String> selectedLecturers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Enrol Lecturers",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Lecturers',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'Lecturer')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final lecturers = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: lecturers.length,
                  itemBuilder: (context, index) {
                    final lecturer = lecturers[index];
                    final lecturerName = lecturer['name'];
                    final lecturerEmail = lecturer['email'];
                    final isSelected =
                        selectedLecturers.contains(lecturerEmail);
                    return ListTile(
                      title: Text(lecturerName),
                      subtitle: Text(lecturerEmail),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedLecturers.add(lecturerEmail);
                            } else {
                              selectedLecturers.remove(lecturerEmail);
                            }
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                CollectionReference subjectUsers =
                    FirebaseFirestore.instance.collection('subjects');

                await subjectUsers.doc(widget.documentID).update({
                  'subject_lecturers': FieldValue.arrayUnion(selectedLecturers),
                });

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Lecturer(s) Enrolment Succesful",
                      ),
                      content: Text(
                        "The lecturer(s) have been successfully enrolled",
                      ),
                      actions: [
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {}
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class SubjectEnrolStudentsPageView extends StatefulWidget {
  final String documentID;
  const SubjectEnrolStudentsPageView({Key? key, required this.documentID})
      : super(key: key);

  @override
  State<SubjectEnrolStudentsPageView> createState() =>
      _SubjectEnrolStudentsPageViewState();
}

class _SubjectEnrolStudentsPageViewState
    extends State<SubjectEnrolStudentsPageView> {
  List<String> selectedStudents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Enrol Students",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Students',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'Student')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final students = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final studentName = student['name'];
                    final studentEmail = student['email'];
                    final isSelected = selectedStudents.contains(studentEmail);
                    return ListTile(
                      title: Text(studentName),
                      subtitle: Text(studentEmail),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedStudents.add(studentEmail);
                            } else {
                              selectedStudents.remove(studentEmail);
                            }
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                CollectionReference subjectUsers =
                    FirebaseFirestore.instance.collection('subjects');

                await subjectUsers.doc(widget.documentID).update({
                  'subject_students': FieldValue.arrayUnion(
                    selectedStudents
                        .map((studentEmail) =>
                            {'email': studentEmail, 'late': 0, 'scan': 0})
                        .toList(),
                  ),
                });

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Students Enrolment Succesful",
                      ),
                      content: Text(
                        "The students have been successfully enrolled",
                      ),
                      actions: [
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {}
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class SubjectRemoveLecturersPageView extends StatefulWidget {
  final String documentID;
  const SubjectRemoveLecturersPageView({Key? key, required this.documentID})
      : super(key: key);

  @override
  State<SubjectRemoveLecturersPageView> createState() =>
      _SubjectRemoveLecturersPageViewState();
}

class _SubjectRemoveLecturersPageViewState
    extends State<SubjectRemoveLecturersPageView> {
  List<String> enrolledLecturers = [];

  @override
  void initState() {
    super.initState();
    fetchEnrolledLecturers();
  }

  void fetchEnrolledLecturers() async {
    try {
      DocumentSnapshot subjectSnapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .doc(widget.documentID)
          .get();

      List<String> enrolledLecturersList =
          List<String>.from(subjectSnapshot['subject_lecturers']);
      setState(() {
        enrolledLecturers = enrolledLecturersList;
      });
    } catch (e) {
      print("Error fetching enrolled lecturers: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remove Enrolled Lecturers"),
      ),
      body: ListView.builder(
        itemCount: enrolledLecturers.length,
        itemBuilder: (context, index) {
          final lecturerInfo = enrolledLecturers[index];
          return ListTile(
            title: Text(lecturerInfo),
            trailing: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                removeLecturerFromSubject(lecturerInfo);
              },
            ),
          );
        },
      ),
    );
  }

  void removeLecturerFromSubject(String lecturerEmail) async {
    try {
      CollectionReference subjectUsers =
          FirebaseFirestore.instance.collection('subjects');

      await subjectUsers.doc(widget.documentID).update({
        'subject_lecturers': FieldValue.arrayRemove([lecturerEmail]),
      });

      // Refresh the list of enrolled lecturers after removal
      fetchEnrolledLecturers();
    } catch (e) {
      print("Error removing lecturer: $e");
    }
  }
}

class SubjectRemoveStudentsPageView extends StatefulWidget {
  final String documentID;
  const SubjectRemoveStudentsPageView({Key? key, required this.documentID})
      : super(key: key);

  @override
  State<SubjectRemoveStudentsPageView> createState() =>
      _SubjectRemoveStudentsPageViewState();
}

class _SubjectRemoveStudentsPageViewState
    extends State<SubjectRemoveStudentsPageView> {
  List<String> enrolledStudents = [];

  @override
  void initState() {
    super.initState();
    fetchEnrolledStudents();
  }

  void fetchEnrolledStudents() async {
    try {
      DocumentSnapshot subjectSnapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .doc(widget.documentID)
          .get();

      List<dynamic> subjectStudents = subjectSnapshot['subject_students'];

      List<String> enrolledStudentsList = [];

      for (var studentData in subjectStudents) {
        if (studentData is Map<String, dynamic> && studentData
            .containsKey('email')) {
          enrolledStudentsList.add(studentData['email'] as String);
        }
      }

      setState(() {
        enrolledStudents = enrolledStudentsList;
      });
    } catch (e) {
      print("Error fetching enrolled students: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remove Enrolled Students"),
      ),
      body: ListView.builder(
        itemCount: enrolledStudents.length,
        itemBuilder: (context, index) {
          final studentInfo = enrolledStudents[index];
          return ListTile(
            title: Text(studentInfo),
            trailing: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                removeStudentsFromSubject(studentInfo);
              },
            ),
          );
        },
      ),
    );
  }

  void removeStudentsFromSubject(String studentEmail) async {
    try {
      CollectionReference subjectUsers =
          FirebaseFirestore.instance.collection('subjects');

      await subjectUsers.doc(widget.documentID).update({
        'subject_students': FieldValue.arrayRemove([studentEmail]),
      });

      // Refresh the list of enrolled students after removal
      fetchEnrolledStudents();
    } catch (e) {
      print("Error removing student: $e");
    }
  }
}
