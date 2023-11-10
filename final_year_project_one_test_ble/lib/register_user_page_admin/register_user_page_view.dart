import 'package:final_year_project_one/register_user_page_admin/register_user_page_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../attendance_info_page/attendance_info_page_view.dart';
import '../home_page/home_page_view.dart';
import '../profile_page/profile_page_view.dart';
import '../student_info_page/student_info_page_view.dart';

class RegisterUserPageViewAdmin extends StatefulWidget {
  final String storeAdminEmailRegister;
  final String storeAdminPasswordRegister;
  const RegisterUserPageViewAdmin({
    Key? key,
    required this.storeAdminEmailRegister,
    required this.storeAdminPasswordRegister,
  }) : super(key: key);

  @override
  State<RegisterUserPageViewAdmin> createState() =>
      _RegisterUserPageViewAdminState();
}

class _RegisterUserPageViewAdminState extends State<RegisterUserPageViewAdmin> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController initialPasswordController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();

  late RegisterUserPageViewModel _registerUserPageViewModel;

  int _selectedIndex = 1;
  String selectedRole = 'Role';
  bool showStudentIdField = false;

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _registerUserPageViewModel = RegisterUserPageViewModel();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    fullNameController.dispose();
    emailAddressController.dispose();
    initialPasswordController.dispose();
    studentIdController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageViewAdmin(
            storeAdminEmailHome: widget.storeAdminEmailRegister,
            storeAdminPasswordHome: widget.storeAdminPasswordRegister,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterUserPageViewAdmin(
            storeAdminEmailRegister: widget.storeAdminEmailRegister,
            storeAdminPasswordRegister: widget.storeAdminPasswordRegister,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoPageViewAdmin(
            storeAdminEmailUser: widget.storeAdminEmailRegister,
            storeAdminPasswordUser: widget.storeAdminPasswordRegister,
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPageViewAdmin(
            storeAdminEmailSettings: widget.storeAdminEmailRegister,
            storeAdminPasswordSettings: widget.storeAdminPasswordRegister,
          ),
        ),
      );
    }
  }

  bool isStrongPassword(String password) {
    // Check if the password is at least 12 characters long
    if (password.length < 12) {
      Fluttertoast.showToast(
        msg: "The password is less than 12 characters",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    }

    // Check if the password contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      Fluttertoast.showToast(
        msg: "The password must contain at least 1 upper-case letter",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    }

    // Check if the password contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      Fluttertoast.showToast(
        msg: "The password must contain at least 1 lower-case letter",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    }

    // Check if the password contains at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      Fluttertoast.showToast(
        msg: "The password must contain at least 1 numeric character",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    }

    // Check if the password contains at least one symbol
    if (!password.contains(RegExp(r"[!@#\$%^&*()_+|~=`{}\[\]:';<>,./?\\-]"))) {
      Fluttertoast.showToast(
        msg: "The password must contain at least 1 symbol",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Register User",
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
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2.5, // Border width
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: selectedRole,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue!;
                        showStudentIdField = newValue == 'Student';
                      });
                    },
                    items: <String>[
                      'Role',
                      'Student',
                      'Lecturer',
                      'Admin',
                      'Technician'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 35.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                    iconSize: 35.0, // Adjust the dropdown icon size
                    underline: SizedBox(),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          16.0), // Adjust the horizontal padding as needed
                  child: TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                    onChanged: (value) {},
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          16.0), // Adjust the horizontal padding as needed
                  child: TextFormField(
                    controller: emailAddressController,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onChanged: (value) {},
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          16.0), // Adjust the horizontal padding as needed
                  child: TextFormField(
                    controller: initialPasswordController,
                    decoration: InputDecoration(labelText: 'Initial Password'),
                    onChanged: (value) {},
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 16.0),
                if (showStudentIdField)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            16.0), // Adjust the horizontal padding as needed
                    child: TextFormField(
                      controller: studentIdController,
                      decoration: InputDecoration(labelText: 'Student ID'),
                      onChanged: (value) {},
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                SizedBox(height: 32.0),
                SizedBox(
                  width: 200,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      // Update the values using the controllers
                      String fullName = fullNameController.text;
                      String emailAddress = emailAddressController.text;
                      String initialPassword = initialPasswordController.text;
                      String userRole = selectedRole.toString();
                      String ID = "";
                      String mobileIMEI = "";
                      String firstLogin = "Yes";
                      if (showStudentIdField) {
                        ID = studentIdController.text;
                      }
                      if (isStrongPassword(initialPassword)) {
                        // Update values into the Model using the viewModel
                        _registerUserPageViewModel.updateModel(
                          fullName,
                          emailAddress,
                          initialPassword,
                          userRole,
                          ID,
                          mobileIMEI,
                          firstLogin,
                        );
                        // Register user using viewModel
                        _registerUserPageViewModel.registerUser(
                          context,
                          widget.storeAdminEmailRegister,
                          widget.storeAdminPasswordRegister,
                          initialPassword,
                        );

                        //Clear Info Typed
                        setState(() {
                          selectedRole = "Role";
                          fullNameController.clear();
                          emailAddressController.clear();
                          initialPasswordController.clear();
                          studentIdController.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 30.0,
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
