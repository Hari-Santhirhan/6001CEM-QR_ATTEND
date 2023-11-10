import 'package:final_year_project_one/first_time_login_page/request_device_id_collection_page_view.dart';
import 'package:final_year_project_one/profile_page/profile_page_viewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../attendance_info_page/attendance_info_page_view.dart';
import '../ble_page/ble_page_view.dart';
import '../home_page/home_page_view.dart';
import '../home_page/home_page_viewModel.dart';
import '../register_user_page_admin/register_user_page_view.dart';
import '../scan_attendance_page_student/scan_attendance_page_view.dart';
import '../student_info_page/student_info_page_view.dart';
import '../take_attendance_lecturer/take_attendance_page_view.dart';

// STUDENT=====================================================================
class ProfilePageView extends StatefulWidget {
  final String studentEmailProfile;
  final String studentNameProfile;
  const ProfilePageView({
    Key? key,
    required this.studentEmailProfile,
    required this.studentNameProfile,
  }) : super(key: key);

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  int _selectedIndex = 3;
  late ProfilePageViewModel _profilePageViewModel;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _profilePageViewModel = ProfilePageViewModel();
  }

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageView(
            studentEmailHome: widget.studentEmailProfile,
            studentNameHome: widget.studentNameProfile,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScanAttendancePageView(
            studentEmailScan: widget.studentEmailProfile,
            studentNameScan: widget.studentNameProfile,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceInfoPageView(
            studentEmailInfo: widget.studentEmailProfile,
            studentNameInfo: widget.studentNameProfile,
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePageView(
            studentEmailProfile: widget.studentEmailProfile,
            studentNameProfile: widget.studentNameProfile,
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
          "Profile",
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
            height: 150,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                // For Getting New Device ID for a new phone
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestDeviceID(
                      studentEmailRequest: widget.studentEmailProfile,
                    ),
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 150,
                color: Color(0XFF18FF2F),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Text(
                      "Request Device ID Collection",
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
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                // For Log Out
                try {
                  _profilePageViewModel.LogOut(context);
                } catch (e) {}
              },
              child: Container(
                width: 300,
                height: 150,
                color: Color(0xFF00FFE0),
                child: Center(
                  child: Text(
                    "Log Out",
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

// TECHNICIAN==================================================================
class SettingsPageTech extends StatefulWidget {
  const SettingsPageTech({Key? key}) : super(key: key);

  @override
  State<SettingsPageTech> createState() => _SettingsPageTechState();
}

class _SettingsPageTechState extends State<SettingsPageTech> {
  int _selectedIndex = 2;
  late ProfilePageViewModel _profilePageViewModel;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _profilePageViewModel = ProfilePageViewModel();
  }

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageViewTech()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BLEPageView()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsPageTech()),
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
          "Settings",
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
        child: GestureDetector(
          onTap: () async {
            // For Log Out
            try {
              _profilePageViewModel.LogOut(context);
            } catch (e) {}
          },
          child: Container(
            width: 300,
            height: 150,
            color: Color(0xFF00FFE0),
            child: Center(
              child: Text(
                "Log Out",
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
            icon: Icon(Icons.bluetooth),
            label: "BLE",
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
// TECHNICIAN==================================================================

// LECTURER====================================================================
class ProfilePageViewLecturer extends StatefulWidget {
  final String lecturerProfileEmail;
  const ProfilePageViewLecturer({Key? key, required this.lecturerProfileEmail})
      : super(key: key);

  @override
  State<ProfilePageViewLecturer> createState() =>
      _ProfilePageViewLecturerState();
}

class _ProfilePageViewLecturerState extends State<ProfilePageViewLecturer> {
  late ProfilePageViewModel _profilePageViewModel;
  int _selectedIndex = 3;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _profilePageViewModel = ProfilePageViewModel();
  }

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePageViewLecturer(
                  lecturerHomeEmail: widget.lecturerProfileEmail,
                )),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TakeAttendancePageViewLecturer(
                  lecturerAttendEmail: widget.lecturerProfileEmail,
                )),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AttendanceInfoPageViewLecturer(
                  lecturerAttendInfoEmail: widget.lecturerProfileEmail,
                )),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePageViewLecturer(
                  lecturerProfileEmail: widget.lecturerProfileEmail,
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
          "Profile",
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
        child: GestureDetector(
          onTap: () async {
            // For Log Out
            try {
              _profilePageViewModel.LogOut(context);
            } catch (e) {}
          },
          child: Container(
            width: 300,
            height: 150,
            color: Color(0xFF00FFE0),
            child: Center(
              child: Text(
                "Log Out",
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
class SettingsPageViewAdmin extends StatefulWidget {
  final String storeAdminEmailSettings;
  final String storeAdminPasswordSettings;
  const SettingsPageViewAdmin({
    Key? key,
    required this.storeAdminEmailSettings,
    required this.storeAdminPasswordSettings,
  }) : super(key: key);

  @override
  State<SettingsPageViewAdmin> createState() => _SettingsPageViewAdminState();
}

class _SettingsPageViewAdminState extends State<SettingsPageViewAdmin> {
  late ProfilePageViewModel _profilePageViewModel;
  int _selectedIndex = 3;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _profilePageViewModel = ProfilePageViewModel();
  }

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageViewAdmin(
            storeAdminEmailHome: widget.storeAdminEmailSettings,
            storeAdminPasswordHome: widget.storeAdminPasswordSettings,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterUserPageViewAdmin(
            storeAdminEmailRegister: widget.storeAdminEmailSettings,
            storeAdminPasswordRegister: widget.storeAdminPasswordSettings,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoPageViewAdmin(
            storeAdminEmailUser: widget.storeAdminEmailSettings,
            storeAdminPasswordUser: widget.storeAdminPasswordSettings,
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPageViewAdmin(
            storeAdminEmailSettings: widget.storeAdminEmailSettings,
            storeAdminPasswordSettings: widget.storeAdminPasswordSettings,
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
          "Profile",
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // Class Subjects
                    try {
                      _profilePageViewModel.GoToSubject(context);
                    } catch (e) {}
                  },
                  child: Container(
                    width: 300,
                    height: 150,
                    color: Color(0xFFFBE83B),
                    child: Center(
                      child: Text(
                        "Class Subjects",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ), // Class Subjects Button
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // Add Semester Session
                    try {
                      _profilePageViewModel.GoToAddSemSession(context);
                    } catch (e) {}
                  },
                  child: Container(
                    width: 300,
                    height: 150,
                    color: Color(0xFF18FF2F),
                    child: Center(
                      child: Text(
                        "Add Semester Session",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ), // Class Subjects Button
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // For Log Out
                    try {
                      _profilePageViewModel.LogOut(context);
                    } catch (e) {}
                  },
                  child: Container(
                    width: 300,
                    height: 150,
                    color: Color(0xFF00FFE0),
                    child: Center(
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ), // Log Out Button
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
