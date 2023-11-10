import 'package:cloud_firestore/cloud_firestore.dart';

class SemesterSessionModel {
  String sem_session;

  SemesterSessionModel({
    required this.sem_session
  });

  Map<String, dynamic> toMapSubject() {
    return {
      'sem_session': sem_session,
    };
  }
}