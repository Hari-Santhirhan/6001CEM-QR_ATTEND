import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/profile_page/add_semester_session_model.dart';
import 'package:flutter/material.dart';

class SemesterSessionPageViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SemesterSessionModel semesterSessionModel = SemesterSessionModel(
    sem_session: "",
  );

  void addSemSession(
    String startSession,
    String endSession,
    BuildContext context,
  ) async {
    semesterSessionModel.sem_session = startSession + " - " + endSession;

    try {
      Map<String, dynamic> semSessionData = semesterSessionModel.toMapSubject();

      await _firestore.collection('semester_session').doc().set(semSessionData);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Semester Session Added",
            ),
            content: Text(
              "The Semester Session\n${semesterSessionModel.sem_session}\n"
              "has been added",
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
    } catch (e) {}
  }
}
