import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/subject_page/subject_model.dart';
import 'package:flutter/material.dart';

class SubjectDetailsPageViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SubjectModel subjectModel = SubjectModel(
    subject_name: "",
    subject_code: "",
    semester_session: "",
  );

  void addSubject(
    String subjectCode,
    subjectName,
    semSession,
    BuildContext context,
  ) async {
    subjectModel.subject_code = subjectCode;
    subjectModel.subject_name = subjectName;
    subjectModel.semester_session = semSession;

    try {
      Map<String, dynamic> subjectData = subjectModel.toMapSubject();

      await _firestore.collection('subjects').doc().set(subjectData);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '' + subjectModel.subject_code + subjectModel.subject_name,
            ),
            content: Text(
              '' +
                  subjectModel.subject_code +
                  subjectModel.subject_name +
                  ' for semester session ' +
                  subjectModel.semester_session +
                  ' has been successfully added',
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

  void enrolUsers(){

  }
}
