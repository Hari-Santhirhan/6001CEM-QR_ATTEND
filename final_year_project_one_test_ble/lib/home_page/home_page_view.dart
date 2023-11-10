import 'package:final_year_project_one/attendance_info_page/attendance_info_page_view.dart';
import 'package:final_year_project_one/home_page/home_page_viewModel.dart';
import 'package:final_year_project_one/home_page/statistics_page_view.dart';
import 'package:final_year_project_one/profile_page/profile_page_view.dart';
import 'package:final_year_project_one/register_user_page_admin/register_user_page_view.dart';
import 'package:final_year_project_one/scan_attendance_page_student/scan_attendance_page_view.dart';
import 'package:final_year_project_one/student_info_page/student_info_page_view.dart';
import 'package:final_year_project_one/take_attendance_lecturer/take_attendance_page_view.dart';
import 'package:flutter/material.dart';
import '../ble_page/ble_page_view.dart';

// STUDENTS====================================================================
class HomePageView extends StatefulWidget {
  final String studentEmailHome;
  final String studentNameHome;
  const HomePageView({
    Key? key,
    required this.studentEmailHome,
    required this.studentNameHome,
  }) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late HomePageViewModel _homePageViewModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _homePageViewModel = HomePageViewModel();
  }

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageView(
            studentEmailHome: widget.studentEmailHome,
            studentNameHome: widget.studentNameHome,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScanAttendancePageView(
            studentEmailScan: widget.studentEmailHome,
            studentNameScan: widget.studentNameHome,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceInfoPageView(
            studentEmailInfo: widget.studentEmailHome,
            studentNameInfo: widget.studentNameHome,
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePageView(
            studentEmailProfile: widget.studentEmailHome,
            studentNameProfile: widget.studentNameHome,
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
          "Homepage",
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
                height: 20,
              ),
              Center(
                child: Text(
                  "Welcome Student",
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
                    // For the View Statistics
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentStatisticsPageView(
                          studentEmailStats: widget.studentEmailHome,
                          studentNameStats: widget.studentNameHome,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 150,
                    color: Color(0xFF00FFE0),
                    child: Center(
                      child: Text(
                        "View Statistics",
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
// STUDENTS====================================================================

// TECHNICIAN==================================================================
class HomePageViewTech extends StatefulWidget {
  const HomePageViewTech({Key? key}) : super(key: key);

  @override
  State<HomePageViewTech> createState() => _HomePageViewTechState();
}

class _HomePageViewTechState extends State<HomePageViewTech> {
  late HomePageViewModel _homePageViewModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _homePageViewModel = HomePageViewModel();
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
          "Homepage",
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
                height: 20,
              ),
              Center(
                child: Text(
                  "Welcome Technician",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
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
class HomePageViewLecturer extends StatefulWidget {
  final String lecturerHomeEmail;
  const HomePageViewLecturer({Key? key, required this.lecturerHomeEmail})
      : super(key: key);

  @override
  State<HomePageViewLecturer> createState() => _HomePageViewLecturerState();
}

class _HomePageViewLecturerState extends State<HomePageViewLecturer> {
  late HomePageViewModel _homePageViewModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _homePageViewModel = HomePageViewModel();
  }

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageViewLecturer(
            lecturerHomeEmail: widget.lecturerHomeEmail,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TakeAttendancePageViewLecturer(
                  lecturerAttendEmail: widget.lecturerHomeEmail,
                )),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AttendanceInfoPageViewLecturer(
                  lecturerAttendInfoEmail: widget.lecturerHomeEmail,
                )),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePageViewLecturer(
                  lecturerProfileEmail: widget.lecturerHomeEmail,
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
          "Homepage",
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
                height: 20,
              ),
              Center(
                child: Text(
                  "Welcome Lecturer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
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
class HomePageViewAdmin extends StatefulWidget {
  final String storeAdminEmailHome;
  final String storeAdminPasswordHome;
  const HomePageViewAdmin({
    Key? key,
    required this.storeAdminEmailHome,
    required this.storeAdminPasswordHome,
  }) : super(key: key);

  @override
  State<HomePageViewAdmin> createState() => _HomePageViewAdminState();
}

class _HomePageViewAdminState extends State<HomePageViewAdmin> {
  late HomePageViewModel _homePageViewModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _homePageViewModel = HomePageViewModel();
  }

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageViewAdmin(
            storeAdminEmailHome: widget.storeAdminEmailHome,
            storeAdminPasswordHome: widget.storeAdminPasswordHome,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterUserPageViewAdmin(
            storeAdminEmailRegister: widget.storeAdminEmailHome,
            storeAdminPasswordRegister: widget.storeAdminPasswordHome,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoPageViewAdmin(
            storeAdminEmailUser: widget.storeAdminEmailHome,
            storeAdminPasswordUser: widget.storeAdminPasswordHome,
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPageViewAdmin(
            storeAdminEmailSettings: widget.storeAdminEmailHome,
            storeAdminPasswordSettings: widget.storeAdminPasswordHome,
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
          "Homepage",
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
                height: 20,
              ),
              Center(
                child: Text(
                  "Welcome Admin",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
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
