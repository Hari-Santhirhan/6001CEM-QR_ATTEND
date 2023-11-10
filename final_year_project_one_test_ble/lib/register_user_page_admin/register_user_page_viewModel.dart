import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/register_user_page_admin/register_user_page_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

RegisterUserPageModel registerUserPageModel = RegisterUserPageModel(
  name: '',
  email: '',
  password: '',
  role: '',
  id: '',
  imei: '',
  firstLogin: '',
);

class RegisterUserPageViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String encryptEmail(String email) {
    final bytes = utf8.encode(email);
    final hash = sha256.convert(bytes);
    return hash.toString();
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

  void updateModel(String name, String email, String password, String role,
      String id, String imei, String firstLogin) {
    //String encryptedEmail = encryptEmail(email);
    String encryptedPassword = encryptPassword(password);

    registerUserPageModel.name = name;
    registerUserPageModel.email = email; //encryptedEmail;
    registerUserPageModel.password = encryptedPassword;
    registerUserPageModel.role = role;

    if (id == "") {
      registerUserPageModel.id = id;
    } else {
      // String encryptedID = encryptID(id);
      // registerUserPageModel.id = encryptedID;
      registerUserPageModel.id = id;
    }

    registerUserPageModel.imei = imei;
    registerUserPageModel.firstLogin = firstLogin;
  }

  Future<void>? registerUser(
    BuildContext context,
    String currentAdminEmail,
    String currentAdminPassword,
      String currentNonHashedPassword,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: registerUserPageModel.email,
        password: registerUserPageModel.password,
      );

      User? currentUser = userCredential.user;

      Map<String, dynamic> registerData = registerUserPageModel.registerToMap();

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .set(registerData);

      _auth.signOut();

      _auth.signInWithEmailAndPassword(
        email: currentAdminEmail,
        password: currentAdminPassword,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('User Registration Successful for ' +
                registerUserPageModel.name),
            content: Text(
              '' +
                  registerUserPageModel.name +
                  ' with for the email ' +
                  registerUserPageModel.email +
                  ' has been successfully registered.\n'
                      'Please note their email and password to email to them:\n'
                      'Email: ${registerUserPageModel.email}\n'
                      'Password: ${currentNonHashedPassword}',
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // SEND EMAIL HERE

                  // SEND EMAIL HERE
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(
              "$e",
            ),
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
  }
}
