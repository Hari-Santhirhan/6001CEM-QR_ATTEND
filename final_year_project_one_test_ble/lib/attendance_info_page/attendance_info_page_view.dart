import 'package:final_year_project_one/attendance_info_page/attendance_lecturer_page_view.dart';
import 'package:final_year_project_one/attendance_info_page/warning_letters_page_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../home_page/home_page_view.dart';
import '../home_page/home_page_viewModel.dart';
import '../profile_page/profile_page_view.dart';
import '../register_user_page_admin/register_user_page_view.dart';
import '../scan_attendance_page_student/scan_attendance_page_view.dart';
import '../student_info_page/student_info_page_view.dart';
import '../take_attendance_lecturer/take_attendance_page_view.dart';

// STUDENT=====================================================================
class AttendanceInfoPageView extends StatefulWidget {
  final String studentEmailInfo;
  final String studentNameInfo;
  const AttendanceInfoPageView({
    Key? key,
    required this.studentEmailInfo,
    required this.studentNameInfo,
  }) : super(key: key);

  @override
  State<AttendanceInfoPageView> createState() => _AttendanceInfoPageViewState();
}

class _AttendanceInfoPageViewState extends State<AttendanceInfoPageView> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageView(
            studentEmailHome: widget.studentEmailInfo,
            studentNameHome: widget.studentNameInfo,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScanAttendancePageView(
            studentEmailScan: widget.studentEmailInfo,
            studentNameScan: widget.studentNameInfo,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceInfoPageView(
            studentEmailInfo: widget.studentEmailInfo,
            studentNameInfo: widget.studentNameInfo,
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePageView(
            studentEmailProfile: widget.studentEmailInfo,
            studentNameProfile: widget.studentNameInfo,
          ),
        ),
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
          "Attendance Info",
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                // BEFORE 1st Square
                height: 150,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // To Warning Letter Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WarningLettersPageView(
                            studentEmailLetter: widget.studentEmailInfo),
                      ),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 150,
                    color: Colors.orange,
                    child: Center(
                      child: Text(
                        "Warning Letters",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   // BEFORE 2nd Square
              //   height: 20,
              // ),
              // Center(
              //   child: GestureDetector(
              //     onTap: () {},
              //     child: Container(
              //       width: 300,
              //       height: 150,
              //       color: Color(0xFF18FF2F),
              //       child: Center(
              //         child: Text(
              //           "Attendance Report",
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 27,
              //             color: Colors.black,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   // BEFORE 3rd Square
              //   height: 20,
              // ),
              // Center(
              //   child: GestureDetector(
              //     onTap: () {
              //
              //     },
              //     child: Container(
              //       width: 300,
              //       height: 150,
              //       color: Color(0xFFDA59EF),
              //       child: Center(
              //         child: Text(
              //           "Privacy Policy",
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 27,
              //             color: Colors.black,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
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
            icon: Icon(Icons.qr_code_scanner),
            label: "Scan Attendance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_sharp),
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
// STUDENT=====================================================================

// LECTURER====================================================================
class AttendanceInfoPageViewLecturer extends StatefulWidget {
  final String lecturerAttendInfoEmail;
  const AttendanceInfoPageViewLecturer(
      {Key? key, required this.lecturerAttendInfoEmail})
      : super(key: key);

  @override
  State<AttendanceInfoPageViewLecturer> createState() =>
      _AttendanceInfoPageViewLecturerState();
}

class _AttendanceInfoPageViewLecturerState
    extends State<AttendanceInfoPageViewLecturer> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePageViewLecturer(
                  lecturerHomeEmail: widget.lecturerAttendInfoEmail,
                )),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TakeAttendancePageViewLecturer(
                  lecturerAttendEmail: widget.lecturerAttendInfoEmail,
                )),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AttendanceInfoPageViewLecturer(
                  lecturerAttendInfoEmail: widget.lecturerAttendInfoEmail,
                )),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePageViewLecturer(
                  lecturerProfileEmail: widget.lecturerAttendInfoEmail,
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
          "Attendance Info",
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                // BEFORE 1st Square
                height: 150,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Go to Subject Selection
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectSelectionAttendance(
                          lecturerSubSelect: widget.lecturerAttendInfoEmail,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 150,
                    color: Colors.cyanAccent,
                    child: Center(
                      child: Text(
                        "Past Attendances",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                // BEFORE 2nd Square
                height: 20,
              ),
            ],
          ),
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
// LECTURER====================================================================

// ADMIN=======================================================================
class AttendanceInfoPageViewAdmin extends StatefulWidget {
  final String storeAdminEmailInfo;
  final String storeAdminPasswordInfo;
  const AttendanceInfoPageViewAdmin({
    Key? key,
    required this.storeAdminEmailInfo,
    required this.storeAdminPasswordInfo,
  }) : super(key: key);

  @override
  State<AttendanceInfoPageViewAdmin> createState() =>
      _AttendanceInfoPageViewAdminState();
}

class _AttendanceInfoPageViewAdminState
    extends State<AttendanceInfoPageViewAdmin> {
  int _selectedIndex = 2;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageViewAdmin(
            storeAdminEmailHome: widget.storeAdminEmailInfo,
            storeAdminPasswordHome: widget.storeAdminPasswordInfo,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterUserPageViewAdmin(
            storeAdminEmailRegister: widget.storeAdminEmailInfo,
            storeAdminPasswordRegister: widget.storeAdminPasswordInfo,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceInfoPageViewAdmin(
            storeAdminEmailInfo: widget.storeAdminEmailInfo,
            storeAdminPasswordInfo: widget.storeAdminPasswordInfo,
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoPageViewAdmin(
            storeAdminEmailUser: widget.storeAdminEmailInfo,
            storeAdminPasswordUser: widget.storeAdminPasswordInfo,
          ),
        ),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPageViewAdmin(
            storeAdminEmailSettings: widget.storeAdminEmailInfo,
            storeAdminPasswordSettings: widget.storeAdminPasswordInfo,
          ),
        ),
      );
    }
  }

  void _checkUserUID() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;
        Fluttertoast.showToast(
          msg: "Current User's UID: $uid",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "No user is currently logged in.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Error checking UID: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Attendance Info",
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
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                _checkUserUID();
              },
              child: Text("Get UUID"))),
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
            icon: Icon(Icons.app_registration),
            label: "Register User",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_sharp),
            label: "Attendance Info",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "User Info",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
// ADMIN=======================================================================
