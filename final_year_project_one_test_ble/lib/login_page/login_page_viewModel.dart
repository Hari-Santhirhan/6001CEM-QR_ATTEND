import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/first_time_login_page/first_time_login_page_view.dart';
import 'package:final_year_project_one/home_page/home_page_view.dart';
import 'package:final_year_project_one/login_page/login_page_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class LoginPageViewModel extends ChangeNotifier {
  LoginPageModel loginPageModel = LoginPageModel(email: '', password: '');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _showPassword = false; // Initialize variable
  bool get showPassword => _showPassword; // Gets the current bool value
  late String firstTimeLogin;

  Future<String?> getRole(String docID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(docID).get();
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        return documentSnapshot['role'];
      } else {}
    } catch (e) {}
  }

  Future<String?> getEmail(String docID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(docID).get();
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        return documentSnapshot['email'];
      } else {}
    } catch (e) {}
  }

  void toggleShowPassword() {
    _showPassword = !_showPassword; // true to false and vice versa
  }

  void updateEmail(String value) {
    loginPageModel.email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    loginPageModel.password = value;
    notifyListeners();
  }

  String encryptPassword(String normalPassword) {
    final bytes = utf8.encode(normalPassword);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<void> loginProcess(BuildContext context) async {
    try {
      String email = loginPageModel.email.trim();
      String password = loginPageModel.password.trim();
      String encryptedPassword = encryptPassword(password);

      if (email.isEmpty || password.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Please enter both email and password.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: encryptedPassword,
      );

      User? currentUser = userCredential.user;
      String userName = "";

      if (currentUser != null) {
        final userCollection = FirebaseFirestore.instance.collection('users');
        final userDoc =
            await userCollection.doc(currentUser.uid.toString()).get();
        String documentID = currentUser.uid.toString();

        if (userDoc.exists) {
          userName = userDoc['name'].toString();
          firstTimeLogin = userDoc['firstLogin'].toString();

          loginPageModel.email = "";
          loginPageModel.password = "";
        }

        // Check Role
        String? userRole = await getRole(currentUser.uid);
        String? userEmail = await getEmail(currentUser.uid);
        if (userRole == "Student") {
          if (firstTimeLogin == "Yes") {
            // First time login students
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FirstTimeLoginStudentsView(
                  studentEmailFirst: userEmail!,
                  studentNameFirst: userName!,
                  docID: documentID,
                ),
              ),
            );
          } else if (firstTimeLogin == "No") {
            // Non first time login students
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePageView(
                  studentEmailHome: userEmail!,
                  studentNameHome: userName,
                ), // HOMEPAGE STUDENT VIEW
              ),
            );
          }
        } else if (userRole == "Lecturer") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageViewLecturer(
                lecturerHomeEmail: userEmail!,
              ), // HOMEPAGE STUDENT VIEW
            ),
          );
        } else if (userRole == "Admin") {
          final String storeAdminEmail = email;
          final String storeAdminPassword = encryptedPassword;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageViewAdmin(
                storeAdminEmailHome: storeAdminEmail,
                storeAdminPasswordHome: storeAdminPassword,
              ), // HOMEPAGE STUDENT VIEW
            ),
          );
        } else if (userRole == "Technician") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageViewTech(), // HOMEPAGE TECH VIEW
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Role Unassigned/Unrecognized'),
                content: Text('Your role is unassigned/unrecognized'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Incorrect email or password
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Incorrect email or password.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        // Incorrect password
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Incorrect password.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Other FirebaseAuthException errors
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('$e'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error logging in: $e');
    }
    loginPageModel.email = "";
    loginPageModel.password = "";
  }
}
