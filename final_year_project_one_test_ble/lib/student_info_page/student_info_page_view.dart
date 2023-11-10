import 'package:final_year_project_one/student_info_page/detailed_user_view.dart';
import 'package:flutter/material.dart';

import '../attendance_info_page/attendance_info_page_view.dart';
import '../home_page/home_page_view.dart';
import '../home_page/home_page_viewModel.dart';
import '../profile_page/profile_page_view.dart';
import '../register_user_page_admin/register_user_page_view.dart';
import '../take_attendance_lecturer/take_attendance_page_view.dart';

// LECTURER====================================================================
class StudentInfoPageViewLecturer extends StatefulWidget {
  final String lecturerStudentInfoEmail;
  const StudentInfoPageViewLecturer(
      {Key? key, required this.lecturerStudentInfoEmail})
      : super(key: key);

  @override
  State<StudentInfoPageViewLecturer> createState() =>
      _StudentInfoPageViewLecturerState();
}

class _StudentInfoPageViewLecturerState
    extends State<StudentInfoPageViewLecturer> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePageViewLecturer(
                  lecturerHomeEmail: widget.lecturerStudentInfoEmail,
                )),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TakeAttendancePageViewLecturer(
                  lecturerAttendEmail: widget.lecturerStudentInfoEmail,
                )),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AttendanceInfoPageViewLecturer(
                  lecturerAttendInfoEmail: widget.lecturerStudentInfoEmail,
                )),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => StudentInfoPageViewLecturer(
                  lecturerStudentInfoEmail: widget.lecturerStudentInfoEmail,
                )),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePageViewLecturer(
                  lecturerProfileEmail: widget.lecturerStudentInfoEmail,
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
          "Student Info",
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
        child: Text("Student Info Page in Development"),
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
            icon: Icon(Icons.school),
            label: "Student Info",
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
class UserInfoPageViewAdmin extends StatefulWidget {
  final String storeAdminEmailUser;
  final String storeAdminPasswordUser;
  const UserInfoPageViewAdmin({
    Key? key,
    required this.storeAdminEmailUser,
    required this.storeAdminPasswordUser,
  }) : super(key: key);

  @override
  State<UserInfoPageViewAdmin> createState() => _UserInfoPageViewAdminState();
}

class _UserInfoPageViewAdminState extends State<UserInfoPageViewAdmin> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageViewAdmin(
            storeAdminEmailHome: widget.storeAdminEmailUser,
            storeAdminPasswordHome: widget.storeAdminPasswordUser,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterUserPageViewAdmin(
            storeAdminEmailRegister: widget.storeAdminEmailUser,
            storeAdminPasswordRegister: widget.storeAdminPasswordUser,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoPageViewAdmin(
            storeAdminEmailUser: widget.storeAdminEmailUser,
            storeAdminPasswordUser: widget.storeAdminPasswordUser,
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPageViewAdmin(
            storeAdminEmailSettings: widget.storeAdminEmailUser,
            storeAdminPasswordSettings: widget.storeAdminPasswordUser,
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
          "User Info",
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
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "Please Select a Role",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedUserViewAdmin(
                      userRole: "Student",
                      detailedAdminEmail: widget.storeAdminEmailUser,
                      detailedAdminPassword: widget.storeAdminPasswordUser,
                    ),
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                color: Color(0xFF00FFE0),
                child: Center(
                  child: Text(
                    "Student",
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
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedUserViewAdmin(
                      userRole: "Technician",
                      detailedAdminEmail: widget.storeAdminEmailUser,
                      detailedAdminPassword: widget.storeAdminPasswordUser,
                    ),
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                color: Color(0xFF00FFE0),
                child: Center(
                  child: Text(
                    "Technician",
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
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedUserViewAdmin(
                      userRole: "Lecturer",
                      detailedAdminEmail: widget.storeAdminEmailUser,
                      detailedAdminPassword: widget.storeAdminPasswordUser,
                    ),
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                color: Color(0xFF00FFE0),
                child: Center(
                  child: Text(
                    "Lecturer",
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
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedUserViewAdmin(
                      userRole: "Admin",
                      detailedAdminEmail: widget.storeAdminEmailUser,
                      detailedAdminPassword: widget.storeAdminPasswordUser,
                    ),
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                color: Color(0xFF00FFE0),
                child: Center(
                  child: Text(
                    "Admin",
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
